package mx.gob.vucem.componente.infrastructure.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.domain.AuditorAware;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import mx.gob.vucem.componente.infrastructure.persistence.repositories.AuditorAwareImpl;

/**
 * Configuración de JPA para la aplicación.
 * Define la configuración de auditoría, transacciones y repositorios.
 */
@Configuration
@EnableTransactionManagement
@EnableJpaRepositories(basePackages = "mx.gob.vucem.componente.infrastructure.persistence.repositories")
@EnableJpaAuditing(auditorAwareRef = "auditorProvider")
public class JpaConfig {

    /**
     * Proporciona el auditor para la auditoría de JPA.
     *
     * @return Implementación de AuditorAware
     */
    @Bean
    public AuditorAware<String> auditorProvider() {
        return new AuditorAwareImpl();
    }
}