# Diagramas de Arquitectura del Componente VUCEM

## Índice

1. [Diagrama de Contexto](#diagrama-de-contexto)
2. [Diagrama de Contenedores](#diagrama-de-contenedores)
3. [Diagrama de Componentes](#diagrama-de-componentes)
4. [Diagrama de Clases](#diagrama-de-clases)
5. [Diagrama de Secuencia](#diagrama-de-secuencia)
6. [Diagrama de Despliegue](#diagrama-de-despliegue)
7. [Diagrama de Estado](#diagrama-de-estado)

## Diagrama de Contexto

El diagrama de contexto muestra cómo el componente VUCEM interactúa con los sistemas externos y usuarios.

```mermaid
C4Context
    title Diagrama de Contexto - Componente VUCEM
    
    Person(usuario, "Usuario", "Usuario del sistema VUCEM")
    Person(administrador, "Administrador", "Administrador del sistema")
    
    System(componenteVucem, "Componente VUCEM", "Proporciona funcionalidades específicas dentro del ecosistema VUCEM")
    
    System_Ext(autenticacion, "Servicio de Autenticación", "Gestiona la autenticación y autorización centralizada")
    System_Ext(catalogo, "Servicio de Catálogos", "Proporciona datos de referencia y catálogos")
    System_Ext(notificacion, "Servicio de Notificaciones", "Envía notificaciones a usuarios")
    System_Ext(auditoria, "Servicio de Auditoría", "Registra eventos de auditoría")
    
    Rel(usuario, componenteVucem, "Utiliza", "HTTPS/JSON")
    Rel(administrador, componenteVucem, "Administra", "HTTPS/JSON")
    
    Rel(componenteVucem, autenticacion, "Valida tokens", "HTTPS/JWT")
    Rel(componenteVucem, catalogo, "Consulta catálogos", "HTTPS/JSON")
    Rel(componenteVucem, notificacion, "Envía notificaciones", "HTTPS/JSON")
    Rel(componenteVucem, auditoria, "Registra eventos", "HTTPS/JSON")
```

## Diagrama de Contenedores

El diagrama de contenedores muestra cómo el componente VUCEM está compuesto internamente.

```mermaid
C4Container
    title Diagrama de Contenedores - Componente VUCEM
    
    Person(usuario, "Usuario", "Usuario del sistema VUCEM")
    
    System_Boundary(componenteVucem, "Componente VUCEM") {
        Container(api, "API REST", "Spring Boot", "Proporciona la API REST para interactuar con el componente")
        Container(logica, "Lógica de Negocio", "Spring Services", "Implementa la lógica de negocio del componente")
        Container(persistencia, "Capa de Persistencia", "Spring Data JPA", "Gestiona la persistencia de datos")
        ContainerDb(db, "Base de Datos", "PostgreSQL", "Almacena datos del componente")
        Container(cache, "Caché", "Caffeine/Redis", "Almacenamiento en caché para mejorar rendimiento")
    }
    
    System_Ext(autenticacion, "Servicio de Autenticación", "Gestiona la autenticación y autorización centralizada")
    System_Ext(catalogo, "Servicio de Catálogos", "Proporciona datos de referencia y catálogos")
    
    Rel(usuario, api, "Accede", "HTTPS/JSON")
    Rel(api, autenticacion, "Valida tokens", "HTTPS/JWT")
    Rel(api, logica, "Utiliza")
    Rel(logica, persistencia, "Utiliza")
    Rel(logica, catalogo, "Consulta", "HTTPS/JSON")
    Rel(logica, cache, "Lee/Escribe")
    Rel(persistencia, db, "Lee/Escribe", "JDBC")
```

## Diagrama de Componentes

El diagrama de componentes muestra la estructura interna de los componentes software del sistema.

```mermaid
C4Component
    title Diagrama de Componentes - Componente VUCEM
    
    Container_Boundary(api, "API REST") {
        Component(controllers, "Controllers", "Spring RestControllers", "Maneja las solicitudes HTTP")
        Component(advisors, "Exception Advisors", "Spring ControllerAdvice", "Maneja las excepciones globalmente")
        Component(filters, "Security Filters", "Spring Security", "Filtros de seguridad y autenticación")
    }
    
    Container_Boundary(logica, "Lógica de Negocio") {
        Component(services, "Services", "Spring Services", "Implementa la lógica de negocio")
        Component(validators, "Validators", "Bean Validation", "Valida la entrada de datos")
        Component(mappers, "Mappers", "MapStruct", "Mapea entre entidades y DTOs")
        Component(clients, "Clients", "Feign Clients", "Clientes para servicios externos")
    }
    
    Container_Boundary(persistencia, "Capa de Persistencia") {
        Component(repositories, "Repositories", "Spring Data JPA", "Interfaces para acceso a datos")
        Component(entities, "Entities", "JPA Entities", "Entidades JPA para persistencia")
        Component(auditing, "Auditing", "Spring Data JPA Auditing", "Auditoría automática de entidades")
    }
    
    ContainerDb(db, "Base de Datos", "PostgreSQL", "Almacena datos del componente")
    
    Rel(controllers, services, "Utiliza")
    Rel(controllers, mappers, "Utiliza")
    Rel(advisors, controllers, "Maneja excepciones de")
    Rel(filters, controllers, "Filtra solicitudes a")
    
    Rel(services, validators, "Valida con")
    Rel(services, repositories, "Utiliza")
    Rel(services, clients, "Utiliza")
    Rel(services, mappers, "Utiliza")
    
    Rel(repositories, entities, "Utiliza")
    Rel(repositories, db, "Lee/Escribe")
    Rel(auditing, entities, "Audita")
```

## Diagrama de Clases

El diagrama de clases muestra las principales clases del componente VUCEM y sus relaciones.

```mermaid
classDiagram
    class AuditableEntity {
        +UUID id
        +LocalDateTime fechaCreacion
        +LocalDateTime fechaActualizacion
        +String creadoPor
        +String actualizadoPor
    }
    
    class Recurso {
        +String nombre
        +String descripcion
        +Boolean activo
        +Map~String, String~ atributos
        +validar() Boolean
    }
    
    class RecursoDTO {
        +UUID id
        +String nombre
        +String descripcion
        +Map~String, String~ atributos
        +LocalDateTime fechaCreacion
    }
    
    class RecursoRepository {
        +findById(UUID id) Optional~Recurso~
        +findByNombreContaining(String nombre) List~Recurso~
        +findByActivoTrue() List~Recurso~
        +save(Recurso recurso) Recurso
        +deleteById(UUID id) void
    }
    
    class RecursoService {
        +obtenerTodos() List~RecursoDTO~
        +obtenerPorId(UUID id) RecursoDTO
        +crear(RecursoDTO recursoDTO) RecursoDTO
        +actualizar(UUID id, RecursoDTO recursoDTO) RecursoDTO
        +eliminar(UUID id) void
        +buscar(String termino) List~RecursoDTO~
    }
    
    class RecursoController {
        +getAll() ResponseEntity~List~RecursoDTO~~
        +getById(UUID id) ResponseEntity~RecursoDTO~
        +create(RecursoDTO recursoDTO) ResponseEntity~RecursoDTO~
        +update(UUID id, RecursoDTO recursoDTO) ResponseEntity~RecursoDTO~
        +delete(UUID id) ResponseEntity~Void~
        +search(String termino) ResponseEntity~List~RecursoDTO~~
    }
    
    class RecursoMapper {
        +toDto(Recurso recurso) RecursoDTO
        +toEntity(RecursoDTO dto) Recurso
        +updateEntityFromDto(RecursoDTO dto, Recurso recurso) void
    }
    
    class BusinessException {
        +String code
        +String message
        +Map~String, Object~ data
    }
    
    AuditableEntity <|-- Recurso
    RecursoService --> RecursoRepository
    RecursoService --> RecursoMapper
    RecursoController --> RecursoService
    RecursoMapper ..> Recurso
    RecursoMapper ..> RecursoDTO
    RecursoRepository ..> Recurso
    RecursoService ..> BusinessException
```

## Diagrama de Secuencia

El diagrama de secuencia muestra cómo interactúan los componentes en un flujo típico.

```mermaid
sequenceDiagram
    participant Cliente
    participant Controller as RecursoController
    participant Service as RecursoService
    participant Mapper as RecursoMapper
    participant Repository as RecursoRepository
    participant Database as Base de Datos
    
    Cliente->>+Controller: POST /api/recursos (RecursoDTO)
    Controller->>+Service: crear(recursoDTO)
    Service->>Service: validar datos
    
    alt Datos inválidos
        Service-->>Controller: lanza BusinessException
        Controller-->>Cliente: 400 Bad Request (Error)
    else Datos válidos
        Service->>+Mapper: toEntity(recursoDTO)
        Mapper-->>-Service: entidad Recurso
        
        Service->>+Repository: save(recurso)
        Repository->>+Database: INSERT
        Database-->>-Repository: Recurso persistido
        Repository-->>-Service: Recurso guardado
        
        Service->>+Mapper: toDto(recursoGuardado)
        Mapper-->>-Service: RecursoDTO resultante
        Service-->>-Controller: RecursoDTO resultante
        Controller-->>-Cliente: 201 Created (RecursoDTO)
    end
```

## Diagrama de Despliegue

El diagrama de despliegue muestra cómo se despliega el componente VUCEM en infraestructura.

```mermaid
C4Deployment
    title Diagrama de Despliegue - Componente VUCEM
    
    Deployment_Node(cluster, "Cluster Kubernetes") {
        Deployment_Node(namespace, "Namespace: vucem-componente") {
            Deployment_Node(deployment, "Deployment: vucem-componente") {
                Container(pod1, "Pod 1", "Container: vucem-componente", "Instancia del componente VUCEM")
                Container(pod2, "Pod 2", "Container: vucem-componente", "Instancia del componente VUCEM")
                Container(pod3, "Pod 3", "Container: vucem-componente", "Instancia del componente VUCEM")
            }
            
            Deployment_Node(db_statefulset, "StatefulSet: postgresql") {
                ContainerDb(db_pod, "Pod: postgresql", "Container: postgresql", "Base de datos PostgreSQL")
                Container(db_backup, "Pod: backup", "Container: postgresql-backup", "Respaldo de base de datos")
            }
            
            Deployment_Node(cache_deployment, "Deployment: redis") {
                Container(redis_pod, "Pod: redis", "Container: redis", "Caché Redis")
            }
            
            Container(service, "Service: vucem-componente", "ClusterIP", "Servicio interno")
            Container(ingress, "Ingress: vucem-componente", "nginx", "Punto de entrada externo")
        }
        
        Container_Ext(monitoring, "Prometheus/Grafana", "Monitorización")
        Container_Ext(logging, "Elasticsearch/Kibana", "Logs centralizados")
    }
    
    Rel(ingress, service, "Enruta tráfico a")
    Rel(service, pod1, "Dirige solicitudes a")
    Rel(service, pod2, "Dirige solicitudes a")
    Rel(service, pod3, "Dirige solicitudes a")
    
    Rel(pod1, db_pod, "Conecta a")
    Rel(pod2, db_pod, "Conecta a")
    Rel(pod3, db_pod, "Conecta a")
    
    Rel(pod1, redis_pod, "Utiliza")
    Rel(pod2, redis_pod, "Utiliza")
    Rel(pod3, redis_pod, "Utiliza")
    
    Rel(db_backup, db_pod, "Respalda")
    
    Rel(monitoring, pod1, "Monitoriza")
    Rel(monitoring, pod2, "Monitoriza")
    Rel(monitoring, pod3, "Monitoriza")
    Rel(monitoring, db_pod, "Monitoriza")
    Rel(monitoring, redis_pod, "Monitoriza")
    
    Rel(pod1, logging, "Envía logs")
    Rel(pod2, logging, "Envía logs")
    Rel(pod3, logging, "Envía logs")
```

## Diagrama de Estado

Este diagrama muestra los estados posibles de un recurso y las transiciones entre ellos.

```mermaid
stateDiagram-v2
    [*] --> Borrador: Crear
    Borrador --> EnRevision: Enviar a revisión
    Borrador --> [*]: Cancelar
    EnRevision --> Aprobado: Aprobar
    EnRevision --> Rechazado: Rechazar
    EnRevision --> Borrador: Devolver para corrección
    Aprobado --> Publicado: Publicar
    Aprobado --> Archivado: Archivar
    Publicado --> Despublicado: Despublicar
    Publicado --> Archivado: Archivar
    Despublicado --> Publicado: Republicar
    Despublicado --> Archivado: Archivar
    Rechazado --> Borrador: Corregir
    Rechazado --> [*]: Eliminar
    Archivado --> [*]: Eliminar
    
    note right of Borrador
        Estado inicial de un recurso
        cuando se está creando
    end note
    
    note right of Publicado
        El recurso está visible
        y disponible para uso
    end note
    
    note right of Archivado
        El recurso se conserva
        pero no está activo
    end note
```