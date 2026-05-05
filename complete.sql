-- =========================
-- USER DOMAIN
-- =========================
CREATE TABLE app_user (
    user_id BIGINT GENERATED ALWAYS AS IDENTITY,
    keycloak_id VARCHAR(100) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    profile_picture_url TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP
);
ALTER TABLE app_user ADD CONSTRAINT pk_app_user PRIMARY KEY (user_id);
ALTER TABLE app_user ADD CONSTRAINT uk_app_user_keycloak UNIQUE (keycloak_id);

CREATE TABLE user_contact (
    user_contact_id BIGINT GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT NOT NULL,
    contact_type_id BIGINT NOT NULL, -- catalogue_value (PHONE, EMAIL)
    contact_value VARCHAR(150) NOT NULL,
    is_primary BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);
ALTER TABLE user_contact ADD CONSTRAINT pk_user_contact PRIMARY KEY (user_contact_id);

CREATE TABLE user_address (
    user_address_id BIGINT GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT NOT NULL,
    country_id BIGINT NOT NULL,
    province_id BIGINT NOT NULL,
    city_id BIGINT NOT NULL,
    parish_id BIGINT,
    address_line TEXT NOT NULL,
    reference TEXT,
    is_primary BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);
ALTER TABLE user_address ADD CONSTRAINT pk_user_address PRIMARY KEY (user_address_id);


CREATE TABLE user_identification (
    user_identification_id BIGINT GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT NOT NULL,
    identification_type_id BIGINT NOT NULL, -- CEDULA, RUC, PASSPORT
    identification_number VARCHAR(30) NOT NULL,
    issued_country_id BIGINT,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);
ALTER TABLE user_identification ADD CONSTRAINT pk_user_identification PRIMARY KEY (user_identification_id);
ALTER TABLE user_identification ADD CONSTRAINT uk_user_identification_unique UNIQUE (identification_type_id, identification_number);

-- =========================
-- EVENT DOMAIN
-- =========================
CREATE TABLE event (
    event_id BIGINT GENERATED ALWAYS AS IDENTITY,
    created_by_user_id BIGINT NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    event_type_id BIGINT NOT NULL, -- PHYSICAL / VIRTUAL
    event_visibility_id BIGINT NOT NULL, -- PUBLIC / PRIVATE
    is_paid BOOLEAN NOT NULL DEFAULT FALSE,
    price NUMERIC(10,2),
    max_attendees INTEGER, -- Capacidad máxima de asistencia del público
    max_entrepreneurships INTEGER, -- Capacidad máxima de emprendimientos
    virtual_link TEXT,
    start_datetime TIMESTAMP NOT NULL,
    end_datetime TIMESTAMP NOT NULL,
    country_id BIGINT,
    province_id BIGINT,
    city_id BIGINT,
    address_line TEXT,
    cover_image_url TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);
ALTER TABLE event ADD CONSTRAINT pk_event PRIMARY KEY (event_id);

CREATE TABLE event_entrepreneurship_participant (
    event_participant_id BIGINT GENERATED ALWAYS AS IDENTITY,
    event_id BIGINT NOT NULL,
    entrepreneurship_id BIGINT NOT NULL,
    space_code VARCHAR(10),
    participation_status_id BIGINT NOT NULL, -- INVITED / ACCEPTED / REJECTED
    invited_at TIMESTAMP NOT NULL DEFAULT now(),
    responded_at TIMESTAMP
);
ALTER TABLE event_entrepreneurship_participant ADD CONSTRAINT pk_event_participant PRIMARY KEY (event_participant_id);

CREATE TABLE event_space (
    event_space_id BIGINT GENERATED ALWAYS AS IDENTITY,
    event_id BIGINT NOT NULL,
    space_code VARCHAR(20) NOT NULL,
    is_available BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);
ALTER TABLE event_space ADD CONSTRAINT pk_event_space PRIMARY KEY (event_space_id);
ALTER TABLE event_space ADD CONSTRAINT uk_event_space_code UNIQUE (event_id, space_code);

CREATE TABLE event_invitation (
    invitation_id BIGINT GENERATED ALWAYS AS IDENTITY,
    event_id BIGINT NOT NULL,
    entrepreneurship_id BIGINT NOT NULL,
    event_space_id BIGINT NOT NULL,
    invitation_status_id BIGINT NOT NULL, -- catalogue_value
    sent_at TIMESTAMP NOT NULL DEFAULT now(),
    responded_at TIMESTAMP
);
ALTER TABLE event_invitation ADD CONSTRAINT pk_event_invitation PRIMARY KEY (invitation_id);
ALTER TABLE event_invitation ADD CONSTRAINT uk_event_invitation_unique UNIQUE (event_id, entrepreneurship_id);
-- =========================
-- ENTREPRENEURSHIP DOMAIN
-- =========================
CREATE TABLE category (
    category_id BIGINT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);
ALTER TABLE category ADD CONSTRAINT pk_category PRIMARY KEY (category_id);
ALTER TABLE category ADD CONSTRAINT uk_category_name UNIQUE (name);

CREATE TABLE entrepreneurship (
    entrepreneurship_id BIGINT GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT NOT NULL,
    category_id BIGINT NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    logo_url TEXT,
    is_physical BOOLEAN NOT NULL,
    is_digital BOOLEAN NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP
);
ALTER TABLE entrepreneurship ADD CONSTRAINT pk_entrepreneurship PRIMARY KEY (entrepreneurship_id);


CREATE TABLE entrepreneurship_location (
    location_id BIGINT GENERATED ALWAYS AS IDENTITY,
    entrepreneurship_id BIGINT NOT NULL,
    country_id BIGINT NOT NULL,
    province_id BIGINT NOT NULL,
    city_id BIGINT NOT NULL,
    parish_id BIGINT,
    address_line TEXT,
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    created_at TIMESTAMP NOT NULL DEFAULT now()
);
ALTER TABLE entrepreneurship_location ADD CONSTRAINT pk_entrepreneurship_location PRIMARY KEY (location_id);

CREATE TABLE entrepreneurship_social_link (
    social_link_id BIGINT GENERATED ALWAYS AS IDENTITY,
    entrepreneurship_id BIGINT NOT NULL,
    social_platform_id BIGINT NOT NULL, -- catalogue_value
    url TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);
ALTER TABLE entrepreneurship_social_link ADD CONSTRAINT pk_entrepreneurship_social_link PRIMARY KEY (social_link_id);

-- Tabla genérica para galerías de imágenes de usuarios, emprendimientos y eventos
CREATE TABLE image_gallery (
    image_id BIGINT GENERATED ALWAYS AS IDENTITY,
    entity_type VARCHAR(50) NOT NULL, -- 'USER', 'ENTREPRENEURSHIP', 'EVENT'
    entity_id BIGINT NOT NULL, -- ID de la entidad relacionada
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
    updated_at TIMESTAMP
);

ALTER TABLE image_gallery ADD CONSTRAINT pk_image_gallery PRIMARY KEY (image_id);
ALTER TABLE image_gallery ADD CONSTRAINT chk_image_gallery_entity_type CHECK (entity_type IN ('USER', 'ENTREPRENEURSHIP', 'EVENT'));
CREATE INDEX idx_image_gallery_entity ON image_gallery (entity_type, entity_id);
CREATE INDEX idx_image_gallery_order ON image_gallery (entity_type, entity_id, display_order);

CREATE TABLE entrepreneurship_portal (
    portal_id BIGINT GENERATED ALWAYS AS IDENTITY,
    entrepreneurship_id BIGINT NOT NULL,
    subdomain VARCHAR(100) NOT NULL,
    theme_id BIGINT,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);
ALTER TABLE entrepreneurship_portal ADD CONSTRAINT pk_entrepreneurship_portal PRIMARY KEY (portal_id);
ALTER TABLE entrepreneurship_portal ADD CONSTRAINT uk_entrepreneurship_subdomain UNIQUE (subdomain);


ALTER TABLE event ADD CONSTRAINT ck_event_price_paid CHECK ((is_paid = false AND price IS NULL) OR (is_paid = true AND price IS NOT NULL AND price >= 0));

-- =========================
-- CATALOG DOMAIN
-- =========================
CREATE TABLE catalogue_type (
    catalogue_type_id BIGINT GENERATED ALWAYS AS IDENTITY,
    code VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

ALTER TABLE catalogue_type ADD CONSTRAINT pk_catalogue_type PRIMARY KEY (catalogue_type_id);
ALTER TABLE catalogue_type ADD CONSTRAINT uk_catalogue_type_code UNIQUE (code);

CREATE TABLE catalogue_value (
    catalogue_value_id BIGINT GENERATED ALWAYS AS IDENTITY,
    catalogue_type_id BIGINT NOT NULL,
    code VARCHAR(50) NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    parent_value_id BIGINT,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

ALTER TABLE catalogue_value ADD CONSTRAINT pk_catalogue_value PRIMARY KEY (catalogue_value_id);
ALTER TABLE catalogue_value ADD CONSTRAINT uk_catalogue_value_code UNIQUE (catalogue_type_id, code);


-- =========================
-- FOREIGN KEYS
-- =========================

--🧩 CATALOGUE DOMAIN
--catalogue_value → catalogue_type
ALTER TABLE catalogue_value ADD CONSTRAINT fk_catalogue_value_type FOREIGN KEY (catalogue_type_id) REFERENCES catalogue_type (catalogue_type_id);
--catalogue_value (self-reference)
ALTER TABLE catalogue_value ADD CONSTRAINT fk_catalogue_value_parent FOREIGN KEY (parent_value_id) REFERENCES catalogue_value (catalogue_value_id);

--🧑 USER DOMAIN
--user_contact → app_user
ALTER TABLE user_contact ADD CONSTRAINT fk_user_contact_user FOREIGN KEY (user_id) REFERENCES app_user (user_id);
--user_contact → catalogue_value (CONTACT_TYPE)
ALTER TABLE user_contact ADD CONSTRAINT fk_user_contact_type FOREIGN KEY (contact_type_id) REFERENCES catalogue_value (catalogue_value_id);
--user_address → app_user
ALTER TABLE user_address ADD CONSTRAINT fk_user_address_user FOREIGN KEY (user_id) REFERENCES app_user (user_id);
--user_address → catalogue_value (Location)
ALTER TABLE user_address ADD CONSTRAINT fk_user_address_country FOREIGN KEY (country_id) REFERENCES catalogue_value (catalogue_value_id);
ALTER TABLE user_address ADD CONSTRAINT fk_user_address_province FOREIGN KEY (province_id) REFERENCES catalogue_value (catalogue_value_id);
ALTER TABLE user_address ADD CONSTRAINT fk_user_address_city FOREIGN KEY (city_id) REFERENCES catalogue_value (catalogue_value_id);
ALTER TABLE user_address ADD CONSTRAINT fk_user_address_parish FOREIGN KEY (parish_id) REFERENCES catalogue_value (catalogue_value_id);
--user_identification → app_user
ALTER TABLE user_identification ADD CONSTRAINT fk_user_identification_user FOREIGN KEY (user_id) REFERENCES app_user (user_id);
--user_identification → catalogue_value
ALTER TABLE user_identification ADD CONSTRAINT fk_user_identification_type FOREIGN KEY (identification_type_id)REFERENCES catalogue_value (catalogue_value_id);
ALTER TABLE user_identification ADD CONSTRAINT fk_user_identification_country FOREIGN KEY (issued_country_id) REFERENCES catalogue_value (catalogue_value_id);

--🏪 ENTREPRENEURSHIP DOMAIN
--entrepreneurship → category
ALTER TABLE entrepreneurship ADD CONSTRAINT fk_entrepreneurship_category FOREIGN KEY (category_id) REFERENCES category (category_id);
--entrepreneurship_location → catalogue_value
ALTER TABLE entrepreneurship_location ADD CONSTRAINT fk_entrepreneurship_location_country FOREIGN KEY (country_id) REFERENCES catalogue_value (catalogue_value_id);
ALTER TABLE entrepreneurship_location ADD CONSTRAINT fk_entrepreneurship_location_province FOREIGN KEY (province_id) REFERENCES catalogue_value (catalogue_value_id);
ALTER TABLE entrepreneurship_location ADD CONSTRAINT fk_entrepreneurship_location_city FOREIGN KEY (city_id) REFERENCES catalogue_value (catalogue_value_id);
ALTER TABLE entrepreneurship_location ADD CONSTRAINT fk_entrepreneurship_location_parish FOREIGN KEY (parish_id) REFERENCES catalogue_value (catalogue_value_id);
--entrepreneurship_social_link → catalogue_value
ALTER TABLE entrepreneurship_social_link ADD CONSTRAINT fk_entrepreneurship_social_platform FOREIGN KEY (social_platform_id) REFERENCES catalogue_value (catalogue_value_id);
--entrepreneurship_portal → catalogue_value
ALTER TABLE entrepreneurship_portal ADD CONSTRAINT fk_entrepreneurship_portal_theme FOREIGN KEY (theme_id) REFERENCES catalogue_value (catalogue_value_id);

--📅 EVENT DOMAIN
--event → catalogue_value (EVENT_TYPE)
ALTER TABLE event ADD CONSTRAINT fk_event_type FOREIGN KEY (event_type_id) REFERENCES catalogue_value (catalogue_value_id);
--event → catalogue_value (EVENT_VISIBILITY)
ALTER TABLE event ADD CONSTRAINT fk_event_visibility FOREIGN KEY (event_visibility_id) REFERENCES catalogue_value (catalogue_value_id);
--event → catalogue_value (Location)
ALTER TABLE event ADD CONSTRAINT fk_event_country FOREIGN KEY (country_id) REFERENCES catalogue_value (catalogue_value_id);
ALTER TABLE event ADD CONSTRAINT fk_event_province FOREIGN KEY (province_id) REFERENCES catalogue_value (catalogue_value_id);
ALTER TABLE event ADD CONSTRAINT fk_event_city FOREIGN KEY (city_id) REFERENCES catalogue_value (catalogue_value_id);
--event -> app_user
ALTER TABLE event ADD CONSTRAINT fk_event_creator FOREIGN KEY (created_by_user_id) REFERENCES app_user(user_id);
--event_space → event
ALTER TABLE event_space ADD CONSTRAINT fk_event_space_event FOREIGN KEY (event_id) REFERENCES event (event_id);
--event_invitation → event
ALTER TABLE event_invitation ADD CONSTRAINT fk_event_invitation_event FOREIGN KEY (event_id) REFERENCES event (event_id);
--event_invitation → event_space
ALTER TABLE event_invitation ADD CONSTRAINT fk_event_invitation_space FOREIGN KEY (event_space_id) REFERENCES event_space (event_space_id);
--event_entrepreneurship_participant -> event
ALTER TABLE event_entrepreneurship_participant ADD CONSTRAINT fk_participant_event FOREIGN KEY (event_id) REFERENCES event(event_id);
--event_entrepreneurship_participant -> entrepreneurship
ALTER TABLE event_entrepreneurship_participant ADD CONSTRAINT fk_participant_entrepreneurship FOREIGN KEY (entrepreneurship_id) REFERENCES entrepreneurship(entrepreneurship_id);
--event_entrepreneurship_participant -> catalogue_value
ALTER TABLE event_entrepreneurship_participant ADD CONSTRAINT fk_participant_status FOREIGN KEY (participation_status_id) REFERENCES catalogue_value(catalogue_value_id);

--🖼️ IMAGE GALLERY
--image_gallery → app_user (uploaded_by_user_id)
ALTER TABLE image_gallery ADD CONSTRAINT fk_image_gallery_uploader FOREIGN KEY (uploaded_by_user_id) REFERENCES app_user (user_id);