# Manual de Usuario del Componente VUCEM

## Introducción

Este manual proporciona una guía completa sobre la instalación, configuración y uso del componente VUCEM. El documento está dirigido a desarrolladores, administradores de sistemas y usuarios finales que necesiten trabajar con el componente.

## Tabla de Contenidos

1. [Requisitos del Sistema](#requisitos-del-sistema)
2. [Instalación](#instalación)
3. [Configuración](#configuración)
4. [Uso Básico](#uso-básico)
5. [Funcionalidades Principales](#funcionalidades-principales)
6. [Integración con Otros Sistemas](#integración-con-otros-sistemas)
7. [Seguridad](#seguridad)
8. [Monitoreo y Mantenimiento](#monitoreo-y-mantenimiento)
9. [Solución de Problemas](#solución-de-problemas)
10. [FAQ](#faq)
11. [Glosario](#glosario)

## Requisitos del Sistema

### Hardware Recomendado

- **CPU**: 2 núcleos o más
- **RAM**: 4GB o más
- **Almacenamiento**: 20GB mínimo de espacio libre

### Software Requerido

- **Java**: JDK 21 o superior
- **Base de Datos**: PostgreSQL 14 o superior
- **Sistema Operativo**: Linux (recomendado), Windows Server 2019+, o macOS

### Requisitos de Red

- Conexión a internet para acceso a repositorios de dependencias
- Puertos abiertos según entorno de despliegue (por defecto 8080)

## Instalación

### Preparación del Entorno

1. Asegúrese de tener instalado JDK 21 o superior:
   ```bash
   java -version
   ```

2. Verifique que tenga Maven 3.8+ instalado:
   ```bash
   mvn -version
   ```

3. Configure PostgreSQL con una base de datos dedicada:
   ```sql
   CREATE DATABASE vucem_componente;
   CREATE USER vucem_app WITH ENCRYPTED PASSWORD 'su_contraseña_segura';
   GRANT ALL PRIVILEGES ON DATABASE vucem_componente TO vucem_app;
   ```

### Instalación desde Código Fuente

1. Clone el repositorio:
   ```bash
   git clone https://github.com/vucem/vucem-componente.git
   cd vucem-componente
   ```

2. Compile la aplicación:
   ```bash
   mvn clean package
   ```

3. Ejecute la aplicación:
   ```bash
   java -jar target/vucem-componente-*.jar
   ```

### Instalación con Docker

1. Obtenga la imagen Docker:
   ```bash
   docker pull ghcr.io/vucem/vucem-componente:latest
   ```

2. Ejecute el contenedor:
   ```bash
   docker run -d -p 8080:8080 \
     -e SPRING_DATASOURCE_URL=jdbc:postgresql://db-host:5432/vucem_componente \
     -e SPRING_DATASOURCE_USERNAME=vucem_app \
     -e SPRING_DATASOURCE_PASSWORD=su_contraseña_segura \
     --name vucem-componente \
     ghcr.io/vucem/vucem-componente:latest
   ```

### Instalación en Kubernetes

1. Aplique los manifiestos de Kubernetes incluidos:
   ```bash
   kubectl apply -f infrastructure/kubernetes/base/
   kubectl apply -f infrastructure/kubernetes/environments/dev/
   ```

2. Verifique que los pods estén ejecutándose:
   ```bash
   kubectl get pods -n vucem-componente
   ```

## Configuración

### Archivos de Configuración

La configuración principal se realiza a través de archivos YAML en el directorio `src/main/resources/`:

- `application.yml`: Configuración base común a todos los entornos
- `application-local.yml`: Configuración para desarrollo local
- `application-dev.yml`: Configuración para entorno de desarrollo
- `application-qa.yml`: Configuración para entorno de pruebas
- `application-prod.yml`: Configuración para entorno de producción

### Variables de Entorno

Las siguientes variables de entorno pueden utilizarse para configurar la aplicación:

| Variable | Descripción | Valor Predeterminado |
|----------|-------------|---------------------|
| `SPRING_PROFILES_ACTIVE` | Perfil activo de Spring | `local` |
| `COMPONENTE_NOMBRE` | Nombre del componente | `vucem-componente` |
| `SPRING_DATASOURCE_URL` | URL de conexión a la base de datos | `jdbc:postgresql://localhost:5432/vucem_componente` |
| `SPRING_DATASOURCE_USERNAME` | Usuario de la base de datos | `vucem_app` |
| `SPRING_DATASOURCE_PASSWORD` | Contraseña de la base de datos | - |
| `JWT_ISSUER` | Emisor de tokens JWT | `vucem.gob.mx` |
| `JWT_EXPIRACION` | Tiempo de expiración JWT en segundos | `3600` |
| `PERMITIR_ORIGINS` | Orígenes permitidos para CORS | `*` |

### Ejemplo de application-local.yml

```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/vucem_componente
    username: vucem_app
    password: su_contraseña_local
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true

logging:
  level:
    mx.gob.vucem: DEBUG
    org.springframework.web: INFO
    org.hibernate: INFO
```

## Uso Básico

### Iniciar el Servicio

#### Desde línea de comandos:
```bash
java -jar vucem-componente.jar --spring.profiles.active=dev
```

#### Con Maven en desarrollo:
```bash
mvn spring-boot:run -Dspring-boot.run.profiles=local
```

### Verificar el Estado del Servicio

Una vez iniciado, puede verificar el estado del servicio accediendo a:
```
http://localhost:8080/actuator/health
```

Debería recibir una respuesta similar a:
```json
{
  "status": "UP",
  "components": {
    "db": {
      "status": "UP"
    },
    "diskSpace": {
      "status": "UP"
    }
  }
}
```

### Acceso a la Documentación API

La documentación interactiva de la API (Swagger UI) está disponible en:
```
http://localhost:8080/swagger-ui.html
```

## Funcionalidades Principales

### Gestión de Recursos

El componente proporciona operaciones CRUD completas para los recursos principales:

1. **Listar recursos**: Recuperar una lista paginada de recursos
2. **Obtener recurso**: Obtener detalles de un recurso específico
3. **Crear recurso**: Registrar un nuevo recurso en el sistema
4. **Actualizar recurso**: Modificar un recurso existente
5. **Eliminar recurso**: Remover un recurso del sistema

### Validaciones

El componente implementa validaciones en múltiples niveles:

1. **Validación de entrada**: Verificación de formato y estructura de datos
2. **Validación de negocio**: Reglas específicas del dominio
3. **Validación de consistencia**: Relaciones entre entidades

### Procesamiento Asíncrono

Para operaciones de larga duración, el componente ofrece procesamiento asíncrono:

1. **Cola de trabajos**: Las tareas se encolan para procesamiento en segundo plano
2. **Notificaciones**: Se envían notificaciones al completarse el procesamiento
3. **Consulta de estado**: API para verificar el estado de las tareas en curso

## Integración con Otros Sistemas

### Autenticación Centralizada

El componente se integra con el sistema centralizado de autenticación VUCEM a través de JWT.

### Servicios Externos

Se integra con los siguientes servicios externos:

1. **Servicio de Catálogos**: Para obtener datos de referencia
2. **Servicio de Notificaciones**: Para enviar alertas y comunicaciones
3. **Servicio de Auditoría**: Para el registro centralizado de eventos

### Ejemplos de Integración

#### Consumo de Servicios Externos

```java
@Autowired
private CatalogoClient catalogoClient;

public List<CatalogoDTO> obtenerCatalogo(String tipo) {
    return catalogoClient.obtenerCatalogo(tipo);
}
```

#### Publicación de Eventos

```java
@Autowired
private EventPublisher eventPublisher;

public void procesarRecurso(Recurso recurso) {
    // Procesamiento del recurso
    eventPublisher.publish(
        EventoVucem.builder()
            .tipo("recurso.procesado")
            .carga(recurso)
            .build()
    );
}
```

## Seguridad

### Autenticación y Autorización

El componente utiliza Spring Security con JWT para la autenticación y autorización:

1. **Tokens JWT**: Los clientes deben proporcionar tokens JWT válidos para acceder a recursos protegidos
2. **Roles y Permisos**: El acceso a los recursos se controla mediante roles asignados a los usuarios
3. **Renovación de Tokens**: Mecanismo para renovar tokens antes de su expiración

### Protección de Datos

El componente implementa las siguientes medidas de protección de datos:

1. **Cifrado en Tránsito**: Comunicación HTTPS obligatoria en entornos no locales
2. **Cifrado de Datos Sensibles**: Los datos sensibles se almacenan cifrados en la base de datos
3. **Auditoría de Acceso**: Registro detallado de accesos y modificaciones

### Vulnerabilidades Comunes

El componente implementa protecciones contra:

1. **Inyección SQL**: Uso de JPA y consultas parametrizadas
2. **XSS**: Escapado de datos en respuestas JSON
3. **CSRF**: Tokens CSRF para operaciones mutantes
4. **Ataques de Fuerza Bruta**: Límites de tasa y bloqueo temporal

## Monitoreo y Mantenimiento

### Endpoints de Salud y Métricas

El componente expone endpoints de Spring Boot Actuator para monitoreo:

- `/actuator/health`: Estado general del servicio
- `/actuator/metrics`: Métricas detalladas
- `/actuator/prometheus`: Métricas en formato Prometheus
- `/actuator/loggers`: Configuración de niveles de log en tiempo de ejecución

### Logs

Los logs se generan en formato estructurado JSON y contienen:

1. **Timestamp**: Fecha y hora exacta del evento
2. **Nivel**: INFO, WARN, ERROR, DEBUG
3. **Mensaje**: Descripción del evento
4. **Contexto**: Datos adicionales relevantes
5. **Trazas**: IDs de correlación para seguimiento entre servicios

### Respaldos y Recuperación

Recomendaciones para respaldos:

1. **Base de Datos**: Respaldos diarios mediante pgdump
2. **Configuración**: Control de versiones para archivos de configuración
3. **Logs**: Rotación y archivo de logs por período

## Solución de Problemas

### Problemas Comunes y Soluciones

#### La aplicación no inicia

**Síntomas**: Errores en los logs durante el arranque, servicio no disponible.

**Posibles causas y soluciones**:

1. **Base de datos no disponible**:
   - Verificar conectividad con la base de datos
   - Comprobar credenciales en la configuración

2. **Puerto ya en uso**:
   - Verificar si hay otro servicio usando el puerto 8080
   - Cambiar el puerto en `application.yml`: `server.port=8081`

3. **Errores de configuración**:
   - Revisar logs en busca de errores específicos
   - Verificar la sintaxis de los archivos YAML

#### Rendimiento Lento

**Síntomas**: Tiempos de respuesta elevados, alto uso de CPU o memoria.

**Posibles causas y soluciones**:

1. **Consultas ineficientes**:
   - Revisar los logs de SQL y optimizar consultas
   - Añadir índices a la base de datos

2. **Memoria insuficiente**:
   - Aumentar memoria asignada: `java -Xmx1g -jar vucem-componente.jar`
   - Verificar y ajustar la pila de conexiones

3. **Caché no optimizado**:
   - Configurar caché para consultas frecuentes
   - Verificar configuración de Caffeine

### Herramientas de Diagnóstico

1. **JConsole/VisualVM**: Para monitoreo detallado de la JVM
2. **Spring Boot Admin**: Interfaz web para administración y monitoreo
3. **pgAdmin/DBeaver**: Para diagnóstico de problemas de base de datos

## FAQ

### Preguntas Frecuentes

#### ¿Cómo cambio la contraseña de la base de datos?

Para cambiar la contraseña de la base de datos, debe:

1. Actualizar la contraseña en PostgreSQL:
   ```sql
   ALTER USER vucem_app WITH PASSWORD 'nueva_contraseña';
   ```

2. Actualizar la configuración de la aplicación:
   - Modificar `application.yml` o
   - Establecer la variable de entorno `SPRING_DATASOURCE_PASSWORD=nueva_contraseña`

#### ¿Cómo añado nuevos usuarios al sistema?

Los usuarios se gestionan a través del sistema centralizado de autenticación VUCEM. Para añadir nuevos usuarios:

1. Acceda al portal de administración de usuarios VUCEM
2. Cree el nuevo usuario y asigne los roles correspondientes
3. El usuario podrá acceder al componente con las credenciales proporcionadas

#### ¿Cómo escalo el componente para manejar más carga?

Para escalar el componente:

1. **Escala vertical**: Asigne más recursos (CPU/memoria) a la instancia
2. **Escala horizontal**: Despliegue múltiples instancias con un balanceador de carga
   ```bash
   kubectl scale deployment vucem-componente --replicas=3 -n vucem-componente
   ```

## Glosario

| Término | Definición |
|---------|------------|
| **API** | Interfaz de Programación de Aplicaciones, conjunto de reglas que permiten que diferentes programas se comuniquen entre sí |
| **JWT** | JSON Web Token, estándar para la creación de tokens de acceso basado en JSON |
| **VUCEM** | Ventanilla Única de Comercio Exterior Mexicana |
| **Microservicio** | Estilo arquitectónico que estructura una aplicación como un conjunto de servicios pequeños y autónomos |
| **Auditoría** | Registro cronológico de quién ha accedido a un sistema y qué operaciones ha realizado |
| **Resiliencia** | Capacidad de un sistema para adaptarse a condiciones cambiantes y recuperarse rápidamente de fallos |
| **OAuth2** | Protocolo de autorización que permite a aplicaciones de terceros obtener acceso limitado a un servicio |