#!/usr/bin/env python
"""Pre-generation hooks for the cookiecutter template."""

import re
import sys

MODULE_REGEX = r'^[_a-zA-Z][_a-zA-Z0-9]+$'

module_name = '{{ cookiecutter.package_name }}'

if not re.match(MODULE_REGEX, module_name):
    print(f'ERROR: El nombre del paquete ({module_name}) no es válido para Java.')
    print('Debe comenzar con una letra y contener solo letras, números y guiones bajos.')
    sys.exit(1)

# Validar que el puerto sea un número válido
try:
    port = int('{{ cookiecutter.port }}')
    if not (1024 <= port <= 65535):
        print(f'ERROR: El puerto debe estar entre 1024 y 65535.')
        sys.exit(1)
except ValueError:
    print(f'ERROR: El puerto debe ser un número válido.')
    sys.exit(1)

print(f"Generando componente VUCEM: {{ cookiecutter.component_name }}")
print(f"Área funcional: {{ cookiecutter.component_area }}")
print(f"Paquete Java: {{ cookiecutter.organization }}.{{ cookiecutter.package_name }}")