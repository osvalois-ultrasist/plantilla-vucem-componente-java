package mx.gob.vucem.componente.infrastructure.security;

import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collections;

/**
 * Implementación de UserDetailsService para la autenticación de usuarios.
 * En un entorno real, esta clase debería obtener los usuarios de una base de datos
 * o un servicio de autenticación externo.
 */
@Service
@Slf4j
public class UserDetailsServiceImpl implements UserDetailsService {

    /**
     * Carga un usuario por su nombre de usuario.
     * Esta implementación es solo para pruebas y debería ser reemplazada 
     * por una implementación real que obtenga los usuarios de una base de datos.
     *
     * @param username Nombre de usuario
     * @return Detalles del usuario
     * @throws UsernameNotFoundException si el usuario no existe
     */
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        log.debug("Buscando usuario: {}", username);
        
        // En un entorno real, aquí se consultaría un recurso externo
        // Esta implementación es solo para pruebas
        
        // Simular un usuario de sistema para el ejemplo
        if ("sistema".equals(username)) {
            return new User(
                    "sistema",
                    "", // La contraseña no se utiliza en autenticación por token
                    Collections.singletonList(new SimpleGrantedAuthority("ROLE_SYSTEM"))
            );
        }
        
        throw new UsernameNotFoundException("Usuario no encontrado: " + username);
    }
}