# Mapa de Workflows de GitHub Actions para VUCEM

Este documento describe la organización y propósito de los diferentes workflows de GitHub Actions utilizados en este proyecto.

## Estructura de Workflows

### Principales Workflows

| Workflow | Archivo | Propósito | Cuándo se ejecuta |
|----------|---------|-----------|-------------------|
| **CI Pipeline** | `.github/workflows/ci.yml` | Integración Continua - Compila, prueba y verifica la calidad del código | Push a ramas, PRs a main/desarrollo |
| **CD Pipeline** | `.github/workflows/cd.yml` | Despliegue Continuo - Despliega a entornos específicos | Manual (workflow_dispatch) |
| **Security Scan** | `.github/workflows/security-scan.yml` | Análisis de seguridad profundo | Programado (lunes) o manual |
| **Quality Gates** | `.github/workflows/quality-gates.yml` | Análisis exhaustivo de calidad de código | PRs o manual |
| **Compliance Checks** | `.github/workflows/compliance-checks.yml` | Verificación de cumplimiento normativo | Programado (lunes) o manual |

### Acciones Compuestas Reutilizables

| Acción | Ruta | Propósito |
|--------|------|-----------|
| **Setup Environment** | `.github/actions/setup-environment/` | Configuración del entorno de desarrollo (JDK, Maven, etc.) |
| **Security Scan** | `.github/actions/security-scan/` | Ejecuta diferentes tipos de escaneos de seguridad |
| **Quality Checks** | `.github/actions/quality-checks/` | Ejecuta verificaciones de calidad de código |
| **Deployment** | `.github/actions/deployment/` | Maneja el despliegue en diferentes entornos |
| **Notification** | `.github/actions/notification/` | Sistema unificado de notificaciones |

## Flujo de Trabajo

![Mapa de Workflows](workflow-map.png)

## Propósito y Alcance de cada Workflow

### CI Pipeline (ci.yml)

**Propósito**: Pipeline principal de Integración Continua que garantiza la calidad básica del código.

**Alcance**:
- Compila el código y verifica su sintaxis
- Ejecuta pruebas unitarias y de integración
- Realiza análisis básico de calidad de código
- Construye imágenes Docker
- Despliega automáticamente a entornos de desarrollo/pruebas según la rama

**Cuándo usarlo**: 
- Se ejecuta automáticamente en cada push
- Es el workflow principal para desarrollo continuo

### CD Pipeline (cd.yml)

**Propósito**: Controla el despliegue a entornos específicos, especialmente producción.

**Alcance**:
- Despliega a entornos específicos (QA, UAT, producción)
- Incluye verificaciones de seguridad y validación previas
- Requiere aprobación manual para entornos críticos
- Realiza verificaciones post-despliegue

**Cuándo usarlo**:
- Cuando necesites desplegar a un entorno específico
- Se ejecuta manualmente con parámetros específicos

### Security Scan (security-scan.yml)

**Propósito**: Realiza análisis profundos de seguridad.

**Alcance**:
- Escaneo de secretos en el código
- Análisis de vulnerabilidades en dependencias
- Análisis estático de seguridad del código (SAST)
- Escaneo de contenedores
- Análisis dinámico de aplicaciones (DAST)
- Firma de imágenes para garantía de cadena de suministro

**Cuándo usarlo**:
- Se ejecuta semanalmente para mantener la seguridad del código
- Ejecución manual para análisis bajo demanda
- No se ejecuta en cada PR para evitar sobrecarga

### Quality Gates (quality-gates.yml)

**Propósito**: Análisis exhaustivo de calidad de código, más allá del CI básico.

**Alcance**:
- Análisis profundo de code smells
- Validación exhaustiva de dependencias
- Análisis de complejidad ciclomática
- Verificación de estándares de codificación específicos
- SonarQube con reglas extendidas

**Cuándo usarlo**:
- En PRs para asegurar calidad antes de merges
- Ejecución manual para verificaciones adicionales

### Compliance Checks (compliance-checks.yml)

**Propósito**: Verificar cumplimiento normativo y estándares organizacionales.

**Alcance**:
- Verifica licencias de dependencias
- Asegura cumplimiento de políticas organizacionales
- Valida arquitectura de software
- Verifica estructura de directorios y archivos
- Genera evidencia para auditorías

**Cuándo usarlo**:
- Se ejecuta semanalmente para auditoría
- Ejecución manual para generar evidencias de cumplimiento

## Interacción entre Workflows

- **CI Pipeline** es el flujo principal y ejecuta verificaciones básicas
- **Quality Gates** se ejecuta para análisis más detallados durante PRs
- **Security Scan** proporciona análisis de seguridad profundos, ejecutado periódicamente
- **CD Pipeline** se encarga del despliegue basado en artefactos validados
- **Compliance Checks** asegura que todo el código cumpla con las políticas establecidas

## Recomendaciones de Uso

1. Para cambios diarios, confía en el **CI Pipeline** automático
2. Antes de solicitar un PR, considera ejecutar manualmente **Quality Gates**
3. Usa **Security Scan** periódicamente o antes de releases importantes
4. Utiliza **CD Pipeline** para despliegues controlados a entornos específicos
5. Ejecuta **Compliance Checks** antes de auditorías o cuando necesites generar evidencias