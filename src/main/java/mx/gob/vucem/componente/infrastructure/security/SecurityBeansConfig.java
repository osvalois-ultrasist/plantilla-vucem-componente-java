package mx.gob.vucem.componente.infrastructure.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

/**
 * Configuración de beans relacionados con seguridad.
 */
@Configuration
public class SecurityBeansConfig {

    /**
     * Codificador de contraseñas para la aplicación.
     *
     * @return Implementación de PasswordEncoder
     */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}