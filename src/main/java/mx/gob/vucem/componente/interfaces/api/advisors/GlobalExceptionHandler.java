package mx.gob.vucem.componente.interfaces.api.advisors;

import jakarta.persistence.EntityNotFoundException;
import lombok.extern.slf4j.Slf4j;
import mx.gob.vucem.componente.domain.exceptions.BusinessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Manejador global de excepciones para la API.
 * Proporciona un formato estándar para las respuestas de error en la API.
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    /**
     * Maneja excepciones de validación de argumentos.
     *
     * @param ex Excepción de validación
     * @param request Solicitud web
     * @return Respuesta con errores de validación
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, Object>> handleValidationExceptions(
            MethodArgumentNotValidException ex, WebRequest request) {
        
        Map<String, String> errors = ex.getBindingResult()
                .getAllErrors()
                .stream()
                .collect(Collectors.toMap(
                        error -> ((FieldError) error).getField(),
                        error -> error.getDefaultMessage() != null ? error.getDefaultMessage() : "Error de validación",
                        (e1, e2) -> e1 + ", " + e2
                ));
        
        Map<String, Object> response = createErrorResponse(
                "ERR_VALIDACION", 
                "Error de validación en los datos de entrada", 
                HttpStatus.BAD_REQUEST,
                request.getDescription(false));
        
        response.put("errores", errors);
        
        log.warn("Error de validación: {}", errors);
        return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
    }

    /**
     * Maneja excepciones de negocio.
     *
     * @param ex Excepción de negocio
     * @param request Solicitud web
     * @return Respuesta con error de negocio
     */
    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<Map<String, Object>> handleBusinessExceptions(
            BusinessException ex, WebRequest request) {
        
        Map<String, Object> response = createErrorResponse(
                ex.getCodigo(),
                ex.getMensaje(),
                HttpStatus.UNPROCESSABLE_ENTITY,
                request.getDescription(false));
        
        log.warn("Error de negocio: {} - {}", ex.getCodigo(), ex.getMensaje());
        return new ResponseEntity<>(response, HttpStatus.UNPROCESSABLE_ENTITY);
    }

    /**
     * Maneja excepciones de entidad no encontrada.
     *
     * @param ex Excepción de entidad no encontrada
     * @param request Solicitud web
     * @return Respuesta con error de recurso no encontrado
     */
    @ExceptionHandler(EntityNotFoundException.class)
    public ResponseEntity<Map<String, Object>> handleEntityNotFoundExceptions(
            EntityNotFoundException ex, WebRequest request) {
        
        Map<String, Object> response = createErrorResponse(
                "ERR_RECURSO_NO_ENCONTRADO",
                ex.getMessage(),
                HttpStatus.NOT_FOUND,
                request.getDescription(false));
        
        log.warn("Recurso no encontrado: {}", ex.getMessage());
        return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
    }

    /**
     * Maneja excepciones genéricas.
     *
     * @param ex Excepción genérica
     * @param request Solicitud web
     * @return Respuesta con error interno del servidor
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, Object>> handleAllExceptions(
            Exception ex, WebRequest request) {
        
        Map<String, Object> response = createErrorResponse(
                "ERR_INTERNO",
                "Error interno del servidor",
                HttpStatus.INTERNAL_SERVER_ERROR,
                request.getDescription(false));
        
        log.error("Error no controlado: ", ex);
        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
    }

    /**
     * Crea una respuesta de error estándar.
     *
     * @param codigo Código de error
     * @param mensaje Mensaje de error
     * @param status Estado HTTP
     * @param path Ruta de la solicitud
     * @return Mapa con la respuesta de error
     */
    private Map<String, Object> createErrorResponse(
            String codigo, String mensaje, HttpStatus status, String path) {
        
        Map<String, Object> errorResponse = new HashMap<>();
        errorResponse.put("timestamp", LocalDateTime.now().toString());
        errorResponse.put("codigo", codigo);
        errorResponse.put("mensaje", mensaje);
        errorResponse.put("status", status.value());
        errorResponse.put("error", status.getReasonPhrase());
        errorResponse.put("path", path);
        
        return errorResponse;
    }
}