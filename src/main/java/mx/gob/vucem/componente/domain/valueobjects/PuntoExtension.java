package mx.gob.vucem.componente.domain.valueobjects;

import java.util.Map;

/**
 * Interfaz para definir puntos de extensión en el componente.
 * Permite implementar el patrón de extensión para añadir funcionalidad
 * sin modificar el código base del componente.
 *
 * @param <T> Tipo de entrada para el punto de extensión
 * @param <R> Tipo de retorno del punto de extensión
 */
public interface PuntoExtension<T, R> {

    /**
     * Ejecuta la lógica del punto de extensión.
     *
     * @param entrada Datos de entrada para el punto de extensión
     * @param contexto Contexto adicional para la ejecución
     * @return Resultado de la ejecución
     */
    R ejecutar(T entrada, Map<String, Object> contexto);

    /**
     * Obtiene el identificador único del punto de extensión.
     *
     * @return Identificador único
     */
    String getIdentificador();

    /**
     * Obtiene la prioridad del punto de extensión.
     * Valores más bajos indican mayor prioridad.
     *
     * @return Prioridad del punto de extensión
     */
    int getPrioridad();
}