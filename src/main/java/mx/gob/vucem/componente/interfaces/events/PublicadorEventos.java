package mx.gob.vucem.componente.interfaces.events;

import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;

/**
 * Servicio para la publicación de eventos en el sistema.
 * Utiliza el mecanismo de eventos de Spring para la publicación.
 */
@Service
public class PublicadorEventos {
    
    private final ApplicationEventPublisher publisher;
    
    /**
     * Constructor con inyección de dependencias.
     * 
     * @param publisher Publicador de eventos de Spring
     */
    public PublicadorEventos(ApplicationEventPublisher publisher) {
        this.publisher = publisher;
    }
    
    /**
     * Publica un evento en el sistema.
     * 
     * @param <T> Tipo de datos del evento
     * @param evento Evento a publicar
     */
    public <T> void publicar(EventoVucem<T> evento) {
        publisher.publishEvent(evento);
    }
}