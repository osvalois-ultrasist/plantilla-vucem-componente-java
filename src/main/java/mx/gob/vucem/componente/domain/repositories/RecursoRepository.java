package mx.gob.vucem.componente.domain.repositories;

import mx.gob.vucem.componente.domain.entities.Recurso;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Interfaz de repositorio para la entidad Recurso.
 * Define las operaciones de acceso a datos para los recursos.
 */
public interface RecursoRepository {

    /**
     * Obtiene todos los recursos.
     *
     * @return Lista de todos los recursos
     */
    List<Recurso> findAll();

    /**
     * Obtiene todos los recursos activos.
     *
     * @return Lista de recursos activos
     */
    List<Recurso> findByActivoTrue();

    /**
     * Busca recursos por nombre.
     *
     * @param nombre Nombre o parte del nombre a buscar
     * @return Lista de recursos que coinciden con el nombre
     */
    List<Recurso> findByNombreContaining(String nombre);

    /**
     * Busca un recurso por su ID.
     *
     * @param id ID del recurso
     * @return Opcional que contiene el recurso si existe
     */
    Optional<Recurso> findById(UUID id);

    /**
     * Guarda un recurso.
     *
     * @param recurso Recurso a guardar
     * @return Recurso guardado
     */
    Recurso save(Recurso recurso);

    /**
     * Elimina un recurso por su ID.
     *
     * @param id ID del recurso a eliminar
     */
    void deleteById(UUID id);
}