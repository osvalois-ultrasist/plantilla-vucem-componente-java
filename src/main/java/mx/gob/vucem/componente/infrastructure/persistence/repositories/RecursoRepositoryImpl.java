package mx.gob.vucem.componente.infrastructure.persistence.repositories;

import lombok.RequiredArgsConstructor;
import mx.gob.vucem.componente.domain.entities.Recurso;
import mx.gob.vucem.componente.domain.repositories.RecursoRepository;
import mx.gob.vucem.componente.infrastructure.persistence.entities.RecursoEntity;
import mx.gob.vucem.componente.infrastructure.persistence.mappers.RecursoEntityMapper;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Implementación de RecursoRepository que utiliza JPA.
 */
@Component
@RequiredArgsConstructor
public class RecursoRepositoryImpl implements RecursoRepository {

    private final RecursoJpaRepository recursoJpaRepository;
    private final RecursoEntityMapper mapper;

    @Override
    public List<Recurso> findAll() {
        return recursoJpaRepository.findAll()
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Recurso> findByActivoTrue() {
        return recursoJpaRepository.findByActivoTrue()
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Recurso> findByNombreContaining(String nombre) {
        return recursoJpaRepository.findByNombreContainingIgnoreCase(nombre)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<Recurso> findById(UUID id) {
        return recursoJpaRepository.findById(id)
                .map(mapper::toDomain);
    }

    @Override
    public Recurso save(Recurso recurso) {
        RecursoEntity entity = mapper.toEntity(recurso);
        RecursoEntity savedEntity = recursoJpaRepository.save(entity);
        return mapper.toDomain(savedEntity);
    }

    @Override
    public void deleteById(UUID id) {
        recursoJpaRepository.deleteById(id);
    }
}