# VUCEM - Arquetipo de Componente

Este repositorio contiene un arquetipo para el desarrollo de componentes modulares dentro del ecosistema VUCEM, proporcionando una estructura base coherente, patrones de implementación y configuraciones de integración continua que garantizan la consistencia técnica y de calidad.

## Estructura del Proyecto

El arquetipo sigue una estructura de Clean Architecture con las siguientes capas:

```
src/
├── main/
│   ├── java/mx/gob/vucem/componente/
│   │   ├── domain/              # Entidades y reglas de negocio
│   │   ├── application/         # Casos de uso e implementación
│   │   ├── infrastructure/      # Implementaciones técnicas
│   │   └── interfaces/          # Interfaces de usuario/API
│   └── resources/               # Configuraciones y recursos
└── test/                        # Pruebas automatizadas
```

## Características Principales

- **Clean Architecture**: Separación clara de responsabilidades en capas
- **Observabilidad**: Métricas, trazabilidad y logging configurados
- **Seguridad**: Autenticación y autorización con Spring Security y JWT
- **Validación**: Validación automática de datos de entrada
- **Documentación API**: OpenAPI/Swagger integrado
- **CI/CD**: Flujos de trabajo configurados para GitHub Actions
- **Resiliencia**: Circuit breakers, retries y timeouts configurados

## Requisitos

- Java 21+
- Maven 3.8+
- Docker (para contenedorización)

## Uso

Para crear un nuevo componente basado en este arquetipo, use el script de generación incluido:

```bash
./scripts/generador-componente.sh nombre-componente area-funcional "Descripción del componente"
```

## Componentes Preconfigurados

- Spring Boot 3.2.0
- Spring Security
- Spring Data JPA
- PostgreSQL (base de datos)
- Resilience4j (tolerancia a fallos)
- Micrometer + Prometheus (métricas)
- OpenTelemetry (trazabilidad)
- Logback + SLF4J (logging)
- MapStruct (mapeo de objetos)
- Caffeine (caché local)

## Compilación y Ejecución

### Compilación

```bash
mvn clean package
```

### Ejecución Local

```bash
mvn spring-boot:run -Dspring-boot.run.profiles=local
```

### Docker

```bash
# Construir imagen
docker build -t vucem-componente .

# Ejecutar contenedor
docker run -p 8080:8080 vucem-componente
```

## Documentación

Para más detalles sobre la arquitectura y uso del arquetipo, consulte:

- [Documentación de Arquitectura](ARCHITECTURE.md)
- [Guía para Desarrolladores](docs/manual/guia-desarrollo.md)

## Licencia

Gobierno de México - Todos los derechos reservados