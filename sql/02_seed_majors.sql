BEGIN;

INSERT INTO majors(code, name) VALUES
('ANTH', 'Anthropology'),
('ARH',  'Art History')
ON CONFLICT (code) DO NOTHING;

COMMIT;