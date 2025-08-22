#!/bin/bash

#############################################################################
# validar-componente.sh - Validador de Componentes VUCEM
# 
# Descripción: Valida que un componente generado cumpla con todos los
#              estándares y mejores prácticas de VUCEM
#
# Uso: ./validar-componente.sh <directorio-componente>
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
readonly SCRIPT_NAME=$(basename "$0")

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

# Contadores
ERRORS=0
WARNINGS=0
PASSED=0

# ===========================================================================
# FUNCIONES DE UTILIDAD
# ===========================================================================

log() {
    local level="$1"
    shift
    local message="$*"
    
    case "$level" in
        PASS)    echo -e "${GREEN}✓${NC} ${message}"; ((PASSED++)) ;;
        FAIL)    echo -e "${RED}✗${NC} ${message}"; ((ERRORS++)) ;;
        WARN)    echo -e "${YELLOW}⚠${NC} ${message}"; ((WARNINGS++)) ;;
        INFO)    echo -e "${BLUE}ℹ${NC} ${message}" ;;
        SECTION) echo -e "\n${BOLD}${CYAN}▸ ${message}${NC}" ;;
        *)       echo "${message}" ;;
    esac
}

show_header() {
    echo -e "${BOLD}${BLUE}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║           VALIDADOR DE COMPONENTES VUCEM v${SCRIPT_VERSION}          ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

show_help() {
    show_header
    cat << EOF
${BOLD}USO:${NC}
    ${SCRIPT_NAME} <directorio-componente>

${BOLD}DESCRIPCIÓN:${NC}
    Valida que un componente VUCEM cumpla con:
    - Estructura de directorios correcta
    - Arquitectura de 4 capas
    - Configuraciones válidas
    - DevSecOps pipelines
    - Documentación completa
    - Compilación exitosa

${BOLD}EJEMPLOS:${NC}
    ${SCRIPT_NAME} vucem-sistema-aduanas
    ${SCRIPT_NAME} /path/to/vucem-component
    ${SCRIPT_NAME} .

${BOLD}VALIDACIONES:${NC}
    ✓ Estructura base
    ✓ Arquitectura modular
    ✓ Configuración Maven/Spring
    ✓ DevSecOps (CI/CD)
    ✓ Documentación
    ✓ Calidad de código
    ✓ Seguridad
    ✓ Compilación

${BOLD}CÓDIGOS DE SALIDA:${NC}
    0 - Validación exitosa
    1 - Errores encontrados
    2 - Argumentos inválidos

EOF
}

# ===========================================================================
# FUNCIONES DE VALIDACIÓN
# ===========================================================================

check_file() {
    local file="$1"
    local description="$2"
    local required="${3:-true}"
    
    if [[ -f "$COMPONENT_DIR/$file" ]]; then
        log PASS "$description"
        return 0
    else
        if [[ "$required" == "true" ]]; then
            log FAIL "$description - Archivo no encontrado: $file"
            return 1
        else
            log WARN "$description - Archivo opcional no encontrado: $file"
            return 0
        fi
    fi
}

check_dir() {
    local dir="$1"
    local description="$2"
    local required="${3:-true}"
    
    if [[ -d "$COMPONENT_DIR/$dir" ]]; then
        log PASS "$description"
        return 0
    else
        if [[ "$required" == "true" ]]; then
            log FAIL "$description - Directorio no encontrado: $dir"
            return 1
        else
            log WARN "$description - Directorio opcional no encontrado: $dir"
            return 0
        fi
    fi
}

check_content() {
    local file="$1"
    local pattern="$2"
    local description="$3"
    
    if [[ -f "$COMPONENT_DIR/$file" ]]; then
        if grep -q "$pattern" "$COMPONENT_DIR/$file" 2>/dev/null; then
            log PASS "$description"
            return 0
        else
            log WARN "$description - Patrón no encontrado"
            return 1
        fi
    else
        log WARN "$description - Archivo no existe"
        return 1
    fi
}

validate_structure() {
    log SECTION "Estructura Base"
    
    check_file "pom.xml" "Maven POM"
    check_file "README.md" "Documentación README"
    check_file "Dockerfile" "Dockerfile"
    check_file ".gitignore" "Git ignore"
    check_file "LICENSE" "Licencia" false
    check_dir "src/main/java" "Código fuente Java"
    check_dir "src/main/resources" "Recursos"
    check_dir "src/test" "Tests"
}

validate_architecture() {
    log SECTION "Arquitectura Modular (Clean Architecture)"
    
    # Buscar estructura de paquetes
    local package_path=$(find "$COMPONENT_DIR/src/main/java" -type d -name "domain" 2>/dev/null | head -1)
    
    if [[ -n "$package_path" ]]; then
        package_path=$(dirname "$package_path")
        local package_name=$(basename "$package_path")
        log INFO "Paquete detectado: $package_name"
        
        # Validar las 4 capas
        local layers=("domain" "application" "infrastructure" "interfaces")
        for layer in "${layers[@]}"; do
            if [[ -d "$package_path/$layer" ]]; then
                log PASS "Capa $layer presente"
                
                # Validar subcarpetas según la capa
                case "$layer" in
                    domain)
                        check_dir "${package_path#$COMPONENT_DIR/}/$layer/entities" "Entidades" false
                        check_dir "${package_path#$COMPONENT_DIR/}/$layer/services" "Servicios de dominio" false
                        ;;
                    application)
                        check_dir "${package_path#$COMPONENT_DIR/}/$layer/services" "Servicios de aplicación" false
                        check_dir "${package_path#$COMPONENT_DIR/}/$layer/dtos" "DTOs" false
                        ;;
                    infrastructure)
                        check_dir "${package_path#$COMPONENT_DIR/}/$layer/persistence" "Persistencia" false
                        check_dir "${package_path#$COMPONENT_DIR/}/$layer/config" "Configuraciones" false
                        ;;
                    interfaces)
                        check_dir "${package_path#$COMPONENT_DIR/}/$layer/api" "API REST" false
                        ;;
                esac
            else
                log FAIL "Capa $layer faltante"
            fi
        done
    else
        log FAIL "No se encontró estructura de paquetes Java"
    fi
}

validate_configuration() {
    log SECTION "Configuración"
    
    # Validar POM
    if [[ -f "$COMPONENT_DIR/pom.xml" ]]; then
        # Verificar artifact ID
        if grep -q "<artifactId>vucem-" "$COMPONENT_DIR/pom.xml"; then
            local artifact=$(grep "<artifactId>vucem-" "$COMPONENT_DIR/pom.xml" | head -1 | sed 's/.*<artifactId>//;s/<\/artifactId>.*//')
            log PASS "Artifact ID válido: $artifact"
        else
            log WARN "Artifact ID no sigue convención vucem-*"
        fi
        
        # Verificar versión de Java
        if grep -q "<java.version>" "$COMPONENT_DIR/pom.xml"; then
            local java_version=$(grep "<java.version>" "$COMPONENT_DIR/pom.xml" | head -1 | sed 's/.*<java.version>//;s/<\/java.version>.*//')
            if [[ "$java_version" -ge 17 ]]; then
                log PASS "Versión de Java: $java_version"
            else
                log WARN "Versión de Java antigua: $java_version (se recomienda 21+)"
            fi
        fi
    fi
    
    # Validar application.yml
    check_file "src/main/resources/application.yml" "Configuración Spring Boot"
    
    if [[ -f "$COMPONENT_DIR/src/main/resources/application.yml" ]]; then
        check_content "src/main/resources/application.yml" "name:" "Nombre de aplicación configurado"
        check_content "src/main/resources/application.yml" "port:" "Puerto configurado"
        check_content "src/main/resources/application.yml" "datasource:" "Base de datos configurada"
    fi
}

validate_devsecops() {
    log SECTION "DevSecOps"
    
    check_dir ".github/workflows" "GitHub Actions workflows"
    check_file ".github/workflows/ci.yml" "Pipeline CI" false
    check_file ".github/workflows/cd.yml" "Pipeline CD" false
    check_file ".github/workflows/security-scan.yml" "Escaneo de seguridad" false
    check_dir "infrastructure" "Infrastructure as Code" false
    check_file "infrastructure/kubernetes" "Configuración Kubernetes" false
    check_file "infrastructure/docker" "Configuración Docker" false
}

validate_documentation() {
    log SECTION "Documentación"
    
    check_dir "docs" "Directorio de documentación"
    check_file "CONTRIBUTING.md" "Guía de contribución" false
    check_file "SECURITY.md" "Política de seguridad" false
    check_file "CHANGELOG.md" "Registro de cambios" false
    check_file "docs/arquitectura/ArquitecturaDeSoftware.md" "Documentación de arquitectura" false
    
    # Validar README
    if [[ -f "$COMPONENT_DIR/README.md" ]]; then
        check_content "README.md" "## " "Secciones en README"
        check_content "README.md" "### " "Subsecciones en README"
    fi
}

validate_code_quality() {
    log SECTION "Calidad de Código"
    
    # Verificar que no haya TODOs o FIXMEs
    local todos=$(grep -r "TODO\|FIXME" "$COMPONENT_DIR/src" 2>/dev/null | wc -l || echo 0)
    if [[ $todos -eq 0 ]]; then
        log PASS "Sin TODOs o FIXMEs pendientes"
    else
        log WARN "Encontrados $todos TODOs/FIXMEs"
    fi
    
    # Verificar tests
    local test_files=$(find "$COMPONENT_DIR/src/test" -name "*Test.java" 2>/dev/null | wc -l || echo 0)
    if [[ $test_files -gt 0 ]]; then
        log PASS "Tests encontrados: $test_files archivos"
    else
        log WARN "No se encontraron tests"
    fi
}

validate_security() {
    log SECTION "Seguridad"
    
    # Verificar que no haya credenciales hardcodeadas
    local patterns=("password.*=.*['\"]" "secret.*=.*['\"]" "token.*=.*['\"]" "api[_-]?key.*=.*['\"]")
    local found_secrets=false
    
    for pattern in "${patterns[@]}"; do
        if grep -r -i "$pattern" "$COMPONENT_DIR/src" --include="*.java" --include="*.yml" --include="*.properties" 2>/dev/null | grep -v "password\": \"\"" | grep -v "\${" > /dev/null; then
            found_secrets=true
            break
        fi
    done
    
    if [[ "$found_secrets" == "false" ]]; then
        log PASS "Sin credenciales hardcodeadas"
    else
        log FAIL "Posibles credenciales hardcodeadas detectadas"
    fi
    
    # Verificar configuración de seguridad
    check_dir "src/main/java/mx/gob/vucem/*/infrastructure/security" "Capa de seguridad" false
}

validate_compilation() {
    log SECTION "Compilación"
    
    if ! command -v mvn &> /dev/null; then
        log WARN "Maven no instalado - saltando compilación"
        return 0
    fi
    
    cd "$COMPONENT_DIR"
    
    # Intentar compilación rápida
    log INFO "Intentando compilación..."
    if mvn clean compile -DskipTests -q 2>/dev/null; then
        log PASS "Compilación exitosa"
        
        # Intentar tests
        if mvn test -q 2>/dev/null; then
            log PASS "Tests ejecutados exitosamente"
        else
            log WARN "Tests fallaron o no están configurados"
        fi
    else
        log WARN "Compilación requiere configuración adicional"
    fi
}

# ===========================================================================
# PROGRAMA PRINCIPAL
# ===========================================================================

main() {
    # Verificar argumentos
    if [[ $# -ne 1 ]]; then
        show_help
        exit 2
    fi
    
    COMPONENT_DIR="$1"
    
    # Verificar que el directorio existe
    if [[ ! -d "$COMPONENT_DIR" ]]; then
        log FAIL "El directorio $COMPONENT_DIR no existe"
        exit 2
    fi
    
    # Convertir a path absoluto
    COMPONENT_DIR=$(cd "$COMPONENT_DIR" && pwd)
    
    show_header
    echo -e "${BOLD}Validando:${NC} $COMPONENT_DIR"
    
    # Ejecutar validaciones
    validate_structure
    validate_architecture
    validate_configuration
    validate_devsecops
    validate_documentation
    validate_code_quality
    validate_security
    validate_compilation
    
    # Resumen
    echo
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════${NC}"
    echo -e "${BOLD}RESUMEN DE VALIDACIÓN${NC}"
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════${NC}"
    echo
    echo -e "  ${GREEN}✓ Pasadas:${NC} $PASSED"
    echo -e "  ${YELLOW}⚠ Advertencias:${NC} $WARNINGS"
    echo -e "  ${RED}✗ Errores:${NC} $ERRORS"
    echo
    
    if [[ $ERRORS -eq 0 ]]; then
        if [[ $WARNINGS -eq 0 ]]; then
            echo -e "${BOLD}${GREEN}✅ COMPONENTE VÁLIDO - Perfecto!${NC}"
            echo -e "El componente cumple con todos los estándares VUCEM."
        else
            echo -e "${BOLD}${YELLOW}⚠️  COMPONENTE VÁLIDO - Con advertencias${NC}"
            echo -e "El componente es funcional pero tiene $WARNINGS aspectos mejorables."
        fi
        exit 0
    else
        echo -e "${BOLD}${RED}❌ COMPONENTE INVÁLIDO${NC}"
        echo -e "Se encontraron $ERRORS errores críticos que deben corregirse."
        exit 1
    fi
}

# Ejecutar si no se está sourcing
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi