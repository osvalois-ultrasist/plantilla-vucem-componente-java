# 🌐 Uso Remoto de la Plantilla VUCEM

Esta guía muestra todas las formas de usar la plantilla VUCEM directamente desde GitHub sin necesidad de clonar el repositorio.

## 🚀 One-Liners (Recomendado)

### Instalación Ultra Rápida

```bash
# Crear componente directamente desde GitHub
curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/crear-componente-remoto.sh | bash -s sistema-aduanas aduanas

# Con descripción personalizada
curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/crear-componente-remoto.sh | bash -s \
  validador-xml exportacion "Validador de documentos XML para exportaciones"
```

### Verificar Requisitos Primero

```bash
# Verificar que el sistema tiene todas las dependencias
curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/verificar-requisitos.sh | bash

# Instalar dependencias faltantes automáticamente
curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/verificar-requisitos.sh | bash -s --install
```

## 📦 Métodos de Instalación

### Método 1: Descarga y Ejecución Directa (Ultra Rápido)

```bash
# Una sola línea - crea el componente inmediatamente
curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/crear-componente-remoto.sh | bash -s mi-componente area-funcional "Mi descripción"
```

**Ventajas:**
- ✅ Instalación instantánea
- ✅ Siempre usa la versión más reciente
- ✅ No ocupa espacio en disco
- ✅ Perfecto para CI/CD

### Método 2: Descarga de Scripts Individuales

```bash
# Descargar script generador
curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/crear-componente-remoto.sh -o crear-componente.sh
chmod +x crear-componente.sh

# Usar localmente
./crear-componente.sh sistema-aduanas aduanas "Sistema de gestión aduanera"

# Descargar validador
curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/validar-componente.sh -o validar-componente.sh
chmod +x validar-componente.sh
```

### Método 3: Descarga de Plantilla Completa

```bash
# Descargar plantilla como ZIP
curl -sSL https://github.com/osvalois-ultrasist/template-vucem-componente/archive/refs/heads/main.zip -o vucem-template.zip
unzip vucem-template.zip
cd template-vucem-componente-main

# Usar scripts locales
./generar-componente.sh mi-componente area-funcional
```

### Método 4: Git Clone (Tradicional)

```bash
# Clonar repositorio completo
git clone https://github.com/osvalois-ultrasist/template-vucem-componente.git
cd template-vucem-componente

# Usar scripts
./generar-componente.sh mi-componente area-funcional
```

## 🛠️ URLs Directas de Scripts

| Script | URL Raw | Propósito |
|--------|---------|-----------|
| **Generador Remoto** | `https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/crear-componente-remoto.sh` | Crear componentes desde GitHub |
| **Generador Local** | `https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/generar-componente.sh` | Usar plantilla local |
| **Validador** | `https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/validar-componente.sh` | Validar componentes |
| **Verificador** | `https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/verificar-requisitos.sh` | Verificar dependencias |

## 🔧 Configuración para Tu Repositorio

Si forkeas la plantilla, actualiza las URLs en `crear-componente-remoto.sh`:

```bash
# Cambiar estas variables:
readonly GITHUB_USER="tu-usuario"
readonly GITHUB_REPO="tu-repo-template"
readonly GITHUB_BRANCH="main"  # o tu rama principal
```

## 📋 Casos de Uso Específicos

### Para Desarrolladores Individuales

```bash
# Setup completo en una línea
curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/verificar-requisitos.sh | bash && \
curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/crear-componente-remoto.sh | bash -s mi-proyecto comercio-exterior
```

### Para CI/CD Pipelines

```yaml
# GitHub Actions example
- name: Generate VUCEM Component
  run: |
    curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/crear-componente-remoto.sh | \
    bash -s ${{ github.event.inputs.component_name }} ${{ github.event.inputs.area }} "${{ github.event.inputs.description }}"
```

### Para Scripts de Automatización

```bash
#!/bin/bash
# Script para crear múltiples componentes

COMPONENTS=(
  "gestion-usuarios:usuarios:Sistema de gestión de usuarios"
  "validador-docs:documentos:Validador de documentos"
  "notificaciones:comunicacion:Sistema de notificaciones"
)

for component in "${COMPONENTS[@]}"; do
  IFS=':' read -r name area desc <<< "$component"
  curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/crear-componente-remoto.sh | \
  bash -s "$name" "$area" "$desc"
done
```

### Para Entornos Dockerizados

```dockerfile
# Dockerfile para generar componentes
FROM openjdk:21-slim

RUN apt-get update && apt-get install -y curl tar

# Generar componente durante build
RUN curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/crear-componente-remoto.sh | \
    bash -s mi-componente area "Mi componente"

WORKDIR /vucem-mi-componente
```

## 🎯 Comandos de Uso Frecuente

### Setup Inicial de Proyecto

```bash
# 1. Verificar sistema
curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/verificar-requisitos.sh | bash

# 2. Crear componente
curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/crear-componente-remoto.sh | \
bash -s sistema-gestion usuarios "Sistema de gestión de usuarios"

# 3. Validar resultado
cd vucem-sistema-gestion
curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/validar-componente.sh | bash -s .
```

### Validación de Componentes Existentes

```bash
# Validar componente actual
curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/validar-componente.sh | bash -s .

# Validar otro directorio
curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/validar-componente.sh | bash -s ../otro-componente
```

## 🔒 Consideraciones de Seguridad

### Verificación de Integridad

```bash
# Verificar checksum del script (opcional)
curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/crear-componente-remoto.sh | sha256sum

# Descargar y revisar antes de ejecutar
curl -sSL https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/crear-componente-remoto.sh -o script.sh
cat script.sh  # Revisar contenido
bash script.sh mi-componente area
```

### Uso en Redes Corporativas

```bash
# Si tienes proxy corporativo
export https_proxy=http://proxy.empresa.com:8080
curl -sSL --proxy $https_proxy https://raw.githubusercontent.com/... | bash -s mi-componente area
```

## 📊 Comparación de Métodos

| Método | Velocidad | Espacio | Actualización | Uso Recomendado |
|--------|-----------|---------|---------------|-----------------|
| **One-liner** | ⚡ Ultra rápido | 💾 Cero | 🔄 Automática | Desarrollo diario |
| **Scripts individuales** | ⚡ Rápido | 💾 Mínimo | 🔄 Manual | Uso repetitivo |
| **Plantilla completa** | 🐌 Medio | 💾 Completo | 🔄 Manual | Desarrollo offline |
| **Git clone** | 🐌 Lento | 💾 Máximo | 🔄 git pull | Contribución |

## 🆘 Troubleshooting

### Error: "curl: command not found"

```bash
# Ubuntu/Debian
sudo apt-get install curl

# CentOS/RHEL
sudo yum install curl

# macOS
brew install curl
```

### Error: "Permission denied"

```bash
# Los scripts remotos no necesitan permisos chmod
# Si descargas localmente:
chmod +x script-descargado.sh
```

### Error: "Repository not found"

Verifica que las URLs estén correctas y el repositorio sea público:

```bash
# Probar acceso al repositorio
curl -sSL https://api.github.com/repos/osvalois-ultrasist/template-vucem-componente
```

## 📚 Recursos Adicionales

- **Repositorio**: https://github.com/osvalois-ultrasist/template-vucem-componente
- **Issues**: https://github.com/osvalois-ultrasist/template-vucem-componente/issues
- **Documentación**: https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/README.md
- **Changelog**: https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main/CHANGELOG.md

---

**¿Preguntas?** Abre un [issue en GitHub](https://github.com/osvalois-ultrasist/template-vucem-componente/issues) o contacta al equipo VUCEM.