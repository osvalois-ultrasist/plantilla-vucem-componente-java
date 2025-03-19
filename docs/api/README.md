# Documentación de API del Componente VUCEM

## Introducción

Esta documentación describe la API RESTful proporcionada por el componente VUCEM. Esta API sigue los principios de diseño RESTful y utiliza JSON como formato principal para el intercambio de datos.

## Base URL

Todas las URLs referenciadas en esta documentación tienen como base:

```
https://{entorno}.vucem.gob.mx/api/v1
```

Donde `{entorno}` puede ser:
- `dev` - Entorno de desarrollo
- `qa` - Entorno de pruebas de calidad
- `prod` - Entorno de producción

## Autenticación

La API utiliza autenticación basada en tokens JWT (JSON Web Tokens). Para acceder a los endpoints protegidos, se debe incluir un token válido en el encabezado `Authorization` de la siguiente manera:

```
Authorization: Bearer {token}
```

### Obtención del Token

Los tokens se obtienen a través del servicio centralizado de autenticación de VUCEM. Para más detalles sobre la obtención de tokens, consulte la [documentación de autenticación](https://vucem.gob.mx/docs/autenticacion).

## Estructura de las Respuestas

Todas las respuestas siguen una estructura común:

```json
{
  "status": "SUCCESS",
  "data": { ... },
  "errors": null,
  "timestamp": "2023-11-15T14:30:45.123Z",
  "traceId": "abc123xyz456"
}
```

En caso de error:

```json
{
  "status": "ERROR",
  "data": null,
  "errors": [
    {
      "code": "ERR-1001",
      "message": "Descripción del error",
      "field": "campoInvolucrado"
    }
  ],
  "timestamp": "2023-11-15T14:30:45.123Z",
  "traceId": "abc123xyz456"
}
```

## Códigos de Estado HTTP

| Código | Descripción |
|--------|-------------|
| 200 | Éxito - La solicitud se ha completado correctamente |
| 201 | Creado - El recurso se ha creado correctamente |
| 400 | Solicitud incorrecta - Error de validación o datos incorrectos |
| 401 | No autorizado - Autenticación requerida o inválida |
| 403 | Prohibido - No tiene permisos para acceder al recurso |
| 404 | No encontrado - Recurso no encontrado |
| 409 | Conflicto - Operación no puede completarse debido a un conflicto |
| 422 | Entidad no procesable - Error de validación semántica |
| 500 | Error interno del servidor - Error inesperado en el servidor |

## Endpoints API

### Salud del Sistema

#### GET /health

Comprueba el estado del servicio.

**Respuesta de éxito:**
```json
{
  "status": "SUCCESS",
  "data": {
    "status": "UP",
    "components": {
      "db": {
        "status": "UP"
      },
      "diskSpace": {
        "status": "UP"
      }
    }
  },
  "timestamp": "2023-11-15T14:30:45.123Z"
}
```

### Recursos Protegidos

Para acceder a estos endpoints, se requiere un token JWT válido con los permisos adecuados.

#### GET /recursos

Obtiene una lista paginada de recursos.

**Parámetros de consulta:**
- `page` (opcional): Número de página (predeterminado: 0)
- `size` (opcional): Tamaño de página (predeterminado: 20)
- `sort` (opcional): Campo y dirección de ordenación (formato: `campo,asc/desc`)

**Respuesta de éxito:**
```json
{
  "status": "SUCCESS",
  "data": {
    "content": [
      {
        "id": "123e4567-e89b-12d3-a456-426614174000",
        "nombre": "Ejemplo de recurso",
        "descripcion": "Descripción del recurso",
        "fechaCreacion": "2023-11-15T12:30:45.123Z"
      }
    ],
    "page": 0,
    "size": 20,
    "totalElements": 1,
    "totalPages": 1
  },
  "timestamp": "2023-11-15T14:30:45.123Z"
}
```

#### GET /recursos/{id}

Obtiene un recurso específico por su ID.

**Parámetros de ruta:**
- `id`: UUID del recurso

**Respuesta de éxito:**
```json
{
  "status": "SUCCESS",
  "data": {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "nombre": "Ejemplo de recurso",
    "descripcion": "Descripción del recurso",
    "fechaCreacion": "2023-11-15T12:30:45.123Z",
    "atributos": {
      "atributo1": "valor1",
      "atributo2": "valor2"
    }
  },
  "timestamp": "2023-11-15T14:30:45.123Z"
}
```

**Respuesta de error (recurso no encontrado):**
```json
{
  "status": "ERROR",
  "errors": [
    {
      "code": "REC-404",
      "message": "Recurso no encontrado con ID 123e4567-e89b-12d3-a456-426614174000"
    }
  ],
  "timestamp": "2023-11-15T14:30:45.123Z",
  "traceId": "abc123xyz456"
}
```

#### POST /recursos

Crea un nuevo recurso.

**Cuerpo de la solicitud:**
```json
{
  "nombre": "Nuevo recurso",
  "descripcion": "Descripción del nuevo recurso",
  "atributos": {
    "atributo1": "valor1",
    "atributo2": "valor2"
  }
}
```

**Respuesta de éxito:**
```json
{
  "status": "SUCCESS",
  "data": {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "nombre": "Nuevo recurso",
    "descripcion": "Descripción del nuevo recurso",
    "fechaCreacion": "2023-11-15T14:30:45.123Z",
    "atributos": {
      "atributo1": "valor1",
      "atributo2": "valor2"
    }
  },
  "timestamp": "2023-11-15T14:30:45.123Z"
}
```

**Respuesta de error (validación):**
```json
{
  "status": "ERROR",
  "errors": [
    {
      "code": "VAL-001",
      "message": "El nombre no puede estar vacío",
      "field": "nombre"
    }
  ],
  "timestamp": "2023-11-15T14:30:45.123Z",
  "traceId": "abc123xyz456"
}
```

#### PUT /recursos/{id}

Actualiza un recurso existente.

**Parámetros de ruta:**
- `id`: UUID del recurso

**Cuerpo de la solicitud:**
```json
{
  "nombre": "Recurso actualizado",
  "descripcion": "Descripción actualizada",
  "atributos": {
    "atributo1": "valor actualizado",
    "atributo2": "valor2"
  }
}
```

**Respuesta de éxito:**
```json
{
  "status": "SUCCESS",
  "data": {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "nombre": "Recurso actualizado",
    "descripcion": "Descripción actualizada",
    "fechaCreacion": "2023-11-15T12:30:45.123Z",
    "fechaActualizacion": "2023-11-15T14:30:45.123Z",
    "atributos": {
      "atributo1": "valor actualizado",
      "atributo2": "valor2"
    }
  },
  "timestamp": "2023-11-15T14:30:45.123Z"
}
```

#### DELETE /recursos/{id}

Elimina un recurso existente.

**Parámetros de ruta:**
- `id`: UUID del recurso

**Respuesta de éxito:**
```json
{
  "status": "SUCCESS",
  "data": {
    "mensaje": "Recurso eliminado correctamente"
  },
  "timestamp": "2023-11-15T14:30:45.123Z"
}
```

## Límites de Tasa

La API implementa límites de tasa para proteger contra abusos. Los límites actuales son:

- 100 solicitudes por minuto por IP
- 1000 solicitudes por hora por usuario autenticado

Cuando se excede un límite, la API responderá con un código de estado HTTP 429 (Too Many Requests).

## Versionado de la API

La API utiliza versionado en la URL. La versión actual es `v1`. Las versiones anteriores pueden ser descontinuadas después de un período de tiempo adecuado y con notificación previa.

## Documentación OpenAPI/Swagger

La especificación completa de la API está disponible en formato OpenAPI (Swagger) en:

```
https://{entorno}.vucem.gob.mx/api/v1/swagger-ui.html
```

## Soporte

Para soporte técnico o preguntas relacionadas con esta API, comuníquese con el equipo de soporte VUCEM:

- Correo electrónico: soporte.vucem@sat.gob.mx
- Portal de soporte: https://soporte.vucem.gob.mx

## Cambios en la API

Para información sobre cambios y actualizaciones de la API, consulte el [registro de cambios](CHANGELOG.md).