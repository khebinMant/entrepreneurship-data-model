# Guía de Implementación - Sistema de Imágenes

## 📸 Resumen

El sistema de imágenes está diseñado para integrarse con **Digital Ocean Spaces** y soporta:

- ✅ **Fotos de perfil** de usuarios (principal + galería)
- ✅ **Logos** de emprendimientos  
- ✅ **Imágenes de portada** de eventos
- ✅ **Galerías de imágenes** para usuarios, emprendimientos y eventos

---

## 🏗️ Arquitectura

### Imágenes Principales (1 por entidad)
Se almacenan como campos **TEXT** directamente en las tablas:

| Tabla | Campo | Descripción |
|-------|-------|-------------|
| `app_user` | `profile_picture_url` | Foto de perfil del usuario |
| `entrepreneurship` | `logo_url` | Logo del emprendimiento |
| `event` | `cover_image_url` | Imagen de portada del evento |

### Galerías de Imágenes (múltiples por entidad)
Se usa la tabla genérica **`image_gallery`** para almacenar colecciones de imágenes.

---

## 📁 Estructura de URLs en Digital Ocean Spaces

```
bucket-name/
├── users/
│   └── {userId}/
│       ├── profile.jpg
│       └── gallery/
│           ├── img1.jpg
│           ├── img2.jpg
│           └── img3.jpg
│
├── entrepreneurships/
│   └── {entrepreneurshipId}/
│       ├── logo.jpg
│       └── gallery/
│           ├── img1.jpg
│           ├── img2.jpg
│           └── img3.jpg
│
└── events/
    └── {eventId}/
        ├── cover.jpg
        └── gallery/
            ├── img1.jpg
            ├── img2.jpg
            └── img3.jpg
```

### Ejemplo de URLs completas:
```
https://my-bucket.nyc3.digitaloceanspaces.com/users/15/profile.jpg
https://my-bucket.nyc3.digitaloceanspaces.com/users/15/gallery/img1.jpg
https://my-bucket.nyc3.digitaloceanspaces.com/entrepreneurships/42/logo.jpg
https://my-bucket.nyc3.digitaloceanspaces.com/entrepreneurships/42/gallery/img1.jpg
https://my-bucket.nyc3.digitaloceanspaces.com/events/8/cover.jpg
https://my-bucket.nyc3.digitaloceanspaces.com/events/8/gallery/photo1.jpg
```

---

## 💻 Ejemplos de Uso SQL

### 1. Actualizar foto de perfil de usuario
```sql
UPDATE app_user 
SET profile_picture_url = 'https://bucket.nyc3.digitaloceanspaces.com/users/15/profile.jpg',
    updated_at = now()
WHERE user_id = 15;
```

### 2. Actualizar logo de emprendimiento
```sql
UPDATE entrepreneurship 
SET logo_url = 'https://bucket.nyc3.digitaloceanspaces.com/entrepreneurships/42/logo.jpg',
    updated_at = now()
WHERE entrepreneurship_id = 42;
```

### 3. Actualizar portada de evento
```sql
UPDATE event 
SET cover_image_url = 'https://bucket.nyc3.digitaloceanspaces.com/events/8/cover.jpg'
WHERE event_id = 8;
```

### 4. Agregar imagen a galería de emprendimiento
```sql
INSERT INTO image_gallery (
    entity_type,
    entity_id,
    image_url,
    file_name,
    display_order,
    alt_text,
    file_size_kb,
    width_px,
    height_px,
    mime_type,
    uploaded_by_user_id
) VALUES (
    'ENTREPRENEURSHIP',
    42,
    'https://bucket.nyc3.digitaloceanspaces.com/entrepreneurships/42/gallery/img1.jpg',
    'producto_artesanal.jpg',
    1,
    'Producto artesanal hecho a mano',
    245,
    1920,
    1080,
    'image/jpeg',
    15
);
```

### 5. Agregar imagen a galería de evento
```sql
INSERT INTO image_gallery (
    entity_type,
    entity_id,
    image_url,
    file_name,
    display_order,
    uploaded_by_user_id
) VALUES (
    'EVENT',
    8,
    'https://bucket.nyc3.digitaloceanspaces.com/events/8/gallery/photo1.jpg',
    'feria_ambiente.jpg',
    1,
    7
);
```

### 6. Agregar imagen a galería de usuario
```sql
INSERT INTO image_gallery (
    entity_type,
    entity_id,
    image_url,
    file_name,
    display_order,
    alt_text,
    uploaded_by_user_id
) VALUES (
    'USER',
    15,
    'https://bucket.nyc3.digitaloceanspaces.com/users/15/gallery/photo1.jpg',
    'mi_certificado.jpg',
    1,
    'Certificado de emprendimiento',
    15
);
```

### 7. Obtener galería completa de un emprendimiento (ordenada)
```sql
SELECT 
    image_id,
    image_url,
    file_name,
    alt_text,
    description,
    display_order,
    created_at
FROM image_gallery
WHERE entity_type = 'ENTREPRENEURSHIP' 
  AND entity_id = 42
ORDER BY display_order ASC;
```

### 8. Obtener toda la información de imágenes de un usuario
```sql
-- Foto de perfil principal
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.profile_picture_url AS main_profile_pic
FROM app_user u
WHERE u.user_id = 15;

-- Galería adicional
SELECT 
    ig.image_url,
    ig.file_name,
    ig.alt_text,
    ig.display_order
FROM image_gallery ig
WHERE ig.entity_type = 'USER' 
  AND ig.entity_id = 15
ORDER BY ig.display_order;
```

### 9. Obtener toda la información de imágenes de un emprendimiento
```sql
-- Logo principal
SELECT 
    e.entrepreneurship_id,
    e.name,
    e.logo_url AS main_logo
FROM entrepreneurship e
WHERE e.entrepreneurship_id = 42;

-- Galería
SELECT 
    ig.image_url,
    ig.file_name,
    ig.alt_text,
    ig.display_order
FROM image_gallery ig
WHERE ig.entity_type = 'ENTREPRENEURSHIP' 
  AND ig.entity_id = 42
ORDER BY ig.display_order;
```

### 10. Reordenar imágenes de una galería
```sql
-- Cambiar orden de una imagen específica
UPDATE image_gallery 
SET display_order = 3,
    updated_at = now()
WHERE image_id = 156;

-- Mover una imagen al principio
UPDATE image_gallery 
SET display_order = 0,
    updated_at = now()
WHERE image_id = 158;
```

### 11. Eliminar una imagen de la galería
```sql
DELETE FROM image_gallery 
WHERE image_id = 156;

-- NOTA: La aplicación debe también eliminar el archivo de Digital Ocean Spaces
```

### 12. Obtener estadísticas de imágenes por emprendimiento
```sql
SELECT 
    e.entrepreneurship_id,
    e.name,
    COUNT(ig.image_id) AS total_gallery_images,
    SUM(ig.file_size_kb) AS total_size_kb,
    AVG(ig.width_px) AS avg_width,
    AVG(ig.height_px) AS avg_height
FROM entrepreneurship e
LEFT JOIN image_gallery ig 
    ON ig.entity_type = 'ENTREPRENEURSHIP' 
    AND ig.entity_id = e.entrepreneurship_id
GROUP BY e.entrepreneurship_id, e.name;
```

---

## 🔒 Validaciones Recomendadas en la Aplicación

### Backend debe validar:
1. **Formato de archivo**: solo JPEG, PNG, WebP, GIF
2. **Tamaño máximo**: 
   - Fotos de perfil: 2 MB
   - Logos: 1 MB
   - Galería: 5 MB por imagen
3. **Dimensiones**:
   - Fotos de perfil: mínimo 200x200px
   - Logos: mínimo 300x300px
   - Galería: mínimo 800x600px
4. **Integridad referencial polimórfica**:
   - Verificar que `entity_id` existe en la tabla correspondiente
   - Si `entity_type = 'USER'`, validar que existe en `app_user`
   - Si `entity_type = 'ENTREPRENEURSHIP'`, validar que existe en `entrepreneurship`
   - Si `entity_type = 'EVENT'`, validar que existe en `event`
5. **Límites de galería**:
   - Máximo 5 imágenes por usuario
   - Máximo 10 imágenes por emprendimiento
   - Máximo 20 imágenes por evento

### Ejemplo de validación (pseudocódigo):
```javascript
async function uploadImageToGallery(entityType, entityId, file, userId) {
    // 1. Validar tipo de entidad
    if (!['USER', 'ENTREPRENEURSHIP', 'EVENT'].includes(entityType)) {
        throw new Error('Invalid entity type');
    }
    
    // 2. Verificar que la entidad existe
    if (entityType === 'USER') {
        const exists = await db.query(
            'SELECT 1 FROM app_user WHERE user_id = $1',
            [entityId]
        );
        if (!exists.rows.length) throw new Error('User not found');
    } else if (entityType === 'ENTREPRENEURSHIP') {
        const exists = await db.query(
            'SELECT 1 FROM entrepreneurship WHERE entrepreneurship_id = $1',
            [entityId]
        );
        if (!exists.rows.length) throw new Error('Entrepreneurship not found');
    } else if (entityType === 'EVENT') {
        const exists = await db.query(
            'SELECT 1 FROM event WHERE event_id = $1',
            [entityId]
        );
        if (!exists.rows.length) throw new Error('Event not found');
    }
    
    // 3. Verificar límite de imágenes
    const count = await db.query(
        'SELECT COUNT(*) FROM image_gallery WHERE entity_type = $1 AND entity_id = $2',
        [entityType, entityId]
    );
    const maxImages = entityType === 'EVENT' ? 20 : (entityType === 'ENTREPRENEURSHIP' ? 10 : 5);
    if (count.rows[0].count >= maxImages) {
        throw new Error(`Maximum ${maxImages} images allowed`);
    }
    
    // 4. Subir a Digital Ocean
    const url = await uploadToSpaces(file, entityType, entityId);
    
    // 5. Guardar en BD
    await db.query(
        `INSERT INTO image_gallery (
            entity_type, entity_id, image_url, file_name, 
            display_order, file_size_kb, width_px, height_px, 
            mime_type, uploaded_by_user_id
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)`,
        [entityType, entityId, url, file.name, 
         nextOrder, file.size/1024, file.width, file.height,
         file.mimetype, userId]
    );
}
```

---

## 🚀 Flujo de Trabajo Completo

### Subir una imagen:
1. Usuario selecciona archivo en frontend
2. Frontend valida tamaño y formato
3. Frontend envía a backend con metadatos
4. Backend valida permisos y constraints
5. Backend sube archivo a Digital Ocean Spaces
6. Backend guarda URL en PostgreSQL
7. Backend retorna URL pública al frontend

### Eliminar una imagen:
1. Frontend solicita eliminación
2. Backend valida permisos
3. Backend elimina registro de PostgreSQL
4. Backend elimina archivo de Digital Ocean Spaces
5. Backend confirma eliminación

---

## 📊 Casos de Uso por Entidad

### Usuario (USER)
- **Campo principal**: `app_user.profile_picture_url` - Foto de perfil principal
- **Galería**: Fotos adicionales (certificados, premios, momentos destacados)
- **Límite**: 5 imágenes adicionales en galería

### Emprendimiento (ENTREPRENEURSHIP)
- **Campo principal**: `entrepreneurship.logo_url` - Logo del emprendimiento
- **Galería**: Productos, instalaciones, equipo de trabajo, procesos
- **Límite**: 10 imágenes en galería

### Evento (EVENT)
- **Campo principal**: `event.cover_image_url` - Imagen de portada del evento
- **Galería**: Momentos del evento, espacios, actividades, stands
- **Límite**: 20 imágenes en galería

---

## 📊 Campos Opcionales vs Requeridos

### Campos Requeridos:
- `entity_type`
- `entity_id`
- `image_url`
- `file_name`
- `uploaded_by_user_id`

### Campos Opcionales pero Recomendados:
- `display_order` (default: 0)
- `alt_text` (importante para accesibilidad)
- `file_size_kb`
- `width_px`, `height_px`
- `mime_type`
- `description`

---

## 🎨 Frontend - Sugerencias de UI/UX

### Vista de Galería:
```jsx
// Ejemplo conceptual en React
<ImageGallery>
  {images.map((img, index) => (
    <ImageCard 
      key={img.image_id}
      src={img.image_url}
      alt={img.alt_text || img.file_name}
      order={img.display_order}
      onReorder={(newOrder) => updateOrder(img.image_id, newOrder)}
      onDelete={() => deleteImage(img.image_id)}
    />
  ))}
</ImageGallery>
```

### Drag & Drop para reordenar:
- Usar `display_order` para ordenamiento
- Permitir arrastrar y soltar imágenes
- Actualizar `display_order` en BD cuando cambie el orden

---

## 📝 Notas Importantes

1. **Las URLs son públicas**: Digital Ocean Spaces puede configurarse con URLs públicas o firmadas. Decidir según requisitos de seguridad.

2. **Versionado de imágenes**: Si se requiere historial, considerar agregar campos `version` o `replaced_by_image_id`.

3. **Thumbnails**: La aplicación puede generar miniaturas y guardar URLs adicionales o usar parámetros de transformación en el CDN.

4. **CDN**: Configurar CloudFlare o el CDN de Digital Ocean para mejor performance global.

5. **Backup**: Configurar replicación y backup automático en Digital Ocean Spaces.

---

## 🔗 Referencias

- [Digital Ocean Spaces Documentation](https://docs.digitalocean.com/products/spaces/)
- [PostgreSQL Text Type](https://www.postgresql.org/docs/current/datatype-character.html)
- [Image Optimization Best Practices](https://web.dev/fast/#optimize-your-images)
