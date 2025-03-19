package mx.gob.vucem.componente;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

/**
 * Clase principal de la aplicación VUCEM Componente.
 * Punto de entrada para la inicialización de Spring Boot.
 */
@SpringBootApplication
@EnableFeignClients
@EnableJpaAuditing
public class VucemComponenteApplication {

    public static void main(String[] args) {
        SpringApplication.run(VucemComponenteApplication.class, args);
    }
}