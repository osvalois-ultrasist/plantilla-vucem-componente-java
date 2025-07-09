# Políticas OPA para VUCEM - Policy as Code
# Enforces security, compliance and governance rules

package vucem.security

import rego.v1

# ============================================================================
# POLÍTICAS DE SEGURIDAD PARA CONTENEDORES
# ============================================================================

# Denegar contenedores que ejecuten como root
deny_root_user contains msg if {
    input.kind == "Pod"
    input.spec.securityContext.runAsUser == 0
    msg := "Los contenedores no pueden ejecutarse como root (UID 0)"
}

deny_root_user contains msg if {
    input.kind == "Pod"
    some container in input.spec.containers
    container.securityContext.runAsUser == 0
    msg := sprintf("El contenedor '%s' no puede ejecutarse como root", [container.name])
}

# Requerir que los contenedores no sean privilegiados
deny_privileged_containers contains msg if {
    input.kind == "Pod"
    some container in input.spec.containers
    container.securityContext.privileged == true
    msg := sprintf("El contenedor '%s' no puede ser privilegiado", [container.name])
}

# Prohibir hostNetwork, hostPID, hostIPC
deny_host_namespaces contains msg if {
    input.kind == "Pod"
    input.spec.hostNetwork == true
    msg := "Los pods no pueden usar hostNetwork"
}

deny_host_namespaces contains msg if {
    input.kind == "Pod"
    input.spec.hostPID == true
    msg := "Los pods no pueden usar hostPID"
}

deny_host_namespaces contains msg if {
    input.kind == "Pod"
    input.spec.hostIPC == true
    msg := "Los pods no pueden usar hostIPC"
}

# ============================================================================
# POLÍTICAS DE RECURSOS Y LÍMITES
# ============================================================================

# Requerir límites de recursos para todos los contenedores
require_resource_limits contains msg if {
    input.kind == "Pod"
    some container in input.spec.containers
    not container.resources.limits
    msg := sprintf("El contenedor '%s' debe tener límites de recursos definidos", [container.name])
}

require_resource_limits contains msg if {
    input.kind == "Pod"
    some container in input.spec.containers
    not container.resources.limits.memory
    msg := sprintf("El contenedor '%s' debe tener límite de memoria", [container.name])
}

require_resource_limits contains msg if {
    input.kind == "Pod"
    some container in input.spec.containers
    not container.resources.limits.cpu
    msg := sprintf("El contenedor '%s' debe tener límite de CPU", [container.name])
}

# ============================================================================
# POLÍTICAS DE IMÁGENES Y REGISTROS
# ============================================================================

# Lista de registros autorizados para VUCEM
allowed_registries := {
    "ghcr.io/vucem",
    "registry.vucem.gob.mx",
    "docker.io/library",  # Solo para imágenes base oficiales
    "gcr.io/distroless"   # Imágenes distroless de Google
}

deny_unauthorized_registries contains msg if {
    input.kind == "Pod"
    some container in input.spec.containers
    registry := regex.split("/", container.image)[0]
    not registry in allowed_registries
    msg := sprintf("Registro no autorizado: '%s' en contenedor '%s'", [registry, container.name])
}

# Requerir tags específicos (no 'latest')
deny_latest_tag contains msg if {
    input.kind == "Pod"
    some container in input.spec.containers
    endswith(container.image, ":latest")
    msg := sprintf("El contenedor '%s' no puede usar el tag 'latest'", [container.name])
}

deny_no_tag contains msg if {
    input.kind == "Pod"
    some container in input.spec.containers
    not contains(container.image, ":")
    msg := sprintf("El contenedor '%s' debe especificar un tag", [container.name])
}

# ============================================================================
# POLÍTICAS DE ETIQUETAS Y METADATOS
# ============================================================================

# Requerir etiquetas obligatorias para recursos VUCEM
required_labels := {
    "mx.gob.vucem/component",
    "mx.gob.vucem/environment",
    "app.kubernetes.io/name",
    "app.kubernetes.io/version"
}

missing_required_labels contains msg if {
    input.kind in {"Pod", "Deployment", "Service", "ConfigMap", "Secret"}
    some label in required_labels
    not input.metadata.labels[label]
    msg := sprintf("Falta la etiqueta obligatoria: '%s'", [label])
}

# Validar valores de environment
valid_environments := {"dev", "test", "prod", "qa"}

invalid_environment contains msg if {
    input.metadata.labels["mx.gob.vucem/environment"]
    env := input.metadata.labels["mx.gob.vucem/environment"]
    not env in valid_environments
    msg := sprintf("Environment inválido: '%s'. Debe ser uno de: %v", [env, valid_environments])
}

# ============================================================================
# POLÍTICAS DE SERVICIOS Y NETWORKING
# ============================================================================

# Prohibir servicios NodePort en producción
deny_nodeport_in_prod contains msg if {
    input.kind == "Service"
    input.spec.type == "NodePort"
    input.metadata.labels["mx.gob.vucem/environment"] == "prod"
    msg := "Los servicios NodePort no están permitidos en producción"
}

# Requerir TLS para Ingress en producción
require_tls_ingress contains msg if {
    input.kind == "Ingress"
    input.metadata.labels["mx.gob.vucem/environment"] == "prod"
    not input.spec.tls
    msg := "Los Ingress en producción deben tener TLS configurado"
}

# ============================================================================
# POLÍTICAS DE SECRETOS Y CONFIGURACIÓN
# ============================================================================

# Prohibir secretos hardcodeados en ConfigMaps
deny_secrets_in_configmap contains msg if {
    input.kind == "ConfigMap"
    some key, value in input.data
    regex.match("(?i)(password|secret|key|token)", key)
    msg := sprintf("Posible secreto en ConfigMap: clave '%s'", [key])
}

deny_secrets_in_configmap contains msg if {
    input.kind == "ConfigMap"
    some key, value in input.data
    regex.match("(?i)(password|secret|key|token)", value)
    msg := sprintf("Posible secreto hardcodeado en ConfigMap: valor de '%s'", [key])
}

# Requerir cifrado en secretos sensibles
require_encryption_labels contains msg if {
    input.kind == "Secret"
    input.type != "kubernetes.io/service-account-token"
    not input.metadata.labels["encryption.vucem.gob.mx/enabled"]
    msg := "Los secretos deben tener la etiqueta de cifrado habilitada"
}

# ============================================================================
# POLÍTICAS ESPECÍFICAS PARA VUCEM
# ============================================================================

# Validar naming convention para componentes VUCEM
invalid_component_name contains msg if {
    input.metadata.labels["mx.gob.vucem/component"]
    component := input.metadata.labels["mx.gob.vucem/component"]
    not regex.match("^vucem-[a-z0-9-]+$", component)
    msg := sprintf("Nombre de componente inválido: '%s'. Debe seguir el patrón 'vucem-*'", [component])
}

# Requerir anotaciones de compliance
require_compliance_annotations contains msg if {
    input.kind in {"Deployment", "StatefulSet", "DaemonSet"}
    input.metadata.labels["mx.gob.vucem/environment"] == "prod"
    not input.metadata.annotations["compliance.vucem.gob.mx/reviewed"]
    msg := "Los recursos de producción deben tener anotación de compliance"
}

# ============================================================================
# POLÍTICAS DE VOLÚMENES Y ALMACENAMIENTO
# ============================================================================

# Prohibir hostPath volumes
deny_hostpath_volumes contains msg if {
    input.kind == "Pod"
    some volume in input.spec.volumes
    volume.hostPath
    msg := sprintf("El volumen hostPath '%s' no está permitido", [volume.name])
}

# Requerir storageClass específicas para datos persistentes
allowed_storage_classes := {"fast-ssd", "standard", "backup"}

invalid_storage_class contains msg if {
    input.kind == "PersistentVolumeClaim"
    storage_class := input.spec.storageClassName
    storage_class != ""
    not storage_class in allowed_storage_classes
    msg := sprintf("StorageClass no autorizada: '%s'", [storage_class])
}

# ============================================================================
# FUNCIÓN PRINCIPAL DE VALIDACIÓN
# ============================================================================

# Combinar todas las violaciones
violations := array.concat([
    deny_root_user,
    deny_privileged_containers,
    deny_host_namespaces,
    require_resource_limits,
    deny_unauthorized_registries,
    deny_latest_tag,
    deny_no_tag,
    missing_required_labels,
    invalid_environment,
    deny_nodeport_in_prod,
    require_tls_ingress,
    deny_secrets_in_configmap,
    require_encryption_labels,
    invalid_component_name,
    require_compliance_annotations,
    deny_hostpath_volumes,
    invalid_storage_class
], [])

# Resultado final
allow if {
    count(violations) == 0
}

# Mensaje de respuesta
response := {
    "allowed": count(violations) == 0,
    "message": violations
}