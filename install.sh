#!/bin/bash

#############################################################################
# install.sh - Instalador Global de VUCEM CLI
# 
# Descripción: Instala VUCEM CLI globalmente en el sistema
#
# Uso: curl -s https://raw.../install.sh | bash
# 
# Autor: VUCEM Team
# Versión: 3.0.0
#############################################################################

set -euo pipefail

# Colores
readonly G='\033[0;32m' R='\033[0;31m' Y='\033[0;33m' B='\033[1m' NC='\033[0m'

ok() { echo -e "${G}✓${NC} $*"; }
info() { echo -e "\033[0;36m▸\033[0m $*"; }
warn() { echo -e "${Y}⚠${NC} $*"; }

readonly GITHUB_RAW="https://raw.githubusercontent.com/osvalois-ultrasist/template-vucem-componente/main"
readonly INSTALL_DIR="/usr/local/bin"

main() {
    echo -e "${B}VUCEM CLI Installer${NC}"
    echo
    
    # Verificar permisos
    if [[ ! -w "$INSTALL_DIR" ]]; then
        warn "Se requieren permisos de administrador"
        echo "Ejecutando con sudo..."
        
        # Re-ejecutar con sudo
        curl -sSL "$GITHUB_RAW/install.sh" | sudo bash
        exit $?
    fi
    
    info "Instalando en $INSTALL_DIR..."
    
    # Descargar CLI principal
    if curl -sSL "$GITHUB_RAW/vucem" -o "$INSTALL_DIR/vucem"; then
        chmod +x "$INSTALL_DIR/vucem"
        ok "vucem instalado"
    else
        echo -e "${R}Error al descargar vucem${NC}"
        exit 1
    fi
    
    # Crear aliases útiles
    ln -sf "$INSTALL_DIR/vucem" "$INSTALL_DIR/vucem-new" 2>/dev/null || true
    ln -sf "$INSTALL_DIR/vucem" "$INSTALL_DIR/vucem-create" 2>/dev/null || true
    
    echo
    ok "Instalación completada"
    echo
    echo -e "${B}Uso:${NC}"
    echo "  vucem mi-app usuarios"
    echo "  vucem sistema-aduanas aduanas \"Mi sistema\""
    echo
    echo -e "${B}Verificar:${NC}"
    echo "  vucem --help"
}

main "$@"