package mx.gob.vucem.componente.interfaces.api.controllers;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

/**
 * Controlador para verificación de salud del servicio.
 * Proporciona endpoints para verificar si el servicio está funcionando correctamente.
 */
@RestController
@RequestMapping("/api/health")
@RequiredArgsConstructor
@Tag(name = "Salud", description = "Operaciones de verificación de salud del servicio")
public class HealthController {

    @Value("${spring.application.name}")
    private String applicationName;

    @Value("${vucem.componente.version}")
    private String version;

    /**
     * Verifica que el servicio esté en funcionamiento.
     *
     * @return Respuesta con información básica del servicio
     */
    @GetMapping
    @Operation(
        summary = "Verifica el estado del servicio",
        description = "Retorna información básica del servicio, confirmando que está en funcionamiento",
        responses = {
            @ApiResponse(
                responseCode = "200", 
                description = "Servicio en funcionamiento",
                content = @Content(
                    mediaType = "application/json",
                    schema = @Schema(implementation = Map.class)
                )
            )
        }
    )
    public ResponseEntity<Map<String, Object>> health() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("service", applicationName);
        response.put("version", version);
        response.put("timestamp", System.currentTimeMillis());

        return ResponseEntity.ok(response);
    }
}