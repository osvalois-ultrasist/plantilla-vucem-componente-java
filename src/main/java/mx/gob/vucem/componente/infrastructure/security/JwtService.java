package mx.gob.vucem.componente.infrastructure.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import java.security.Key;
import java.security.SecureRandom;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.function.Function;

/**
 * Servicio para la gestión de tokens JWT con implementación mejorada de seguridad.
 */
@Service
@RequiredArgsConstructor
public class JwtService {
    private static final Logger logger = LoggerFactory.getLogger(JwtService.class);
    private static final int MINIMUM_KEY_LENGTH_BYTES = 32; // 256 bits (requisito mínimo para HMAC-SHA256)

    @Value("${vucem.seguridad.jwt.secret:${JWT_SECRET:}}")
    private String secretKey;

    @Value("${vucem.seguridad.jwt.expiracion:3600}")
    private long jwtExpiration;

    @Value("${vucem.seguridad.jwt.issuer:vucem.gob.mx}")
    private String issuer;

    @Value("${vucem.seguridad.jwt.audience:api}")
    private String audience;

    private Key signingKey;

    /**
     * Inicializa la clave de firma del token con manejo robusto de errores.
     */
    @PostConstruct
    public void init() {
        try {
            // Verificar si la clave secreta fue proporcionada y es válida
            if (secretKey != null && !secretKey.trim().isEmpty()) {
                byte[] keyBytes = Decoders.BASE64.decode(secretKey);

                // Verificar que los bytes decodificados sean suficientes para la seguridad
                if (keyBytes.length >= MINIMUM_KEY_LENGTH_BYTES) {
                    this.signingKey = Keys.hmacShaKeyFor(keyBytes);
                    logger.info("JWT signing key inicializada correctamente desde la configuración.");
                    return;
                } else {
                    logger.warn("La clave JWT proporcionada es demasiado débil ({}). Se requieren al menos {} bytes.",
                            keyBytes.length, MINIMUM_KEY_LENGTH_BYTES);
                }
            }

            // Si llegamos aquí, la clave no se proporcionó o no es válida
            // Generar una clave segura automáticamente
            this.signingKey = Keys.secretKeyFor(SignatureAlgorithm.HS256);

            // Generar y mostrar la clave para configuración futura
            // NOTA: En producción, esto debería guardarse de forma segura
            String generatedKey = Base64.getEncoder().encodeToString(this.signingKey.getEncoded());
            logger.warn("Usando una clave JWT generada automáticamente. Para la producción, configure una clave JWT fija.");
            logger.info("Clave JWT generada: {}. Considere agregar esta clave a sus variables de entorno o configuración.", generatedKey);

        } catch (Exception e) {
            logger.error("Error al inicializar la clave de firma JWT: {}", e.getMessage());
            // Generar una clave de respaldo como último recurso
            this.signingKey = generateFallbackKey();
            logger.info("Se ha generado una clave de firma de respaldo.");
        }
    }

    /**
     * Genera una clave de respaldo en caso de error.
     *
     * @return Una clave segura para firmar JWT
     */
    private Key generateFallbackKey() {
        try {
            return Keys.secretKeyFor(SignatureAlgorithm.HS256);
        } catch (Exception e) {
            // Implementación manual de último recurso para generar una clave
            byte[] keyBytes = new byte[MINIMUM_KEY_LENGTH_BYTES];
            new SecureRandom().nextBytes(keyBytes);
            return Keys.hmacShaKeyFor(keyBytes);
        }
    }

    /**
     * Extrae el nombre de usuario del token JWT.
     *
     * @param token Token JWT
     * @return Nombre de usuario
     */
    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    /**
     * Extrae una reclamación específica del token JWT.
     *
     * @param token Token JWT
     * @param claimsResolver Función para resolver la reclamación
     * @param <T> Tipo de la reclamación
     * @return Valor de la reclamación
     */
    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    /**
     * Genera un token JWT para un usuario.
     *
     * @param userDetails Detalles del usuario
     * @return Token JWT
     */
    public String generateToken(UserDetails userDetails) {
        return generateToken(new HashMap<>(), userDetails);
    }

    /**
     * Genera un token JWT para un usuario con reclamaciones adicionales.
     *
     * @param extraClaims Reclamaciones adicionales
     * @param userDetails Detalles del usuario
     * @return Token JWT
     */
    public String generateToken(Map<String, Object> extraClaims, UserDetails userDetails) {
        Instant now = Instant.now();

        return Jwts.builder()
                .setClaims(extraClaims)
                .setSubject(userDetails.getUsername())
                .setIssuedAt(Date.from(now))
                .setNotBefore(Date.from(now))  // El token no es válido antes de ahora
                .setExpiration(Date.from(now.plus(jwtExpiration, ChronoUnit.SECONDS)))
                .setIssuer(issuer)
                .setAudience(audience)
                .setId(UUID.randomUUID().toString())  // Identificador único para el token (JTI)
                .signWith(signingKey, SignatureAlgorithm.HS256)
                .compact();
    }

    /**
     * Verifica si un token JWT es válido para un usuario.
     *
     * @param token Token JWT
     * @param userDetails Detalles del usuario
     * @return true si el token es válido, false en caso contrario
     */
    public boolean isTokenValid(String token, UserDetails userDetails) {
        try {
            final String username = extractUsername(token);
            return username != null &&
                    username.equals(userDetails.getUsername()) &&
                    !isTokenExpired(token) &&
                    validateTokenIssuer(token);
        } catch (JwtException | IllegalArgumentException e) {
            logger.warn("Token JWT inválido: {}", e.getMessage());
            return false;
        }
    }

    /**
     * Valida el emisor del token.
     *
     * @param token Token JWT
     * @return true si el emisor es válido
     */
    private boolean validateTokenIssuer(String token) {
        String tokenIssuer = extractClaim(token, Claims::getIssuer);
        return issuer.equals(tokenIssuer);
    }

    /**
     * Verifica si un token JWT ha expirado.
     *
     * @param token Token JWT
     * @return true si el token ha expirado, false en caso contrario
     */
    private boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }

    /**
     * Extrae la fecha de expiración de un token JWT.
     *
     * @param token Token JWT
     * @return Fecha de expiración
     */
    private Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    /**
     * Extrae todas las reclamaciones de un token JWT.
     *
     * @param token Token JWT
     * @return Reclamaciones
     * @throws JwtException si el token es inválido
     */
    private Claims extractAllClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(signingKey)
                .build()
                .parseClaimsJws(token)
                .getBody();
    }
}