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

## 🚀 Uso Ultra Rápido

### ⚡ Una Línea (47% más corto)

```bash
# Crear componente instantáneamente
curl -s https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/vucem | bash -s sistema-aduanas aduanas

# Con descripción personalizada
curl -s https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/vucem | bash -s \
  validador-xml exportacion "Validador de documentos XML"
```

### 🔧 Setup Completo

```bash
# 1. Configurar sistema (una vez)
curl -s https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/setup | bash

# 2. Crear proyecto (diario)
curl -s https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/vucem | bash -s mi-app usuarios

# 3. Validar resultado
curl -s https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/check | bash -s vucem-mi-app
```

### 💻 Uso Local (Naming Optimizado)

Si tienes el repositorio clonado:

```bash
./setup           # Verificar/instalar requisitos
./vucem mi-app area "descripción"    # Generar componente  
./check vucem-mi-app                 # Validar resultado
./test                               # Probar todo
```

### 📚 Más Información

- 📖 **[Naming Optimizado](NAMING_OPTIMIZADO.md)** - 67% menos caracteres, máxima eficiencia
- 🌐 **[Uso Remoto Completo](USO_REMOTO.md)** - Todas las opciones disponibles
- ⚡ **[Quick Start](QUICK_START.md)** - Inicio en 30 segundos

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