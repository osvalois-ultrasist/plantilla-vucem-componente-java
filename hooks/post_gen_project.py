#!/usr/bin/env python
"""Post-generation hooks for the cookiecutter template."""

import os
import shutil
from pathlib import Path

def remove_files_if_disabled():
    """Remove files based on user choices."""
    
    # Si no se habilita Docker, eliminar archivos relacionados
    if '{{ cookiecutter.enable_docker }}' != 'yes':
        files_to_remove = [
            'Dockerfile',
            'docker-compose.yml',
            '.dockerignore',
            'infrastructure/docker'
        ]
        for file_path in files_to_remove:
            if os.path.exists(file_path):
                if os.path.isdir(file_path):
                    shutil.rmtree(file_path)
                else:
                    os.remove(file_path)
                print(f"Removed: {file_path}")
    
    # Si no se habilita seguridad, eliminar archivos relacionados
    if '{{ cookiecutter.enable_security }}' != 'yes':
        security_files = [
            'src/main/java/{{ cookiecutter.organization.replace(".", "/") }}/{{ cookiecutter.package_name }}/infrastructure/security',
            'src/main/java/{{ cookiecutter.organization.replace(".", "/") }}/{{ cookiecutter.package_name }}/interfaces/api/filters/JwtAuthenticationFilter.java',
            'src/main/java/{{ cookiecutter.organization.replace(".", "/") }}/{{ cookiecutter.package_name }}/interfaces/api/controllers/AuthController.java'
        ]
        for file_path in security_files:
            if os.path.exists(file_path):
                if os.path.isdir(file_path):
                    shutil.rmtree(file_path)
                else:
                    os.remove(file_path)
                print(f"Removed security: {file_path}")
    
    # Si no se habilita Swagger, eliminar configuración
    if '{{ cookiecutter.enable_swagger }}' != 'yes':
        swagger_file = 'src/main/java/{{ cookiecutter.organization.replace(".", "/") }}/{{ cookiecutter.package_name }}/interfaces/api/docs/OpenApiConfig.java'
        if os.path.exists(swagger_file):
            os.remove(swagger_file)
            print(f"Removed Swagger: {swagger_file}")

def create_package_structure():
    """Create the correct Java package structure."""
    
    # Crear la estructura de paquetes correcta
    base_path = Path('src/main/java')
    org_path = base_path / '{{ cookiecutter.organization.replace(".", "/") }}' / '{{ cookiecutter.package_name }}'
    
    # Asegurar que los directorios existan
    org_path.mkdir(parents=True, exist_ok=True)
    
    # Mover archivos desde la estructura genérica si existe
    old_path = base_path / 'mx/gob/vucem/componente'
    if old_path.exists() and old_path != org_path:
        # Mover todos los archivos
        for item in old_path.glob('**/*'):
            if item.is_file():
                relative = item.relative_to(old_path)
                new_item = org_path / relative
                new_item.parent.mkdir(parents=True, exist_ok=True)
                shutil.move(str(item), str(new_item))
        
        # Limpiar estructura antigua
        shutil.rmtree(str(base_path / 'mx/gob/vucem/componente'))
        
        # Limpiar directorios vacíos
        for parent in [base_path / 'mx/gob/vucem', base_path / 'mx/gob', base_path / 'mx']:
            if parent.exists() and not any(parent.iterdir()):
                parent.rmdir()
    
    # Hacer lo mismo para los tests
    test_base_path = Path('src/test/java')
    test_org_path = test_base_path / '{{ cookiecutter.organization.replace(".", "/") }}' / '{{ cookiecutter.package_name }}'
    test_org_path.mkdir(parents=True, exist_ok=True)
    
    old_test_path = test_base_path / 'mx/gob/vucem/componente'
    if old_test_path.exists() and old_test_path != test_org_path:
        for item in old_test_path.glob('**/*'):
            if item.is_file():
                relative = item.relative_to(old_test_path)
                new_item = test_org_path / relative
                new_item.parent.mkdir(parents=True, exist_ok=True)
                shutil.move(str(item), str(new_item))
        
        shutil.rmtree(str(test_base_path / 'mx/gob/vucem/componente'))
        
        for parent in [test_base_path / 'mx/gob/vucem', test_base_path / 'mx/gob', test_base_path / 'mx']:
            if parent.exists() and not any(parent.iterdir()):
                parent.rmdir()

def update_package_declarations():
    """Update package declarations in Java files."""
    
    base_path = Path('src')
    package_name = '{{ cookiecutter.organization }}.{{ cookiecutter.package_name }}'
    
    # Buscar todos los archivos Java y actualizar el package
    for java_file in base_path.glob('**/*.java'):
        content = java_file.read_text()
        
        # Reemplazar declaración de paquete antigua
        content = content.replace(
            'package mx.gob.vucem.componente',
            f'package {package_name}'
        )
        
        # Reemplazar imports
        content = content.replace(
            'import mx.gob.vucem.componente',
            f'import {package_name}'
        )
        
        java_file.write_text(content)

def main():
    """Execute all post-generation hooks."""
    
    print("\n=== Configurando el proyecto ===\n")
    
    create_package_structure()
    update_package_declarations()
    remove_files_if_disabled()
    
    print("\n=== Proyecto generado exitosamente ===")
    print(f"Nombre: {{ cookiecutter.project_name }}")
    print(f"Directorio: {{ cookiecutter.project_slug }}")
    print(f"Paquete: {{ cookiecutter.organization }}.{{ cookiecutter.package_name }}")
    print("\nPróximos pasos:")
    print("1. cd {{ cookiecutter.project_slug }}")
    print("2. mvn clean install")
    print("3. mvn spring-boot:run -Dspring-boot.run.profiles=local")
    print("\n")

if __name__ == '__main__':
    main()