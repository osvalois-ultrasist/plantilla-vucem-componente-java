package mx.gob.vucem.componente.infrastructure.persistence.repositories;

import org.springframework.data.domain.AuditorAware;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.Optional;

/**
 * Implementación de AuditorAware para proporcionar el usuario actual
 * para la auditoría de entidades JPA.
 */
public class AuditorAwareImpl implements AuditorAware<String> {

    private static final String SISTEMA = "SISTEMA";

    /**
     * Obtiene el usuario actual para la auditoría.
     * Si hay un usuario autenticado, devuelve su nombre de usuario,
     * de lo contrario devuelve "SISTEMA".
     *
     * @return Opcional que contiene el nombre de usuario actual
     */
    @Override
    public Optional<String> getCurrentAuditor() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        
        if (authentication == null || !authentication.isAuthenticated() || 
            authentication.getPrincipal().equals("anonymousUser")) {
            return Optional.of(SISTEMA);
        }
        
        return Optional.of(authentication.getName());
    }
}