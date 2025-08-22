# Instrucciones de Uso - Plantilla VUCEM Componente

## 🚀 Inicio Rápido

### Prerequisitos
- Java 21+ (requerido para compilación)
- Maven 3.8+
- Git
- Docker (opcional)

### Verificar Requisitos del Sistema

```bash
# Verificar dependencias instaladas
./verificar-requisitos.sh

# Instalar dependencias faltantes automáticamente
./verificar-requisitos.sh --install
```

### Generar un Nuevo Componente

```bash
# Generar componente (nombres intuitivos)
./generar-componente.sh <nombre> <area> ["descripción"]

# Ejemplos:
./generar-componente.sh sistema-aduanas aduanas
./generar-componente.sh validador-xml exportacion "Validador de documentos XML"
```

### Validar el Componente Generado

```bash
# Validar componente generado
./validar-componente.sh <directorio-componente>

# Ejemplos:
./validar-componente.sh vucem-sistema-aduanas
./validar-componente.sh .
```

## 📁 Estructura Generada

El script genera un proyecto con la siguiente estructura modular:

```
vucem-<nombre-componente>/
├── src/
│   ├── main/
│   │   ├── java/mx/gob/vucem/<nombre_paquete>/
│   │   │   ├── domain/              # Entidades y lógica de negocio
│   │   │   │   ├── entities/        # Entidades del dominio
│   │   │   │   ├── repositories/    # Interfaces de repositorio
│   │   │   │   ├── services/        # Servicios de dominio
│   │   │   │   └── valueobjects/    # Objetos de valor
│   │   │   ├── application/         # Casos de uso
│   │   │   │   ├── dtos/           # DTOs
│   │   │   │   ├── mappers/        # Mapeadores
│   │   │   │   └── services/       # Servicios de aplicación
│   │   │   ├── infrastructure/      # Implementaciones técnicas
│   │   │   │   ├── config/         # Configuraciones
│   │   │   │   ├── persistence/    # JPA/Hibernate
│   │   │   │   └── security/       # Seguridad
│   │   │   └── interfaces/          # Interfaces externas
│   │   │       ├── api/            # REST Controllers
│   │   │       └── events/         # Eventos y mensajería
│   │   └── resources/
│   │       ├── application.yml      # Configuración principal
│   │       └── db/migration/        # Scripts de Flyway
│   └── test/                        # Tests unitarios y de integración
├── .github/
│   ├── workflows/                   # CI/CD pipelines
│   └── ISSUE_TEMPLATE/              # Plantillas de issues
├── docs/                            # Documentación
├── infrastructure/                  # IaC y configuraciones
├── pom.xml                         # Configuración Maven
├── Dockerfile                      # Contenedorización
└── README.md                       # Documentación principal
```

## ⚙️ Configuración Post-Generación

### 1. Configurar Base de Datos

Editar `src/main/resources/application.yml`:

```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/vucem_db
    username: vucem_user
    password: your_secure_password
```

### 2. Configurar Seguridad JWT

Establecer variables de entorno:

```bash
export JWT_SECRET=your-secret-key-min-256-bits
export JWT_EXPIRATION=86400000
```

### 3. Compilar y Ejecutar

```bash
# Entrar al directorio del componente
cd vucem-<nombre-componente>

# Compilar
mvn clean install

# Ejecutar en modo local
mvn spring-boot:run -Dspring-boot.run.profiles=local

# O con Docker
docker build -t vucem/<nombre-componente> .
docker run -p 8080:8080 vucem/<nombre-componente>
```

## 🧪 Testing

```bash
# Ejecutar todos los tests
mvn test

# Tests con cobertura
mvn clean test jacoco:report

# Ver reporte de cobertura
open target/site/jacoco/index.html
```

## 📊 Endpoints Disponibles

Una vez ejecutado, el componente expone:

- **Swagger UI**: http://localhost:8080/swagger-ui.html
- **OpenAPI Spec**: http://localhost:8080/v3/api-docs
- **Health Check**: http://localhost:8080/actuator/health
- **Metrics**: http://localhost:8080/actuator/metrics

### API REST de Ejemplo

```bash
# Health check
curl http://localhost:8080/actuator/health

# Listar recursos
curl http://localhost:8080/api/recursos

# Crear recurso
curl -X POST http://localhost:8080/api/recursos \
  -H "Content-Type: application/json" \
  -d '{"nombre":"Recurso 1","descripcion":"Descripción"}'
```

## 🔧 Personalización

### Cambiar Puerto

En `application.yml`:
```yaml
server:
  port: 8081
```

O por variable de entorno:
```bash
export SERVER_PORT=8081
```

### Deshabilitar Características

Si no necesitas alguna característica:

1. **Sin Docker**: Eliminar `Dockerfile` y archivos en `infrastructure/docker/`
2. **Sin Seguridad**: Eliminar paquete `infrastructure/security/` y `JwtAuthenticationFilter`
3. **Sin Swagger**: Eliminar `OpenApiConfig.java`

## 🚨 Solución de Problemas

### Error: Java 21 requerido

Si tienes Java 17 o anterior, edita `pom.xml`:

```xml
<properties>
    <java.version>17</java.version>
</properties>
```

### Error: Puerto en uso

Cambiar el puerto en `application.yml` o usar variable de entorno:

```bash
SERVER_PORT=8081 mvn spring-boot:run
```

### Error: Base de datos no disponible

Para desarrollo rápido, usar H2 en memoria editando `application.yml`:

```yaml
spring:
  datasource:
    url: jdbc:h2:mem:testdb
    driver-class-name: org.h2.Driver
  h2:
    console:
      enabled: true
```

## 📝 Checklist de Validación

El script `validar-componente.sh` verifica:

- ✅ Estructura de directorios correcta
- ✅ Arquitectura modular (domain, application, infrastructure, interfaces)
- ✅ Archivos de configuración presentes
- ✅ DevSecOps pipelines configurados
- ✅ Documentación completa
- ✅ Compilación exitosa

## 🎯 Mejores Prácticas

1. **Mantener la arquitectura limpia**: No crear dependencias circulares entre capas
2. **Tests primero**: Escribir tests unitarios para la lógica de negocio
3. **Documentar APIs**: Usar anotaciones Swagger/OpenAPI
4. **Seguridad**: Nunca commitear secretos o credenciales
5. **Versionado**: Usar versionado semántico (MAJOR.MINOR.PATCH)

## 📚 Recursos Adicionales

- [Documentación de Arquitectura](docs/arquitectura/ArquitecturaDeSoftware.md)
- [Guía de Desarrollo](docs/manual/guia-desarrollo.md)
- [Pipeline DevOps](docs/compliance/devops-pipeline.md)
- [Políticas de Seguridad](SECURITY.md)

## 💡 Tips

- Usa el perfil `local` para desarrollo con base de datos H2
- Revisa los logs en `target/logs/` para debugging
- Ejecuta `mvn dependency:tree` para ver todas las dependencias
- Usa `mvn versions:display-dependency-updates` para ver actualizaciones disponibles

---

**Última actualización**: Agosto 2024
**Versión de plantilla**: 1.0.0