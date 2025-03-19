package mx.gob.vucem.componente.application.mappers;

import mx.gob.vucem.componente.application.dtos.RecursoDTO;
import mx.gob.vucem.componente.domain.entities.Recurso;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

import java.util.List;

/**
 * Mapper para convertir entre entidades de dominio y DTOs de recursos.
 */
@Mapper(componentModel = "spring")
public interface RecursoMapper {

    /**
     * Convierte una entidad de dominio a DTO.
     *
     * @param entity Entidad de dominio
     * @return DTO
     */
    @Mapping(target = "fechaCreacion", source = "fechaCreacion")
    @Mapping(target = "fechaModificacion", source = "fechaModificacion")
    RecursoDTO toDto(Recurso entity);

    /**
     * Convierte un DTO a entidad de dominio.
     *
     * @param dto DTO
     * @return Entidad de dominio
     */
    @Mapping(target = "fechaCreacion", ignore = true)
    @Mapping(target = "fechaModificacion", ignore = true)
    @Mapping(target = "creadoPor", ignore = true)
    @Mapping(target = "modificadoPor", ignore = true)
    Recurso toDomain(RecursoDTO dto);

    /**
     * Convierte una lista de entidades de dominio a lista de DTOs.
     *
     * @param entities Lista de entidades de dominio
     * @return Lista de DTOs
     */
    List<RecursoDTO> toDtoList(List<Recurso> entities);

    /**
     * Actualiza una entidad de dominio con los valores de un DTO.
     *
     * @param dto DTO con los nuevos valores
     * @param entity Entidad de dominio a actualizar
     */
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "fechaCreacion", ignore = true)
    @Mapping(target = "fechaModificacion", ignore = true)
    @Mapping(target = "creadoPor", ignore = true)
    @Mapping(target = "modificadoPor", ignore = true)
    void updateDomainFromDto(RecursoDTO dto, @MappingTarget Recurso entity);
}