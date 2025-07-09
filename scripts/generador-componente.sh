#!/bin/bash
# generador-componente.sh

# Validar argumentos
if [ "$#" -lt 2 ]; then
    echo "Uso: $0 <nombre-componente> <area-funcional> [descripción]"
    exit 1
fi

NOMBRE_COMPONENTE=$1
AREA_FUNCIONAL=$2
DESCRIPCION=${3:-"Componente de VUCEM para $AREA_FUNCIONAL"}
REPO_BASE="https://github.com/vucem/arquetipo"
FECHA=$(date +"%Y-%m-%d")

echo "Generando componente VUCEM: $NOMBRE_COMPONENTE"
echo "Área funcional: $AREA_FUNCIONAL"

# Clonar arquetipo
git clone $REPO_BASE temp-$NOMBRE_COMPONENTE

# Crear repositorio del nuevo componente
cd temp-$NOMBRE_COMPONENTE
rm -rf .git
git init

# Personalizar archivos
find . -type f -not -path "*/\.*" -not -path "*/node_modules/*" -not -path "*/target/*" |
while read FILE; do
    if [[ -f "$FILE" ]]; then
        sed -i "s/COMPONENTE_NOMBRE/$NOMBRE_COMPONENTE/g" "$FILE"
        sed -i "s/COMPONENTE_AREA/$AREA_FUNCIONAL/g" "$FILE"
        sed -i "s/COMPONENTE_DESCRIPCION/$DESCRIPCION/g" "$FILE"
        sed -i "s/FECHA_GENERACION/$FECHA/g" "$FILE"
    fi
done

# Renombrar paquetes y directorios
mkdir -p src/main/java/mx/gob/vucem/$NOMBRE_COMPONENTE/
mv src/main/java/mx/gob/vucem/componente/* src/main/java/mx/gob/vucem/$NOMBRE_COMPONENTE/
rm -rf src/main/java/mx/gob/vucem/componente/

# Actualizar README
cat > README.md << EOF
# VUCEM - $NOMBRE_COMPONENTE

Componente de $DESCRIPCION para la Ventanilla Única de Comercio Exterior Mexicana.

## Área Funcional

$AREA_FUNCIONAL

## Descripción

$DESCRIPCION

## Fecha de Creación

$FECHA

## Documentación

Consultar el directorio \`/docs\` para la documentación detallada del componente.
EOF

echo "Componente generado en: $(pwd)"
echo "Ejecute los siguientes comandos para finalizar:"
echo "cd temp-$NOMBRE_COMPONENTE"
echo "git add ."
echo "git commit -m \"Generación inicial del componente $NOMBRE_COMPONENTE\""