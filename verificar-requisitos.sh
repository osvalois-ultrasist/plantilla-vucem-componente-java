#!/bin/bash

#############################################################################
# verificar-requisitos.sh - Verificador de Requisitos para VUCEM
# 
# Descripción: Verifica e instala las dependencias necesarias para
#              trabajar con componentes VUCEM
#
# Uso: ./verificar-requisitos.sh [--install]
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
readonly MIN_JAVA_VERSION=17
readonly RECOMMENDED_JAVA_VERSION=21
readonly MIN_MAVEN_VERSION="3.8"
readonly MIN_DOCKER_VERSION="20.10"
readonly MIN_GIT_VERSION="2.25"

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

# Flags
INSTALL_MODE=false
MISSING_DEPS=()

# ===========================================================================
# FUNCIONES
# ===========================================================================

log() {
    local level="$1"
    shift
    case "$level" in
        SUCCESS) echo -e "${GREEN}✓${NC} $*" ;;
        ERROR)   echo -e "${RED}✗${NC} $*" ;;
        WARNING) echo -e "${YELLOW}⚠${NC} $*" ;;
        INFO)    echo -e "${BLUE}ℹ${NC} $*" ;;
        *)       echo "$*" ;;
    esac
}

show_header() {
    echo -e "${BOLD}${BLUE}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║       VERIFICADOR DE REQUISITOS VUCEM v${SCRIPT_VERSION}          ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/debian_version ]; then
            echo "debian"
        elif [ -f /etc/redhat-release ]; then
            echo "redhat"
        elif [ -f /etc/arch-release ]; then
            echo "arch"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

version_compare() {
    # Compara versiones: retorna 0 si $1 >= $2
    local version1="$1"
    local version2="$2"
    
    if [[ "$version1" == "$version2" ]]; then
        return 0
    fi
    
    local IFS=.
    local i ver1=($version1) ver2=($version2)
    
    for ((i=0; i<${#ver1[@]}; i++)); do
        if [[ -z ${ver2[i]} ]]; then
            return 0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]})); then
            return 0
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            return 1
        fi
    done
    
    return 0
}

check_java() {
    echo -e "\n${BOLD}Java:${NC}"
    
    if command -v java &> /dev/null; then
        local java_version=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
        
        # Manejar versiones antiguas (1.8) y nuevas (11, 17, 21)
        if [[ "$java_version" == "1" ]]; then
            java_version=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f2)
        fi
        
        if [[ "$java_version" -ge $MIN_JAVA_VERSION ]]; then
            if [[ "$java_version" -ge $RECOMMENDED_JAVA_VERSION ]]; then
                log SUCCESS "Java $java_version instalado (óptimo)"
            else
                log WARNING "Java $java_version instalado (se recomienda Java $RECOMMENDED_JAVA_VERSION+)"
            fi
        else
            log ERROR "Java $java_version instalado (se requiere Java $MIN_JAVA_VERSION+)"
            MISSING_DEPS+=("java")
        fi
        
        # Verificar JAVA_HOME
        if [[ -n "${JAVA_HOME:-}" ]]; then
            log SUCCESS "JAVA_HOME configurado: $JAVA_HOME"
        else
            log WARNING "JAVA_HOME no configurado"
        fi
    else
        log ERROR "Java no instalado"
        MISSING_DEPS+=("java")
    fi
}

check_maven() {
    echo -e "\n${BOLD}Maven:${NC}"
    
    if command -v mvn &> /dev/null; then
        local maven_version=$(mvn -version 2>/dev/null | head -n 1 | cut -d' ' -f3)
        
        if version_compare "$maven_version" "$MIN_MAVEN_VERSION"; then
            log SUCCESS "Maven $maven_version instalado"
        else
            log ERROR "Maven $maven_version instalado (se requiere $MIN_MAVEN_VERSION+)"
            MISSING_DEPS+=("maven")
        fi
        
        # Verificar configuración
        if [[ -f ~/.m2/settings.xml ]]; then
            log SUCCESS "Configuración Maven encontrada"
        else
            log INFO "Sin configuración Maven personalizada"
        fi
    else
        log ERROR "Maven no instalado"
        MISSING_DEPS+=("maven")
    fi
}

check_git() {
    echo -e "\n${BOLD}Git:${NC}"
    
    if command -v git &> /dev/null; then
        local git_version=$(git --version | cut -d' ' -f3)
        
        if version_compare "$git_version" "$MIN_GIT_VERSION"; then
            log SUCCESS "Git $git_version instalado"
        else
            log WARNING "Git $git_version instalado (se recomienda $MIN_GIT_VERSION+)"
        fi
        
        # Verificar configuración
        if git config --global user.name &> /dev/null; then
            log SUCCESS "Git configurado: $(git config --global user.name)"
        else
            log WARNING "Git sin configuración de usuario"
        fi
    else
        log ERROR "Git no instalado"
        MISSING_DEPS+=("git")
    fi
}

check_docker() {
    echo -e "\n${BOLD}Docker (opcional):${NC}"
    
    if command -v docker &> /dev/null; then
        if docker info &> /dev/null; then
            local docker_version=$(docker --version | cut -d' ' -f3 | tr -d ',')
            
            if version_compare "$docker_version" "$MIN_DOCKER_VERSION"; then
                log SUCCESS "Docker $docker_version instalado y funcionando"
            else
                log WARNING "Docker $docker_version instalado (se recomienda $MIN_DOCKER_VERSION+)"
            fi
            
            # Verificar Docker Compose
            if command -v docker-compose &> /dev/null || docker compose version &> /dev/null; then
                log SUCCESS "Docker Compose disponible"
            else
                log INFO "Docker Compose no instalado"
            fi
        else
            log WARNING "Docker instalado pero no está ejecutándose"
        fi
    else
        log INFO "Docker no instalado (opcional)"
    fi
}

check_database() {
    echo -e "\n${BOLD}Base de Datos (desarrollo):${NC}"
    
    # PostgreSQL
    if command -v psql &> /dev/null; then
        local pg_version=$(psql --version | cut -d' ' -f3 | cut -d'.' -f1)
        log SUCCESS "PostgreSQL $pg_version instalado"
    else
        log INFO "PostgreSQL no instalado (puede usar H2 para desarrollo)"
    fi
}

check_ide() {
    echo -e "\n${BOLD}IDEs y Herramientas:${NC}"
    
    # VS Code
    if command -v code &> /dev/null; then
        log SUCCESS "Visual Studio Code instalado"
    fi
    
    # IntelliJ IDEA
    if [[ -d "/Applications/IntelliJ IDEA.app" ]] || command -v idea &> /dev/null; then
        log SUCCESS "IntelliJ IDEA instalado"
    fi
    
    # Eclipse
    if command -v eclipse &> /dev/null; then
        log SUCCESS "Eclipse instalado"
    fi
}

install_dependencies() {
    local os=$(detect_os)
    
    echo -e "\n${BOLD}${YELLOW}Instalando dependencias faltantes...${NC}"
    
    case "$os" in
        macos)
            install_macos_deps
            ;;
        debian)
            install_debian_deps
            ;;
        redhat)
            install_redhat_deps
            ;;
        arch)
            install_arch_deps
            ;;
        *)
            log ERROR "Sistema operativo no soportado para instalación automática"
            show_manual_install
            ;;
    esac
}

install_macos_deps() {
    # Verificar Homebrew
    if ! command -v brew &> /dev/null; then
        log INFO "Instalando Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    for dep in "${MISSING_DEPS[@]}"; do
        case "$dep" in
            java)
                log INFO "Instalando OpenJDK 21..."
                brew install openjdk@21
                echo 'export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"' >> ~/.zshrc
                ;;
            maven)
                log INFO "Instalando Maven..."
                brew install maven
                ;;
            git)
                log INFO "Instalando Git..."
                brew install git
                ;;
        esac
    done
}

install_debian_deps() {
    for dep in "${MISSING_DEPS[@]}"; do
        case "$dep" in
            java)
                log INFO "Instalando OpenJDK 21..."
                sudo apt-get update
                sudo apt-get install -y openjdk-21-jdk
                ;;
            maven)
                log INFO "Instalando Maven..."
                sudo apt-get install -y maven
                ;;
            git)
                log INFO "Instalando Git..."
                sudo apt-get install -y git
                ;;
        esac
    done
}

install_redhat_deps() {
    for dep in "${MISSING_DEPS[@]}"; do
        case "$dep" in
            java)
                log INFO "Instalando OpenJDK 21..."
                sudo dnf install -y java-21-openjdk-devel
                ;;
            maven)
                log INFO "Instalando Maven..."
                sudo dnf install -y maven
                ;;
            git)
                log INFO "Instalando Git..."
                sudo dnf install -y git
                ;;
        esac
    done
}

install_arch_deps() {
    for dep in "${MISSING_DEPS[@]}"; do
        case "$dep" in
            java)
                log INFO "Instalando OpenJDK 21..."
                sudo pacman -S jdk21-openjdk
                ;;
            maven)
                log INFO "Instalando Maven..."
                sudo pacman -S maven
                ;;
            git)
                log INFO "Instalando Git..."
                sudo pacman -S git
                ;;
        esac
    done
}

show_manual_install() {
    echo -e "\n${BOLD}Instrucciones de instalación manual:${NC}"
    
    for dep in "${MISSING_DEPS[@]}"; do
        case "$dep" in
            java)
                echo -e "\n${BOLD}Java 21:${NC}"
                echo "  - Descargar desde: https://adoptium.net/"
                echo "  - O usar SDKMAN: curl -s 'https://get.sdkman.io' | bash"
                echo "                   sdk install java 21-tem"
                ;;
            maven)
                echo -e "\n${BOLD}Maven:${NC}"
                echo "  - Descargar desde: https://maven.apache.org/download.cgi"
                echo "  - O usar SDKMAN: sdk install maven"
                ;;
            git)
                echo -e "\n${BOLD}Git:${NC}"
                echo "  - Descargar desde: https://git-scm.com/downloads"
                ;;
        esac
    done
}

create_config_files() {
    echo -e "\n${BOLD}Creando archivos de configuración...${NC}"
    
    # Crear settings.xml de Maven si no existe
    if [[ ! -f ~/.m2/settings.xml ]]; then
        mkdir -p ~/.m2
        cat > ~/.m2/settings.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.2.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.2.0
                              https://maven.apache.org/xsd/settings-1.2.0.xsd">
    
    <!-- Repositorios adicionales para VUCEM -->
    <profiles>
        <profile>
            <id>vucem</id>
            <repositories>
                <repository>
                    <id>spring-milestones</id>
                    <name>Spring Milestones</name>
                    <url>https://repo.spring.io/milestone</url>
                </repository>
            </repositories>
        </profile>
    </profiles>
    
    <activeProfiles>
        <activeProfile>vucem</activeProfile>
    </activeProfiles>
</settings>
EOF
        log SUCCESS "Creado ~/.m2/settings.xml"
    fi
    
    # Configurar Git si no está configurado
    if ! git config --global user.name &> /dev/null; then
        log INFO "Configurando Git..."
        read -p "Ingrese su nombre para Git: " git_name
        read -p "Ingrese su email para Git: " git_email
        git config --global user.name "$git_name"
        git config --global user.email "$git_email"
        git config --global init.defaultBranch main
        log SUCCESS "Git configurado"
    fi
}

# ===========================================================================
# PROGRAMA PRINCIPAL
# ===========================================================================

main() {
    # Procesar argumentos
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --install|-i)
                INSTALL_MODE=true
                shift
                ;;
            --help|-h)
                show_header
                echo "Uso: $SCRIPT_NAME [--install]"
                echo ""
                echo "Opciones:"
                echo "  --install, -i  Instalar dependencias faltantes"
                echo "  --help, -h     Mostrar esta ayuda"
                exit 0
                ;;
            *)
                log ERROR "Opción desconocida: $1"
                exit 1
                ;;
        esac
    done
    
    show_header
    
    local os=$(detect_os)
    echo -e "${BOLD}Sistema Operativo:${NC} $os"
    
    # Verificar dependencias
    check_java
    check_maven
    check_git
    check_docker
    check_database
    check_ide
    
    # Resumen
    echo -e "\n${BOLD}${CYAN}═══════════════════════════════════════${NC}"
    echo -e "${BOLD}RESUMEN${NC}"
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════${NC}"
    
    if [[ ${#MISSING_DEPS[@]} -eq 0 ]]; then
        echo -e "\n${BOLD}${GREEN}✅ Todos los requisitos están instalados${NC}"
        echo -e "Tu sistema está listo para trabajar con componentes VUCEM"
        
        # Ofrecer crear archivos de configuración
        read -p "¿Desea crear/actualizar archivos de configuración? (s/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            create_config_files
        fi
    else
        echo -e "\n${BOLD}${YELLOW}⚠️  Faltan las siguientes dependencias:${NC}"
        for dep in "${MISSING_DEPS[@]}"; do
            echo "  - $dep"
        done
        
        if [[ "$INSTALL_MODE" == true ]]; then
            install_dependencies
        else
            echo -e "\n${BOLD}Para instalar automáticamente, ejecute:${NC}"
            echo "  $SCRIPT_NAME --install"
            echo ""
            show_manual_install
        fi
    fi
    
    echo -e "\n${BOLD}Recursos adicionales:${NC}"
    echo "  📚 Documentación: https://github.com/vucem/docs"
    echo "  🐛 Reportar bugs: https://github.com/vucem/template-vucem-componente/issues"
    echo "  💬 Soporte: vucem@economia.gob.mx"
}

# Ejecutar
main "$@"