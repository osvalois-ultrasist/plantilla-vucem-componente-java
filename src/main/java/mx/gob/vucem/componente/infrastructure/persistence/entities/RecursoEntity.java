package mx.gob.vucem.componente.infrastructure.persistence.entities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import mx.gob.vucem.componente.domain.entities.AuditableEntity;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * Entidad JPA que representa un recurso en la base de datos.
 */
@Entity
@Table(name = "recursos")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RecursoEntity extends AuditableEntity {

    /**
     * Identificador único del recurso.
     */
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    /**
     * Nombre del recurso.
     */
    @Column(name = "nombre", nullable = false, length = 100)
    private String nombre;

    /**
     * Descripción del recurso.
     */
    @Column(name = "descripcion", length = 500)
    private String descripcion;

    /**
     * Indica si el recurso está activo.
     */
    @Column(name = "activo", nullable = false)
    private Boolean activo = true;

    /**
     * Atributos adicionales del recurso almacenados como JSON.
     */
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "atributos", columnDefinition = "jsonb")
    private Map<String, String> atributos = new HashMap<>();
}