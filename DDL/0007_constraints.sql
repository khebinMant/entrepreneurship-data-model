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
ALTER TABLE entity_social_link ADD CONSTRAINT fk_entity_social_platform FOREIGN KEY (social_platform_id) REFERENCES catalogue_value (catalogue_value_id);
--entrepreneurship_portal → catalogue_value
ALTER TABLE entity_portal ADD CONSTRAINT fk_entity_portal_theme FOREIGN KEY (theme_id) REFERENCES catalogue_value (catalogue_value_id);

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
-- Nota: entity_id es una relación polimórfica (puede referenciar entrepreneurship_id o event_id dependiendo de entity_type)
-- No se puede crear FK directa, debe validarse en la capa de aplicación