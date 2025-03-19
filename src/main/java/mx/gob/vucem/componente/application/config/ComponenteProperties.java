package mx.gob.vucem.componente.application.config;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import org.springframework.validation.annotation.Validated;

/**
 * Propiedades de configuración específicas del componente.
 * Se cargan desde la configuración externa (application.yml, variables de entorno, etc.).
 */
@Configuration
@ConfigurationProperties(prefix = "vucem.componente")
@Validated
@Getter
@Setter
public class ComponenteProperties {

    /**
     * Nombre del componente.
     */
    @NotBlank
    private String nombre;

    /**
     * Versión del componente.
     */
    private String version;

    /**
     * Número máximo de reintentos para operaciones.
     */
    @Min(1)
    private int maxReintentos = 3;

    /**
     * Tiempo máximo de espera en milisegundos.
     */
    @Min(1000)
    private int timeoutMs = 5000;

    /**
     * Configuración de seguridad.
     */
    @Valid
    private Seguridad seguridad = new Seguridad();

    /**
     * Configuración de seguridad del componente.
     */
    @Getter
    @Setter
    public static class Seguridad {
        
        /**
         * Indica si la seguridad está habilitada.
         */
        private boolean habilitada = true;
        
        /**
         * Nivel mínimo de seguridad requerido.
         */
        private String nivelMinimo = "MEDIO";
        
        /**
         * Configuración JWT.
         */
        @Valid
        private Jwt jwt = new Jwt();
        
        /**
         * Configuración JWT.
         */
        @Getter
        @Setter
        public static class Jwt {
            
            /**
             * Emisor del token JWT.
             */
            private String issuer = "vucem.gob.mx";
            
            /**
             * Tiempo de expiración en segundos.
             */
            @Min(60)
            private long expiracion = 3600;
        }
    }
}