BEGIN;

-- ============================================================
-- Anthropology
-- ============================================================

-- ------------------------------------------------------------
-- 1) Major-specific courses
-- ------------------------------------------------------------
INSERT INTO courses(dept, number, course_code, title, credits) VALUES
('ANT',104,'ANT 104','Anthropological Inquiries',4),
('ANT',205,'ANT 205','Human Evolution',4),
('ANT',210,'ANT 210','Illness, Healing, and Culture',4),
('ANT',225,'ANT 225','Biological Determinism and the Myth of Race',4),
('ANT',238,'ANT 238','Environmental Anthropology',4),
('ANT',250,'ANT 250','Language Contact',4),
('ANT',260,'ANT 260','Language, Culture, and Society',4),
('ANT',263,'ANT 263','Historical Archaeology',4),
('ANT',265,'ANT 265','Ethnography of Communication: Method and Theory',4),
('ANT',280,'ANT 280','Theories of Culture',4),
('ANT',290,'ANT 290','Archaeological Methods',4),
('ANT',291,'ANT 291','Methods of Empirical Investigation',4),
('ANT',292,'ANT 292','Ethnographic Research Methods',4),
('ANT',293,'ANT 293','Applied Research for Community Development',4),
('ANT',375,'ANT 375','Experimental Archaeology and Ethnoarchaeology',4),
('ANT',499,'ANT 499','Senior Thesis (MAP)',4)
ON CONFLICT (course_code) DO NOTHING;

-- ------------------------------------------------------------
-- 2) Subfields
-- ------------------------------------------------------------
INSERT INTO subfields(major_id, code, name)
SELECT m.id, v.code, v.name
FROM majors m
JOIN (
  VALUES
    ('ARCH','Archaeology'),
    ('BIO','Biological Anthropology'),
    ('CULT','Cultural Anthropology'),
    ('LING','Linguistic Anthropology')
) AS v(code, name) ON TRUE
WHERE m.code = 'ANTH'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 3) Course-subfield tags
-- ------------------------------------------------------------

-- Archaeology
INSERT INTO course_subfields(course_id, subfield_id)
SELECT c.id, s.id
FROM courses c
JOIN subfields s ON TRUE
JOIN majors m ON m.id = s.major_id
WHERE m.code = 'ANTH'
  AND s.code = 'ARCH'
  AND c.course_code IN ('ANT 263','ANT 290','ANT 375')
ON CONFLICT DO NOTHING;

-- Biological Anthropology
INSERT INTO course_subfields(course_id, subfield_id)
SELECT c.id, s.id
FROM courses c
JOIN subfields s ON TRUE
JOIN majors m ON m.id = s.major_id
WHERE m.code = 'ANTH'
  AND s.code = 'BIO'
  AND c.course_code IN ('ANT 205','ANT 225')
ON CONFLICT DO NOTHING;

-- Cultural Anthropology
INSERT INTO course_subfields(course_id, subfield_id)
SELECT c.id, s.id
FROM courses c
JOIN subfields s ON TRUE
JOIN majors m ON m.id = s.major_id
WHERE m.code = 'ANTH'
  AND s.code = 'CULT'
  AND c.course_code IN ('ANT 210','ANT 238','ANT 292','ANT 293')
ON CONFLICT DO NOTHING;

-- Linguistic Anthropology
INSERT INTO course_subfields(course_id, subfield_id)
SELECT c.id, s.id
FROM courses c
JOIN subfields s ON TRUE
JOIN majors m ON m.id = s.major_id
WHERE m.code = 'ANTH'
  AND s.code = 'LING'
  AND c.course_code IN ('ANT 250','ANT 260','ANT 265')
ON CONFLICT DO NOTHING;

-- ------------------------------------------------------------
-- 4) Requirement blocks
-- ------------------------------------------------------------

INSERT INTO requirement_blocks(major_id, code, title, rule_type, notes, sort_order)
SELECT m.id, 'ANTH_CORE_ANT104', 'Core: ANT 104', 'must_take', NULL, 10
FROM majors m
WHERE m.code = 'ANTH'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, notes, sort_order)
SELECT m.id, 'ANTH_CORE_ANT280', 'Core: ANT 280', 'must_take', NULL, 20
FROM majors m
WHERE m.code = 'ANTH'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_count, notes, sort_order)
SELECT m.id, 'ANTH_METHODS_1', 'Methods: choose 1 course', 'choose_one', 1,
       'Choose one Methods course (ANT 265/290/291/292/293).', 30
FROM majors m
WHERE m.code = 'ANTH'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_credits, notes, sort_order)
SELECT m.id, 'ANTH_FOUR_FIELDS', 'Four Fields Coverage: 3 of 4 subfields (200/300-level)', 'custom', 12,
       'Need 3 distinct subfields; each satisfied by one four-credit 200/300 ANT course from that subfield.',
       40
FROM majors m
WHERE m.code = 'ANTH'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, notes, sort_order)
SELECT m.id, 'ANTH_ADV_OR', 'Advanced Coursework (choose a path)', 'or_group',
       'Either (A) two 300-level ANT courses OR (B) one 300-level ANT + ANT 499.',
       50
FROM majors m
WHERE m.code = 'ANTH'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_count, notes, sort_order)
SELECT m.id, 'ANTH_ADV_PATH_A', 'Path A: take 2 ANT 300-level courses', 'choose_n', 2,
       'Approved 300-level ANT courses listed in block_course_options.',
       51
FROM majors m
WHERE m.code = 'ANTH'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_count, notes, sort_order)
SELECT m.id, 'ANTH_ADV_PATH_B', 'Path B: 1 ANT 300-level + ANT 499 (thesis)', 'custom', 2,
       'Custom check: at least one ANT 300-level course and ANT 499.',
       52
FROM majors m
WHERE m.code = 'ANTH'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_count, notes, sort_order)
SELECT m.id, 'ANTH_STATS', 'Statistics: SST 115 or STA 209', 'choose_one', 1,
       'Complete SST 115 or STA 209.',
       60
FROM majors m
WHERE m.code = 'ANTH'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 5) OR links
-- ------------------------------------------------------------
INSERT INTO block_or_children(parent_block_id, child_block_id)
SELECT p.id, c.id
FROM requirement_blocks p
JOIN requirement_blocks c
  ON c.major_id = p.major_id
JOIN majors m
  ON m.id = p.major_id
WHERE m.code = 'ANTH'
  AND p.code = 'ANTH_ADV_OR'
  AND c.code IN ('ANTH_ADV_PATH_A', 'ANTH_ADV_PATH_B')
ON CONFLICT DO NOTHING;

-- ------------------------------------------------------------
-- 6) Block course options
-- ------------------------------------------------------------

-- ANT 104
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'ANT 104'
WHERE m.code = 'ANTH'
  AND b.code = 'ANTH_CORE_ANT104'
ON CONFLICT DO NOTHING;

-- ANT 280
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'ANT 280'
WHERE m.code = 'ANTH'
  AND b.code = 'ANTH_CORE_ANT280'
ON CONFLICT DO NOTHING;

-- Methods
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN ('ANT 265','ANT 290','ANT 291','ANT 292','ANT 293')
WHERE m.code = 'ANTH'
  AND b.code = 'ANTH_METHODS_1'
ON CONFLICT DO NOTHING;

-- Statistics
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN ('SST 115','STA 209')
WHERE m.code = 'ANTH'
  AND b.code = 'ANTH_STATS'
ON CONFLICT DO NOTHING;

-- Advanced Path A options
INSERT INTO block_course_options(block_id, course_id, min_level, max_level)
SELECT b.id, c.id, 300, 399
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN ('ANT 375')
WHERE m.code = 'ANTH'
  AND b.code = 'ANTH_ADV_PATH_A'
ON CONFLICT DO NOTHING;

COMMIT;