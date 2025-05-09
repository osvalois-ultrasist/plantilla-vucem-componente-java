package mx.gob.vucem.componente.domain.services;

import mx.gob.vucem.componente.application.services.RecursoServiceImpl;
import mx.gob.vucem.componente.application.services.RegistroExtensiones;
import mx.gob.vucem.componente.domain.entities.Recurso;
import mx.gob.vucem.componente.domain.exceptions.BusinessException;
import mx.gob.vucem.componente.domain.repositories.RecursoRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * Pruebas unitarias para el servicio de recursos.
 */
@ExtendWith(MockitoExtension.class)
class RecursoServiceTest {

    @Mock
    private RecursoRepository recursoRepository;

    @Mock
    private RegistroExtensiones registroExtensiones;

    @InjectMocks
    private RecursoServiceImpl recursoService;

    private Recurso recurso;
    private UUID id;

    @BeforeEach
    void setUp() {
        id = UUID.randomUUID();
        recurso = new Recurso();
        recurso.setId(id);
        recurso.setNombre("Recurso de prueba");
        recurso.setDescripcion("Descripción de prueba");
        recurso.setActivo(true);
    }

    @Test
    void debeObtenerTodosLosRecursos() {
        // Arrange
        List<Recurso> recursos = Arrays.asList(
                recurso,
                new Recurso()
        );
        when(recursoRepository.findAll()).thenReturn(recursos);

        // Act
        List<Recurso> resultado = recursoService.obtenerTodos();

        // Assert
        assertEquals(2, resultado.size());
        verify(recursoRepository).findAll();
    }

    @Test
    void debeObtenerRecursosPorId() {
        // Arrange
        when(recursoRepository.findById(id)).thenReturn(Optional.of(recurso));

        // Act
        Recurso resultado = recursoService.obtenerPorId(id);

        // Assert
        assertNotNull(resultado);
        assertEquals(id, resultado.getId());
        assertEquals("Recurso de prueba", resultado.getNombre());
        verify(recursoRepository).findById(id);
    }

    @Test
    void debeLanzarExcepcionCuandoRecursoNoExiste() {
        // Arrange
        UUID idNoExistente = UUID.randomUUID();
        when(recursoRepository.findById(idNoExistente)).thenReturn(Optional.empty());

        // Act & Assert
        BusinessException exception = assertThrows(BusinessException.class, () -> {
            recursoService.obtenerPorId(idNoExistente);
        });
        
        assertEquals("RECURSO_NO_ENCONTRADO", exception.getCodigo());
        verify(recursoRepository).findById(idNoExistente);
    }

    @Test
    void debeCrearRecurso() {
        // Arrange
        Recurso nuevoRecurso = new Recurso();
        nuevoRecurso.setNombre("Nuevo recurso");
        nuevoRecurso.setDescripcion("Nueva descripción");
        
        when(recursoRepository.save(any(Recurso.class))).thenReturn(nuevoRecurso);
        when(registroExtensiones.ejecutarExtensiones(any(), any(), any())).thenReturn(Arrays.asList(true));

        // Act
        Recurso resultado = recursoService.crear(nuevoRecurso);

        // Assert
        assertNotNull(resultado);
        assertEquals("Nuevo recurso", resultado.getNombre());
        verify(recursoRepository).save(any(Recurso.class));
        verify(registroExtensiones).ejecutarExtensiones(any(), any(), any());
    }

    @Test
    void debeActualizarRecurso() {
        // Arrange
        Recurso recursoActualizado = new Recurso();
        recursoActualizado.setId(id);
        recursoActualizado.setNombre("Nombre actualizado");
        recursoActualizado.setDescripcion("Descripción actualizada");
        
        when(recursoRepository.findById(id)).thenReturn(Optional.of(recurso));
        when(recursoRepository.save(any(Recurso.class))).thenReturn(recursoActualizado);
        when(registroExtensiones.ejecutarExtensiones(any(), any(), any())).thenReturn(Arrays.asList(true));

        // Act
        Recurso resultado = recursoService.actualizar(id, recursoActualizado);

        // Assert
        assertNotNull(resultado);
        assertEquals("Nombre actualizado", resultado.getNombre());
        assertEquals("Descripción actualizada", resultado.getDescripcion());
        verify(recursoRepository).findById(id);
        verify(recursoRepository).save(any(Recurso.class));
        verify(registroExtensiones).ejecutarExtensiones(any(), any(), any());
    }

    @Test
    void debeEliminarRecurso() {
        // Arrange
        when(recursoRepository.findById(id)).thenReturn(Optional.of(recurso));
        doNothing().when(recursoRepository).deleteById(id);

        // Act
        recursoService.eliminar(id);

        // Assert
        verify(recursoRepository).findById(id);
        verify(recursoRepository).deleteById(id);
    }

    @Test
    void debeLanzarExcepcionCuandoNombreEsNulo() {
        // Arrange
        Recurso recursoInvalido = new Recurso();
        recursoInvalido.setNombre(null);

        // Act & Assert
        BusinessException exception = assertThrows(BusinessException.class, () -> {
            recursoService.crear(recursoInvalido);
        });
        
        assertEquals("NOMBRE_REQUERIDO", exception.getCodigo());
        verify(recursoRepository, never()).save(any());
    }
}