# Guía de Desarrollo para el Componente VUCEM

## Introducción

Esta guía proporciona información detallada para desarrolladores que trabajarán con el componente VUCEM. Incluye convenciones de código, arquitectura, patrones de diseño y mejores prácticas para contribuir al desarrollo del componente.

## Tabla de Contenidos

1. [Configuración del Entorno de Desarrollo](#configuración-del-entorno-de-desarrollo)
2. [Arquitectura del Componente](#arquitectura-del-componente)
3. [Convenciones de Código](#convenciones-de-código)
4. [Flujo de Trabajo de Desarrollo](#flujo-de-trabajo-de-desarrollo)
5. [Pruebas](#pruebas)
6. [Seguridad](#seguridad)
7. [Integración Continua](#integración-continua)
8. [Despliegue](#despliegue)
9. [Mejores Prácticas](#mejores-prácticas)
10. [Recursos Adicionales](#recursos-adicionales)

## Configuración del Entorno de Desarrollo

### Requisitos

- JDK 21 o superior
- Maven 3.8+
- IDE compatible con Java (IntelliJ IDEA, Eclipse, VS Code)
- Git
- Docker y Docker Compose (para entornos locales)
- PostgreSQL 14+ (puede ser instancia local o en contenedor)

### Configuración Inicial

1. Clone el repositorio:
   ```bash
   git clone https://github.com/vucem/vucem-componente.git
   cd vucem-componente
   ```

2. Configure el IDE:
   - **IntelliJ IDEA**: Importe como proyecto Maven
   - **Eclipse**: Importe como proyecto Maven existente
   - **VS Code**: Instale las extensiones de Java, Spring Boot, Lombok

3. Configure el archivo de propiedades de desarrollo local:
   - Copie `src/main/resources/application.yml` a `src/main/resources/application-local.yml`
   - Ajuste la configuración según su entorno local

4. Instale Lombok en su IDE si es necesario:
   - IntelliJ IDEA: Plugin de Lombok
   - Eclipse: Ejecute el JAR de Lombok y configure el IDE

### Ejecución Local

1. Inicie PostgreSQL:
   ```bash
   docker run --name postgres-vucem -e POSTGRES_PASSWORD=password -e POSTGRES_DB=vucem_componente -p 5432:5432 -d postgres:14-alpine
   ```

2. Ejecute la aplicación:
   ```bash
   mvn spring-boot:run -Dspring-boot.run.profiles=local
   ```

3. Acceda a la aplicación:
   - API: http://localhost:8080/api
   - Swagger UI: http://localhost:8080/swagger-ui.html
   - Actuator: http://localhost:8080/actuator

## Arquitectura del Componente

El componente sigue los principios de Clean Architecture, organizando el código en capas con responsabilidades bien definidas y dependencias que fluyen hacia adentro.

### Estructura de Paquetes

```
mx.gob.vucem.componente/
├── domain/                # Capa de dominio (núcleo)
│   ├── entities/          # Entidades de negocio
│   ├── exceptions/        # Excepciones de dominio
│   ├── repositories/      # Interfaces de repositorios
│   ├── services/          # Interfaces de servicios de dominio
│   └── valueobjects/      # Objetos de valor
├── application/           # Capa de aplicación (casos de uso)
│   ├── dtos/              # Objetos de transferencia de datos
│   ├── exceptions/        # Excepciones de aplicación
│   ├── mappers/           # Mapeos entre entidades y DTOs
│   ├── services/          # Implementación de servicios
│   └── validators/        # Validadores de datos
├── infrastructure/        # Capa de infraestructura
│   ├── config/            # Configuraciones técnicas
│   ├── persistence/       # Implementación de persistencia
│   ├── security/          # Implementación de seguridad
│   └── services/          # Implementación de servicios externos
└── interfaces/            # Capa de interfaces
    ├── api/               # APIs REST
    └── events/            # Manejadores de eventos
```

### Principios Arquitectónicos

1. **Separación de Responsabilidades**: Cada capa tiene una responsabilidad única y clara
2. **Regla de Dependencia**: Las dependencias apuntan hacia adentro (interfaces → aplicación → dominio)
3. **Aislamiento del Dominio**: El núcleo de negocio está aislado de detalles técnicos
4. **Inversión de Dependencias**: Uso de interfaces para desacoplar componentes

### Patrones de Diseño

1. **Patrón Repositorio**: Abstracción del acceso a datos
2. **Patrón Adaptador**: Adaptación entre diferentes interfaces
3. **Patrón Factoría**: Creación centralizada de objetos complejos
4. **Patrón Estrategia**: Comportamientos intercambiables
5. **Patrón Mediador**: Comunicación entre componentes desacoplados

## Convenciones de Código

### Estilo de Código

El proyecto sigue las convenciones de estilo de código de Google para Java con algunas modificaciones específicas:

1. **Indentación**: 4 espacios, sin tabulaciones
2. **Longitud de línea**: Máximo 120 caracteres
3. **Comentarios**: Javadoc para clases públicas y métodos públicos
4. **Paquetes**: Siempre en minúsculas, estructura `mx.gob.vucem.componente.*`
5. **Clases**: CamelCase comenzando con mayúscula (`RecursoService`)
6. **Métodos**: camelCase comenzando con minúscula (`obtenerRecurso()`)
7. **Constantes**: MAYÚSCULAS con guiones bajos (`MAX_TIMEOUT_SECONDS`)

### Prácticas Recomendadas

1. **Inmutabilidad**: Preferir objetos inmutables cuando sea posible
2. **Excepciones**: Usar excepciones específicas y documentarlas
3. **Logging**: Usar SLF4J con niveles adecuados y contexto
4. **Validación**: Validar todas las entradas externas
5. **Concurrencia**: Documentar y probar comportamientos concurrentes

### Herramientas de Verificación

El proyecto utiliza varias herramientas de análisis estático:

1. **Checkstyle**: Verifica el estilo del código
2. **PMD**: Analiza problemas potenciales
3. **SpotBugs**: Detecta patrones problemáticos
4. **SonarQube**: Análisis de calidad comprensivo

Para ejecutar todas las verificaciones:
```bash
mvn verify
```

## Flujo de Trabajo de Desarrollo

### Gestión de Ramas

El proyecto sigue una adaptación de GitFlow:

1. **main**: Código en producción
2. **desarrollo**: Rama de integración para la próxima versión
3. **feature/XXX**: Nuevas características (a partir de `desarrollo`)
4. **hotfix/XXX**: Correcciones urgentes (a partir de `main`)
5. **release/X.Y.Z**: Preparación de versiones (a partir de `desarrollo`)

### Proceso de Desarrollo

1. Cree una rama desde `desarrollo` para su nueva característica:
   ```bash
   git checkout desarrollo
   git pull
   git checkout -b feature/nueva-funcionalidad
   ```

2. Desarrolle y pruebe la característica localmente

3. Asegúrese de que los tests pasen y el código cumpla con las convenciones:
   ```bash
   mvn clean verify
   ```

4. Realice commits con mensajes descriptivos:
   ```bash
   git commit -m "Añadir validación para documentos especiales"
   ```

5. Envíe la rama a GitHub:
   ```bash
   git push -u origin feature/nueva-funcionalidad
   ```

6. Cree un Pull Request hacia `desarrollo` con:
   - Descripción detallada de los cambios
   - Referencias a tickets o issues relacionados
   - Información sobre pruebas realizadas

7. Espere la revisión de código y CI/CD

8. Después de aprobación, fusione mediante squash y elimine la rama

### Estrategia de Commits

- Commits atómicos: un commit, un cambio lógico
- Mensajes descriptivos que explican el "qué" y el "por qué"
- Formato: `<tipo>: <descripción>` (ejemplo: `feat: añadir validación de RFCs`)
- Tipos comunes: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

## Pruebas

### Niveles de Pruebas

El proyecto requiere pruebas en múltiples niveles:

1. **Pruebas Unitarias**: Verifican componentes individuales aislados
2. **Pruebas de Integración**: Verifican interacciones entre componentes
3. **Pruebas de API**: Verifican el comportamiento de las APIs expuestas
4. **Pruebas de Contrato**: Verifican la compatibilidad con consumidores

### Estructura de Pruebas

Las pruebas siguen la misma estructura de paquetes que el código principal:

```
src/test/java/mx/gob/vucem/componente/
├── domain/                # Pruebas unitarias de dominio
├── application/           # Pruebas unitarias de aplicación
├── infrastructure/        # Pruebas de integración
└── interfaces/            # Pruebas de API
```

### Herramientas de Pruebas

1. **JUnit 5**: Framework de pruebas principal
2. **Mockito**: Creación de mocks y stubs
3. **AssertJ**: Aserciones fluidas
4. **Spring Boot Test**: Soporte para pruebas de integración
5. **Testcontainers**: Contenedores para pruebas de integración
6. **RestAssured**: Pruebas de API REST
7. **WireMock**: Simulación de servicios externos

### Ejemplo de Prueba Unitaria

```java
@ExtendWith(MockitoExtension.class)
public class RecursoServiceTest {

    @Mock
    private RecursoRepository recursoRepository;

    @InjectMocks
    private RecursoServiceImpl recursoService;

    @Test
    void debeObtenerRecursoPorId() {
        // Arrange
        UUID id = UUID.randomUUID();
        Recurso esperado = new Recurso(id, "Test");
        when(recursoRepository.findById(id)).thenReturn(Optional.of(esperado));

        // Act
        Recurso resultado = recursoService.obtenerPorId(id);

        // Assert
        assertThat(resultado).isNotNull();
        assertThat(resultado.getId()).isEqualTo(id);
        verify(recursoRepository).findById(id);
    }
}
```

### Ejemplo de Prueba de Integración

```java
@SpringBootTest
@ActiveProfiles("test")
public class RecursoRepositoryIntegrationTest {

    @Autowired
    private RecursoRepository recursoRepository;

    @Autowired
    private TestEntityManager entityManager;

    @Test
    void debePersistirYRecuperarRecurso() {
        // Arrange
        RecursoEntity entity = new RecursoEntity();
        entity.setNombre("Test");
        entity.setDescripcion("Descripción de prueba");
        
        // Act
        entityManager.persist(entity);
        entityManager.flush();
        
        // Assert
        RecursoEntity found = recursoRepository.findByNombre("Test")
                .orElseThrow();
        assertThat(found.getDescripcion()).isEqualTo("Descripción de prueba");
    }
}
```

### Ejemplo de Prueba de API

```java
@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
@ActiveProfiles("test")
public class RecursoControllerTest {

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    void debeCrearRecurso() {
        // Arrange
        CrearRecursoRequest request = new CrearRecursoRequest();
        request.setNombre("Nuevo Recurso");
        request.setDescripcion("Descripción del nuevo recurso");
        
        // Act
        ResponseEntity<RecursoResponse> response = restTemplate.postForEntity(
                "/api/recursos", request, RecursoResponse.class);
        
        // Assert
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        assertThat(response.getBody()).isNotNull();
        assertThat(response.getBody().getNombre()).isEqualTo("Nuevo Recurso");
    }
}
```

## Seguridad

### Principios de Seguridad

1. **Defensa en Profundidad**: Múltiples capas de seguridad
2. **Mínimo Privilegio**: Acceso limitado a lo estrictamente necesario
3. **Seguridad por Diseño**: Consideraciones de seguridad desde el inicio
4. **Validación de Entradas**: Validación estricta de todas las entradas
5. **Gestión de Secretos**: Nunca hardcodear secretos o credenciales

### Implementación de Seguridad

El componente utiliza Spring Security con las siguientes características:

1. **Autenticación JWT**: Tokens firmados y con tiempo de expiración
2. **Control de Acceso**: Basado en roles y permisos granulares
3. **Gestión de Sesiones**: Stateless para escalabilidad
4. **Protección CSRF**: Para operaciones mutantes en navegadores
5. **Cabeceras de Seguridad**: Configuración de cabeceras HTTP seguras

### Ejemplos de Implementación

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        return http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/public/**").permitAll()
                .requestMatchers("/api/admin/**").hasRole("ADMIN")
                .requestMatchers("/api/**").authenticated()
                .anyRequest().authenticated())
            .oauth2ResourceServer(oauth2 -> oauth2.jwt())
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .csrf(csrf -> csrf.ignoringRequestMatchers("/api/**"))
            .headers(headers -> headers
                .contentSecurityPolicy("default-src 'self'"))
            .build();
    }
}
```

## Integración Continua

### Pipelines de CI/CD

El proyecto utiliza GitHub Actions para CI/CD con los siguientes flujos:

1. **CI**: Ejecutado en cada pull request y push a ramas principales
2. **CD Dev**: Despliegue automático al entorno de desarrollo
3. **CD QA**: Despliegue automático al entorno de pruebas
4. **CD Prod**: Despliegue manual al entorno de producción

### Flujo CI

El flujo de integración continua incluye:

1. **Compilación**: Verificación de la compilación del código
2. **Verificación de Estilo**: Checkstyle, PMD, SpotBugs
3. **Pruebas Unitarias**: Ejecución de pruebas JUnit
4. **Pruebas de Integración**: Pruebas con bases de datos y servicios
5. **Análisis de Cobertura**: Medición de cobertura de código con JaCoCo
6. **Análisis de Calidad**: Integración con SonarQube
7. **Análisis de Seguridad**: Escaneo de dependencias y código

### Flujo CD

El flujo de entrega continua incluye:

1. **Construcción de Artefacto**: Creación del JAR
2. **Construcción de Imagen**: Creación de imagen Docker
3. **Escaneo de Seguridad**: Análisis de vulnerabilidades en la imagen
4. **Publicación de Imagen**: Subida a registro de contenedores
5. **Despliegue**: Actualización de la configuración de Kubernetes
6. **Pruebas de Humo**: Verificación básica post-despliegue

## Despliegue

### Contenedorización

El componente se despliega como contenedor Docker:

1. **Imagen Base**: Eclipse Temurin JRE 21 Alpine
2. **Multi-stage Build**: Separación de compilación y runtime
3. **Usuario No-root**: Ejecución con usuario con privilegios limitados
4. **Healthchecks**: Verificación de salud del contenedor

### Kubernetes

La infraestructura de despliegue utiliza Kubernetes:

1. **Deployments**: Gestión de la disponibilidad de pods
2. **Services**: Exposición del servicio internamente
3. **Ingress**: Enrutamiento del tráfico externo
4. **ConfigMaps**: Configuración por entorno
5. **Secrets**: Almacenamiento seguro de credenciales
6. **HPA**: Escalado horizontal automático

### Ejemplo de Despliegue en Kubernetes

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: vucem-componente
  namespace: vucem
spec:
  replicas: 2
  selector:
    matchLabels:
      app: vucem-componente
  template:
    metadata:
      labels:
        app: vucem-componente
    spec:
      containers:
      - name: vucem-componente
        image: ${CONTAINER_REGISTRY}/vucem-componente:${VERSION}
        ports:
        - containerPort: 8080
        readinessProbe:
          httpGet:
            path: /actuator/health/readiness
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
        livenessProbe:
          httpGet:
            path: /actuator/health/liveness
            port: 8080
          initialDelaySeconds: 60
          periodSeconds: 15
        resources:
          requests:
            memory: "512Mi"
            cpu: "200m"
          limits:
            memory: "1Gi"
            cpu: "500m"
        env:
        - name: SPRING_PROFILES_ACTIVE
          value: "prod"
        - name: SPRING_DATASOURCE_URL
          valueFrom:
            secretKeyRef:
              name: vucem-db-credentials
              key: url
        - name: SPRING_DATASOURCE_USERNAME
          valueFrom:
            secretKeyRef:
              name: vucem-db-credentials
              key: username
        - name: SPRING_DATASOURCE_PASSWORD
          valueFrom:
            secretKeyRef:
              name: vucem-db-credentials
              key: password
```

## Mejores Prácticas

### Desarrollo General

1. **SOLID**: Seguir los principios SOLID (Single Responsibility, Open-Closed, etc.)
2. **DRY**: No repetir código (Don't Repeat Yourself)
3. **KISS**: Mantener soluciones simples (Keep It Simple, Stupid)
4. **YAGNI**: No implementar lo que no se necesita (You Aren't Gonna Need It)
5. **Fail-Fast**: Detectar y reportar errores lo antes posible

### Específicas para Java

1. **Uso de Streams API**: Preferir funcionalidad declarativa sobre imperativa
2. **Optional**: Usar Optional para representar valores potencialmente ausentes
3. **Lombok**: Utilizar para reducir código boilerplate
4. **Records**: Usar para DTOs y objetos de valor inmutables (Java 17+)
5. **Sealed Classes**: Aplicar para jerarquías cerradas (Java 17+)

### Específicas para APIs

1. **Versionado**: Versionar APIs en la URL (ej. `/api/v1/recursos`)
2. **Idempotencia**: Operaciones idénticas producen resultados idénticos
3. **HATEOAS**: Enlaces a recursos relacionados en respuestas
4. **Paginación**: Implementar para colecciones grandes
5. **Filtrado, Ordenación**: Soporte consistente en todas las colecciones

### Ejemplo de Buenas Prácticas

```java
// Uso de records para DTOs (Java 17+)
public record RecursoDTO(
    UUID id,
    String nombre,
    String descripcion,
    ZonedDateTime fechaCreacion
) {}

// Uso de Optional, Stream API y patrones funcionales
public Optional<RecursoDTO> buscarPorCriterios(BusquedaDTO criterios) {
    return recursoRepository.findAll()
        .stream()
        .filter(r -> coincideCriterios(r, criterios))
        .map(recursoMapper::toDto)
        .findFirst();
}

// Fail-fast con precondiciones
public void procesarOperacion(OperacionDTO operacion) {
    Objects.requireNonNull(operacion, "La operación no puede ser nula");
    if (operacion.getMonto() <= 0) {
        throw new IllegalArgumentException("El monto debe ser positivo");
    }
    
    // Procesamiento normal...
}
```

## Recursos Adicionales

### Documentación Oficial

- [Spring Boot](https://docs.spring.io/spring-boot/docs/current/reference/html/)
- [Spring Security](https://docs.spring.io/spring-security/reference/)
- [Spring Data JPA](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/)
- [MapStruct](https://mapstruct.org/documentation/stable/reference/html/)
- [Resilience4j](https://resilience4j.readme.io/docs)

### Tutoriales y Guías

- [Baeldung - Spring Guides](https://www.baeldung.com/spring-tutorial)
- [Reflectoring - Spring Boot Guides](https://reflectoring.io/categories/spring-boot/)
- [OWASP - Secure Coding Practices](https://owasp.org/www-project-secure-coding-practices-quick-reference-guide/)

### Herramientas Recomendadas

- [Postman](https://www.postman.com/) - Pruebas de API
- [DBeaver](https://dbeaver.io/) - Cliente SQL universal
- [k9s](https://k9scli.io/) - CLI para Kubernetes
- [HTTPie](https://httpie.io/) - Cliente HTTP para línea de comandos
- [Lens](https://k8slens.dev/) - IDE para Kubernetes