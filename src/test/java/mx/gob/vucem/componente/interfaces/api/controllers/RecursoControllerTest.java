package mx.gob.vucem.componente.interfaces.api.controllers;

import com.fasterxml.jackson.databind.ObjectMapper;
import mx.gob.vucem.componente.application.dtos.RecursoDTO;
import mx.gob.vucem.componente.application.services.RecursoApplicationService;
import mx.gob.vucem.componente.domain.exceptions.BusinessException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Arrays;
import java.util.List;
import java.util.UUID;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Pruebas unitarias para el controlador de recursos.
 */
@WebMvcTest(RecursoController.class)
@WithMockUser(roles = "SYSTEM")
class RecursoControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private RecursoApplicationService recursoService;

    private RecursoDTO recursoDTO;
    private UUID id;

    @BeforeEach
    void setUp() {
        id = UUID.randomUUID();
        recursoDTO = new RecursoDTO();
        recursoDTO.setId(id);
        recursoDTO.setNombre("Recurso de prueba");
        recursoDTO.setDescripcion("Descripción de prueba");
        recursoDTO.setActivo(true);
    }

    @Test
    void debeObtenerTodosLosRecursos() throws Exception {
        // Arrange
        List<RecursoDTO> recursos = Arrays.asList(recursoDTO, new RecursoDTO());
        when(recursoService.obtenerTodos()).thenReturn(recursos);

        // Act & Assert
        mockMvc.perform(get("/api/recursos"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$", hasSize(2)))
                .andExpect(jsonPath("$[0].id").value(id.toString()));

        verify(recursoService).obtenerTodos();
    }

    @Test
    void debeObtenerRecursoPorId() throws Exception {
        // Arrange
        when(recursoService.obtenerPorId(id)).thenReturn(recursoDTO);

        // Act & Assert
        mockMvc.perform(get("/api/recursos/{id}", id))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(id.toString()))
                .andExpect(jsonPath("$.nombre").value("Recurso de prueba"));

        verify(recursoService).obtenerPorId(id);
    }

    @Test
    void debeResponderConErrorCuandoRecursoNoExiste() throws Exception {
        // Arrange
        when(recursoService.obtenerPorId(id)).thenThrow(
                new BusinessException("RECURSO_NO_ENCONTRADO", "Recurso no encontrado")
        );

        // Act & Assert
        mockMvc.perform(get("/api/recursos/{id}", id))
                .andExpect(status().isUnprocessableEntity())
                .andExpect(jsonPath("$.codigo").value("RECURSO_NO_ENCONTRADO"));

        verify(recursoService).obtenerPorId(id);
    }

    @Test
    void debeCrearRecurso() throws Exception {
        // Arrange
        RecursoDTO nuevoRecurso = new RecursoDTO();
        nuevoRecurso.setNombre("Nuevo recurso");
        nuevoRecurso.setDescripcion("Nueva descripción");

        RecursoDTO creado = new RecursoDTO();
        creado.setId(UUID.randomUUID());
        creado.setNombre("Nuevo recurso");
        creado.setDescripcion("Nueva descripción");

        when(recursoService.crear(any(RecursoDTO.class))).thenReturn(creado);

        // Act & Assert
        mockMvc.perform(post("/api/recursos")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(nuevoRecurso)))
                .andExpect(status().isCreated())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").isNotEmpty())
                .andExpect(jsonPath("$.nombre").value("Nuevo recurso"));

        verify(recursoService).crear(any(RecursoDTO.class));
    }

    @Test
    void debeActualizarRecurso() throws Exception {
        // Arrange
        RecursoDTO actualizacion = new RecursoDTO();
        actualizacion.setNombre("Nombre actualizado");
        actualizacion.setDescripcion("Descripción actualizada");

        RecursoDTO actualizado = new RecursoDTO();
        actualizado.setId(id);
        actualizado.setNombre("Nombre actualizado");
        actualizado.setDescripcion("Descripción actualizada");

        when(recursoService.actualizar(eq(id), any(RecursoDTO.class))).thenReturn(actualizado);

        // Act & Assert
        mockMvc.perform(put("/api/recursos/{id}", id)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(actualizacion)))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(id.toString()))
                .andExpect(jsonPath("$.nombre").value("Nombre actualizado"));

        verify(recursoService).actualizar(eq(id), any(RecursoDTO.class));
    }

    @Test
    void debeEliminarRecurso() throws Exception {
        // Arrange
        doNothing().when(recursoService).eliminar(id);

        // Act & Assert
        mockMvc.perform(delete("/api/recursos/{id}", id))
                .andExpect(status().isNoContent());

        verify(recursoService).eliminar(id);
    }

    @Test
    void debeValidarDatosDeEntrada() throws Exception {
        // Arrange
        RecursoDTO recursoInvalido = new RecursoDTO();
        // Sin nombre, que es requerido

        // Act & Assert
        mockMvc.perform(post("/api/recursos")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(recursoInvalido)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.errores.nombre").exists());

        verify(recursoService, never()).crear(any());
    }
}