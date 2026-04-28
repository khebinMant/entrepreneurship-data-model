-- =========================
-- INITIAL DATA - CATALOGUES AND GEOGRAPHIC DATA
-- =========================

-- =========================
-- CATALOGUE TYPES
-- =========================
INSERT INTO catalogue_type (code, name, description) VALUES
('COUNTRY', 'Country', 'List of countries'),
('PROVINCE', 'Province', 'Administrative provinces'),
('CITY', 'City', 'Cities'),
('PARISH', 'Parish', 'Parishes'),
('CONTACT_TYPE', 'Contact Type', 'Types of user contact'),
('IDENTIFICATION_TYPE', 'Identification Type', 'User identification types'),
('EVENT_TYPE', 'Event Type', 'Physical or virtual events'),
('EVENT_VISIBILITY', 'Event Visibility', 'Public or private events'),
('INVITATION_STATUS', 'Invitation Status', 'Status of event invitations'),
('EVENT_PARTICIPATION_STATUS', 'Participation Status', 'Participation status in event'),
('SOCIAL_PLATFORM', 'Social Platform', 'Social media platforms'),
('THEME_TYPE', 'Portal Theme', 'Themes for entrepreneurship portals');

-- =========================
-- COUNTRY - ECUADOR
-- =========================
INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'EC', 'Ecuador'
FROM catalogue_type WHERE code = 'COUNTRY';

-- =========================
-- PROVINCES OF ECUADOR (24 provinces)
-- =========================
-- Get Ecuador ID for reference
DO $$
DECLARE
    v_ecuador_id BIGINT;
    v_province_type_id BIGINT;
    v_city_type_id BIGINT;
    v_parish_type_id BIGINT;
    
    -- Province IDs
    v_azuay_id BIGINT;
    v_bolivar_id BIGINT;
    v_canar_id BIGINT;
    v_carchi_id BIGINT;
    v_chimborazo_id BIGINT;
    v_cotopaxi_id BIGINT;
    v_el_oro_id BIGINT;
    v_esmeraldas_id BIGINT;
    v_galapagos_id BIGINT;
    v_guayas_id BIGINT;
    v_imbabura_id BIGINT;
    v_loja_id BIGINT;
    v_los_rios_id BIGINT;
    v_manabi_id BIGINT;
    v_morona_santiago_id BIGINT;
    v_napo_id BIGINT;
    v_orellana_id BIGINT;
    v_pastaza_id BIGINT;
    v_pichincha_id BIGINT;
    v_santa_elena_id BIGINT;
    v_santo_domingo_id BIGINT;
    v_sucumbios_id BIGINT;
    v_tungurahua_id BIGINT;
    v_zamora_chinchipe_id BIGINT;
    
    -- City IDs (capitals)
    v_cuenca_id BIGINT;
    v_guaranda_id BIGINT;
    v_azogues_id BIGINT;
    v_tulcan_id BIGINT;
    v_riobamba_id BIGINT;
    v_latacunga_id BIGINT;
    v_machala_id BIGINT;
    v_esmeraldas_city_id BIGINT;
    v_puerto_baquerizo_id BIGINT;
    v_guayaquil_id BIGINT;
    v_ibarra_id BIGINT;
    v_loja_city_id BIGINT;
    v_babahoyo_id BIGINT;
    v_portoviejo_id BIGINT;
    v_macas_id BIGINT;
    v_tena_id BIGINT;
    v_coca_id BIGINT;
    v_puyo_id BIGINT;
    v_quito_id BIGINT;
    v_santa_elena_city_id BIGINT;
    v_santo_domingo_city_id BIGINT;
    v_nueva_loja_id BIGINT;
    v_ambato_id BIGINT;
    v_zamora_id BIGINT;
BEGIN
    -- Get Ecuador ID
    SELECT catalogue_value_id INTO v_ecuador_id
    FROM catalogue_value cv
    JOIN catalogue_type ct ON cv.catalogue_type_id = ct.catalogue_type_id
    WHERE ct.code = 'COUNTRY' AND cv.code = 'EC';
    
    -- Get catalogue type IDs
    SELECT catalogue_type_id INTO v_province_type_id FROM catalogue_type WHERE code = 'PROVINCE';
    SELECT catalogue_type_id INTO v_city_type_id FROM catalogue_type WHERE code = 'CITY';
    SELECT catalogue_type_id INTO v_parish_type_id FROM catalogue_type WHERE code = 'PARISH';
    
    -- =========================
    -- INSERT PROVINCES
    -- =========================
    
    -- 1. AZUAY
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_province_type_id, 'AZUAY', 'Azuay', v_ecuador_id)
    RETURNING catalogue_value_id INTO v_azuay_id;
    
    -- 2. BOLÍVAR
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_province_type_id, 'BOLIVAR', 'Bolívar', v_ecuador_id)
    RETURNING catalogue_value_id INTO v_bolivar_id;
    
    -- 3. CAÑAR
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_province_type_id, 'CANAR', 'Cañar', v_ecuador_id)
    RETURNING catalogue_value_id INTO v_canar_id;
    
    -- 4. CARCHI
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_province_type_id, 'CARCHI', 'Carchi', v_ecuador_id)
    RETURNING catalogue_value_id INTO v_carchi_id;
    
    -- 5. CHIMBORAZO
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_province_type_id, 'CHIMBORAZO', 'Chimborazo', v_ecuador_id)
    RETURNING catalogue_value_id INTO v_chimborazo_id;
    
    -- 6. COTOPAXI
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_province_type_id, 'COTOPAXI', 'Cotopaxi', v_ecuador_id)
    RETURNING catalogue_value_id INTO v_cotopaxi_id;
    
    -- 7. EL ORO
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_province_type_id, 'EL_ORO', 'El Oro', v_ecuador_id)
    RETURNING catalogue_value_id INTO v_el_oro_id;
    
    -- 8. ESMERALDAS
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_province_type_id, 'ESMERALDAS', 'Esmeraldas', v_ecuador_id)
    RETURNING catalogue_value_id INTO v_esmeraldas_id;
    
    -- 9. GALÁPAGOS
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_province_type_id, 'GALAPAGOS', 'Galápagos', v_ecuador_id)
    RETURNING catalogue_value_id INTO v_galapagos_id;
    
    -- 10. GUAYAS
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_province_type_id, 'GUAYAS', 'Guayas', v_ecuador_id)
    RETURNING catalogue_value_id INTO v_guayas_id;
    
    -- 11. IMBABURA
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_province_type_id, 'IMBABURA', 'Imbabura', v_ecuador_id)
    RETURNING catalogue_value_id INTO v_imbabura_id;
    
    -- 12. LOJA
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_province_type_id, 'LOJA', 'Loja', v_ecuador_id)
    RETURNING catalogue_value_id INTO v_loja_id;
    
    -- 13. LOS RÍOS
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_province_type_id, 'LOS_RIOS', 'Los Ríos', v_ecuador_id)
    RETURNING catalogue_value_id INTO v_los_rios_id;
    
    -- 14. MANABÍ
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_province_type_id, 'MANABI', 'Manabí', v_ecuador_id)
    RETURNING catalogue_value_id INTO v_manabi_id;
    
    -- 15. MORONA SANTIAGO
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_province_type_id, 'MORONA_SANTIAGO', 'Morona Santiago', v_ecuador_id)
    RETURNING catalogue_value_id INTO v_morona_santiago_id;
    
    -- 16. NAPO
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_province_type_id, 'NAPO', 'Napo', v_ecuador_id)
    RETURNING catalogue_value_id INTO v_napo_id;
    
    -- 17. ORELLANA
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_province_type_id, 'ORELLANA', 'Orellana', v_ecuador_id)
    RETURNING catalogue_value_id INTO v_orellana_id;
    
    -- 18. PASTAZA
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_province_type_id, 'PASTAZA', 'Pastaza', v_ecuador_id)
    RETURNING catalogue_value_id INTO v_pastaza_id;
    
    -- 19. PICHINCHA
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_province_type_id, 'PICHINCHA', 'Pichincha', v_ecuador_id)
    RETURNING catalogue_value_id INTO v_pichincha_id;
    
    -- 20. SANTA ELENA
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_province_type_id, 'SANTA_ELENA', 'Santa Elena', v_ecuador_id)
    RETURNING catalogue_value_id INTO v_santa_elena_id;
    
    -- 21. SANTO DOMINGO DE LOS TSÁCHILAS
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_province_type_id, 'SANTO_DOMINGO', 'Santo Domingo de los Tsáchilas', v_ecuador_id)
    RETURNING catalogue_value_id INTO v_santo_domingo_id;
    
    -- 22. SUCUMBÍOS
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_province_type_id, 'SUCUMBIOS', 'Sucumbíos', v_ecuador_id)
    RETURNING catalogue_value_id INTO v_sucumbios_id;
    
    -- 23. TUNGURAHUA
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_province_type_id, 'TUNGURAHUA', 'Tungurahua', v_ecuador_id)
    RETURNING catalogue_value_id INTO v_tungurahua_id;
    
    -- 24. ZAMORA CHINCHIPE
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_province_type_id, 'ZAMORA_CHINCHIPE', 'Zamora Chinchipe', v_ecuador_id)
    RETURNING catalogue_value_id INTO v_zamora_chinchipe_id;
    
    -- =========================
    -- INSERT CAPITAL CITIES
    -- =========================
    
    -- 1. Cuenca (Azuay)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_city_type_id, 'CUENCA', 'Cuenca', v_azuay_id)
    RETURNING catalogue_value_id INTO v_cuenca_id;
    
    -- 2. Guaranda (Bolívar)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_city_type_id, 'GUARANDA', 'Guaranda', v_bolivar_id)
    RETURNING catalogue_value_id INTO v_guaranda_id;
    
    -- 3. Azogues (Cañar)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_city_type_id, 'AZOGUES', 'Azogues', v_canar_id)
    RETURNING catalogue_value_id INTO v_azogues_id;
    
    -- 4. Tulcán (Carchi)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_city_type_id, 'TULCAN', 'Tulcán', v_carchi_id)
    RETURNING catalogue_value_id INTO v_tulcan_id;
    
    -- 5. Riobamba (Chimborazo)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_city_type_id, 'RIOBAMBA', 'Riobamba', v_chimborazo_id)
    RETURNING catalogue_value_id INTO v_riobamba_id;
    
    -- 6. Latacunga (Cotopaxi)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_city_type_id, 'LATACUNGA', 'Latacunga', v_cotopaxi_id)
    RETURNING catalogue_value_id INTO v_latacunga_id;
    
    -- 7. Machala (El Oro)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_city_type_id, 'MACHALA', 'Machala', v_el_oro_id)
    RETURNING catalogue_value_id INTO v_machala_id;
    
    -- 8. Esmeraldas (Esmeraldas)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_city_type_id, 'ESMERALDAS', 'Esmeraldas', v_esmeraldas_id)
    RETURNING catalogue_value_id INTO v_esmeraldas_city_id;
    
    -- 9. Puerto Baquerizo Moreno (Galápagos)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_city_type_id, 'PUERTO_BAQUERIZO_MORENO', 'Puerto Baquerizo Moreno', v_galapagos_id)
    RETURNING catalogue_value_id INTO v_puerto_baquerizo_id;
    
    -- 10. Guayaquil (Guayas)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_city_type_id, 'GUAYAQUIL', 'Guayaquil', v_guayas_id)
    RETURNING catalogue_value_id INTO v_guayaquil_id;
    
    -- 11. Ibarra (Imbabura)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_city_type_id, 'IBARRA', 'Ibarra', v_imbabura_id)
    RETURNING catalogue_value_id INTO v_ibarra_id;
    
    -- 12. Loja (Loja)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_city_type_id, 'LOJA', 'Loja', v_loja_id)
    RETURNING catalogue_value_id INTO v_loja_city_id;
    
    -- 13. Babahoyo (Los Ríos)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_city_type_id, 'BABAHOYO', 'Babahoyo', v_los_rios_id)
    RETURNING catalogue_value_id INTO v_babahoyo_id;
    
    -- 14. Portoviejo (Manabí)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_city_type_id, 'PORTOVIEJO', 'Portoviejo', v_manabi_id)
    RETURNING catalogue_value_id INTO v_portoviejo_id;
    
    -- 15. Macas (Morona Santiago)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_city_type_id, 'MACAS', 'Macas', v_morona_santiago_id)
    RETURNING catalogue_value_id INTO v_macas_id;
    
    -- 16. Tena (Napo)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_city_type_id, 'TENA', 'Tena', v_napo_id)
    RETURNING catalogue_value_id INTO v_tena_id;
    
    -- 17. Francisco de Orellana / Coca (Orellana)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_city_type_id, 'FRANCISCO_DE_ORELLANA', 'Francisco de Orellana (Coca)', v_orellana_id)
    RETURNING catalogue_value_id INTO v_coca_id;
    
    -- 18. Puyo (Pastaza)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_city_type_id, 'PUYO', 'Puyo', v_pastaza_id)
    RETURNING catalogue_value_id INTO v_puyo_id;
    
    -- 19. Quito (Pichincha)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_city_type_id, 'QUITO', 'Quito', v_pichincha_id)
    RETURNING catalogue_value_id INTO v_quito_id;
    
    -- 20. Santa Elena (Santa Elena)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_city_type_id, 'SANTA_ELENA', 'Santa Elena', v_santa_elena_id)
    RETURNING catalogue_value_id INTO v_santa_elena_city_id;
    
    -- 21. Santo Domingo (Santo Domingo de los Tsáchilas)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_city_type_id, 'SANTO_DOMINGO', 'Santo Domingo', v_santo_domingo_id)
    RETURNING catalogue_value_id INTO v_santo_domingo_city_id;
    
    -- 22. Nueva Loja / Lago Agrio (Sucumbíos)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_city_type_id, 'NUEVA_LOJA', 'Nueva Loja (Lago Agrio)', v_sucumbios_id)
    RETURNING catalogue_value_id INTO v_nueva_loja_id;
    
    -- 23. Ambato (Tungurahua)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_city_type_id, 'AMBATO', 'Ambato', v_tungurahua_id)
    RETURNING catalogue_value_id INTO v_ambato_id;
    
    -- 24. Zamora (Zamora Chinchipe)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_city_type_id, 'ZAMORA', 'Zamora', v_zamora_chinchipe_id)
    RETURNING catalogue_value_id INTO v_zamora_id;
    
    -- =========================
    -- INSERT CAPITAL PARISHES (One urban parish per capital)
    -- =========================
    
    -- 1. Centro Histórico (Cuenca)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_parish_type_id, 'CUENCA_CENTRO', 'Centro Histórico', v_cuenca_id);
    
    -- 2. Centro (Guaranda)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_parish_type_id, 'GUARANDA_CENTRO', 'Centro', v_guaranda_id);
    
    -- 3. Centro (Azogues)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_parish_type_id, 'AZOGUES_CENTRO', 'Centro', v_azogues_id);
    
    -- 4. Centro (Tulcán)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_parish_type_id, 'TULCAN_CENTRO', 'Centro', v_tulcan_id);
    
    -- 5. Centro (Riobamba)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_parish_type_id, 'RIOBAMBA_CENTRO', 'Centro', v_riobamba_id);
    
    -- 6. Centro (Latacunga)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_parish_type_id, 'LATACUNGA_CENTRO', 'Centro', v_latacunga_id);
    
    -- 7. Centro (Machala)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_parish_type_id, 'MACHALA_CENTRO', 'Centro', v_machala_id);
    
    -- 8. Centro (Esmeraldas)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_parish_type_id, 'ESMERALDAS_CENTRO', 'Centro', v_esmeraldas_city_id);
    
    -- 9. Puerto Baquerizo Moreno (Galápagos)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_parish_type_id, 'PUERTO_BAQUERIZO_CENTRO', 'Puerto Baquerizo Moreno', v_puerto_baquerizo_id);
    
    -- 10. Centro (Guayaquil)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_parish_type_id, 'GUAYAQUIL_CENTRO', 'Centro', v_guayaquil_id);
    
    -- 11. Centro (Ibarra)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_parish_type_id, 'IBARRA_CENTRO', 'Centro', v_ibarra_id);
    
    -- 12. Centro (Loja)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_parish_type_id, 'LOJA_CENTRO', 'Centro', v_loja_city_id);
    
    -- 13. Centro (Babahoyo)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_parish_type_id, 'BABAHOYO_CENTRO', 'Centro', v_babahoyo_id);
    
    -- 14. Centro (Portoviejo)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_parish_type_id, 'PORTOVIEJO_CENTRO', 'Centro', v_portoviejo_id);
    
    -- 15. Centro (Macas)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_parish_type_id, 'MACAS_CENTRO', 'Centro', v_macas_id);
    
    -- 16. Centro (Tena)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_parish_type_id, 'TENA_CENTRO', 'Centro', v_tena_id);
    
    -- 17. Centro (Francisco de Orellana)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_parish_type_id, 'COCA_CENTRO', 'Centro', v_coca_id);
    
    -- 18. Centro (Puyo)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_parish_type_id, 'PUYO_CENTRO', 'Centro', v_puyo_id);
    
    -- 19. La Mariscal (Quito)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_parish_type_id, 'QUITO_LA_MARISCAL', 'La Mariscal', v_quito_id);
    
    -- 20. Centro (Santa Elena)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_parish_type_id, 'SANTA_ELENA_CENTRO', 'Centro', v_santa_elena_city_id);
    
    -- 21. Centro (Santo Domingo)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_parish_type_id, 'SANTO_DOMINGO_CENTRO', 'Centro', v_santo_domingo_city_id);
    
    -- 22. Centro (Nueva Loja)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_parish_type_id, 'NUEVA_LOJA_CENTRO', 'Centro', v_nueva_loja_id);
    
    -- 23. Centro (Ambato)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_parish_type_id, 'AMBATO_CENTRO', 'Centro', v_ambato_id);
    
    -- 24. Centro (Zamora)
    INSERT INTO catalogue_value (catalogue_type_id, code, name, parent_value_id)
    VALUES (v_parish_type_id, 'ZAMORA_CENTRO', 'Centro', v_zamora_id);
    
END $$;

-- =========================
-- CONTACT TYPES
-- =========================
INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'PHONE', 'Phone'
FROM catalogue_type WHERE code = 'CONTACT_TYPE';

INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'EMAIL', 'Email'
FROM catalogue_type WHERE code = 'CONTACT_TYPE';

-- =========================
-- IDENTIFICATION TYPES
-- =========================
INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'CEDULA', 'Cédula'
FROM catalogue_type WHERE code = 'IDENTIFICATION_TYPE';

INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'RUC', 'RUC'
FROM catalogue_type WHERE code = 'IDENTIFICATION_TYPE';

INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'PASSPORT', 'Passport'
FROM catalogue_type WHERE code = 'IDENTIFICATION_TYPE';

-- =========================
-- EVENT TYPES
-- =========================
INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'PHYSICAL', 'Physical Event'
FROM catalogue_type WHERE code = 'EVENT_TYPE';

INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'VIRTUAL', 'Virtual Event'
FROM catalogue_type WHERE code = 'EVENT_TYPE';

-- =========================
-- EVENT VISIBILITY
-- =========================
INSERT INTO catalogue_value (catalogue_type_id, code, name, description)
SELECT catalogue_type_id, 'PUBLIC', 'Public', 'Event visible to everyone'
FROM catalogue_type WHERE code = 'EVENT_VISIBILITY';

INSERT INTO catalogue_value (catalogue_type_id, code, name, description)
SELECT catalogue_type_id, 'PRIVATE', 'Private', 'Event visible only to invited users'
FROM catalogue_type WHERE code = 'EVENT_VISIBILITY';

-- =========================
-- INVITATION STATUS
-- =========================
INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'PENDING', 'Pending'
FROM catalogue_type WHERE code = 'INVITATION_STATUS';

INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'ACCEPTED', 'Accepted'
FROM catalogue_type WHERE code = 'INVITATION_STATUS';

INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'REJECTED', 'Rejected'
FROM catalogue_type WHERE code = 'INVITATION_STATUS';

-- =========================
-- EVENT PARTICIPATION STATUS
-- =========================
INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'INVITED', 'Invited'
FROM catalogue_type WHERE code = 'EVENT_PARTICIPATION_STATUS';

INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'ACCEPTED', 'Accepted'
FROM catalogue_type WHERE code = 'EVENT_PARTICIPATION_STATUS';

INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'REJECTED', 'Rejected'
FROM catalogue_type WHERE code = 'EVENT_PARTICIPATION_STATUS';

-- =========================
-- SOCIAL PLATFORMS
-- =========================
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
SELECT catalogue_type_id, 'TIKTOK', 'TikTok'
FROM catalogue_type WHERE code = 'SOCIAL_PLATFORM';

INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'TWITTER', 'Twitter (X)'
FROM catalogue_type WHERE code = 'SOCIAL_PLATFORM';

-- =========================
-- PORTAL THEMES
-- =========================
INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'LIGHT', 'Light Theme'
FROM catalogue_type WHERE code = 'THEME_TYPE';

INSERT INTO catalogue_value (catalogue_type_id, code, name)
SELECT catalogue_type_id, 'DARK', 'Dark Theme'
FROM catalogue_type WHERE code = 'THEME_TYPE';

-- =========================
-- END OF INITIAL DATA
-- =========================
