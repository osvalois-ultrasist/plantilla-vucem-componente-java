#!/bin/bash

#############################################################################
# generar-componente.sh - Generador de Componentes VUCEM
# 
# Descripción: Script para generar componentes modulares basados en la
#              arquitectura VUCEM con Clean Architecture y DevSecOps
#
# Uso: ./generar-componente.sh <nombre> <area> [descripción]
# 
# Autor: VUCEM Team
# Versión: 2.0.0
# Fecha: 2025-08-22
#############################################################################

set -euo pipefail  # Modo estricto: salir en error, variables no definidas, y pipes fallidos
IFS=$'\n\t'        # Separador de campos seguro

# ===========================================================================
# CONFIGURACIÓN Y CONSTANTES
# ===========================================================================

readonly SCRIPT_VERSION="2.0.0"
readonly SCRIPT_NAME=$(basename "$0")
readonly SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly TEMPLATE_DIR="${SCRIPT_DIR}"
readonly TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
readonly DATE=$(date +"%Y-%m-%d")

# Colores (solo si hay terminal)
if [[ -t 1 ]]; then
    readonly RED='\033[0;31m'
    readonly GREEN='\033[0;32m'
    readonly YELLOW='\033[1;33m'
    readonly BLUE='\033[0;34m'
    readonly MAGENTA='\033[0;35m'
    readonly CYAN='\033[0;36m'
    readonly BOLD='\033[1m'
    readonly NC='\033[0m'
else
    readonly RED=''
    readonly GREEN=''
    readonly YELLOW=''
    readonly BLUE=''
    readonly MAGENTA=''
    readonly CYAN=''
    readonly BOLD=''
    readonly NC=''
fi

# ===========================================================================
# FUNCIONES DE UTILIDAD
# ===========================================================================

# Imprimir mensaje con formato
log() {
    local level="$1"
    shift
    local message="$*"
    
    case "$level" in
        INFO)    echo -e "${BLUE}[INFO]${NC} ${message}" ;;
        SUCCESS) echo -e "${GREEN}[✓]${NC} ${message}" ;;
        WARNING) echo -e "${YELLOW}[⚠]${NC} ${message}" ;;
        ERROR)   echo -e "${RED}[✗]${NC} ${message}" >&2 ;;
        STEP)    echo -e "${CYAN}➜${NC} ${message}" ;;
        *)       echo "${message}" ;;
    esac
}

# Mostrar encabezado
show_header() {
    echo -e "${BOLD}${BLUE}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║          GENERADOR DE COMPONENTES VUCEM v${SCRIPT_VERSION}           ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Mostrar ayuda
show_help() {
    show_header
    cat << EOF
${BOLD}USO:${NC}
    ${SCRIPT_NAME} <nombre-componente> <area-funcional> [descripción]

${BOLD}DESCRIPCIÓN:${NC}
    Genera un componente VUCEM con arquitectura modular, configuración
    DevSecOps, y mejores prácticas de desarrollo.

${BOLD}ARGUMENTOS:${NC}
    nombre-componente  Nombre del componente (ej: sistema-aduanas)
                      - Solo letras minúsculas, números y guiones
                      - Debe iniciar con letra
                      - Longitud: 3-50 caracteres
    
    area-funcional    Área funcional del componente (ej: aduanas)
                      - Solo letras minúsculas, números y guiones
                      - Longitud: 2-30 caracteres
    
    descripción       (Opcional) Descripción del componente
                      - Si contiene espacios, usar comillas

${BOLD}EJEMPLOS:${NC}
    ${SCRIPT_NAME} sistema-aduanas aduanas
    ${SCRIPT_NAME} gestion-permisos importacion "Sistema de gestión de permisos"
    ${SCRIPT_NAME} validador-xml exportacion "Validador de documentos XML"

${BOLD}ESTRUCTURA GENERADA:${NC}
    vucem-<nombre>/
    ├── src/main/java/       # Código fuente (4 capas)
    ├── src/test/            # Pruebas unitarias
    ├── .github/workflows/   # CI/CD pipelines
    ├── docs/                # Documentación
    ├── infrastructure/      # IaC y configuración
    └── pom.xml             # Configuración Maven

${BOLD}MÁS INFORMACIÓN:${NC}
    Documentación: docs/README.md
    Reportar bugs: https://github.com/vucem/template-vucem-componente/issues

EOF
}

# Validar nombre de componente
validate_component_name() {
    local name="$1"
    
    # Verificar longitud
    if [[ ${#name} -lt 3 ]] || [[ ${#name} -gt 50 ]]; then
        log ERROR "El nombre debe tener entre 3 y 50 caracteres"
        return 1
    fi
    
    # Verificar formato (solo minúsculas, números y guiones)
    if ! [[ "$name" =~ ^[a-z][a-z0-9-]*$ ]]; then
        log ERROR "El nombre debe contener solo letras minúsculas, números y guiones"
        log ERROR "Debe comenzar con una letra"
        return 1
    fi
    
    # Evitar dobles guiones
    if [[ "$name" == *"--"* ]]; then
        log ERROR "El nombre no puede contener guiones dobles (--)"
        return 1
    fi
    
    return 0
}

# Validar área funcional
validate_area() {
    local area="$1"
    
    # Verificar longitud
    if [[ ${#area} -lt 2 ]] || [[ ${#area} -gt 30 ]]; then
        log ERROR "El área debe tener entre 2 y 30 caracteres"
        return 1
    fi
    
    # Verificar formato
    if ! [[ "$area" =~ ^[a-z][a-z0-9-]*$ ]]; then
        log ERROR "El área debe contener solo letras minúsculas, números y guiones"
        return 1
    fi
    
    return 0
}

# Limpiar al salir
cleanup() {
    local exit_code=$?
    
    if [[ $exit_code -ne 0 ]]; then
        log WARNING "El proceso fue interrumpido o falló"
        
        # Si existe el directorio temporal y está incompleto, preguntar si eliminarlo
        if [[ -d "${TARGET_DIR:-}" ]] && [[ ! -f "$TARGET_DIR/.generation_complete" ]]; then
            read -p "¿Desea eliminar el directorio parcialmente creado? (s/n): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Ss]$ ]]; then
                rm -rf "$TARGET_DIR"
                log INFO "Directorio eliminado"
            fi
        fi
    fi
    
    exit $exit_code
}

# Configurar manejo de señales
trap cleanup EXIT INT TERM

# ===========================================================================
# FUNCIONES DE GENERACIÓN
# ===========================================================================

# Función segura para reemplazar placeholders
safe_replace() {
    local file="$1"
    local pattern="$2"
    local replacement="$3"
    
    # Escapar caracteres especiales en el reemplazo
    local safe_replacement=$(printf '%s\n' "$replacement" | sed 's/[[\.*^$()+?{|]/\\&/g')
    
    # Detectar el sistema operativo para sed
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/${pattern}/${safe_replacement}/g" "$file" 2>/dev/null || true
    else
        # Linux
        sed -i "s/${pattern}/${safe_replacement}/g" "$file" 2>/dev/null || true
    fi
}

# Procesar un archivo con todos los reemplazos
process_file() {
    local file="$1"
    
    # Solo procesar archivos de texto
    if file -b "$file" 2>/dev/null | grep -q text || [[ "$file" == *.* ]]; then
        safe_replace "$file" "COMPONENTE_NOMBRE" "$NOMBRE_COMPONENTE"
        safe_replace "$file" "COMPONENTE_AREA" "$AREA_FUNCIONAL"
        safe_replace "$file" "COMPONENTE_DESCRIPCION" "$DESCRIPCION"
        safe_replace "$file" "FECHA_GENERACION" "$DATE"
        safe_replace "$file" "vucem-componente" "vucem-$NOMBRE_COMPONENTE"
        safe_replace "$file" "\${COMPONENTE_NOMBRE:vucem-componente}" "vucem-$NOMBRE_COMPONENTE"
        safe_replace "$file" "\${COMPONENTE_DESCRIPCION}" "$DESCRIPCION"
        safe_replace "$file" "\${COMPONENTE_AREA}" "$AREA_FUNCIONAL"
    fi
}

# Copiar y limpiar template
copy_template() {
    log STEP "Copiando plantilla base..."
    
    # Copiar todo excepto archivos git y temporales
    rsync -av --exclude='.git' \
              --exclude='*.sh' \
              --exclude='{{cookiecutter.project_slug}}' \
              --exclude='hooks' \
              --exclude='cookiecutter.json' \
              --exclude='*.pyc' \
              --exclude='__pycache__' \
              --exclude='.DS_Store' \
              --exclude='*.swp' \
              --exclude='*.tmp' \
              "$TEMPLATE_DIR/" "$TARGET_DIR/" > /dev/null 2>&1
    
    log SUCCESS "Plantilla copiada"
}

# Personalizar archivos
customize_files() {
    log STEP "Personalizando archivos..."
    
    # Contador de archivos procesados
    local count=0
    
    # Procesar archivos relevantes
    while IFS= read -r -d '' file; do
        process_file "$file"
        ((count++))
    done < <(find "$TARGET_DIR" -type f \( \
        -name "*.java" -o \
        -name "*.xml" -o \
        -name "*.yml" -o \
        -name "*.yaml" -o \
        -name "*.properties" -o \
        -name "*.md" -o \
        -name "*.txt" -o \
        -name "*.sql" -o \
        -name "Dockerfile" -o \
        -name "*.json" \
    \) -print0)
    
    log SUCCESS "Personalizados $count archivos"
}

# Actualizar POM
update_pom() {
    log STEP "Configurando Maven POM..."
    
    local pom_file="$TARGET_DIR/pom.xml"
    
    if [[ -f "$pom_file" ]]; then
        # Corregir artifact y name
        safe_replace "$pom_file" "<artifactId>vucem-componente</artifactId>" "<artifactId>vucem-$NOMBRE_COMPONENTE</artifactId>"
        safe_replace "$pom_file" "<artifactId>vucem-</artifactId>" "<artifactId>vucem-$NOMBRE_COMPONENTE</artifactId>"
        safe_replace "$pom_file" "<name>vucem-componente</name>" "<name>vucem-$NOMBRE_COMPONENTE</name>"
        safe_replace "$pom_file" "<name>vucem-</name>" "<name>vucem-$NOMBRE_COMPONENTE</name>"
        safe_replace "$pom_file" "<description>.*</description>" "<description>$DESCRIPCION</description>"
        
        log SUCCESS "POM configurado"
    else
        log WARNING "No se encontró pom.xml"
    fi
}

# Actualizar configuración Spring
update_spring_config() {
    log STEP "Configurando Spring Boot..."
    
    local config_file="$TARGET_DIR/src/main/resources/application.yml"
    
    if [[ -f "$config_file" ]]; then
        # Corregir nombre de aplicación
        safe_replace "$config_file" "name: \${COMPONENTE_NOMBRE:vucem-componente}" "name: vucem-$NOMBRE_COMPONENTE"
        safe_replace "$config_file" "name: \${:vucem-}" "name: vucem-$NOMBRE_COMPONENTE"
        safe_replace "$config_file" "name: vucem-componente" "name: vucem-$NOMBRE_COMPONENTE"
        
        # Corregir puerto
        safe_replace "$config_file" "port: \${JWT_EXPIRACION:8090}" "port: \${SERVER_PORT:8080}"
        
        log SUCCESS "Configuración Spring actualizada"
    else
        log WARNING "No se encontró application.yml"
    fi
}

# Reorganizar estructura Java
reorganize_java_packages() {
    log STEP "Reorganizando paquetes Java..."
    
    local NOMBRE_PAQUETE=$(echo "$NOMBRE_COMPONENTE" | tr '-' '_')
    local OLD_PACKAGE="componente"
    local BASE_PATH="mx/gob/vucem"
    
    # Procesar src/main/java
    if [[ -d "$TARGET_DIR/src/main/java/$BASE_PATH/$OLD_PACKAGE" ]]; then
        mv "$TARGET_DIR/src/main/java/$BASE_PATH/$OLD_PACKAGE" \
           "$TARGET_DIR/src/main/java/$BASE_PATH/$NOMBRE_PAQUETE" 2>/dev/null || true
        
        # Actualizar referencias en archivos Java
        find "$TARGET_DIR/src/main/java" -name "*.java" -exec \
            sed -i.bak "s|package $BASE_PATH\.$OLD_PACKAGE|package $BASE_PATH.$NOMBRE_PAQUETE|g; \
                       s|import $BASE_PATH\.$OLD_PACKAGE|import $BASE_PATH.$NOMBRE_PAQUETE|g" {} \;
        
        # Eliminar backups
        find "$TARGET_DIR" -name "*.bak" -delete
    fi
    
    # Procesar src/test/java
    if [[ -d "$TARGET_DIR/src/test/java/$BASE_PATH/$OLD_PACKAGE" ]]; then
        mv "$TARGET_DIR/src/test/java/$BASE_PATH/$OLD_PACKAGE" \
           "$TARGET_DIR/src/test/java/$BASE_PATH/$NOMBRE_PAQUETE" 2>/dev/null || true
        
        # Actualizar referencias
        find "$TARGET_DIR/src/test/java" -name "*.java" -exec \
            sed -i.bak "s|package $BASE_PATH\.$OLD_PACKAGE|package $BASE_PATH.$NOMBRE_PAQUETE|g; \
                       s|import $BASE_PATH\.$OLD_PACKAGE|import $BASE_PATH.$NOMBRE_PAQUETE|g" {} \;
        
        # Eliminar backups
        find "$TARGET_DIR" -name "*.bak" -delete
    fi
    
    # Renombrar clase principal
    local MAIN_CLASS="$TARGET_DIR/src/main/java/$BASE_PATH/$NOMBRE_PAQUETE/VucemComponenteApplication.java"
    if [[ -f "$MAIN_CLASS" ]]; then
        local NEW_CLASS_NAME="Vucem$(echo $NOMBRE_COMPONENTE | sed 's/-//g' | sed 's/\b\(.\)/\u\1/g')Application"
        local NEW_FILE="$TARGET_DIR/src/main/java/$BASE_PATH/$NOMBRE_PAQUETE/${NEW_CLASS_NAME}.java"
        
        mv "$MAIN_CLASS" "$NEW_FILE" 2>/dev/null || true
        safe_replace "$NEW_FILE" "VucemComponenteApplication" "$NEW_CLASS_NAME"
    fi
    
    log SUCCESS "Paquetes Java reorganizados"
}

# Generar README personalizado
generate_readme() {
    log STEP "Generando documentación..."
    
    cat > "$TARGET_DIR/README.md" << EOF
# VUCEM - ${NOMBRE_COMPONENTE}

${DESCRIPCION}

## 📋 Información del Componente

| Campo | Valor |
|-------|-------|
| **Componente** | ${NOMBRE_COMPONENTE} |
| **Área Funcional** | ${AREA_FUNCIONAL} |
| **Versión** | 0.1.0-SNAPSHOT |
| **Fecha de Creación** | ${DATE} |
| **Generado con** | Template VUCEM v${SCRIPT_VERSION} |

## 🏗️ Arquitectura

Implementación de Clean Architecture con las siguientes capas:

\`\`\`
src/main/java/mx/gob/vucem/${NOMBRE_PAQUETE}/
├── domain/              # Lógica de negocio pura
│   ├── entities/        # Entidades del dominio
│   ├── repositories/    # Interfaces de repositorio
│   ├── services/        # Servicios de dominio
│   └── valueobjects/    # Objetos de valor
├── application/         # Casos de uso
│   ├── dtos/           # Data Transfer Objects
│   ├── mappers/        # Mapeadores DTO ⟷ Entity
│   └── services/       # Servicios de aplicación
├── infrastructure/      # Detalles de implementación
│   ├── config/         # Configuraciones técnicas
│   ├── persistence/    # JPA/Hibernate
│   └── security/       # Implementación de seguridad
└── interfaces/          # Puntos de entrada
    ├── api/            # REST Controllers
    └── events/         # Mensajería y eventos
\`\`\`

## 🚀 Inicio Rápido

### Prerequisitos

- Java 21+
- Maven 3.8+
- PostgreSQL 14+ (producción)
- Docker (opcional)

### Instalación

\`\`\`bash
# Clonar repositorio
git clone https://github.com/vucem/vucem-${NOMBRE_COMPONENTE}.git
cd vucem-${NOMBRE_COMPONENTE}

# Compilar
mvn clean install

# Ejecutar
mvn spring-boot:run -Dspring-boot.run.profiles=local
\`\`\`

### Docker

\`\`\`bash
# Construir imagen
docker build -t vucem/${NOMBRE_COMPONENTE}:latest .

# Ejecutar contenedor
docker run -d \\
  --name vucem-${NOMBRE_COMPONENTE} \\
  -p 8080:8080 \\
  -e SPRING_PROFILES_ACTIVE=docker \\
  vucem/${NOMBRE_COMPONENTE}:latest
\`\`\`

## 🔧 Configuración

### Variables de Entorno

| Variable | Descripción | Valor por Defecto |
|----------|-------------|-------------------|
| \`SERVER_PORT\` | Puerto del servidor | 8080 |
| \`DB_HOST\` | Host de base de datos | localhost |
| \`DB_PORT\` | Puerto de base de datos | 5432 |
| \`DB_NAME\` | Nombre de base de datos | vucem_db |
| \`DB_USER\` | Usuario de base de datos | vucem |
| \`DB_PASSWORD\` | Contraseña de base de datos | - |
| \`JWT_SECRET\` | Clave secreta JWT | - |
| \`JWT_EXPIRATION\` | Tiempo de expiración JWT (ms) | 86400000 |

## 📚 API Documentation

Con la aplicación ejecutándose:

- **Swagger UI**: http://localhost:8080/swagger-ui.html
- **OpenAPI Spec**: http://localhost:8080/v3/api-docs
- **Health Check**: http://localhost:8080/actuator/health

## 🧪 Testing

\`\`\`bash
# Ejecutar todos los tests
mvn test

# Tests con cobertura
mvn clean test jacoco:report

# Ver reporte
open target/site/jacoco/index.html
\`\`\`

## 📊 Métricas y Monitoreo

- **Prometheus**: http://localhost:8080/actuator/prometheus
- **Health**: http://localhost:8080/actuator/health
- **Metrics**: http://localhost:8080/actuator/metrics
- **Info**: http://localhost:8080/actuator/info

## 🔒 Seguridad

Este componente implementa:

- ✅ Autenticación JWT
- ✅ Spring Security
- ✅ CORS configurado
- ✅ Rate limiting
- ✅ Validación de entrada
- ✅ Auditoría de accesos

## 📝 Licencia

Gobierno de México - Todos los derechos reservados

## 📧 Contacto

- **Equipo**: VUCEM - ${AREA_FUNCIONAL}
- **Email**: vucem@economia.gob.mx
- **Issues**: [GitHub Issues](https://github.com/vucem/vucem-${NOMBRE_COMPONENTE}/issues)

---

*Generado automáticamente el ${TIMESTAMP}*
EOF

    log SUCCESS "README generado"
}

# Inicializar Git
initialize_git() {
    log STEP "Inicializando repositorio Git..."
    
    cd "$TARGET_DIR"
    
    # Inicializar repo
    git init --initial-branch=main > /dev/null 2>&1 || git init > /dev/null 2>&1
    
    # Configurar git localmente (sin afectar config global)
    git config user.name "VUCEM Generator" 2>/dev/null || true
    git config user.email "generator@vucem.gob.mx" 2>/dev/null || true
    
    # Agregar archivos
    git add -A > /dev/null 2>&1
    
    # Commit inicial
    git commit -m "feat: Generación inicial del componente $NOMBRE_COMPONENTE

- Área funcional: $AREA_FUNCIONAL
- Descripción: $DESCRIPCION
- Arquitectura: Clean Architecture (4 capas)
- DevSecOps: CI/CD configurado
- Generado con: Template VUCEM v${SCRIPT_VERSION}

[skip ci]" > /dev/null 2>&1
    
    log SUCCESS "Repositorio Git inicializado"
}

# ===========================================================================
# PROGRAMA PRINCIPAL
# ===========================================================================

main() {
    # Verificar argumentos
    if [[ $# -lt 2 ]]; then
        show_help
        exit 1
    fi
    
    # Procesar argumentos
    NOMBRE_COMPONENTE="$1"
    AREA_FUNCIONAL="$2"
    DESCRIPCION="${3:-Componente de VUCEM para $AREA_FUNCIONAL}"
    NOMBRE_PAQUETE=$(echo "$NOMBRE_COMPONENTE" | tr '-' '_')
    TARGET_DIR="$(pwd)/vucem-$NOMBRE_COMPONENTE"
    
    # Mostrar encabezado
    show_header
    
    # Validaciones
    log INFO "Validando parámetros..."
    
    if ! validate_component_name "$NOMBRE_COMPONENTE"; then
        exit 1
    fi
    
    if ! validate_area "$AREA_FUNCIONAL"; then
        exit 1
    fi
    
    # Verificar si el directorio ya existe
    if [[ -d "$TARGET_DIR" ]]; then
        log ERROR "El directorio $TARGET_DIR ya existe"
        read -p "¿Desea sobrescribirlo? (s/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Ss]$ ]]; then
            log INFO "Operación cancelada"
            exit 0
        fi
        rm -rf "$TARGET_DIR"
    fi
    
    # Mostrar configuración
    echo -e "${BOLD}Configuración:${NC}"
    echo -e "  ${CYAN}Componente:${NC} $NOMBRE_COMPONENTE"
    echo -e "  ${CYAN}Área:${NC} $AREA_FUNCIONAL"
    echo -e "  ${CYAN}Descripción:${NC} $DESCRIPCION"
    echo -e "  ${CYAN}Directorio:${NC} $TARGET_DIR"
    echo
    
    # Confirmar
    read -p "¿Desea continuar? (s/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        log INFO "Operación cancelada"
        exit 0
    fi
    
    echo
    log INFO "Iniciando generación..."
    
    # Ejecutar pasos de generación
    copy_template
    customize_files
    update_pom
    update_spring_config
    reorganize_java_packages
    generate_readme
    initialize_git
    
    # Marcar como completo
    touch "$TARGET_DIR/.generation_complete"
    
    # Resumen final
    echo
    echo -e "${BOLD}${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${GREEN}║         ✅ COMPONENTE GENERADO EXITOSAMENTE             ║${NC}"
    echo -e "${BOLD}${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo
    echo -e "${BOLD}Próximos pasos:${NC}"
    echo -e "  1. ${CYAN}cd $TARGET_DIR${NC}"
    echo -e "  2. ${CYAN}mvn clean install${NC}"
    echo -e "  3. ${CYAN}mvn spring-boot:run${NC}"
    echo
    echo -e "${BOLD}Documentación:${NC}"
    echo -e "  📖 README.md en el directorio del componente"
    echo -e "  📊 Swagger UI disponible en http://localhost:8080/swagger-ui.html"
    echo
    
    log SUCCESS "Proceso completado en $(pwd)/vucem-$NOMBRE_COMPONENTE"
}

# Ejecutar programa principal
main "$@"