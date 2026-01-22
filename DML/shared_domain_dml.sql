-- =========================
-- DML - SEED DATA
-- =========================
INSERT INTO catalogue_type (code, name, description) VALUES
('COUNTRY', 'Country', 'List of countries'),
('PROVINCE', 'Province', 'Administrative provinces'),
('CITY', 'City', 'Cities'),
('PARISH', 'Parish', 'Parishes'),
('CONTACT_TYPE', 'Contact Type', 'Types of user contact'),
('IDENTIFICATION_TYPE', 'Identification Type', 'User identification types'),
('EVENT_TYPE', 'Event Type', 'Physical or virtual events'),
('INVITATION_STATUS', 'Invitation Status', 'Status of event invitations'),
('SOCIAL_PLATFORM', 'Social Platform', 'Social media platforms'),
('THEME_TYPE', 'Portal Theme', 'Themes for entrepreneurship portals');

INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'EC', 'Ecuador'
FROM catalogue_type WHERE code = 'COUNTRY';

INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
SELECT 
    ct.catalogue_type_id,
    'PICHINCHA',
    'Pichincha',
    cv.catalogue_value_id
FROM catalogue_type ct
JOIN catalogue_value cv ON cv.code = 'EC'
WHERE ct.code = 'PROVINCE';

INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
SELECT 
    ct.catalogue_type_id,
    'QUITO',
    'Quito',
    cv.catalogue_value_id
FROM catalogue_type ct
JOIN catalogue_value cv ON cv.code = 'PICHINCHA'
WHERE ct.code = 'CITY';

INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
SELECT 
    ct.catalogue_type_id,
    'LA_MARISCAL',
    'La Mariscal',
    cv.catalogue_value_id
FROM catalogue_type ct
JOIN catalogue_value cv ON cv.code = 'QUITO'
WHERE ct.code = 'PARISH';


INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'PHONE', 'Phone'
FROM catalogue_type WHERE code = 'CONTACT_TYPE';

INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'EMAIL', 'Email'
FROM catalogue_type WHERE code = 'CONTACT_TYPE';


INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'CEDULA', 'Cédula'
FROM catalogue_type WHERE code = 'IDENTIFICATION_TYPE';

INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'RUC', 'RUC'
FROM catalogue_type WHERE code = 'IDENTIFICATION_TYPE';

INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'PASSPORT', 'Passport'
FROM catalogue_type WHERE code = 'IDENTIFICATION_TYPE';


INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'PHYSICAL', 'Physical Event'
FROM catalogue_type WHERE code = 'EVENT_TYPE';

INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'VIRTUAL', 'Virtual Event'
FROM catalogue_type WHERE code = 'EVENT_TYPE';

INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'PENDING', 'Pending'
FROM catalogue_type WHERE code = 'INVITATION_STATUS';

INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'ACCEPTED', 'Accepted'
FROM catalogue_type WHERE code = 'INVITATION_STATUS';

INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'REJECTED', 'Rejected'
FROM catalogue_type WHERE code = 'INVITATION_STATUS';


INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'FACEBOOK', 'Facebook'
FROM catalogue_type WHERE code = 'SOCIAL_PLATFORM';

INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'INSTAGRAM', 'Instagram'
FROM catalogue_type WHERE code = 'SOCIAL_PLATFORM';

INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'WHATSAPP', 'WhatsApp'
FROM catalogue_type WHERE code = 'SOCIAL_PLATFORM';

INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'LIGHT', 'Light Theme'
FROM catalogue_type WHERE code = 'THEME_TYPE';

INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'DARK', 'Dark Theme'
FROM catalogue_type WHERE code = 'THEME_TYPE';


INSERT INTO catalogue_value (catalogue_type_id, code, description)
VALUES
(1, 'PHYSICAL', 'Physical event'),
(1, 'VIRTUAL', 'Virtual event');

-- PARTICIPATION STATUS
INSERT INTO catalogue_type (code, description)
VALUES ('EVENT_PARTICIPATION_STATUS', 'Participation status in event');

INSERT INTO catalogue_value (catalogue_type_id, code, description)
VALUES
(2, 'INVITED', 'Invited'),
(2, 'ACCEPTED', 'Accepted'),
(2, 'REJECTED', 'Rejected');
