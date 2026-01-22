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


