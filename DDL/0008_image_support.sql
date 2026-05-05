-- =========================
-- IMAGE SUPPORT
-- =========================
-- Este archivo agrega soporte para imágenes en la plataforma
-- Integración con Digital Ocean Spaces

-- Agregar campo de imagen de portada a eventos
ALTER TABLE event ADD COLUMN cover_image_url TEXT;

-- Tabla para manejar galerías de imágenes
CREATE TABLE image_gallery (
    image_id BIGINT GENERATED ALWAYS AS IDENTITY,
    entity_type VARCHAR(50) NOT NULL, -- 'USER', 'ENTREPRENEURSHIP', 'EVENT'
    entity_id BIGINT NOT NULL, -- ID de la entidad relacionada
    image_url TEXT NOT NULL, -- URL completa de Digital Ocean
    file_name VARCHAR(255) NOT NULL, -- Nombre del archivo original
    display_order INTEGER NOT NULL DEFAULT 0, -- Orden de visualización
    alt_text VARCHAR(255), -- Texto alternativo para accesibilidad
    description TEXT, -- Descripción opcional de la imagen
    file_size_kb INTEGER, -- Tamaño del archivo en KB
    width_px INTEGER, -- Ancho de la imagen en pixeles
    height_px INTEGER, -- Alto de la imagen en pixeles
    mime_type VARCHAR(50), -- Tipo MIME (image/jpeg, image/png, etc.)
    uploaded_by_user_id BIGINT NOT NULL, -- Usuario que subió la imagen
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP
);

ALTER TABLE image_gallery ADD CONSTRAINT pk_image_gallery PRIMARY KEY (image_id);

-- Índice compuesto para búsquedas eficientes por entidad
CREATE INDEX idx_image_gallery_entity ON image_gallery (entity_type, entity_id);

-- Índice para ordenamiento
CREATE INDEX idx_image_gallery_order ON image_gallery (entity_type, entity_id, display_order);

-- Constraint para validar entity_type
ALTER TABLE image_gallery ADD CONSTRAINT chk_image_gallery_entity_type 
    CHECK (entity_type IN ('USER', 'ENTREPRENEURSHIP', 'EVENT'));

COMMENT ON TABLE image_gallery IS 'Almacena URLs de imágenes de galerías para usuarios, emprendimientos y eventos';
COMMENT ON COLUMN image_gallery.entity_type IS 'Tipo de entidad: USER, ENTREPRENEURSHIP o EVENT';
COMMENT ON COLUMN image_gallery.entity_id IS 'ID de la entidad (user_id, entrepreneurship_id o event_id)';
COMMENT ON COLUMN image_gallery.image_url IS 'URL completa de Digital Ocean Spaces (ej: bucket/entrepreneurships/{id}/gallery/img1.jpg)';
COMMENT ON COLUMN image_gallery.display_order IS 'Orden de visualización en la galería (menor número = primera posición)';
COMMENT ON COLUMN event.cover_image_url IS 'URL de imagen de portada del evento en Digital Ocean Spaces';
