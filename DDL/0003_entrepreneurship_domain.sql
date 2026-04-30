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

CREATE TABLE entrepreneurship_gallery (
    gallery_id BIGINT GENERATED ALWAYS AS IDENTITY,
    entrepreneurship_id BIGINT NOT NULL,
    image_url TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

ALTER TABLE entrepreneurship_gallery ADD CONSTRAINT pk_entrepreneurship_gallery PRIMARY KEY (gallery_id);

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