#!/bin/bash

#############################################################################
# probar-remoto.sh - Script de Prueba para Uso Remoto
# 
# Descripción: Prueba que todos los scripts funcionen correctamente cuando
#              se acceden desde URLs raw de GitHub
#
# Uso: ./probar-remoto.sh
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

readonly GITHUB_USER="osvalois-ultrasist"  # Cambiar por tu usuario
readonly GITHUB_REPO="template-vucem-componente"
readonly GITHUB_BRANCH="main"
readonly BASE_URL="https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/${GITHUB_BRANCH}"

# Colores
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly BOLD='\033[1m'
readonly NC='\033[0m'

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
        TEST)    echo -e "${CYAN}[TEST]${NC} $*" ;;
    esac
}

show_header() {
    echo -e "${BOLD}${BLUE}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║              PRUEBAS DE USO REMOTO VUCEM                ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Verificar que curl funciona
test_curl() {
    log TEST "Verificando curl..."
    
    if ! command -v curl &> /dev/null; then
        log ERROR "curl no está instalado"
        return 1
    fi
    
    log SUCCESS "curl disponible"
    return 0
}

# Probar acceso a GitHub
test_github_access() {
    log TEST "Verificando acceso a GitHub..."
    
    local url="https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}"
    
    if curl -sSL "$url" > /dev/null 2>&1; then
        log SUCCESS "Acceso a GitHub OK"
        return 0
    else
        log ERROR "No se puede acceder al repositorio en GitHub"
        return 1
    fi
}

# Probar descarga de scripts
test_script_download() {
    local script_name="$1"
    local url="${BASE_URL}/${script_name}"
    
    log TEST "Probando descarga de $script_name..."
    
    if curl -sSL "$url" --fail > /dev/null 2>&1; then
        log SUCCESS "$script_name disponible"
        return 0
    else
        log ERROR "$script_name no accesible en: $url"
        return 1
    fi
}

# Probar contenido de scripts
test_script_content() {
    local script_name="$1"
    local url="${BASE_URL}/${script_name}"
    
    log TEST "Verificando contenido de $script_name..."
    
    local content=$(curl -sSL "$url" 2>/dev/null)
    
    # Verificar que es un script bash válido
    if [[ "$content" =~ ^#!/bin/bash ]]; then
        log SUCCESS "$script_name tiene formato válido"
    else
        log ERROR "$script_name no es un script bash válido"
        return 1
    fi
    
    # Verificar que no está vacío
    if [[ -n "$content" ]] && [[ $(echo "$content" | wc -l) -gt 10 ]]; then
        log SUCCESS "$script_name tiene contenido suficiente"
    else
        log ERROR "$script_name parece estar vacío o incompleto"
        return 1
    fi
    
    return 0
}

# Probar ejecución simulada
test_script_help() {
    local script_name="$1"
    local url="${BASE_URL}/${script_name}"
    
    log TEST "Probando ayuda de $script_name..."
    
    # Intentar obtener ayuda del script
    if curl -sSL "$url" | bash -s --help > /dev/null 2>&1; then
        log SUCCESS "$script_name responde a --help"
    else
        log WARNING "$script_name no responde a --help (puede ser normal)"
    fi
    
    return 0
}

# Verificar URLs en documentación
test_documentation_urls() {
    log TEST "Verificando URLs en documentación..."
    
    local docs=("README.md" "USO_REMOTO.md" "INSTRUCCIONES_USO.md")
    
    for doc in "${docs[@]}"; do
        local url="${BASE_URL}/${doc}"
        if curl -sSL "$url" --fail > /dev/null 2>&1; then
            log SUCCESS "$doc accesible"
        else
            log WARNING "$doc no accesible"
        fi
    done
    
    return 0
}

# Probar descarga del archivo completo
test_archive_download() {
    log TEST "Probando descarga de archivo completo..."
    
    local archive_url="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/archive/refs/heads/${GITHUB_BRANCH}.tar.gz"
    
    if curl -sSL "$archive_url" --fail > /dev/null 2>&1; then
        log SUCCESS "Archivo tar.gz accesible"
        return 0
    else
        log ERROR "No se puede descargar el archivo completo"
        return 1
    fi
}

# Mostrar comandos de ejemplo
show_usage_examples() {
    echo
    echo -e "${BOLD}🎯 Comandos de Prueba:${NC}"
    echo
    echo -e "${YELLOW}# Verificar requisitos:${NC}"
    echo "curl -sSL ${BASE_URL}/verificar-requisitos.sh | bash"
    echo
    echo -e "${YELLOW}# Crear componente de prueba:${NC}"
    echo "curl -sSL ${BASE_URL}/crear-componente-remoto.sh | bash -s prueba-remota testing \"Componente de prueba remota\""
    echo
    echo -e "${YELLOW}# Validar resultado:${NC}"
    echo "curl -sSL ${BASE_URL}/validar-componente.sh | bash -s vucem-prueba-remota"
    echo
}

# ===========================================================================
# PROGRAMA PRINCIPAL
# ===========================================================================

main() {
    show_header
    
    local failed_tests=0
    local total_tests=0
    
    echo -e "${BOLD}Repositorio:${NC} ${GITHUB_USER}/${GITHUB_REPO}"
    echo -e "${BOLD}Rama:${NC} ${GITHUB_BRANCH}"
    echo -e "${BOLD}Base URL:${NC} ${BASE_URL}"
    echo
    
    # Lista de scripts a probar
    local scripts=(
        "crear-componente-remoto.sh"
        "generar-componente.sh"
        "validar-componente.sh"
        "verificar-requisitos.sh"
    )
    
    # Pruebas básicas
    ((total_tests++))
    test_curl || ((failed_tests++))
    
    ((total_tests++))
    test_github_access || ((failed_tests++))
    
    ((total_tests++))
    test_archive_download || ((failed_tests++))
    
    # Probar cada script
    for script in "${scripts[@]}"; do
        ((total_tests++))
        test_script_download "$script" || ((failed_tests++))
        
        ((total_tests++))
        test_script_content "$script" || ((failed_tests++))
        
        ((total_tests++))
        test_script_help "$script" || true  # No cuenta como fallo
    done
    
    # Probar documentación
    ((total_tests++))
    test_documentation_urls || true  # No cuenta como fallo
    
    # Mostrar resultados
    echo
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════${NC}"
    echo -e "${BOLD}RESULTADOS DE PRUEBAS${NC}"
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════${NC}"
    echo
    echo -e "  ${GREEN}✓ Pasadas:${NC} $((total_tests - failed_tests))"
    echo -e "  ${RED}✗ Fallidas:${NC} $failed_tests"
    echo -e "  ${BLUE}📊 Total:${NC} $total_tests"
    echo
    
    if [[ $failed_tests -eq 0 ]]; then
        echo -e "${BOLD}${GREEN}🎉 ¡TODAS LAS PRUEBAS PASARON!${NC}"
        echo -e "El repositorio está listo para uso remoto."
        show_usage_examples
        exit 0
    else
        echo -e "${BOLD}${RED}❌ ALGUNAS PRUEBAS FALLARON${NC}"
        echo -e "Revisa las URLs y configuración del repositorio."
        exit 1
    fi
}

# Ejecutar programa principal
main "$@"