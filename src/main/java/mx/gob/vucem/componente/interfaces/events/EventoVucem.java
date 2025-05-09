package mx.gob.vucem.componente.interfaces.events;

import java.time.ZonedDateTime;

/**
 * Interfaz base para eventos en el sistema VUCEM.
 * Define la estructura común para todos los eventos del sistema.
 * 
 * @param <T> Tipo de datos que transporta el evento
 */
public interface EventoVucem<T> {
    
    /**
     * Obtiene el tipo de evento.
     * Debería identificar de forma única el tipo de evento en el sistema.
     * 
     * @return Identificador del tipo de evento
     */
    String getTipo();
    
    /**
     * Obtiene la carga útil del evento.
     * Contiene los datos específicos relacionados con este evento.
     * 
     * @return Datos asociados al evento
     */
    T getCarga();
    
    /**
     * Obtiene la fecha y hora de creación del evento.
     * 
     * @return Marca de tiempo de la creación del evento
     */
    ZonedDateTime getFechaCreacion();
    
    /**
     * Obtiene el origen del evento.
     * Identifica el componente o microservicio que generó el evento.
     * 
     * @return Identificador del origen del evento
     */
    String getOrigen();
}