#!/bin/bash

#############################################################################
# crear-componente-remoto.sh - Generador Remoto de Componentes VUCEM
# 
# Descripción: Descarga y ejecuta la plantilla VUCEM directamente desde GitHub
#              sin necesidad de clonar el repositorio completo
#
# Uso: ./crear-componente-remoto.sh <nombre> <area> [descripción]
#      O: curl -sSL <raw-url> | bash -s <nombre> <area> [descripción]
# 
# Autor: VUCEM Team
# Versión: 2.0.0
# Fecha: 2025-08-22
#############################################################################

set -euo pipefail
IFS=$'\n\t'

# ===========================================================================
# CONFIGURACIÓN
# ===========================================================================

readonly SCRIPT_VERSION="2.0.0"
readonly GITHUB_USER="osvalois-ultrasist"  # Cambiar por tu usuario
readonly GITHUB_REPO="template-vucem-componente"
readonly GITHUB_BRANCH="main"
readonly BASE_URL="https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/${GITHUB_BRANCH}"
readonly ARCHIVE_URL="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/archive/refs/heads/${GITHUB_BRANCH}.tar.gz"

# Colores
if [[ -t 1 ]]; then
    readonly RED='\033[0;31m'
    readonly GREEN='\033[0;32m'
    readonly YELLOW='\033[1;33m'
    readonly BLUE='\033[0;34m'
    readonly CYAN='\033[0;36m'
    readonly BOLD='\033[1m'
    readonly NC='\033[0m'
else
    readonly RED='' GREEN='' YELLOW='' BLUE='' CYAN='' BOLD='' NC=''
fi

# ===========================================================================
# FUNCIONES
# ===========================================================================

log() {
    local level="$1"
    shift
    case "$level" in
        INFO)    echo -e "${BLUE}[INFO]${NC} $*" ;;
        SUCCESS) echo -e "${GREEN}[✓]${NC} $*" ;;
        WARNING) echo -e "${YELLOW}[⚠]${NC} $*" ;;
        ERROR)   echo -e "${RED}[✗]${NC} $*" >&2 ;;
        STEP)    echo -e "${CYAN}➜${NC} $*" ;;
    esac
}

show_header() {
    echo -e "${BOLD}${BLUE}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║       GENERADOR REMOTO VUCEM v${SCRIPT_VERSION} (desde GitHub)      ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

show_help() {
    show_header
    cat << EOF
${BOLD}USO:${NC}
    ${0} <nombre-componente> <area-funcional> [descripción]

${BOLD}USO REMOTO (recomendado):${NC}
    # Instalación directa desde GitHub
    curl -sSL ${BASE_URL}/crear-componente-remoto.sh | bash -s sistema-aduanas aduanas

    # O con descripción personalizada
    curl -sSL ${BASE_URL}/crear-componente-remoto.sh | bash -s \\
        validador-xml exportacion "Validador de documentos XML"

${BOLD}INSTALACIÓN LOCAL:${NC}
    # Descargar script y usar localmente
    curl -sSL ${BASE_URL}/crear-componente-remoto.sh -o crear-componente.sh
    chmod +x crear-componente.sh
    ./crear-componente.sh mi-componente area-funcional

${BOLD}DESCRIPCIÓN:${NC}
    Este script descarga automáticamente la plantilla VUCEM más reciente
    desde GitHub y genera un componente con arquitectura modular.

${BOLD}REQUISITOS:${NC}
    - curl o wget instalado
    - tar (para extraer archivos)
    - Java 21+ y Maven 3.8+ (para compilar)

${BOLD}EJEMPLOS:${NC}
    # Uso directo desde terminal
    curl -sSL ${BASE_URL}/crear-componente-remoto.sh | bash -s \\
        gestion-permisos importacion "Sistema de gestión de permisos"

    # Verificar requisitos primero
    curl -sSL ${BASE_URL}/verificar-requisitos.sh | bash

${BOLD}MÁS INFORMACIÓN:${NC}
    Repositorio: https://github.com/${GITHUB_USER}/${GITHUB_REPO}
    Documentación: ${BASE_URL}/README.md

EOF
}

# Verificar herramientas necesarias
check_dependencies() {
    local missing=()
    
    if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
        missing+=("curl o wget")
    fi
    
    if ! command -v tar &> /dev/null; then
        missing+=("tar")
    fi
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log ERROR "Herramientas faltantes: ${missing[*]}"
        log ERROR "Por favor instale las herramientas requeridas"
        return 1
    fi
    
    return 0
}

# Función para descargar archivos
download_file() {
    local url="$1"
    local output="$2"
    
    if command -v curl &> /dev/null; then
        curl -sSL "$url" -o "$output"
    elif command -v wget &> /dev/null; then
        wget -q "$url" -O "$output"
    else
        log ERROR "curl o wget requerido para descargar archivos"
        return 1
    fi
}

# Validar entrada (copiado del script principal)
validate_component_name() {
    local name="$1"
    
    if [[ ${#name} -lt 3 ]] || [[ ${#name} -gt 50 ]]; then
        log ERROR "El nombre debe tener entre 3 y 50 caracteres"
        return 1
    fi
    
    if ! [[ "$name" =~ ^[a-z][a-z0-9-]*$ ]]; then
        log ERROR "El nombre debe contener solo letras minúsculas, números y guiones"
        return 1
    fi
    
    if [[ "$name" == *"--"* ]]; then
        log ERROR "El nombre no puede contener guiones dobles (--)"
        return 1
    fi
    
    return 0
}

validate_area() {
    local area="$1"
    
    if [[ ${#area} -lt 2 ]] || [[ ${#area} -gt 30 ]]; then
        log ERROR "El área debe tener entre 2 y 30 caracteres"
        return 1
    fi
    
    if ! [[ "$area" =~ ^[a-z][a-z0-9-]*$ ]]; then
        log ERROR "El área debe contener solo letras minúsculas, números y guiones"
        return 1
    fi
    
    return 0
}

# Descargar plantilla desde GitHub
download_template() {
    local temp_dir="$1"
    
    log STEP "Descargando plantilla desde GitHub..."
    
    # Crear directorio temporal
    mkdir -p "$temp_dir"
    
    # Descargar archivo tar.gz
    local archive_file="$temp_dir/template.tar.gz"
    if ! download_file "$ARCHIVE_URL" "$archive_file"; then
        log ERROR "No se pudo descargar la plantilla desde GitHub"
        return 1
    fi
    
    # Extraer archivo
    cd "$temp_dir"
    tar -xzf template.tar.gz --strip-components=1 2>/dev/null || {
        log ERROR "No se pudo extraer la plantilla"
        return 1
    }
    
    # Limpiar archivo descargado
    rm -f template.tar.gz
    
    log SUCCESS "Plantilla descargada y extraída"
    return 0
}

# Ejecutar generador local
run_generator() {
    local template_dir="$1"
    local nombre="$2"
    local area="$3"
    local descripcion="$4"
    
    log STEP "Ejecutando generador de componentes..."
    
    # Verificar que existe el script generador
    local generator_script="$template_dir/generar-componente.sh"
    if [[ ! -f "$generator_script" ]]; then
        log ERROR "No se encontró el script generador en la plantilla"
        return 1
    fi
    
    # Dar permisos de ejecución
    chmod +x "$generator_script"
    
    # Cambiar al directorio donde queremos crear el componente
    cd "$(dirname "$template_dir")"
    
    # Ejecutar generador con respuesta automática 's' (sí) para confirmación
    echo "s" | TEMPLATE_DIR="$template_dir" "$generator_script" "$nombre" "$area" "$descripcion"
    
    return $?
}

# Limpiar archivos temporales
cleanup() {
    if [[ -n "${TEMP_DIR:-}" ]] && [[ -d "$TEMP_DIR" ]]; then
        log INFO "Limpiando archivos temporales..."
        rm -rf "$TEMP_DIR"
    fi
}

# Configurar trap para limpiar al salir
trap cleanup EXIT INT TERM

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
    local NOMBRE_COMPONENTE="$1"
    local AREA_FUNCIONAL="$2"
    local DESCRIPCION="${3:-Componente de VUCEM para $AREA_FUNCIONAL}"
    
    show_header
    
    # Validaciones
    log INFO "Validando parámetros..."
    
    if ! validate_component_name "$NOMBRE_COMPONENTE"; then
        exit 1
    fi
    
    if ! validate_area "$AREA_FUNCIONAL"; then
        exit 1
    fi
    
    # Verificar dependencias
    if ! check_dependencies; then
        exit 1
    fi
    
    # Mostrar configuración
    echo -e "${BOLD}Configuración:${NC}"
    echo -e "  ${CYAN}Componente:${NC} $NOMBRE_COMPONENTE"
    echo -e "  ${CYAN}Área:${NC} $AREA_FUNCIONAL"
    echo -e "  ${CYAN}Descripción:${NC} $DESCRIPCION"
    echo -e "  ${CYAN}Fuente:${NC} GitHub (${GITHUB_USER}/${GITHUB_REPO})"
    echo
    
    # Crear directorio temporal
    TEMP_DIR=$(mktemp -d)
    
    # Descargar plantilla
    if ! download_template "$TEMP_DIR"; then
        exit 1
    fi
    
    # Ejecutar generador
    if run_generator "$TEMP_DIR" "$NOMBRE_COMPONENTE" "$AREA_FUNCIONAL" "$DESCRIPCION"; then
        echo
        echo -e "${BOLD}${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
        echo -e "${BOLD}${GREEN}║    ✅ COMPONENTE GENERADO DESDE GITHUB EXITOSAMENTE     ║${NC}"
        echo -e "${BOLD}${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
        echo
        echo -e "${BOLD}Próximos pasos:${NC}"
        echo -e "  1. ${CYAN}cd vucem-$NOMBRE_COMPONENTE${NC}"
        echo -e "  2. ${CYAN}mvn clean install${NC}"
        echo -e "  3. ${CYAN}mvn spring-boot:run${NC}"
        echo
        echo -e "${BOLD}Documentación:${NC}"
        echo -e "  📖 README.md en el directorio del componente"
        echo -e "  🌐 Repositorio: https://github.com/${GITHUB_USER}/${GITHUB_REPO}"
        echo
    else
        log ERROR "Error al generar el componente"
        exit 1
    fi
}

# Ejecutar programa principal
main "$@"