package mx.gob.vucem.componente.application.services;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import mx.gob.vucem.componente.application.dtos.RecursoDTO;
import mx.gob.vucem.componente.application.mappers.RecursoMapper;
import mx.gob.vucem.componente.domain.entities.Recurso;
import mx.gob.vucem.componente.domain.exceptions.BusinessException;
import mx.gob.vucem.componente.domain.repositories.RecursoRepository;
import mx.gob.vucem.componente.domain.services.RecursoService;
import mx.gob.vucem.componente.domain.valueobjects.PuntoExtension;
import mx.gob.vucem.componente.interfaces.events.PublicadorEventos;
import mx.gob.vucem.componente.interfaces.events.RecursoCreado;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Implementación del servicio de gestión de recursos.
 */
@Service
@Slf4j
@RequiredArgsConstructor
public class RecursoServiceImpl implements RecursoService {

    private final RecursoRepository recursoRepository;
    private final RegistroExtensiones registroExtensiones;
    private final RecursoMapper recursoMapper;
    private final PublicadorEventos publicadorEventos;

    @Override
    @Transactional(readOnly = true)
    public List<Recurso> obtenerTodos() {
        log.debug("Obteniendo todos los recursos");
        return recursoRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Recurso> obtenerActivos() {
        log.debug("Obteniendo recursos activos");
        return recursoRepository.findByActivoTrue();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Recurso> buscarPorNombre(String nombre) {
        log.debug("Buscando recursos por nombre: {}", nombre);
        return recursoRepository.findByNombreContaining(nombre);
    }

    @Override
    @Transactional(readOnly = true)
    public Recurso obtenerPorId(UUID id) {
        log.debug("Obteniendo recurso por ID: {}", id);
        return recursoRepository.findById(id)
                .orElseThrow(() -> new BusinessException("RECURSO_NO_ENCONTRADO", 
                        "Recurso no encontrado con ID: " + id));
    }

    @Override
    @Transactional
    public Recurso crear(Recurso recurso) {
        log.debug("Creando nuevo recurso: {}", recurso.getNombre());
        validarRecurso(recurso);
        
        // Aplicar puntos de extensión de validación
        Map<String, Object> contexto = new HashMap<>();
        List<Boolean> resultadosValidacion = registroExtensiones.ejecutarExtensiones(
                Recurso.class, recurso, contexto);
        
        // Si alguna validación falla
        if (resultadosValidacion.contains(Boolean.FALSE)) {
            throw new BusinessException("VALIDACION_EXTENSION", 
                    "El recurso no cumple con las validaciones de las extensiones");
        }
        
        // Generar ID si no tiene
        if (recurso.getId() == null) {
            recurso.setId(UUID.randomUUID());
        }
        
        Recurso recursoGuardado = recursoRepository.save(recurso);
        
        // Publicar evento de recurso creado
        RecursoDTO recursoDTO = recursoMapper.toDto(recursoGuardado);
        publicadorEventos.publicar(new RecursoCreado(recursoDTO));
        
        return recursoGuardado;
    }

    @Override
    @Transactional
    public Recurso actualizar(UUID id, Recurso recurso) {
        log.debug("Actualizando recurso con ID: {}", id);
        
        Recurso existente = obtenerPorId(id);
        recurso.setId(id);
        validarRecurso(recurso);
        
        // Aplicar puntos de extensión de validación
        Map<String, Object> contexto = new HashMap<>();
        contexto.put("recursoExistente", existente);
        List<Boolean> resultadosValidacion = registroExtensiones.ejecutarExtensiones(
                Recurso.class, recurso, contexto);
        
        // Si alguna validación falla
        if (resultadosValidacion.contains(Boolean.FALSE)) {
            throw new BusinessException("VALIDACION_EXTENSION", 
                    "El recurso no cumple con las validaciones de las extensiones");
        }
        
        return recursoRepository.save(recurso);
    }

    @Override
    @Transactional
    public void eliminar(UUID id) {
        log.debug("Eliminando recurso con ID: {}", id);
        
        // Verificar que existe
        obtenerPorId(id);
        
        recursoRepository.deleteById(id);
    }
    
    /**
     * Valida que el recurso cumpla con las reglas de negocio.
     *
     * @param recurso Recurso a validar
     * @throws BusinessException si el recurso no es válido
     */
    private void validarRecurso(Recurso recurso) {
        if (recurso == null) {
            throw new BusinessException("RECURSO_REQUERIDO", "El recurso no puede ser nulo");
        }
        
        if (recurso.getNombre() == null || recurso.getNombre().trim().isEmpty()) {
            throw new BusinessException("NOMBRE_REQUERIDO", "El nombre del recurso es requerido");
        }
        
        if (recurso.getNombre().length() > 100) {
            throw new BusinessException("NOMBRE_MUY_LARGO", 
                    "El nombre del recurso no puede exceder los 100 caracteres");
        }
        
        if (recurso.getDescripcion() != null && recurso.getDescripcion().length() > 500) {
            throw new BusinessException("DESCRIPCION_MUY_LARGA", 
                    "La descripción del recurso no puede exceder los 500 caracteres");
        }
    }
}