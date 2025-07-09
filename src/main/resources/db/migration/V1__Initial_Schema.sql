-- Script de migración inicial para la creación del esquema de base de datos
-- Versión: 1.0

-- Tabla de recursos
CREATE TABLE recursos (
    id UUID PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(500),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    atributos JSONB,
    fecha_creacion TIMESTAMP NOT NULL,
    fecha_modificacion TIMESTAMP,
    creado_por VARCHAR(50) NOT NULL,
    modificado_por VARCHAR(50),
    CONSTRAINT uk_recursos_nombre UNIQUE (nombre)
);

-- Índices para búsqueda y rendimiento
CREATE INDEX idx_recursos_nombre ON recursos (nombre);
CREATE INDEX idx_recursos_activo ON recursos (activo);

-- Tabla de usuarios para autenticación
CREATE TABLE usuarios (
    id UUID PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL,
    nombre_completo VARCHAR(100),
    email VARCHAR(100),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    bloqueado BOOLEAN NOT NULL DEFAULT FALSE,
    fecha_ultimo_acceso TIMESTAMP,
    intentos_fallidos INTEGER NOT NULL DEFAULT 0,
    fecha_creacion TIMESTAMP NOT NULL,
    fecha_modificacion TIMESTAMP,
    creado_por VARCHAR(50) NOT NULL,
    modificado_por VARCHAR(50),
    CONSTRAINT uk_usuarios_username UNIQUE (username),
    CONSTRAINT uk_usuarios_email UNIQUE (email)
);

-- Tabla de roles
CREATE TABLE roles (
    id UUID PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL,
    fecha_modificacion TIMESTAMP,
    creado_por VARCHAR(50) NOT NULL,
    modificado_por VARCHAR(50),
    CONSTRAINT uk_roles_nombre UNIQUE (nombre)
);

-- Tabla de asignación de roles a usuarios
CREATE TABLE usuarios_roles (
    usuario_id UUID NOT NULL,
    rol_id UUID NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL,
    fecha_modificacion TIMESTAMP,
    creado_por VARCHAR(50) NOT NULL,
    modificado_por VARCHAR(50),
    PRIMARY KEY (usuario_id, rol_id),
    CONSTRAINT fk_usuarios_roles_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios (id),
    CONSTRAINT fk_usuarios_roles_rol FOREIGN KEY (rol_id) REFERENCES roles (id)
);

-- Tabla de permisos
CREATE TABLE permisos (
    id UUID PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(200),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL,
    fecha_modificacion TIMESTAMP,
    creado_por VARCHAR(50) NOT NULL,
    modificado_por VARCHAR(50),
    CONSTRAINT uk_permisos_nombre UNIQUE (nombre)
);

-- Tabla de asignación de permisos a roles
CREATE TABLE roles_permisos (
    rol_id UUID NOT NULL,
    permiso_id UUID NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL,
    fecha_modificacion TIMESTAMP,
    creado_por VARCHAR(50) NOT NULL,
    modificado_por VARCHAR(50),
    PRIMARY KEY (rol_id, permiso_id),
    CONSTRAINT fk_roles_permisos_rol FOREIGN KEY (rol_id) REFERENCES roles (id),
    CONSTRAINT fk_roles_permisos_permiso FOREIGN KEY (permiso_id) REFERENCES permisos (id)
);

-- Tabla de auditoría para registro de eventos
CREATE TABLE auditoria (
    id BIGSERIAL PRIMARY KEY,
    tipo_evento VARCHAR(50) NOT NULL,
    entidad VARCHAR(100) NOT NULL,
    entidad_id VARCHAR(100),
    datos_previos JSONB,
    datos_nuevos JSONB,
    usuario VARCHAR(50) NOT NULL,
    direccion_ip VARCHAR(45),
    fecha_hora TIMESTAMP NOT NULL,
    detalles VARCHAR(500)
);

-- Índices para búsqueda en auditoría
CREATE INDEX idx_auditoria_tipo_evento ON auditoria (tipo_evento);
CREATE INDEX idx_auditoria_entidad ON auditoria (entidad);
CREATE INDEX idx_auditoria_usuario ON auditoria (usuario);
CREATE INDEX idx_auditoria_fecha_hora ON auditoria (fecha_hora);

-- Inserciones iniciales
-- Rol de administrador
INSERT INTO roles (id, nombre, descripcion, activo, fecha_creacion, creado_por)
VALUES (
    '00000000-0000-0000-0000-000000000001',
    'ADMINISTRADOR',
    'Rol con acceso completo al sistema',
    TRUE,
    CURRENT_TIMESTAMP,
    'SISTEMA'
);

-- Rol de usuario estándar
INSERT INTO roles (id, nombre, descripcion, activo, fecha_creacion, creado_por)
VALUES (
    '00000000-0000-0000-0000-000000000002',
    'USUARIO',
    'Rol con acceso limitado a funciones básicas',
    TRUE,
    CURRENT_TIMESTAMP,
    'SISTEMA'
);

-- Permisos básicos
INSERT INTO permisos (id, nombre, descripcion, activo, fecha_creacion, creado_por)
VALUES 
    ('00000000-0000-0000-0000-000000000001', 'RECURSOS_LEER', 'Permiso para consultar recursos', TRUE, CURRENT_TIMESTAMP, 'SISTEMA'),
    ('00000000-0000-0000-0000-000000000002', 'RECURSOS_CREAR', 'Permiso para crear recursos', TRUE, CURRENT_TIMESTAMP, 'SISTEMA'),
    ('00000000-0000-0000-0000-000000000003', 'RECURSOS_ACTUALIZAR', 'Permiso para actualizar recursos', TRUE, CURRENT_TIMESTAMP, 'SISTEMA'),
    ('00000000-0000-0000-0000-000000000004', 'RECURSOS_ELIMINAR', 'Permiso para eliminar recursos', TRUE, CURRENT_TIMESTAMP, 'SISTEMA'),
    ('00000000-0000-0000-0000-000000000005', 'USUARIOS_ADMINISTRAR', 'Permiso para administrar usuarios', TRUE, CURRENT_TIMESTAMP, 'SISTEMA');

-- Asignación de permisos al rol administrador
INSERT INTO roles_permisos (rol_id, permiso_id, fecha_creacion, creado_por)
VALUES 
    ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', CURRENT_TIMESTAMP, 'SISTEMA'),
    ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000002', CURRENT_TIMESTAMP, 'SISTEMA'),
    ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000003', CURRENT_TIMESTAMP, 'SISTEMA'),
    ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000004', CURRENT_TIMESTAMP, 'SISTEMA'),
    ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000005', CURRENT_TIMESTAMP, 'SISTEMA');

-- Asignación de permisos al rol usuario
INSERT INTO roles_permisos (rol_id, permiso_id, fecha_creacion, creado_por)
VALUES 
    ('00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000001', CURRENT_TIMESTAMP, 'SISTEMA');

-- Usuario administrador (password: admin123 - codificada con BCrypt)
INSERT INTO usuarios (id, username, password, nombre_completo, email, activo, fecha_creacion, creado_por)
VALUES (
    '00000000-0000-0000-0000-000000000001',
    'admin',
    '$2a$10$rPiEAgQNIT1TCoKi3Eqq8eVaRaAKgdh9xS.mIz9m1JBKt0jJsCdx.',
    'Administrador del Sistema',
    'admin@vucem.gob.mx',
    TRUE,
    CURRENT_TIMESTAMP,
    'SISTEMA'
);

-- Asignación del rol de administrador al usuario administrador
INSERT INTO usuarios_roles (usuario_id, rol_id, fecha_creacion, creado_por)
VALUES (
    '00000000-0000-0000-0000-000000000001',
    '00000000-0000-0000-0000-000000000001',
    CURRENT_TIMESTAMP,
    'SISTEMA'
);

-- Recurso de ejemplo
INSERT INTO recursos (id, nombre, descripcion, activo, atributos, fecha_creacion, creado_por)
VALUES (
    '00000000-0000-0000-0000-000000000001',
    'Recurso de ejemplo',
    'Este es un recurso de ejemplo para mostrar la estructura de datos',
    TRUE,
    '{"tipo": "ejemplo", "prioridad": "alta"}',
    CURRENT_TIMESTAMP,
    'SISTEMA'
);