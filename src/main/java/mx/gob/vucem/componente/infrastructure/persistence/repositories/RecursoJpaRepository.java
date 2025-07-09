package mx.gob.vucem.componente.infrastructure.persistence.repositories;

import mx.gob.vucem.componente.infrastructure.persistence.entities.RecursoEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

/**
 * Repositorio JPA para la entidad RecursoEntity.
 */
@Repository
public interface RecursoJpaRepository extends JpaRepository<RecursoEntity, UUID> {

    /**
     * Busca recursos activos.
     *
     * @return Lista de recursos activos
     */
    List<RecursoEntity> findByActivoTrue();

    /**
     * Busca recursos que contengan el nombre especificado.
     *
     * @param nombre Nombre o parte del nombre a buscar
     * @return Lista de recursos que coinciden con el nombre
     */
    List<RecursoEntity> findByNombreContainingIgnoreCase(String nombre);
}