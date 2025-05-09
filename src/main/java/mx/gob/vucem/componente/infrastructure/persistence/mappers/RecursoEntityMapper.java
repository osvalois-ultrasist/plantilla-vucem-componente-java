package mx.gob.vucem.componente.infrastructure.persistence.mappers;

import mx.gob.vucem.componente.domain.entities.Recurso;
import mx.gob.vucem.componente.infrastructure.persistence.entities.RecursoEntity;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

/**
 * Mapper para convertir entre entidades de dominio y entidades JPA.
 */
@Mapper(componentModel = "spring")
public interface RecursoEntityMapper {

    /**
     * Convierte una entidad de dominio a entidad JPA.
     *
     * @param domain Entidad de dominio
     * @return Entidad JPA
     */
    RecursoEntity toEntity(Recurso domain);

    /**
     * Convierte una entidad JPA a entidad de dominio.
     *
     * @param entity Entidad JPA
     * @return Entidad de dominio
     */
    Recurso toDomain(RecursoEntity entity);

    /**
     * Actualiza una entidad JPA con los valores de una entidad de dominio.
     *
     * @param domain Entidad de dominio con los nuevos valores
     * @param entity Entidad JPA a actualizar
     */
    void updateEntityFromDomain(Recurso domain, @MappingTarget RecursoEntity entity);
}