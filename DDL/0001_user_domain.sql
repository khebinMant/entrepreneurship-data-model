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

