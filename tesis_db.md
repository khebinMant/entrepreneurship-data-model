# Base de Datos - Plataforma de Emprendimientos

## 📋 Resumen Ejecutivo

Este proyecto de tesis implementa una **plataforma de gestión de emprendimientos y eventos** diseñada para conectar emprendedores, gestionar eventos (físicos y virtuales), y facilitar la participación de emprendimientos en ferias y exposiciones.

La base de datos utiliza **PostgreSQL** y está organizada en **dominios funcionales** con una estructura modular y escalable.

---

## 🏗️ Arquitectura General

### Principios de Diseño
- **Separación por dominios**: Cada funcionalidad tiene su propio conjunto de tablas
- **Uso de catálogos**: Sistema centralizado de valores configurables (`catalogue_type` y `catalogue_value`)
- **Auditoría temporal**: Campos `created_at` y `updated_at` en todas las tablas
- **Identidad autogenerada**: Uso de `GENERATED ALWAYS AS IDENTITY` para PKs
- **Integridad referencial**: FKs explícitas con nombres descriptivos

### Dominios Implementados
1. **User Domain** (Usuarios) - Gestión de usuarios y sus datos
2. **Entrepreneurship Domain** (Emprendimientos) - Negocios y su información
3. **Event Domain** (Eventos) - Eventos, espacios e invitaciones
4. **Shared Domain** (Catálogos) - Valores compartidos y configurables
5. **Metrics Domain** (Métricas) - *Preparado para futuro*
6. **Notification Domain** (Notificaciones) - *Preparado para futuro*

---

## 👥 1. USER DOMAIN (Dominio de Usuarios)

### Objetivo
Gestionar usuarios de la plataforma con autenticación mediante Keycloak y múltiples datos de contacto e identificación.

### Tablas

#### 1.1 `app_user`
Tabla principal de usuarios del sistema.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `user_id` | BIGINT | PK autoincremental |
| `keycloak_id` | VARCHAR(100) | ID único de Keycloak (UK) |
| `first_name` | VARCHAR(100) | Nombre del usuario |
| `last_name` | VARCHAR(100) | Apellido del usuario |
| `profile_picture_url` | TEXT | URL de foto de perfil |
| `created_at` | TIMESTAMP | Fecha de creación |
| `updated_at` | TIMESTAMP | Fecha de última actualización |

**Constraints:**
- PK: `pk_app_user` en `user_id`
- UK: `uk_app_user_keycloak` en `keycloak_id`

---

#### 1.2 `user_contact`
Información de contacto del usuario (teléfonos, emails).

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `user_contact_id` | BIGINT | PK autoincremental |
| `user_id` | BIGINT | FK → `app_user` |
| `contact_type_id` | BIGINT | FK → `catalogue_value` (PHONE/EMAIL) |
| `contact_value` | VARCHAR(150) | Valor del contacto |
| `is_primary` | BOOLEAN | ¿Es contacto principal? |
| `created_at` | TIMESTAMP | Fecha de creación |

**Relaciones:**
- Un usuario puede tener múltiples contactos
- Permite marcar uno como principal

---

#### 1.3 `user_address`
Direcciones físicas del usuario.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `user_address_id` | BIGINT | PK autoincremental |
| `user_id` | BIGINT | FK → `app_user` |
| `country_id` | BIGINT | FK → `catalogue_value` (País) |
| `province_id` | BIGINT | FK → `catalogue_value` (Provincia) |
| `city_id` | BIGINT | FK → `catalogue_value` (Ciudad) |
| `parish_id` | BIGINT | FK → `catalogue_value` (Parroquia) |
| `address_line` | TEXT | Dirección completa |
| `reference` | TEXT | Referencia de ubicación |
| `is_primary` | BOOLEAN | ¿Es dirección principal? |
| `created_at` | TIMESTAMP | Fecha de creación |

**Diseño:**
- Ubicación geográfica jerárquica (País → Provincia → Ciudad → Parroquia)
- Permite múltiples direcciones por usuario

---

#### 1.4 `user_identification`
Documentos de identificación del usuario.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `user_identification_id` | BIGINT | PK autoincremental |
| `user_id` | BIGINT | FK → `app_user` |
| `identification_type_id` | BIGINT | FK → `catalogue_value` (CEDULA/RUC/PASSPORT) |
| `identification_number` | VARCHAR(30) | Número del documento |
| `issued_country_id` | BIGINT | FK → `catalogue_value` (País emisor) |
| `created_at` | TIMESTAMP | Fecha de creación |

**Constraints:**
- UK: `uk_user_identification_unique` en (`identification_type_id`, `identification_number`)
- Garantiza que no existen identificaciones duplicadas

---

## 🏪 2. ENTREPRENEURSHIP DOMAIN (Dominio de Emprendimientos)

### Objetivo
Gestionar emprendimientos, sus ubicaciones, redes sociales, galerías de imágenes y portales personalizados.

### Tablas

#### 2.1 `category`
Categorías de emprendimientos (Gastronomía, Artesanías, Tecnología, etc.).

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `category_id` | BIGINT | PK autoincremental |
| `name` | VARCHAR(100) | Nombre de categoría (UK) |
| `description` | TEXT | Descripción de la categoría |
| `created_at` | TIMESTAMP | Fecha de creación |

---

#### 2.2 `entrepreneurship`
Tabla principal de emprendimientos.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `entrepreneurship_id` | BIGINT | PK autoincremental |
| `user_id` | BIGINT | FK → `app_user` (Dueño) |
| `category_id` | BIGINT | FK → `category` |
| `name` | VARCHAR(150) | Nombre del emprendimiento |
| `description` | TEXT | Descripción del negocio |
| `logo_url` | TEXT | URL del logo |
| `is_physical` | BOOLEAN | ¿Tiene presencia física? |
| `is_digital` | BOOLEAN | ¿Tiene presencia digital? |
| `created_at` | TIMESTAMP | Fecha de creación |
| `updated_at` | TIMESTAMP | Fecha de actualización |

**Características:**
- Un emprendimiento pertenece a un usuario
- Puede ser físico, digital o ambos
- Vinculado a una categoría específica

---

#### 2.3 `entrepreneurship_location`
Ubicación física del emprendimiento.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `location_id` | BIGINT | PK autoincremental |
| `entrepreneurship_id` | BIGINT | FK → `entrepreneurship` |
| `country_id` | BIGINT | FK → `catalogue_value` |
| `province_id` | BIGINT | FK → `catalogue_value` |
| `city_id` | BIGINT | FK → `catalogue_value` |
| `parish_id` | BIGINT | FK → `catalogue_value` |
| `address_line` | TEXT | Dirección completa |
| `latitude` | DECIMAL(9,6) | Coordenada GPS |
| `longitude` | DECIMAL(9,6) | Coordenada GPS |
| `created_at` | TIMESTAMP | Fecha de creación |

**Funcionalidad:**
- Permite geolocalización precisa
- Ubicación jerárquica (País → Provincia → Ciudad → Parroquia)

---

#### 2.4 `entrepreneurship_social_link`
Redes sociales del emprendimiento.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `social_link_id` | BIGINT | PK autoincremental |
| `entrepreneurship_id` | BIGINT | FK → `entrepreneurship` |
| `social_platform_id` | BIGINT | FK → `catalogue_value` (FACEBOOK/INSTAGRAM/WHATSAPP) |
| `url` | TEXT | URL o link de la red social |
| `created_at` | TIMESTAMP | Fecha de creación |

---

#### 2.5 `entrepreneurship_gallery`
Galería de imágenes del emprendimiento.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `gallery_id` | BIGINT | PK autoincremental |
| `entrepreneurship_id` | BIGINT | FK → `entrepreneurship` |
| `image_url` | TEXT | URL de la imagen |
| `created_at` | TIMESTAMP | Fecha de creación |

---

#### 2.6 `entrepreneurship_portal`
Portal o sitio web personalizado del emprendimiento.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `portal_id` | BIGINT | PK autoincremental |
| `entrepreneurship_id` | BIGINT | FK → `entrepreneurship` |
| `subdomain` | VARCHAR(100) | Subdominio único (UK) |
| `theme_id` | BIGINT | FK → `catalogue_value` (LIGHT/DARK) |
| `is_active` | BOOLEAN | ¿Portal activo? |
| `created_at` | TIMESTAMP | Fecha de creación |

**Constraints:**
- UK: `uk_entrepreneurship_subdomain` garantiza subdominios únicos
- Permite personalizar el tema visual

---

## 📅 3. EVENT DOMAIN (Dominio de Eventos)

### Objetivo
Gestionar eventos (ferias, exposiciones), espacios disponibles, invitaciones a emprendimientos y seguimiento de participación.

### Tablas

#### 3.1 `event`
Tabla principal de eventos.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `event_id` | BIGINT | PK autoincremental |
| `created_by_user_id` | BIGINT | FK → `app_user` (Creador) |
| `name` | VARCHAR(150) | Nombre del evento |
| `description` | TEXT | Descripción del evento |
| `event_type_id` | BIGINT | FK → `catalogue_value` (PHYSICAL/VIRTUAL) |
| `event_visibility_id` | BIGINT | FK → `catalogue_value` (PUBLIC/PRIVATE) |
| `is_paid` | BOOLEAN | ¿Evento de pago? |
| `price` | NUMERIC(10,2) | Precio de entrada |
| `max_attendees` | INTEGER | Capacidad máxima de asistencia del público |
| `max_entrepreneurships` | INTEGER | Capacidad máxima de emprendimientos |
| `virtual_link` | TEXT | Link para eventos virtuales |
| `start_datetime` | TIMESTAMP | Fecha/hora de inicio |
| `end_datetime` | TIMESTAMP | Fecha/hora de fin |
| `country_id` | BIGINT | FK → `catalogue_value` |
| `province_id` | BIGINT | FK → `catalogue_value` |
| `city_id` | BIGINT | FK → `catalogue_value` |
| `address_line` | TEXT | Dirección del evento |
| `created_at` | TIMESTAMP | Fecha de creación |

**Reglas de Negocio:**
- Check constraint: Si `is_paid = false`, entonces `price` debe ser `NULL`
- Check constraint: Si `is_paid = true`, entonces `price` debe ser `>= 0`
- Campo `event_visibility_id`: Permite eventos públicos (visibles a todos) o privados (solo invitados)
- Campo `max_attendees`: Controla capacidad del público general
- Campo `max_entrepreneurships`: Controla cantidad de emprendimientos participantes

---

#### 3.2 `event_space`
Espacios o stands disponibles en el evento.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `event_space_id` | BIGINT | PK autoincremental |
| `event_id` | BIGINT | FK → `event` |
| `space_code` | VARCHAR(20) | Código del espacio (ej: "A-01") |
| `is_available` | BOOLEAN | ¿Espacio disponible? |
| `created_at` | TIMESTAMP | Fecha de creación |

**Constraints:**
- UK: `uk_event_space_code` en (`event_id`, `space_code`)
- Garantiza códigos únicos por evento

---

#### 3.3 `event_invitation`
Invitaciones formales a emprendimientos para participar.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `invitation_id` | BIGINT | PK autoincremental |
| `event_id` | BIGINT | FK → `event` |
| `entrepreneurship_id` | BIGINT | FK → `entrepreneurship` |
| `event_space_id` | BIGINT | FK → `event_space` (Espacio asignado) |
| `invitation_status_id` | BIGINT | FK → `catalogue_value` (PENDING/ACCEPTED/REJECTED) |
| `sent_at` | TIMESTAMP | Fecha de envío |
| `responded_at` | TIMESTAMP | Fecha de respuesta |

**Constraints:**
- UK: `uk_event_invitation_unique` en (`event_id`, `entrepreneurship_id`)
- Un emprendimiento solo puede ser invitado una vez por evento

---

#### 3.4 `event_entrepreneurship_participant`
Participantes confirmados del evento.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `event_participant_id` | BIGINT | PK autoincremental |
| `event_id` | BIGINT | FK → `event` |
| `entrepreneurship_id` | BIGINT | FK → `entrepreneurship` |
| `space_code` | VARCHAR(10) | Código del espacio asignado |
| `participation_status_id` | BIGINT | FK → `catalogue_value` (INVITED/ACCEPTED/REJECTED) |
| `invited_at` | TIMESTAMP | Fecha de invitación |
| `responded_at` | TIMESTAMP | Fecha de respuesta |

**Función:**
- Registra el historial de participación
- Permite seguimiento del status de cada emprendimiento

---

## 🔧 4. SHARED DOMAIN (Dominio Compartido - Catálogos)

### Objetivo
Sistema centralizado y flexible para gestionar valores configurables utilizados en toda la aplicación.

### Tablas

#### 4.1 `catalogue_type`
Define tipos de catálogos.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `catalogue_type_id` | BIGINT | PK autoincremental |
| `code` | VARCHAR(50) | Código único (UK) |
| `name` | VARCHAR(100) | Nombre descriptivo |
| `description` | TEXT | Descripción del catálogo |
| `created_at` | TIMESTAMP | Fecha de creación |

### Tipos Implementados:
- `COUNTRY` - Países
- `PROVINCE` - Provincias
- `CITY` - Ciudades
- `PARISH` - Parroquias
- `CONTACT_TYPE` - Tipos de contacto (Phone, Email)
- `IDENTIFICATION_TYPE` - Tipos de identificación (Cédula, RUC, Passport)
- `EVENT_TYPE` - Tipos de evento (Physical, Virtual)
- `EVENT_VISIBILITY` - Visibilidad de evento (Public, Private)
- `INVITATION_STATUS` - Estados de invitación (Pending, Accepted, Rejected)
- `SOCIAL_PLATFORM` - Plataformas sociales (Facebook, Instagram, WhatsApp, TikTok, Twitter)
- `THEME_TYPE` - Temas de portal (Light, Dark)
- `EVENT_PARTICIPATION_STATUS` - Estados de participación (Invited, Accepted, Rejected)

---

#### 4.2 `catalogue_value`
Valores específicos de cada catálogo.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `catalogue_value_id` | BIGINT | PK autoincremental |
| `catalogue_type_id` | BIGINT | FK → `catalogue_type` |
| `code` | VARCHAR(50) | Código del valor |
| `name` | VARCHAR(150) | Nombre descriptivo |
| `description` | TEXT | Descripción del valor |
| `parent_value_id` | BIGINT | FK → `catalogue_value` (Self-reference) |
| `created_at` | TIMESTAMP | Fecha de creación |

**Características:**
- UK: `uk_catalogue_value_code` en (`catalogue_type_id`, `code`)
- **Auto-referencia**: Permite jerarquías (Ej: Quito → Pichincha → Ecuador)
- Patrones jerárquicos: `COUNTRY` → `PROVINCE` → `CITY` → `PARISH`

---

## 🌐 5. Datos Semilla (DML)

### Ubicaciones Geográficas - Ecuador Completo

#### País
- **Ecuador** (código: EC)

#### 24 Provincias y sus Capitales

1. **Azuay** → Cuenca
2. **Bolívar** → Guaranda
3. **Cañar** → Azogues
4. **Carchi** → Tulcán
5. **Chimborazo** → Riobamba
6. **Cotopaxi** → Latacunga
7. **El Oro** → Machala
8. **Esmeraldas** → Esmeraldas
9. **Galápagos** → Puerto Baquerizo Moreno
10. **Guayas** → Guayaquil
11. **Imbabura** → Ibarra
12. **Loja** → Loja
13. **Los Ríos** → Babahoyo
14. **Manabí** → Portoviejo
15. **Morona Santiago** → Macas
16. **Napo** → Tena
17. **Orellana** → Francisco de Orellana (Coca)
18. **Pastaza** → Puyo
19. **Pichincha** → Quito
20. **Santa Elena** → Santa Elena
21. **Santo Domingo de los Tsáchilas** → Santo Domingo
22. **Sucumbíos** → Nueva Loja (Lago Agrio)
23. **Tungurahua** → Ambato
24. **Zamora Chinchipe** → Zamora

#### Parroquias Urbanas Centrales
Cada ciudad capital tiene una parroquia urbana central registrada.

**Ejemplo de jerarquía:**
```
Ecuador (COUNTRY)
  ├─ Pichincha (PROVINCE)
  │   └─ Quito (CITY)
  │       └─ La Mariscal (PARISH)
  ├─ Guayas (PROVINCE)
  │   └─ Guayaquil (CITY)
  │       └─ Centro (PARISH)
  └─ Azuay (PROVINCE)
      └─ Cuenca (CITY)
          └─ Centro Histórico (PARISH)
```

### Tipos de Contacto
- `PHONE` - Teléfono
- `EMAIL` - Correo electrónico

### Tipos de Identificación
- `CEDULA` - Cédula de identidad
- `RUC` - Registro Único de Contribuyentes
- `PASSPORT` - Pasaporte

### Tipos de Evento
- `PHYSICAL` - Evento presencial
- `VIRTUAL` - Evento virtual

### Visibilidad de Evento
- `PUBLIC` - Evento público (visible para todos)
- `PRIVATE` - Evento privado (solo para invitados)

### Estados de Invitación
- `PENDING` - Pendiente
- `ACCEPTED` - Aceptada
- `REJECTED` - Rechazada

### Plataformas Sociales
- `FACEBOOK` - Facebook
- `INSTAGRAM` - Instagram
- `WHATSAPP` - WhatsApp
- `TIKTOK` - TikTok
- `TWITTER` - Twitter (X)

### Temas de Portal
- `LIGHT` - Tema claro
- `DARK` - Tema oscuro

---

## 🔗 6. Relaciones y Constraints (Foreign Keys)

### 6.1 Catálogos
- `catalogue_value` → `catalogue_type`
- `catalogue_value` → `catalogue_value` (self-reference para jerarquías)

### 6.2 Usuario
- `user_contact` → `app_user`
- `user_contact` → `catalogue_value` (tipo de contacto)
- `user_address` → `app_user`
- `user_address` → `catalogue_value` × 4 (country, province, city, parish)
- `user_identification` → `app_user`
- `user_identification` → `catalogue_value` × 2 (tipo y país emisor)

### 6.3 Emprendimientos
- `entrepreneurship` → `app_user` (dueño)
- `entrepreneurship` → `category`
- `entrepreneurship_location` → `entrepreneurship`
- `entrepreneurship_location` → `catalogue_value` × 4 (ubicación)
- `entrepreneurship_social_link` → `entrepreneurship`
- `entrepreneurship_social_link` → `catalogue_value` (plataforma)
- `entrepreneurship_gallery` → `entrepreneurship`
- `entrepreneurship_portal` → `entrepreneurship`
- `entrepreneurship_portal` → `catalogue_value` (tema)

### 6.4 Eventos
- `event` → `app_user` (creador)
- `event` → `catalogue_value` × 5 (tipo, visibilidad y ubicación)
- `event_space` → `event`
- `event_invitation` → `event`
- `event_invitation` → `entrepreneurship`
- `event_invitation` → `event_space`
- `event_invitation` → `catalogue_value` (status)
- `event_entrepreneurship_participant` → `event`
- `event_entrepreneurship_participant` → `entrepreneurship`
- `event_entrepreneurship_participant` → `catalogue_value` (status)

---

## 🚀 7. Funcionalidades Futuras (Roadmap)

### 7.1 Sistema de Tickets Pagados
```sql
CREATE TABLE event_ticket (
    ticket_id BIGINT GENERATED ALWAYS AS IDENTITY,
    event_id BIGINT NOT NULL,
    user_id BIGINT,
    price NUMERIC(10,2) NOT NULL,
    purchased_at TIMESTAMP DEFAULT now()
);
```

**Objetivo:** Permitir que eventos cobren entradas a usuarios finales.

---

### 7.2 Sistema de Pagos
```sql
CREATE TABLE payment (
    payment_id BIGINT GENERATED ALWAYS AS IDENTITY,
    ticket_id BIGINT,
    amount NUMERIC(10,2),
    payment_status_id BIGINT,
    created_at TIMESTAMP
);
```

**Objetivo:** Procesar y registrar pagos de tickets.

---

### 7.3 Metrics Domain
- **Propósito:** Analytics y métricas de uso
- Seguimiento de visitas a portales
- Estadísticas de participación en eventos
- Métricas de emprendimientos más populares

---

### 7.4 Notification Domain
- **Propósito:** Sistema de notificaciones
- Notificaciones de invitaciones a eventos
- Recordatorios de eventos próximos
- Alertas de cambios en participación

---

## 📊 8. Diagrama Conceptual de Dominios

```
┌─────────────────────────────────────────────────────────┐
│                   SHARED DOMAIN                         │
│  (catalogue_type, catalogue_value)                      │
│  → Valores configurables para toda la aplicación        │
└─────────────────────────────────────────────────────────┘
                          ▲
                          │ Referenciado por todos
                          │
┌──────────────────┐      │      ┌──────────────────────┐
│   USER DOMAIN    │◄─────┼─────►│ ENTREPRENEURSHIP     │
│                  │              │      DOMAIN          │
│  - app_user      │              │  - entrepreneurship  │
│  - user_contact  │──────────────│  - category          │
│  - user_address  │   Dueño      │  - location          │
│  - identification│              │  - social_link       │
└──────────────────┘              │  - gallery           │
         │                        │  - portal            │
         │ Creador                └──────────────────────┘
         │                                   │
         ▼                                   │ Participante
┌──────────────────┐                        │
│   EVENT DOMAIN   │◄───────────────────────┘
│                  │
│  - event         │
│  - event_space   │
│  - invitation    │
│  - participant   │
└──────────────────┘
```

---

## 🎯 9. Casos de Uso Principales

### 9.1 Registro de Usuario
1. Crear registro en `app_user` con `keycloak_id`
2. Agregar contactos en `user_contact`
3. Registrar dirección en `user_address`
4. Guardar identificación en `user_identification`

### 9.2 Creación de Emprendimiento
1. Usuario crea emprendimiento en `entrepreneurship`
2. Define categoría
3. Agrega ubicación física (si aplica)
4. Registra redes sociales
5. Sube imágenes a galería
6. Opcionalmente crea portal personalizado

### 9.3 Organización de Evento
1. Usuario crea evento en `event`
2. Define espacios disponibles en `event_space`
3. Envía invitaciones a emprendimientos (`event_invitation`)
4. Emprendimientos aceptan/rechazan
5. Se registran participantes confirmados en `event_entrepreneurship_participant`

### 9.4 Búsqueda de Emprendimientos
- Por categoría
- Por ubicación geográfica
- Por redes sociales disponibles
- Filtros combinados

---

## 🔐 10. Consideraciones de Seguridad

### Autenticación
- Integración con **Keycloak** para gestión de identidad
- `keycloak_id` como identificador único externo

### Integridad de Datos
- Todas las FKs están definidas explícitamente
- Check constraints para validar lógica de negocio
- Unique constraints para prevenir duplicados

### Auditoría
- Campos `created_at` en todas las tablas
- Campos `updated_at` en tablas modificables
- Timestamps de respuesta en invitaciones

---

## 📈 11. Escalabilidad

### Diseño Modular
- Dominios independientes permiten escalar por funcionalidad
- Nuevos dominios pueden agregarse sin afectar existentes

### Catálogos Flexibles
- Sistema de catálogos permite agregar nuevos tipos sin cambios en esquema
- Valores jerárquicos soportan estructuras complejas

### Preparación para Futuro
- Dominios de métricas y notificaciones definidos
- Sistema de pagos y tickets diseñado pero no implementado
- Permite crecimiento incremental

---

## 🛠️ 12. Tecnologías y Herramientas

- **Motor de BD:** PostgreSQL
- **Autenticación:** Keycloak
- **Estrategia de IDs:** `GENERATED ALWAYS AS IDENTITY`
- **Nomenclatura:** Snake_case para tablas y columnas
- **Prefijos:** 
  - `pk_` para Primary Keys
  - `fk_` para Foreign Keys
  - `uk_` para Unique Keys
  - `ck_` para Check Constraints

---

## 📝 13. Archivos del Proyecto

### Estructura de Carpetas
```
db/
├── complete.sql                          # Script completo consolidado
├── futuro.txt                            # Funcionalidades futuras
├── tesis_db.md                           # Este documento
├── tesis_db_er.puml                      # Diagrama PlantUML del modelo ER
├── DDL/
│   ├── 0001_user_domain.sql              # Tablas de usuarios
│   ├── 0002_entrepreneurship_domain.sql  # Tablas de emprendimientos
│   ├── 0003_event_domain.sql             # Tablas de eventos
│   ├── 0004_shared_domain.sql            # Tablas de catálogos
│   ├── 0005_metrics_domain.sql           # (Vacío - futuro)
│   ├── 0006_notification_domain.sql      # (Vacío - futuro)
│   └── 0007_constraints.sql              # Foreign keys y constraints
└── DML/
    ├── shared_domain_dml.sql             # Datos semilla básicos (deprecado)
    └── initial_data.sql                  # Datos iniciales completos (USAR ESTE)
```

### Orden de Ejecución

#### Opción 1: Ejecución Modular (Recomendado para desarrollo)
1. DDL en orden numérico (0001 → 0007)
2. DML: Ejecutar `initial_data.sql` para datos completos

#### Opción 2: Ejecución Única (Recomendado para producción)
1. Ejecutar `complete.sql` (contiene toda la estructura)
2. Ejecutar `initial_data.sql` (contiene todos los catálogos)

**Nota:** `shared_domain_dml.sql` está deprecado. Usar `initial_data.sql` que incluye:
- Todas las 24 provincias de Ecuador
- Las 24 ciudades capitales
- Parroquias urbanas centrales
- Todos los catálogos del sistema

---

## ✅ 14. Conclusiones

Esta base de datos representa un sistema completo para:
- ✅ Gestionar usuarios con autenticación externa (Keycloak)
- ✅ Administrar emprendimientos con múltiples características
- ✅ Organizar eventos públicos y privados con control de capacidad
- ✅ Gestionar participación de emprendimientos en eventos
- ✅ Sistema flexible de catálogos para configuración
- ✅ Datos geográficos completos de Ecuador (24 provincias)
- ✅ Escalabilidad para funcionalidades futuras (pagos, métricas, notificaciones)

**Ventajas del diseño:**
- Modular y mantenible
- Escalable horizontalmente por dominio
- Integridad de datos garantizada
- Flexible mediante sistema de catálogos
- Preparado para crecimiento futuro
- Datos geográficos completos y jerárquicos

**Nuevas funcionalidades implementadas:**
- ✅ Eventos públicos vs privados
- ✅ Control de capacidad de público (`max_attendees`)
- ✅ Control de capacidad de emprendimientos (`max_entrepreneurships`)
- ✅ Base de datos geográfica completa de Ecuador
- ✅ Diagrama ER en PlantUML

---

## 📧 Contacto del Proyecto

**Autor:** Kevin Guachagmira  
**Email:** kguachag@pichincha.com  
**Fecha:** Abril 2026  
**Institución:** Banco Pichincha - Proyecto de Tesis

---

*Documento generado automáticamente mediante análisis de esquema de base de datos*
