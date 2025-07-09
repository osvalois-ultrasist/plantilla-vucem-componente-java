package mx.gob.vucem.componente.interfaces.events;

import java.time.ZonedDateTime;

/**
 * Implementación base para eventos VUCEM.
 * Proporciona funcionalidad común para todos los eventos.
 * 
 * @param <T> Tipo de datos que transporta el evento
 */
public abstract class EventoBase<T> implements EventoVucem<T> {
    
    private final String tipo;
    private final T carga;
    private final ZonedDateTime fechaCreacion;
    private final String origen;
    
    /**
     * Constructor con todos los parámetros necesarios.
     * 
     * @param tipo Tipo de evento
     * @param carga Datos del evento
     * @param origen Origen del evento
     */
    protected EventoBase(String tipo, T carga, String origen) {
        this.tipo = tipo;
        this.carga = carga;
        this.fechaCreacion = ZonedDateTime.now();
        this.origen = origen;
    }
    
    @Override
    public String getTipo() {
        return tipo;
    }
    
    @Override
    public T getCarga() {
        return carga;
    }
    
    @Override
    public ZonedDateTime getFechaCreacion() {
        return fechaCreacion;
    }
    
    @Override
    public String getOrigen() {
        return origen;
    }
}