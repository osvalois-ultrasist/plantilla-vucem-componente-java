package mx.gob.vucem.componente.interfaces.api.docs;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Configuración de OpenAPI para la documentación de la API.
 * Esta clase extiende la configuración base en infrastructure/config/OpenApiConfig.java
 * para personalizar aspectos específicos de la documentación de la API.
 */
@Configuration
public class OpenApiConfig {

    @Value("${spring.application.name}")
    private String applicationName;

    @Value("${vucem.componente.version}")
    private String applicationVersion;

    /**
     * Personaliza la configuración de OpenAPI para la documentación de la API.
     * 
     * @return Configuración personalizada de OpenAPI
     */
    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("API de " + applicationName)
                        .version(applicationVersion)
                        .description("API para gestionar recursos en el componente VUCEM")
                        .contact(new Contact()
                                .name("Equipo VUCEM")
                                .email("vucem@sat.gob.mx")
                                .url("https://www.gob.mx/vucem"))
                        .license(new License()
                                .name("Gobierno de México")
                                .url("https://www.gob.mx/terminos")))
                .addSecurityItem(new SecurityRequirement().addList("bearerAuth"))
                .components(new Components()
                        .addSecuritySchemes("bearerAuth", new SecurityScheme()
                                .type(SecurityScheme.Type.HTTP)
                                .scheme("bearer")
                                .bearerFormat("JWT")));
    }
}