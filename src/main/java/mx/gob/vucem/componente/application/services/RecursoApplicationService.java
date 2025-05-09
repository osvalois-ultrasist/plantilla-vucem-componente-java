package mx.gob.vucem.componente.application.services;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import mx.gob.vucem.componente.application.dtos.RecursoDTO;
import mx.gob.vucem.componente.application.mappers.RecursoMapper;
import mx.gob.vucem.componente.domain.entities.Recurso;
import mx.gob.vucem.componente.domain.services.RecursoService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

/**
 * Servicio de aplicación para recursos.
 * Este servicio actúa como fachada entre la capa de interfaz y la capa de dominio.
 */
@Service
@Slf4j
@RequiredArgsConstructor
public class RecursoApplicationService {

    private final RecursoService recursoService;
    private final RecursoMapper recursoMapper;

    /**
     * Obtiene todos los recursos.
     *
     * @return Lista de DTOs de recursos
     */
    @Transactional(readOnly = true)
    public List<RecursoDTO> obtenerTodos() {
        List<Recurso> recursos = recursoService.obtenerTodos();
        return recursoMapper.toDtoList(recursos);
    }

    /**
     * Obtiene todos los recursos activos.
     *
     * @return Lista de DTOs de recursos activos
     */
    @Transactional(readOnly = true)
    public List<RecursoDTO> obtenerActivos() {
        List<Recurso> recursos = recursoService.obtenerActivos();
        return recursoMapper.toDtoList(recursos);
    }

    /**
     * Busca recursos por nombre.
     *
     * @param nombre Nombre o parte del nombre a buscar
     * @return Lista de DTOs de recursos que coinciden con el nombre
     */
    @Transactional(readOnly = true)
    public List<RecursoDTO> buscarPorNombre(String nombre) {
        List<Recurso> recursos = recursoService.buscarPorNombre(nombre);
        return recursoMapper.toDtoList(recursos);
    }

    /**
     * Obtiene un recurso por su ID.
     *
     * @param id ID del recurso
     * @return DTO del recurso
     */
    @Transactional(readOnly = true)
    public RecursoDTO obtenerPorId(UUID id) {
        Recurso recurso = recursoService.obtenerPorId(id);
        return recursoMapper.toDto(recurso);
    }

    /**
     * Crea un nuevo recurso.
     *
     * @param recursoDTO DTO con los datos del recurso a crear
     * @return DTO del recurso creado
     */
    @Transactional
    public RecursoDTO crear(RecursoDTO recursoDTO) {
        Recurso recurso = recursoMapper.toDomain(recursoDTO);
        Recurso creado = recursoService.crear(recurso);
        return recursoMapper.toDto(creado);
    }

    /**
     * Actualiza un recurso existente.
     *
     * @param id ID del recurso a actualizar
     * @param recursoDTO DTO con los nuevos datos del recurso
     * @return DTO del recurso actualizado
     */
    @Transactional
    public RecursoDTO actualizar(UUID id, RecursoDTO recursoDTO) {
        Recurso recurso = recursoMapper.toDomain(recursoDTO);
        Recurso actualizado = recursoService.actualizar(id, recurso);
        return recursoMapper.toDto(actualizado);
    }

    /**
     * Elimina un recurso.
     *
     * @param id ID del recurso a eliminar
     */
    @Transactional
    public void eliminar(UUID id) {
        recursoService.eliminar(id);
    }
}