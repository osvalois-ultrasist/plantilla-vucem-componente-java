package mx.gob.vucem.componente.domain.entities;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * Entidad de dominio que representa un recurso genérico.
 * Esta es una entidad de ejemplo para la plantilla del componente.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Recurso extends AuditableEntity {

    /**
     * Identificador único del recurso.
     */
    private UUID id;

    /**
     * Nombre del recurso.
     */
    private String nombre;

    /**
     * Descripción del recurso.
     */
    private String descripcion;

    /**
     * Indica si el recurso está activo.
     */
    private Boolean activo = true;

    /**
     * Atributos adicionales del recurso.
     */
    private Map<String, String> atributos = new HashMap<>();

    /**
     * Valida si el recurso es válido según las reglas de negocio.
     *
     * @return true si el recurso es válido, false en caso contrario
     */
    public boolean esValido() {
        return nombre != null && !nombre.trim().isEmpty();
    }
}