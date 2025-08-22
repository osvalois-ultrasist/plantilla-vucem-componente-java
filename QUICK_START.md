# ⚡ Quick Start - Plantilla VUCEM

## 🚀 Instalación Ultra Rápida (30 segundos)

### 1. Crear Componente Directamente

```bash
curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/crear-componente-remoto.sh | bash -s sistema-aduanas aduanas
```

### 2. Compilar y Ejecutar

```bash
cd vucem-sistema-aduanas
mvn clean install
mvn spring-boot:run
```

### 3. Acceder a la Aplicación

- **Swagger UI**: http://localhost:8080/swagger-ui.html
- **Health Check**: http://localhost:8080/actuator/health

## 📋 Comandos Esenciales

### Verificar Requisitos
```bash
curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/verificar-requisitos.sh | bash
```

### Crear Componente con Descripción
```bash
curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/crear-componente-remoto.sh | bash -s \
  validador-xml exportacion "Validador de documentos XML para exportaciones"
```

### Validar Componente
```bash
curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/validar-componente.sh | bash -s vucem-mi-componente
```

## 🛠️ Scripts Disponibles

| Acción | Comando |
|--------|---------|
| **Crear componente** | `curl -sSL https://raw.githubusercontent.com/.../crear-componente-remoto.sh \| bash -s nombre area` |
| **Verificar sistema** | `curl -sSL https://raw.githubusercontent.com/.../verificar-requisitos.sh \| bash` |
| **Validar componente** | `curl -sSL https://raw.githubusercontent.com/.../validar-componente.sh \| bash -s directorio` |

## 📖 Documentación Completa

- **[Uso Remoto Completo](USO_REMOTO.md)** - Todas las opciones disponibles
- **[Instrucciones Detalladas](INSTRUCCIONES_USO.md)** - Guía paso a paso
- **[Scripts](README_SCRIPTS.md)** - Documentación técnica de scripts

## 🎯 Ejemplos Rápidos

### Para Diferentes Áreas
```bash
# Sistema de aduanas
curl -sSL ... | bash -s sistema-aduanas aduanas

# Gestión de usuarios  
curl -sSL ... | bash -s gestion-usuarios usuarios

# Validador de documentos
curl -sSL ... | bash -s validador-docs documentos
```

### Setup Completo
```bash
# 1. Verificar sistema e instalar dependencias
curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/verificar-requisitos.sh | bash -s --install

# 2. Crear proyecto
curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/crear-componente-remoto.sh | bash -s mi-proyecto comercio

# 3. Desarrollar
cd vucem-mi-proyecto
mvn spring-boot:run
```

## ✨ Características Incluidas

- ✅ **Clean Architecture** (4 capas)
- ✅ **Spring Boot 3.2** + Java 21
- ✅ **Spring Security** + JWT
- ✅ **OpenAPI/Swagger** integrado
- ✅ **Tests** unitarios y de integración
- ✅ **Docker** ready
- ✅ **CI/CD** GitHub Actions
- ✅ **DevSecOps** configurado

## 🆘 ¿Problemas?

### Error común: Java version
```bash
# Si tienes Java < 21, instalar:
curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/verificar-requisitos.sh | bash -s --install
```

### Error común: Maven no encontrado
```bash
# Instalar Maven automáticamente:
curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/verificar-requisitos.sh | bash -s --install
```

## 🔗 Enlaces Rápidos

- [Repositorio](https://github.com/osvalois-ultrasist/template-vucem-componente)
- [Issues/Soporte](https://github.com/osvalois-ultrasist/template-vucem-componente/issues)
- [Documentación Técnica](docs/)

---

**¡Listo para crear tu primer componente VUCEM en menos de un minuto!** 🚀