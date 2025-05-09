package mx.gob.vucem.componente.interfaces.events;

import mx.gob.vucem.componente.application.dtos.RecursoDTO;

/**
 * Evento que representa la creación de un nuevo recurso.
 */
public class RecursoCreado extends EventoBase<RecursoDTO> {
    
    private static final String TIPO_EVENTO = "recurso.creado";
    private static final String ORIGEN = "vucem-componente";
    
    /**
     * Constructor para crear un evento de recurso creado.
     * 
     * @param recurso El DTO del recurso creado
     */
    public RecursoCreado(RecursoDTO recurso) {
        super(TIPO_EVENTO, recurso, ORIGEN);
    }
}