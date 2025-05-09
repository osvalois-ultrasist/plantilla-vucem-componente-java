package mx.gob.vucem.componente.application.dtos;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * DTO para la transferencia de datos de recursos.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Representa un recurso del sistema")
public class RecursoDTO {

    /**
     * Identificador único del recurso.
     */
    @Schema(description = "Identificador único del recurso", example = "123e4567-e89b-12d3-a456-426614174000")
    private UUID id;

    /**
     * Nombre del recurso.
     */
    @NotBlank(message = "El nombre es requerido")
    @Size(max = 100, message = "El nombre no puede exceder los 100 caracteres")
    @Schema(description = "Nombre del recurso", example = "Recurso de ejemplo", required = true)
    private String nombre;

    /**
     * Descripción del recurso.
     */
    @Size(max = 500, message = "La descripción no puede exceder los 500 caracteres")
    @Schema(description = "Descripción del recurso", example = "Esta es una descripción de ejemplo para el recurso")
    private String descripcion;

    /**
     * Indica si el recurso está activo.
     */
    @Schema(description = "Indica si el recurso está activo", defaultValue = "true")
    private Boolean activo;

    /**
     * Atributos adicionales del recurso.
     */
    @Schema(description = "Atributos adicionales del recurso")
    private Map<String, String> atributos = new HashMap<>();

    /**
     * Fecha de creación del recurso.
     */
    @Schema(description = "Fecha de creación del recurso", accessMode = Schema.AccessMode.READ_ONLY)
    private LocalDateTime fechaCreacion;

    /**
     * Fecha de última modificación del recurso.
     */
    @Schema(description = "Fecha de última modificación del recurso", accessMode = Schema.AccessMode.READ_ONLY)
    private LocalDateTime fechaModificacion;
}