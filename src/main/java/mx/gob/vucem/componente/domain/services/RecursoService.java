package mx.gob.vucem.componente.domain.services;

import mx.gob.vucem.componente.domain.entities.Recurso;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Interfaz de servicio para la gestión de recursos.
 * Define las operaciones de negocio relacionadas con los recursos.
 */
public interface RecursoService {

    /**
     * Obtiene todos los recursos.
     *
     * @return Lista de recursos
     */
    List<Recurso> obtenerTodos();

    /**
     * Obtiene todos los recursos activos.
     *
     * @return Lista de recursos activos
     */
    List<Recurso> obtenerActivos();

    /**
     * Busca recursos por nombre.
     *
     * @param nombre Nombre o parte del nombre a buscar
     * @return Lista de recursos que coinciden con el nombre
     */
    List<Recurso> buscarPorNombre(String nombre);

    /**
     * Obtiene un recurso por su ID.
     *
     * @param id ID del recurso
     * @return Recurso si existe
     * @throws mx.gob.vucem.componente.domain.exceptions.BusinessException si el recurso no existe
     */
    Recurso obtenerPorId(UUID id);

    /**
     * Crea un nuevo recurso.
     *
     * @param recurso Datos del recurso a crear
     * @return Recurso creado
     * @throws mx.gob.vucem.componente.domain.exceptions.BusinessException si el recurso no es válido
     */
    Recurso crear(Recurso recurso);

    /**
     * Actualiza un recurso existente.
     *
     * @param id ID del recurso a actualizar
     * @param recurso Datos actualizados del recurso
     * @return Recurso actualizado
     * @throws mx.gob.vucem.componente.domain.exceptions.BusinessException si el recurso no existe o no es válido
     */
    Recurso actualizar(UUID id, Recurso recurso);

    /**
     * Elimina un recurso por su ID.
     *
     * @param id ID del recurso a eliminar
     * @throws mx.gob.vucem.componente.domain.exceptions.BusinessException si el recurso no existe
     */
    void eliminar(UUID id);
}