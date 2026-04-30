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
