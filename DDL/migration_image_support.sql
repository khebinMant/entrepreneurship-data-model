-- =========================
-- MIGRACIÓN: SOPORTE DE IMÁGENES
-- =========================
-- Fecha: Mayo 2026
-- Descripción: Agrega soporte completo para imágenes en la plataforma
-- Aplicable a: Bases de datos existentes creadas antes de este update

-- ADVERTENCIA: Ejecutar este script solo si su base de datos NO tiene estos cambios

BEGIN;

-- 1. Agregar campo de imagen de portada a eventos
ALTER TABLE event ADD COLUMN IF NOT EXISTS cover_image_url TEXT;

COMMENT ON COLUMN event.cover_image_url IS 'URL de imagen de portada del evento en Digital Ocean Spaces';

-- 2. Eliminar tabla antigua de galería (si existe)
-- NOTA: Esto eliminará datos existentes. Migrar datos antes de ejecutar si es necesario.
DROP TABLE IF EXISTS entrepreneurship_gallery CASCADE;

-- 3. Crear nueva tabla genérica de galerías
CREATE TABLE IF NOT EXISTS image_gallery (
    image_id BIGINT GENERATED ALWAYS AS IDENTITY,
    entity_type VARCHAR(50) NOT NULL,
    entity_id BIGINT NOT NULL,
    image_url TEXT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    display_order INTEGER NOT NULL DEFAULT 0,
    alt_text VARCHAR(255),
    description TEXT,
    file_size_kb INTEGER,
    width_px INTEGER,
    height_px INTEGER,
    mime_type VARCHAR(50),
    uploaded_by_user_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP,
    CONSTRAINT pk_image_gallery PRIMARY KEY (image_id),
    CONSTRAINT chk_image_gallery_entity_type CHECK (entity_type IN ('USER', 'ENTREPRENEURSHIP', 'EVENT')),
    CONSTRAINT fk_image_gallery_uploader FOREIGN KEY (uploaded_by_user_id) REFERENCES app_user (user_id)
);

-- 4. Crear índices para mejor performance
CREATE INDEX IF NOT EXISTS idx_image_gallery_entity ON image_gallery (entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_image_gallery_order ON image_gallery (entity_type, entity_id, display_order);

-- 5. Agregar comentarios
COMMENT ON TABLE image_gallery IS 'Almacena URLs de imágenes de galerías para usuarios, emprendimientos y eventos';
COMMENT ON COLUMN image_gallery.entity_type IS 'Tipo de entidad: USER, ENTREPRENEURSHIP o EVENT';
COMMENT ON COLUMN image_gallery.entity_id IS 'ID de la entidad (user_id, entrepreneurship_id o event_id)';
COMMENT ON COLUMN image_gallery.image_url IS 'URL completa de Digital Ocean Spaces';
COMMENT ON COLUMN image_gallery.display_order IS 'Orden de visualización en la galería (menor número = primera posición)';

COMMIT;

-- =========================
-- VERIFICACIÓN POST-MIGRACIÓN
-- =========================
-- Ejecutar estas consultas para verificar que la migración fue exitosa:

-- Verificar que el campo cover_image_url existe en event
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'event' AND column_name = 'cover_image_url';

-- Verificar que la tabla image_gallery fue creada correctamente
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'image_gallery'
ORDER BY ordinal_position;

-- Verificar constraints
SELECT constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE table_name = 'image_gallery';

-- Verificar índices
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'image_gallery';
