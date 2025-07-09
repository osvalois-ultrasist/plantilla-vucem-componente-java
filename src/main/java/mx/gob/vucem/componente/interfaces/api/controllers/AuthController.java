package mx.gob.vucem.componente.interfaces.api.controllers;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import mx.gob.vucem.componente.infrastructure.security.JwtService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 * Controlador para autenticación y gestión de tokens.
 * Este controlador es solo para propósitos de demostración y pruebas.
 * En un entorno real, la autenticación debería realizarse contra un servicio centralizado.
 */
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Autenticación", description = "API para autenticación y gestión de tokens")
public class AuthController {

    private final JwtService jwtService;

    /**
     * Genera un token de sistema para pruebas.
     * Este endpoint es solo para propósitos de demostración y pruebas.
     *
     * @return Token JWT generado
     */
    @GetMapping("/token-sistema")
    @Operation(
        summary = "Genera un token de sistema para pruebas",
        description = "Este endpoint es solo para propósitos de demostración y NO debe usarse en producción",
        responses = {
            @ApiResponse(
                responseCode = "200",
                description = "Token generado correctamente",
                content = @Content(mediaType = "application/json")
            )
        }
    )
    public ResponseEntity<Map<String, String>> getSystemToken() {
        log.warn("Generando token de sistema para pruebas");
        
        // Crear usuario de sistema con rol SYSTEM
        UserDetails userDetails = User.builder()
                .username("sistema")
                .password("")
                .authorities(Collections.singletonList(() -> "ROLE_SYSTEM"))
                .build();
        
        // Generar token
        String token = jwtService.generateToken(userDetails);
        
        // Preparar respuesta
        Map<String, String> response = new HashMap<>();
        response.put("token", token);
        response.put("tipo", "Bearer");
        response.put("usuario", userDetails.getUsername());
        
        return ResponseEntity.ok(response);
    }
}