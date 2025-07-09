package mx.gob.vucem.componente.interfaces.api.controllers;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import mx.gob.vucem.componente.application.dtos.RecursoDTO;
import mx.gob.vucem.componente.application.services.RecursoApplicationService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

/**
 * Controlador REST para la gestión de recursos.
 */
@RestController
@RequestMapping("/api/recursos")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Recursos", description = "API para la gestión de recursos")
public class RecursoController {

    private final RecursoApplicationService recursoService;

    /**
     * Obtiene todos los recursos.
     *
     * @return Lista de recursos
     */
    @GetMapping
    @Operation(
        summary = "Obtiene todos los recursos",
        description = "Recupera la lista completa de recursos disponibles en el sistema",
        responses = {
            @ApiResponse(
                responseCode = "200",
                description = "Lista de recursos obtenida correctamente",
                content = @Content(mediaType = "application/json")
            )
        }
    )
    public ResponseEntity<List<RecursoDTO>> obtenerTodos(
            @Parameter(description = "Filtrar recursos activos únicamente")
            @RequestParam(required = false) Boolean soloActivos,
            
            @Parameter(description = "Buscar por nombre")
            @RequestParam(required = false) String nombre
    ) {
        List<RecursoDTO> recursos;
        
        if (nombre != null && !nombre.trim().isEmpty()) {
            log.debug("Buscando recursos por nombre: {}", nombre);
            recursos = recursoService.buscarPorNombre(nombre);
        } else if (soloActivos != null && soloActivos) {
            log.debug("Obteniendo recursos activos");
            recursos = recursoService.obtenerActivos();
        } else {
            log.debug("Obteniendo todos los recursos");
            recursos = recursoService.obtenerTodos();
        }
        
        return ResponseEntity.ok(recursos);
    }

    /**
     * Obtiene un recurso por su ID.
     *
     * @param id ID del recurso
     * @return Recurso
     */
    @GetMapping("/{id}")
    @Operation(
        summary = "Obtiene un recurso por ID",
        description = "Recupera un recurso específico basado en su identificador único",
        responses = {
            @ApiResponse(
                responseCode = "200",
                description = "Recurso encontrado",
                content = @Content(mediaType = "application/json")
            ),
            @ApiResponse(
                responseCode = "404",
                description = "Recurso no encontrado"
            )
        }
    )
    public ResponseEntity<RecursoDTO> obtenerPorId(
            @Parameter(description = "ID del recurso", required = true)
            @PathVariable UUID id
    ) {
        log.debug("Obteniendo recurso por ID: {}", id);
        RecursoDTO recurso = recursoService.obtenerPorId(id);
        return ResponseEntity.ok(recurso);
    }

    /**
     * Crea un nuevo recurso.
     *
     * @param recursoDTO Datos del recurso a crear
     * @return Recurso creado
     */
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(
        summary = "Crea un nuevo recurso",
        description = "Crea un nuevo recurso en el sistema",
        responses = {
            @ApiResponse(
                responseCode = "201",
                description = "Recurso creado correctamente",
                content = @Content(mediaType = "application/json")
            ),
            @ApiResponse(
                responseCode = "400",
                description = "Datos de recurso inválidos"
            )
        }
    )
    public ResponseEntity<RecursoDTO> crear(
            @Parameter(description = "Datos del recurso a crear", required = true)
            @Valid @RequestBody RecursoDTO recursoDTO
    ) {
        log.debug("Creando nuevo recurso: {}", recursoDTO.getNombre());
        RecursoDTO creado = recursoService.crear(recursoDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(creado);
    }

    /**
     * Actualiza un recurso existente.
     *
     * @param id ID del recurso a actualizar
     * @param recursoDTO Nuevos datos del recurso
     * @return Recurso actualizado
     */
    @PutMapping("/{id}")
    @Operation(
        summary = "Actualiza un recurso existente",
        description = "Actualiza los datos de un recurso existente en el sistema",
        responses = {
            @ApiResponse(
                responseCode = "200",
                description = "Recurso actualizado correctamente",
                content = @Content(mediaType = "application/json")
            ),
            @ApiResponse(
                responseCode = "400",
                description = "Datos de recurso inválidos"
            ),
            @ApiResponse(
                responseCode = "404",
                description = "Recurso no encontrado"
            )
        }
    )
    public ResponseEntity<RecursoDTO> actualizar(
            @Parameter(description = "ID del recurso", required = true)
            @PathVariable UUID id,
            
            @Parameter(description = "Nuevos datos del recurso", required = true)
            @Valid @RequestBody RecursoDTO recursoDTO
    ) {
        log.debug("Actualizando recurso con ID: {}", id);
        RecursoDTO actualizado = recursoService.actualizar(id, recursoDTO);
        return ResponseEntity.ok(actualizado);
    }

    /**
     * Elimina un recurso.
     *
     * @param id ID del recurso a eliminar
     * @return Respuesta sin contenido
     */
    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    @Operation(
        summary = "Elimina un recurso",
        description = "Elimina un recurso existente del sistema",
        responses = {
            @ApiResponse(
                responseCode = "204",
                description = "Recurso eliminado correctamente"
            ),
            @ApiResponse(
                responseCode = "404",
                description = "Recurso no encontrado"
            )
        }
    )
    public ResponseEntity<Void> eliminar(
            @Parameter(description = "ID del recurso", required = true)
            @PathVariable UUID id
    ) {
        log.debug("Eliminando recurso con ID: {}", id);
        recursoService.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}