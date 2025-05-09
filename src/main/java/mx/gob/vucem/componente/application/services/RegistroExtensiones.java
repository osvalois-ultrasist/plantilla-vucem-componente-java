package mx.gob.vucem.componente.application.services;

import lombok.extern.slf4j.Slf4j;
import mx.gob.vucem.componente.domain.valueobjects.PuntoExtension;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Servicio para registrar y gestionar los puntos de extensión del componente.
 * Implementa el patrón Registro para mantener y proporcionar extensiones dinámicas.
 */
@Service
@Slf4j
public class RegistroExtensiones {

    private final Map<Class<?>, List<PuntoExtension<?, ?>>> extensiones = new ConcurrentHashMap<>();

    /**
     * Registra un nuevo punto de extensión para un tipo específico.
     *
     * @param <T> Tipo de entrada del punto de extensión
     * @param <R> Tipo de retorno del punto de extensión
     * @param tipo Clase que representa el tipo de extensión
     * @param extension Implementación del punto de extensión
     */
    public <T, R> void registrar(Class<T> tipo, PuntoExtension<T, R> extension) {
        extensiones.computeIfAbsent(tipo, k -> new ArrayList<>())
                  .add(extension);
        
        // Ordenar por prioridad (menor número = mayor prioridad)
        extensiones.get(tipo).sort(Comparator.comparing(PuntoExtension::getPrioridad));
        
        log.info("Registrado punto de extensión: {} para tipo: {} con prioridad: {}", 
                extension.getIdentificador(), tipo.getSimpleName(), extension.getPrioridad());
    }

    /**
     * Obtiene todos los puntos de extensión registrados para un tipo específico.
     *
     * @param <T> Tipo de entrada del punto de extensión
     * @param <R> Tipo de retorno del punto de extensión
     * @param tipo Clase que representa el tipo de extensión
     * @return Lista de puntos de extensión ordenados por prioridad
     */
    @SuppressWarnings("unchecked")
    public <T, R> List<PuntoExtension<T, R>> obtenerExtensiones(Class<T> tipo) {
        return (List<PuntoExtension<T, R>>) (List<?>) 
               extensiones.getOrDefault(tipo, Collections.emptyList());
    }

    /**
     * Ejecuta todos los puntos de extensión registrados para un tipo específico,
     * en orden de prioridad.
     *
     * @param <T> Tipo de entrada del punto de extensión
     * @param <R> Tipo de retorno del punto de extensión
     * @param tipo Clase que representa el tipo de extensión
     * @param entrada Datos de entrada para los puntos de extensión
     * @param contexto Contexto adicional para la ejecución
     * @return Lista de resultados de la ejecución de cada punto de extensión
     */
    public <T, R> List<R> ejecutarExtensiones(Class<T> tipo, T entrada, Map<String, Object> contexto) {
        List<PuntoExtension<T, R>> puntosExtension = obtenerExtensiones(tipo);
        List<R> resultados = new ArrayList<>(puntosExtension.size());
        
        for (PuntoExtension<T, R> extension : puntosExtension) {
            try {
                R resultado = extension.ejecutar(entrada, contexto);
                resultados.add(resultado);
                log.debug("Ejecutado punto de extensión: {} para tipo: {}", 
                        extension.getIdentificador(), tipo.getSimpleName());
            } catch (Exception ex) {
                log.error("Error al ejecutar punto de extensión: {} para tipo: {}", 
                        extension.getIdentificador(), tipo.getSimpleName(), ex);
            }
        }
        
        return resultados;
    }
}