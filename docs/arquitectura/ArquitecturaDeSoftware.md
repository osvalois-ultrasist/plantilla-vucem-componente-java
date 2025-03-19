## 1. Visión General del Arquetipo

Este arquetipo establece un framework arquitectónico estandarizado para el desarrollo de componentes modulares dentro del ecosistema VUCEM. Proporciona una estructura base coherente, patrones de implementación y configuraciones de integración continua que garantizan la consistencia técnica y de calidad en todos los componentes desarrollados.

### 1.1 Propósito

Servir como plantilla de referencia para el desarrollo de nuevos componentes, asegurando:

- Coherencia arquitectónica entre equipos y proyectos
- Implementación consistente de prácticas DevSecOps
- Cumplimiento normativo y de seguridad desde el diseño
- Aceleración del tiempo de desarrollo mediante componentes preconfigurados

### 1.2 Audiencia Objetivo

- Equipos de desarrollo de componentes VUCEM
- Arquitectos de soluciones
- Administradores DevOps
- Auditores de seguridad y cumplimiento

## 2. Framework Arquitectónico

### 2.1 Modelo Arquitectónico: Clean Architecture

El arquetipo implementa los principios de Clean Architecture con un enfoque en la separabilidad de responsabilidades:

![](https://cleanarchitecture.io/wp-content/uploads/2020/04/CleanArchitecture-1.jpg)

### 2.1.1 Capas Definidas

1. **Dominio** (núcleo):
    - Entidades de negocio
    - Reglas y lógica de negocio
    - Interfaces de repositorio y servicios
2. **Aplicación** (casos de uso):
    - Implementación de casos de uso
    - Orquestación de flujos de negocio
    - DTOs (Objetos de Transferencia de Datos)
3. **Infraestructura**:
    - Implementaciones de repositorios
    - Adaptadores para servicios externos
    - Configuración técnica
4. **Interfaces**:
    - APIs REST
    - Interfaces de usuario
    - Adaptadores de entrada

### 2.2 Patrones Arquitectónicos Implementados

- **Patrón Repositorio**: Abstracción del acceso a datos
- **Patrón Adaptador**: Conversión entre interfaces incompatibles
- **Patrón Mediador**: Centralización de la comunicación entre componentes
- **Patrón Estrategia**: Encapsulación de algoritmos intercambiables
- **Patrón Factory**: Creación centralizada de objetos

## 3. Estructura Base del Arquetipo

```
vucem-componente/
├── src/
│   ├── main/
│   │   ├── java/mx/gob/vucem/componente/
│   │   │   ├── domain/              # Entidades y reglas de negocio
│   │   │   │   ├── entities/
│   │   │   │   ├── exceptions/
│   │   │   │   ├── repositories/     # Interfaces de repositorios
│   │   │   │   ├── services/         # Interfaces de servicios de dominio
│   │   │   │   └── valueobjects/
│   │   │   ├── application/          # Casos de uso e implementación
│   │   │   │   ├── dtos/
│   │   │   │   ├── exceptions/
│   │   │   │   ├── mappers/
│   │   │   │   ├── services/         # Implementación de servicios
│   │   │   │   └── validators/
│   │   │   ├── infrastructure/       # Implementaciones técnicas
│   │   │   │   ├── config/
│   │   │   │   ├── persistence/
│   │   │   │   │   ├── entities/     # Entidades JPA
│   │   │   │   │   ├── repositories/ # Implementaciones repositorios
│   │   │   │   │   └── mappers/
│   │   │   │   ├── security/
│   │   │   │   └── services/         # Implementaciones de servicios externos
│   │   │   └── interfaces/           # Interfaces de usuario/API
│   │   │       ├── api/
│   │   │       │   ├── controllers/
│   │   │       │   ├── advisors/     # Manejadores de excepciones
│   │   │       │   ├── docs/         # Documentación Swagger/OpenAPI
│   │   │       │   └── filters/
│   │   │       └── events/           # Manejadores de eventos
│   │   └── resources/
│   │       ├── application.yml       # Configuración general
│   │       ├── application-dev.yml
│   │       ├── application-qa.yml
│   │       └── application-prod.yml
│   └── test/
│       ├── java/mx/gob/vucem/componente/
│       │   ├── domain/               # Pruebas unitarias de dominio
│       │   ├── application/          # Pruebas unitarias de casos de uso
│       │   ├── infrastructure/       # Pruebas de integración
│       │   └── interfaces/           # Pruebas de API
│       └── resources/
│           └── test-data/            # Datos para pruebas
├── infrastructure/                   # Configuración de infraestructura
│   ├── kubernetes/
│   │   ├── base/                     # Configuración base K8s
│   │   └── environments/             # Configuraciones por entorno
│   ├── docker/
│   │   └── Dockerfile
│   └── docs/                         # Documentación de infraestructura
├── .github/
│   ├── workflows/
│   │   ├── ci.yml                    # Flujo de integración continua
│   │   ├── cd-dev.yml                # Despliegue a desarrollo
│   │   ├── cd-qa.yml                 # Despliegue a QA
│   │   └── cd-prod.yml               # Despliegue a producción
│   ├── ISSUE_TEMPLATE/
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── dependabot.yml
├── docs/
│   ├── arquitectura/                 # Documentación arquitectónica
│   ├── api/                          # Documentación de API
│   └── manual/                       # Manuales de usuario/operación
├── scripts/                          # Scripts de utilidad
├── .editorconfig                     # Configuración de editor
├── .gitignore
├── CHANGELOG.md
├── Dockerfile                        # Archivo Docker principal
├── LICENSE
├── README.md
└── pom.xml                           # Configuración Maven

```

## 4. Componentes Preconfigurados del Framework

### 4.1 Componentes Transversales

| Componente | Implementación | Propósito |
| --- | --- | --- |
| **Logging** | Logback + SLF4J | Registro estructurado en formato JSON |
| **Métricas** | Micrometer + Prometheus | Monitoreo de rendimiento y operación |
| **Trazabilidad** | OpenTelemetry | Seguimiento de transacciones distribuidas |
| **Validación** | Hibernate Validator | Validación de datos de entrada |
| **Documentación** | SpringDoc OpenAPI | Documentación automatizada de API |
| **Seguridad** | Spring Security + OAuth2 | Autenticación y autorización |
| **Caché** | Caffeine + Redis | Almacenamiento en caché por niveles |
| **Resiliencia** | Resilience4j | Patrones de tolerancia a fallos |
| **Mensajería** | Spring Cloud Stream | Integración con sistemas de mensajería |
| **Mapeo** | MapStruct | Conversión eficiente entre modelos |

### 4.2 Configuración Base Spring Boot

```yaml
# application.yml base preconfigurado
spring:
  application:
    name: ${COMPONENTE_NOMBRE:vucem-componente}
  profiles:
    active: ${SPRING_PROFILES_ACTIVE:local}
  jackson:
    date-format: com.fasterxml.jackson.databind.util.ISO8601DateFormat
    default-property-inclusion: non_null
    serialization:
      write-dates-as-timestamps: false
  datasource:
    hikari:
      connection-timeout: 20000
      maximum-pool-size: 10
      minimum-idle: 5
  jpa:
    open-in-view: false
    properties:
      hibernate:
        jdbc:
          batch_size: 50
        order_inserts: true
        order_updates: true
        dialect: org.hibernate.dialect.PostgreSQLDialect
  cache:
    cache-names: config,catalogos
    caffeine:
      spec: maximumSize=500,expireAfterAccess=600s
  cloud:
    openfeign:
      client:
        config:
          default:
            connectTimeout: 5000
            readTimeout: 5000
            loggerLevel: full

server:
  port: 8080
  tomcat:
    max-threads: 200
    accept-count: 100
  compression:
    enabled: true
    mime-types: application/json,application/xml,text/plain
    min-response-size: 2048

management:
  endpoints:
    web:
      exposure:
        include: health,info,prometheus,metrics
  endpoint:
    health:
      show-details: when_authorized
      probes:
        enabled: true
      group:
        liveness:
          include: livenessState,diskSpace
        readiness:
          include: readinessState,db,redis
  metrics:
    export:
      prometheus:
        enabled: true
    distribution:
      percentiles-histogram:
        http.server.requests: true
  tracing:
    sampling:
      probability: 1.0

logging:
  pattern:
    console: "%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{36} [%X{traceId},%X{spanId}] - %msg%n"
  level:
    root: INFO
    mx.gob.vucem: INFO
    org.springframework.web: INFO
    org.hibernate: WARN

vucem:
  componente:
    nombre: ${spring.application.name}
    version: @project.version@
  seguridad:
    permitir-origins: ${PERMITIR_ORIGINS:*}
    jwt:
      issuer: ${JWT_ISSUER:vucem.gob.mx}
      expiracion: ${JWT_EXPIRACION:3600}
  metricas:
    enabled: true
  auditoria:
    enabled: true
  circuit-breaker:
    enabled: true
    timeout: 5s
    retry-attempts: 3

```

## 5. Integración Continua y Despliegue (CI/CD)

### 5.1 Flujo de CI Base

```yaml
# ci.yml base para cualquier componente
name: VUCEM Componente CI

env:
  REGISTRO: ghcr.io
  REPO_MAVEN: https://maven.pkg.github.com/${{ github.repository_owner }}
  NAMESPACE_K8S: vucem-${COMPONENTE_AREA}
  COMPONENTE: ${COMPONENTE_NOMBRE}

on:
  push:
    branches: [main, desarrollo]
    paths-ignore:
      - 'docs/**'
      - '**.md'
  pull_request:
    branches: [main, desarrollo]
  workflow_dispatch:

jobs:
  validar:
    name: Validar Código
    runs-on: ubuntu-latest
    steps:
      - name: Obtener Código Fuente
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Configurar JDK
        uses: actions/setup-java@v3
        with:
          java-version: '21'
          distribution: 'temurin'
          cache: 'maven'

      - name: Validar Estilo de Código
        run: mvn -B checkstyle:check

      - name: Análisis Estático
        run: mvn -B spotbugs:check pmd:check

  pruebas:
    name: Ejecutar Pruebas
    needs: validar
    runs-on: ubuntu-latest
    steps:
      - name: Obtener Código Fuente
        uses: actions/checkout@v4

      - name: Configurar JDK
        uses: actions/setup-java@v3
        with:
          java-version: '21'
          distribution: 'temurin'
          cache: 'maven'

      - name: Ejecutar Pruebas Unitarias
        run: mvn -B test

      - name: Generar Reporte de Cobertura
        run: mvn -B jacoco:report

      - name: Verificar Cobertura Mínima
        run: mvn -B jacoco:check

      - name: Publicar Resultados de Pruebas
        uses: dorny/test-reporter@v1
        if: success() || failure()
        with:
          name: Resultados de Pruebas Unitarias
          path: target/surefire-reports/*.xml
          reporter: java-junit

      - name: Publicar Reporte de Cobertura
        uses: codecov/codecov-action@v3
        with:
          file: target/site/jacoco/jacoco.xml
          name: codecov-umbrella
          fail_ci_if_error: false

  analisis-seguridad:
    name: Analizar Seguridad
    needs: pruebas
    runs-on: ubuntu-latest
    permissions:
      contents: read
      security-events: write
    steps:
      - name: Obtener Código Fuente
        uses: actions/checkout@v4

      - name: Análisis de Código Seguro
        uses: github/codeql-action/analyze@v2
        with:
          languages: java

      - name: Escanear Vulnerabilidades en Dependencias
        run: mvn -B dependency-check:check

      - name: Verificar Actualizaciones de Seguridad
        uses: dependency-review-action@v3
        with:
          fail-on-severity: high

  construir:
    name: Construir Artefacto
    needs: [pruebas, analisis-seguridad]
    if: github.event_name != 'pull_request'
    runs-on: ubuntu-latest
    outputs:
      version: ${{ steps.version.outputs.valor }}
    steps:
      - name: Obtener Código Fuente
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Configurar JDK
        uses: actions/setup-java@v3
        with:
          java-version: '21'
          distribution: 'temurin'
          cache: 'maven'

      - name: Determinar Versión
        id: version
        run: |
          if [[ "${{ github.ref }}" == "refs/heads/main" ]]; then
            VERSION="$(git describe --tags --abbrev=0 2>/dev/null || echo '0.1.0')"
          else
            VERSION="$(git describe --tags --always)-SNAPSHOT"
          fi
          echo "valor=$VERSION" >> $GITHUB_OUTPUT

      - name: Construir con Maven
        run: |
          mvn -B package \
            -Drevision=${{ steps.version.outputs.valor }} \
            -DskipTests

      - name: Generar SBOM
        uses: anchore/sbom-action@v0.15
        with:
          artifact-name: vucem-${{ env.COMPONENTE }}-sbom
          format: cyclonedx-json
          output-file: sbom.json

      - name: Subir Artefacto
        uses: actions/upload-artifact@v3
        with:
          name: vucem-${{ env.COMPONENTE }}-${{ steps.version.outputs.valor }}
          path: |
            target/*.jar
            sbom.json
          retention-days: 14

  publicar:
    name: Publicar Imagen
    needs: [construir]
    if: github.ref == 'refs/heads/main' || github.ref == 'refs/heads/desarrollo'
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    steps:
      - name: Obtener Código Fuente
        uses: actions/checkout@v4

      - name: Descargar Artefacto
        uses: actions/download-artifact@v3
        with:
          name: vucem-${{ env.COMPONENTE }}-${{ needs.construir.outputs.version }}
          path: target

      - name: Configurar Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Autenticar en GitHub Container Registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRO }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Extraer Metadatos Docker
        id: docker-meta
        uses: docker/metadata-action@v4
        with:
          images: ${{ env.REGISTRO }}/${{ github.repository }}
          tags: |
            type=semver,pattern={{version}},value=${{ needs.construir.outputs.version }}
            type=ref,event=branch
            type=sha,format=short

      - name: Construir y Publicar Imagen Docker
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ steps.docker-meta.outputs.tags }}
          labels: ${{ steps.docker-meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
          provenance: true
          sbom: true

```

### 5.2 Especificación de Dockerfile Base

```
# Dockerfile base para cualquier componente
FROM eclipse-temurin:21-jdk AS constructor
WORKDIR /app
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN ./mvnw dependency:go-offline -B

COPY src/ ./src/
RUN ./mvnw package -DskipTests && \
    mkdir -p target/extracted && \
    java -Djarmode=layertools -jar target/*.jar extract --destination target/extracted

FROM eclipse-temurin:21-jre AS runtime
WORKDIR /app

# Usuario no privilegiado
RUN addgroup --system --gid 1001 appgroup && \
    adduser --system --uid 1001 --ingroup appgroup appuser

# Metadatos de aplicación
ARG APP_VERSION=unknown
ARG BUILD_TIME=unknown
ARG GIT_COMMIT=unknown

# Certificados y herramientas básicas
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    dumb-init \
    && rm -rf /var/lib/apt/lists/*

# Capas de aplicación
COPY --from=constructor /app/target/extracted/dependencies/ ./
COPY --from=constructor /app/target/extracted/spring-boot-loader/ ./
COPY --from=constructor /app/target/extracted/snapshot-dependencies/ ./
COPY --from=constructor /app/target/extracted/application/ ./

# Configuración del entorno
ENV TZ=America/Mexico_City
ENV JAVA_OPTS="-XX:MaxRAMPercentage=75.0 -XX:+UseG1GC -XX:MaxGCPauseMillis=200"

# Seguridad
USER appuser
EXPOSE 8080
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["sh", "-c", "java $JAVA_OPTS org.springframework.boot.loader.JarLauncher"]

# Verificación de salud
HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://localhost:8080/actuator/health/liveness || exit 1

# Etiquetas estándar
LABEL org.opencontainers.image.title="${COMPONENTE_NOMBRE}" \
      org.opencontainers.image.description="Componente ${COMPONENTE_DESCRIPCION} de VUCEM" \
      org.opencontainers.image.version="${APP_VERSION}" \
      org.opencontainers.image.created="${BUILD_TIME}" \
      org.opencontainers.image.revision="${GIT_COMMIT}" \
      org.opencontainers.image.vendor="Gobierno de México" \
      org.opencontainers.image.source="https://github.com/${GITHUB_REPOSITORY}" \
      mx.gob.vucem.componente="${COMPONENTE_NOMBRE}" \
      mx.gob.vucem.area="${COMPONENTE_AREA}"

```

## 6. Mecanismos de Extensión del Framework

### 6.1 Arquitectura de Plugins

El arquetipo implementa un sistema de plugins que permite extender la funcionalidad base sin modificar el núcleo:

1. **Definición de Puntos de Extensión**:
    
    ```java
    public interface PuntoExtension<T, R> {
        R ejecutar(T entrada, Map<String, Object> contexto);
        String getIdentificador();
        int getPrioridad();
    }
    
    ```
    
2. **Registro de Extensiones**:
    
    ```java
    @Service
    public class RegistroExtensiones {
        private final Map<Class<?>, List<PuntoExtension<?, ?>>> extensiones = new ConcurrentHashMap<>();
    
        public <T, R> void registrar(Class<T> tipo, PuntoExtension<T, R> extension) {
            extensiones.computeIfAbsent(tipo, k -> new ArrayList<>())
                      .add(extension);
            // Ordenar por prioridad
            extensiones.get(tipo).sort(Comparator.comparing(PuntoExtension::getPrioridad));
        }
    
        @SuppressWarnings("unchecked")
        public <T, R> List<PuntoExtension<T, R>> obtenerExtensiones(Class<T> tipo) {
            return (List<PuntoExtension<T, R>>) (List<?>)
                   extensiones.getOrDefault(tipo, Collections.emptyList());
        }
    }
    
    ```
    
3. **Implementación de Extensión**:
    
    ```java
    @Component
    public class ValidacionAdicionalExtension implements PuntoExtension<DocumentoAduanero, Boolean> {
        @Override
        public Boolean ejecutar(DocumentoAduanero doc, Map<String, Object> ctx) {
            // Lógica de validación específica
            return esValido(doc);
        }
    
        @Override
        public String getIdentificador() {
            return "validacion.regimen.especial";
        }
    
        @Override
        public int getPrioridad() {
            return 100; // Mayor número = menor prioridad
        }
    
        private boolean esValido(DocumentoAduanero doc) {
            // Implementación específica
            return true;
        }
    }
    
    ```
    

### 6.2 Interceptores de Eventos

El framework incluye un sistema de eventos que permite desacoplar componentes:

1. **Definición de Eventos**:
    
    ```java
    public interface EventoVucem<T> {
        String getTipo();
        T getCarga();
        ZonedDateTime getFechaCreacion();
        String getOrigen();
    }
    
    ```
    
2. **Publicación de Eventos**:
    
    ```java
    @Service
    public class PublicadorEventos {
        private final ApplicationEventPublisher publisher;
    
        public PublicadorEventos(ApplicationEventPublisher publisher) {
            this.publisher = publisher;
        }
    
        public <T> void publicar(EventoVucem<T> evento) {
            publisher.publishEvent(evento);
        }
    }
    
    ```
    
3. **Escucha de Eventos**:
    
    ```java
    @Component
    public class ManejadorEventosAuditoria {
        private final ServicioAuditoria auditoriaService;
    
        @EventListener
        public void manejarEvento(EventoVucem<?> evento) {
            // Registrar en auditoría
            auditoriaService.registrarEvento(
                evento.getTipo(),
                evento.getOrigen(),
                evento.getCarga()
            );
        }
    }
    
    ```
    

## 7. Validación y Verificación

### 7.1 Pruebas Automatizadas

El arquetipo implementa una estrategia de pruebas en múltiples niveles:

1. **Pruebas Unitarias**:
    
    ```java
    @ExtendWith(MockitoExtension.class)
    class ValidadorDocumentoTest {
        @Mock
        private RepositorioReglas repoReglas;
    
        @InjectMocks
        private ValidadorDocumentoImpl validador;
    
        @Test
        void debeValidarDocumentoValido() {
            // Arrange
            Documento doc = crearDocumentoValido();
            when(repoReglas.obtenerReglas()).thenReturn(List.of(new ReglaSimple()));
    
            // Act
            ResultadoValidacion resultado = validador.validar(doc);
    
            // Assert
            assertTrue(resultado.esValido());
            assertEquals(0, resultado.getErrores().size());
        }
    }
    
    ```
    
2. **Pruebas de Integración**:
    
    ```java
    @SpringBootTest
    @ActiveProfiles("test")
    class RepositorioDocumentosIntegrationTest {
        @Autowired
        private RepositorioDocumentos repositorio;
    
        @Autowired
        private TestEntityManager entityManager;
    
        @Test
        void debePersistirYRecuperarDocumento() {
            // Arrange
            DocumentoEntity entity = new DocumentoEntity();
            entity.setNumero("DOC12345");
            entity.setEstado(EstadoDocumento.NUEVO);
    
            // Act
            entityManager.persist(entity);
            entityManager.flush();
    
            // Assert
            DocumentoEntity recuperado = repositorio.findByNumero("DOC12345")
                .orElseThrow();
    
            assertEquals(EstadoDocumento.NUEVO, recuperado.getEstado());
        }
    }
    
    ```
    
3. **Pruebas de API**:
    
    ```java
    @SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
    @ActiveProfiles("test")
    class DocumentoControllerApiTest {
        @Autowired
        private TestRestTemplate restTemplate;
    
        @Autowired
        private RepositorioDocumentos repositorio;
    
        @BeforeEach
        void configurar() {
            // Datos de prueba
        }
    
        @Test
        void debeCrearDocumento() {
            // Arrange
            CrearDocumentoRequest request = new CrearDocumentoRequest();
            request.setTipo("PEDIMENTO");
            request.setReferencia("P12345");
    
            // Act
            ResponseEntity<DocumentoResponse> response = restTemplate.postForEntity(
                "/api/documentos",
                request,
                DocumentoResponse.class
            );
    
            // Assert
            assertEquals(HttpStatus.CREATED, response.getStatusCode());
            assertNotNull(response.getBody());
            assertNotNull(response.getBody().getId());
        }
    }
    
    ```
    

### 7.2 Verificación de Contratos

El arquetipo incluye pruebas de contratos para garantizar la compatibilidad de API:

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureWireMock(port = 0)
class ContratoClienteExterno {
    @Autowired
    private ClienteServicioExterno cliente;

    @Test
    void debeConsumirServicioExterno() {
        // Arrange
        stubFor(get(urlEqualTo("/api/catalogo/paises"))
            .willReturn(aResponse()
                .withHeader("Content-Type", "application/json")
                .withBodyFile("catalogo-paises.json")));

        // Act
        List<PaisDTO> resultado = cliente.obtenerCatalogoPaises();

        // Assert
        assertFalse(resultado.isEmpty());
        assertEquals("MX", resultado.get(0).getCodigo());
    }
}

```

## 8. Mecanismos de Configuración

### 8.1 Configuración Externalizada

El arquetipo implementa un sistema de configuración por capas:

1. **Configuración Base**: Valores predeterminados en `application.yml`
2. **Configuración por Perfil**: Sobrescrituras específicas en `application-{perfil}.yml`
3. **Configuración por Entorno**: Variables de entorno y propiedades de sistema
4. **Configuración Centralizada**: Spring Cloud Config para valores compartidos

Ejemplo de uso:

```java
@Configuration
@ConfigurationProperties(prefix = "vucem.componente")
@Validated
public class ConfiguracionComponente {
    @NotBlank
    private String nombre;

    private int maxReintentos = 3;

    @Min(1000)
    @Max(30000)
    private int timeoutMs = 5000;

    @Valid
    private Seguridad seguridad = new Seguridad();

    // Getters y setters

    public static class Seguridad {
        private boolean habilitada = true;
        private String nivelMinimo = "MEDIO";

        // Getters y setters
    }
}

```

### 8.2 Gestión de Secretos

El arquetipo implementa un enfoque seguro para gestionar secretos:

1. **En Desarrollo**: Hashicorp Vault
2. **En Producción**: AWS Secrets Manager + Kubernetes Secrets

Configuración de integración:

```java
@Configuration
@Profile({"qa", "production"})
public class SecretManagerConfig {
    @Bean
    public SecretManager awsSecretManager(
            AWSSecretManagerProperties properties) {
        return new AWSSecretManager(properties);
    }
}

@Configuration
@Profile({"dev", "local"})
public class VaultConfig {
    @Bean
    public SecretManager vaultSecretManager(
            VaultProperties properties) {
        return new VaultSecretManager(properties);
    }
}

// Interfaz común
public interface SecretManager {
    String obtenerSecreto(String ruta);
    Map<String, String> obtenerSecretos(String ruta);
    void almacenarSecreto(String ruta, String valor);
}

```

## 9. Herramientas de Generación y Bootstrapping

### 9.1 Generador de Proyectos

Para facilitar la creación de nuevos componentes basados en este arquetipo, se incluye un script de generación:

```bash
#!/bin/bash
# generador-componente.sh

# Validar argumentos
if [ "$#" -lt 2 ]; then
    echo "Uso: $0 <nombre-componente> <area-funcional> [descripción]"
    exit 1
fi

NOMBRE_COMPONENTE=$1
AREA_FUNCIONAL=$2
DESCRIPCION=${3:-"Componente de VUCEM para $AREA_FUNCIONAL"}
REPO_BASE="https://github.com/vucem/arquetipo"
FECHA=$(date +"%Y-%m-%d")

echo "Generando componente VUCEM: $NOMBRE_COMPONENTE"
echo "Área funcional: $AREA_FUNCIONAL"

# Clonar arquetipo
git clone $REPO_BASE temp-$NOMBRE_COMPONENTE

# Crear repositorio del nuevo componente
cd temp-$NOMBRE_COMPONENTE
rm -rf .git
git init

# Personalizar archivos
find . -type f -not -path "*/\.*" -not -path "*/node_modules/*" -not -path "*/target/*" |
while read FILE; do
    if [[ -f "$FILE" ]]; then
        sed -i "s/COMPONENTE_NOMBRE/$NOMBRE_COMPONENTE/g" "$FILE"
        sed -i "s/COMPONENTE_AREA/$AREA_FUNCIONAL/g" "$FILE"
        sed -i "s/COMPONENTE_DESCRIPCION/$DESCRIPCION/g" "$FILE"
        sed -i "s/FECHA_GENERACION/$FECHA/g" "$FILE"
    fi
done

# Renombrar paquetes y directorios
mkdir -p src/main/java/mx/gob/vucem/$NOMBRE_COMPONENTE/
mv src/main/java/mx/gob/vucem/componente/* src/main/java/mx/gob/vucem/$NOMBRE_COMPONENTE/
rm -rf src/main/java/mx/gob/vucem/componente/

# Actualizar README
cat > README.md << EOF
# VUCEM - $NOMBRE_COMPONENTE

Componente de $DESCRIPCION para la Ventanilla Única de Comercio Exterior Mexicana.

## Área Funcional

$AREA_FUNCIONAL

## Descripción

$DESCRIPCION

## Fecha de Creación

$FECHA

## Documentación

Consultar el directorio \`/docs\` para la documentación detallada del componente.
EOF

echo "Componente generado en: $(pwd)"
echo "Ejecute los siguientes comandos para finalizar:"
echo "cd temp-$NOMBRE_COMPONENTE"
echo "git add ."
echo "git commit -m \"Generación inicial del componente $NOMBRE_COMPONENTE\""

```

### 9.2 Maven Archetype

El arquetipo también está disponible como un Maven Archetype para integración con IDEs:

```xml
<!-- pom.xml para el archetype -->
<project>
    <modelVersion>4.0.0</modelVersion>
    <groupId>mx.gob.vucem</groupId>
    <artifactId>vucem-componente-archetype</artifactId>
    <version>1.0.0</version>
    <packaging>maven-archetype</packaging>

    <name>VUCEM Componente Archetype</name>
    <description>Arquetipo Maven para componentes de VUCEM</description>

    <properties>
        <maven.compiler.source>21</maven.compiler.source>
        <maven.compiler.target>21</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <build>
        <extensions>
            <extension>
                <groupId>org.apache.maven.archetype</groupId>
                <artifactId>archetype-packaging</artifactId>
                <version>3.2.0</version>
            </extension>
        </extensions>
        <plugins>
            <plugin>
                <artifactId>maven-archetype-plugin</artifactId>
                <version>3.2.0</version>
            </plugin>
        </plugins>
    </build>
</project>

```

Ejemplos de uso:

```bash
# Desde línea de comandos
mvn archetype:generate \
  -DarchetypeGroupId=mx.gob.vucem \
  -DarchetypeArtifactId=vucem-componente-archetype \
  -DarchetypeVersion=1.0.0 \
  -DgroupId=mx.gob.vucem \
  -DartifactId=mi-nuevo-componente \
  -Dversion=0.1.0-SNAPSHOT \
  -DcomponenteNombre=nuevoComponente \
  -DcomponenteArea=regulaciones \
  -DcomponenteDescripcion="Gestión de regulaciones y restricciones"

```

## 10. Modelo de Documentación

### 10.1 Documentación Arquitectónica

El arquetipo incluye plantillas para la documentación arquitectónica según el formato Arc42:

```markdown
# 1. Introducción y Objetivos

## 1.1 Requisitos

| ID    | Requisito | Prioridad |
|-------|-----------|-----------|
| REQ-01 | El componente debe... | Alta |
| REQ-02 | El sistema debe... | Media |

## 1.2 Objetivos de Calidad

| ID    | Atributo | Descripción | Métrica |
|-------|----------|-------------|---------|
| CA-01 | Rendimiento | Tiempo de respuesta | < 500ms |
| CA-02 | Disponibilidad | Tiempo de funcionamiento | 99.9% |

## 1.3 Restricciones

* Restricción 1
* Restricción 2

# 2. Contexto del Sistema

## 2.1 Contexto de Negocio

[Diagrama de contexto de negocio]

## 2.2 Contexto Técnico

[Diagrama de contexto técnico]

# 3. Estrategia de la Solución

[Descripción de la estrategia]

# 4. Vista de Bloques de Construcción

## 4.1 Refinamiento de Nivel 1

[Diagrama de componentes principales]

## 4.2 Refinamiento de Nivel 2

[Diagrama de subcomponentes]

# 5. Vista de Tiempo de Ejecución

[Diagramas de secuencia principales]

# 6. Vista de Despliegue

[Diagrama de infraestructura]

# 7. Conceptos Transversales

[Descripción de conceptos transversales]

# 8. Decisiones Arquitectónicas

| ID    | Decisión | Justificación | Alternativas Consideradas |
|-------|----------|---------------|---------------------------|
| AD-01 | Uso de Spring Boot | Facilita desarrollo, amplio soporte | Quarkus, Micronaut |
| AD-02 | Base de datos PostgreSQL | Soporte para datos JSON, rendimiento | Oracle, MySQL |

```

### 10.2 Documentación de API

El arquetipo genera automáticamente la documentación de API con OpenAPI:

```java
@Configuration
public class OpenApiConfig {
    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("API de " + System.getenv().getOrDefault("COMPONENTE_NOMBRE", "Componente VUCEM"))
                        .description(System.getenv().getOrDefault("COMPONENTE_DESCRIPCION", "API del componente"))
                        .version("v1")
                        .contact(new Contact()
                                .name("Equipo VUCEM")
                                .email("vucem@sat.gob.mx")
                                .url("https://www.gob.mx/vucem"))
                        .license(new License()
                                .name("Gobierno de México")
                                .url("https://www.gob.mx/terminos")))
                .externalDocs(new ExternalDocumentation()
                        .description("Documentación adicional")
                        .url("https://www.gob.mx/vucem/documentos/api"))
                .addSecurityItem(new SecurityRequirement().addList("bearerAuth"))
                .components(new Components()
                        .addSecuritySchemes("bearerAuth", new SecurityScheme()
                                .type(SecurityScheme.Type.HTTP)
                                .scheme("bearer")
                                .bearerFormat("JWT")));
    }
}

```

## 11. Cumplimiento y Gobernanza

### 11.1 Matriz de Cumplimiento Normativo

El arquetipo implementa controles para garantizar el cumplimiento de:

| Normativa | Control | Implementación |
| --- | --- | --- |
| **NOM-151** | Conservación de datos | Sistema de auditoría y bitácoras |
| **LFPDPPP** | Protección de datos | Cifrado en reposo y tránsito |
| **ISO 27001** | Seguridad de información | Controles de acceso, auditoría |
| **GDPR** | Datos internacionales | Anonimización, retención |

### 11.2 Verificación Automática de Cumplimiento

```yaml
# verificacion-cumplimiento.yml
name: Verificación de Cumplimiento

on:
  schedule:
    - cron: '0 0 * * 1'  # Cada lunes
  workflow_dispatch:

jobs:
  verificar-cumplimiento:
    name: Verificar Controles de Cumplimiento
    runs-on: ubuntu-latest
    steps:
      - name: Obtener Código Fuente
        uses: actions/checkout@v4

      - name: Verificar Licencias
        uses: apache/skywalking-eyes@main
        with:
          log-level: info
          config-file: .licenserc.yaml

      - name: Verificar Estándares de Código
        run: mvn -B checkstyle:check pmd:check spotbugs:check

      - name: Verificar Vulnerabilidades
        run: mvn -B dependency-check:check

      - name: Verificar Cobertura de Pruebas
        run: mvn -B test jacoco:report jacoco:check

      - name: Generar Reporte de Cumplimiento
        run: |
          echo "# Reporte de Cumplimiento Normativo" > compliance-report.md
          echo "Fecha: $(date)" >> compliance-report.md
          echo "Commit: ${{ github.sha }}" >> compliance-report.md
          echo "" >> compliance-report.md
          echo "## Resultados" >> compliance-report.md
          echo "" >> compliance-report.md
          echo "| Control | Estado | Detalles |" >> compliance-report.md
          echo "|---------|--------|----------|" >> compliance-report.md
          echo "| Licencias | ✅ | Todas las licencias verificadas |" >> compliance-report.md
          echo "| Estándares de Código | ✅ | Cumple estándares |" >> compliance-report.md
          echo "| Vulnerabilidades | ✅ | Sin vulnerabilidades detectadas |" >> compliance-report.md
          echo "| Cobertura de Pruebas | ✅ | >80% de cobertura |" >> compliance-report.md

      - name: Subir Reporte de Cumplimiento
        uses: actions/upload-artifact@v3
        with:
          name: reporte-cumplimiento
          path: compliance-report.md

```

## 12. Consideraciones de Operación y Desarrollo

### 12.1 Lineamientos de Desarrollo

El arquetipo define guías y prácticas recomendadas para los desarrolladores:

1. **Convenciones de Código**:
    - Seguir el estilo de código Java de Google
    - Utilizar Lombok para reducir código boilerplate
    - Documentar todas las clases públicas con Javadoc
2. **Gestión de Ramas**:
    - `main`: Código en producción
    - `desarrollo`: Integraciones para próxima versión
    - `feature/XXX`: Características individuales
    - `hotfix/XXX`: Correcciones urgentes
3. **Proceso de Revisión**:
    - Requerir al menos una aprobación para PR
    - Ejecutar todas las pruebas automatizadas
    - Verificar análisis de código estático

### 12.2 Guía de Operación

El arquetipo incluye documentación operativa base:

1. **Monitoreo**:
    - Endpoints de métricas en `/actuator/prometheus`
    - Alertas configuradas en Grafana
    - Dashboards predefinidos para operación
2. **Escalamiento**:
    - Configuración de auto-escalamiento horizontal
    - Recomendaciones de recursos por entorno
3. **Recuperación ante Desastres**:
    - Procedimientos de respaldo y recuperación
    - Estrategia de continuidad de operaciones

## 13. Generación y Uso del Arquetipo

Este arquetipo se puede utilizar como base para nuevos componentes VUCEM siguiendo estos pasos:

1. Obtener el arquetipo:
    
    ```bash
    git clone https://github.com/vucem/arquetipo
    
    ```
    
2. Crear nuevo proyecto basado en arquetipo:
    
    ```bash
    cd arquetipo
    ./scripts/generar-componente.sh nombre-componente area-funcional "Descripción breve"
    
    ```
    
3. Configurar el nuevo proyecto:
    
    ```bash
    cd vucem-{nombre-componente}
    # Personalizar configuración específica
    
    ```
    
4. Iniciar el desarrollo:
    
    ```bash
    # Arrancar en modo local
    ./mvnw spring-boot:run -Dspring-boot.run.profiles=local
    
    ```
    

## 14. Conclusiones

Este arquetipo proporciona un framework de arquitectura completo para el desarrollo de componentes modulares dentro del ecosistema VUCEM. Al seguir esta estructura y directrices, los equipos pueden:

1. Reducir el tiempo de configuración y desarrollo inicial
2. Garantizar la consistencia técnica entre componentes
3. Asegurar la implementación de controles de seguridad y cumplimiento
4. Facilitar la evolución continua mediante mecanismos de extensión
5. Mantener un alto nivel de calidad a través de verificaciones automatizadas

La arquitectura modular y desacoplada facilita tanto la mantenibilidad como la extensibilidad, permitiendo que VUCEM evolucione gradualmente hacia un sistema más ágil y adaptable a las necesidades cambiantes del comercio exterior mexicano.