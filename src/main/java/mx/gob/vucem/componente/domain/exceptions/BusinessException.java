package mx.gob.vucem.componente.domain.exceptions;

import lombok.Getter;

/**
 * Excepción base para errores de negocio en la aplicación.
 * Proporciona un mecanismo estándar para manejar errores relacionados con las reglas de negocio.
 */
@Getter
public class BusinessException extends RuntimeException {

    private final String codigo;
    private final String mensaje;
    private final Object[] args;

    /**
     * Constructor para crear una excepción de negocio con código y mensaje.
     *
     * @param codigo Código de error, útil para identificar el tipo de error
     * @param mensaje Mensaje descriptivo del error
     */
    public BusinessException(String codigo, String mensaje) {
        super(mensaje);
        this.codigo = codigo;
        this.mensaje = mensaje;
        this.args = new Object[0];
    }

    /**
     * Constructor para crear una excepción de negocio con código, mensaje y argumentos.
     * Los argumentos pueden ser utilizados para generar mensajes dinámicos.
     *
     * @param codigo Código de error
     * @param mensaje Mensaje descriptivo del error
     * @param args Argumentos adicionales para el mensaje
     */
    public BusinessException(String codigo, String mensaje, Object... args) {
        super(mensaje);
        this.codigo = codigo;
        this.mensaje = mensaje;
        this.args = args;
    }

    /**
     * Constructor para crear una excepción de negocio basada en otra excepción.
     *
     * @param codigo Código de error
     * @param mensaje Mensaje descriptivo del error
     * @param cause Excepción original que causó este error
     */
    public BusinessException(String codigo, String mensaje, Throwable cause) {
        super(mensaje, cause);
        this.codigo = codigo;
        this.mensaje = mensaje;
        this.args = new Object[0];
    }
}