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
('ANT',212,'ANT 212','Graphic Medicine: Reading Medical Comics Anthropologically',4),
('ANT',221,'ANT 221','Primate Behavior and Taxonomy',4),
('ANT',225,'ANT 225','Biological Determinism and the Myth of Race',4),
('ANT',231,'ANT 231','Disasters, Society and Culture',4),
('ANT',232,'ANT 232','Health, Inequality, and Social Justice',4),
('ANT',233,'ANT 233','Anthropology of Borderlands',4),
('ANT',238,'ANT 238','Environmental Anthropology',4),
('ANT',250,'ANT 250','Language Contact',4),
('ANT',260,'ANT 260','Language, Culture, and Society',4),
('ANT',263,'ANT 263','Historical Archaeology',4),
('ANT',265,'ANT 265','Ethnography of Communication: Method and Theory',4),
('ANT',268,'ANT 268','Language, Gender and Sexuality',4),
('ANT',280,'ANT 280','Theories of Culture',4),
('ANT',285,'ANT 285','Anthropology, Violence, and Human Rights',4),
('ANT',290,'ANT 290','Archaeological Methods',4),
('ANT',291,'ANT 291','Methods of Empirical Investigation',4),
('ANT',292,'ANT 292','Ethnographic Research Methods',4),
('ANT',293,'ANT 293','Applied Research for Community Development',4),
('ANT',324,'ANT 324','War, Peace, and Human Nature',4),
('ANT',355,'ANT 355','Collective Memory in Anthropological Perspective',4),
('ANT',365,'ANT 365','Fighting Words: Conflict, Discourse, and Power',4),
('ANT',375,'ANT 375','Experimental Archaeology and Ethnoarchaeology',4),
('ANT',377,'ANT 377','War, Religion, and Politics in the Puebloan Southwest',4),
('ANT',378,'ANT 378','Archaeology of Racialized Communities',4),
('ANT',388,'ANT 388','Landscapes of Social Inequality',4),
('ANT',499,'ANT 499','Senior Thesis (MAP)',4)
ON CONFLICT (course_code) DO NOTHING;

-- ------------------------------------------------------------
-- Course offering terms and prerequisites used by the planner
-- Source: Grinnell 2025-2026 catalog, Anthropology, B.A.
-- ------------------------------------------------------------
INSERT INTO course_terms(course_id, term)
SELECT c.id, v.term
FROM courses c
JOIN (VALUES
  ('ANT 104','Fall'), ('ANT 104','Spring'),
  ('ANT 280','Fall'), ('ANT 280','Spring'),
  ('ANT 292','Fall'), ('ANT 292','Spring'),
  ('ANT 263','Fall'), ('ANT 263','Spring'),
  ('ANT 378','Fall'), ('ANT 378','Spring'),
  ('ANT 205','Fall'), ('ANT 205','Spring'),
  ('ANT 212','Fall'),
  ('ANT 231','Fall'), ('ANT 231','Spring'),
  ('ANT 232','Fall'), ('ANT 232','Spring'),
  ('ANT 233','Fall'), ('ANT 233','Spring'),
  ('ANT 238','Fall'), ('ANT 238','Spring'),
  ('ANT 388','Fall'), ('ANT 388','Spring'),
  ('SST 115','Fall'), ('SST 115','Spring'),
  ('STA 209','Fall'), ('STA 209','Spring')
) AS v(course_code, term) ON v.course_code = c.course_code
ON CONFLICT DO NOTHING;

DELETE FROM course_prerequisite_groups
USING courses c
WHERE course_prerequisite_groups.course_id = c.id
  AND c.course_code IN (
    'ANT 205','ANT 210','ANT 212','ANT 221','ANT 225','ANT 231',
    'ANT 232','ANT 233','ANT 238','ANT 250','ANT 260','ANT 263',
    'ANT 265','ANT 268','ANT 280','ANT 290','ANT 292','ANT 324',
    'ANT 355','ANT 365','ANT 375','ANT 377','ANT 378','ANT 388',
    'STA 209'
  );

DELETE FROM course_prerequisites
USING courses c
WHERE course_prerequisites.course_id = c.id
  AND c.course_code IN (
    'ANT 205','ANT 210','ANT 212','ANT 221','ANT 225','ANT 231',
    'ANT 232','ANT 233','ANT 238','ANT 250','ANT 260','ANT 263',
    'ANT 265','ANT 268','ANT 280','ANT 290','ANT 292','ANT 324',
    'ANT 355','ANT 365','ANT 375','ANT 377','ANT 378','ANT 388',
    'STA 209'
  );

INSERT INTO course_prerequisite_groups(
  course_id,
  group_code,
  prerequisite_course_id,
  can_be_corequisite
)
SELECT course.id, v.group_code, prereq.id, false
FROM (VALUES
  ('ANT 205','ant104','ANT 104'),
  ('ANT 210','ant104','ANT 104'),
  ('ANT 212','ant104','ANT 104'),
  ('ANT 221','ant104','ANT 104'),
  ('ANT 225','ant104','ANT 104'),
  ('ANT 231','ant104','ANT 104'),
  ('ANT 232','ant104','ANT 104'),
  ('ANT 233','ant104','ANT 104'),
  ('ANT 238','ant104','ANT 104'),
  ('ANT 250','ant104','ANT 104'),
  ('ANT 260','ant104','ANT 104'),
  ('ANT 263','ant104','ANT 104'),
  ('ANT 265','ant104','ANT 104'),
  ('ANT 268','ant104','ANT 104'),
  ('ANT 280','ant104','ANT 104'),
  ('ANT 290','ant104','ANT 104'),
  ('ANT 292','ant104','ANT 104'),
  ('ANT 324','ant280','ANT 280'),
  ('ANT 355','seminar_base','ANT 265'),
  ('ANT 355','seminar_base','ANT 280'),
  ('ANT 355','seminar_base','ANT 285'),
  ('ANT 365','seminar_base','ANT 265'),
  ('ANT 365','seminar_base','ANT 280'),
  ('ANT 375','ant280','ANT 280'),
  ('ANT 377','ant280','ANT 280'),
  ('ANT 378','ant280','ANT 280'),
  ('ANT 388','archaeology_base','ANT 280'),
  ('ANT 388','archaeology_base','ANT 290'),
  ('STA 209','stats_base','SST 115')
) AS v(course_code, group_code, prerequisite_code)
JOIN courses course ON course.course_code = v.course_code
JOIN courses prereq ON prereq.course_code = v.prerequisite_code
ON CONFLICT DO NOTHING;

INSERT INTO course_registration_rules(
  course_id,
  min_semester_index,
  min_prior_courses_dept,
  min_prior_courses_min_number,
  min_prior_courses_max_number,
  min_prior_courses_count,
  notes
)
SELECT c.id,
       v.min_semester_index,
       v.min_prior_courses_dept,
       v.min_prior_courses_min_number,
       v.min_prior_courses_max_number,
       v.min_prior_courses_count,
       v.notes
FROM courses c
JOIN (VALUES
  ('SST 115',1,NULL,NULL,NULL,NULL,'Second semester of first-year standing.'),
  ('ANT 293',2,NULL,NULL,NULL,NULL,'Second-year standing.'),
  ('ANT 280',NULL,'ANT',200,299,1,'ANT 104 and at least one 200-level anthropology course.'),
  ('ANT 285',NULL,'ANT',200,299,1,'One 200-level Anthropology, Political Science, or GWSS course.'),
  ('ANT 499',6,'ANT',300,399,1,'Senior thesis after advanced anthropology coursework.')
) AS v(
  course_code,
  min_semester_index,
  min_prior_courses_dept,
  min_prior_courses_min_number,
  min_prior_courses_max_number,
  min_prior_courses_count,
  notes
) ON v.course_code = c.course_code
ON CONFLICT (course_id) DO UPDATE
SET min_semester_index = EXCLUDED.min_semester_index,
    min_prior_courses_dept = EXCLUDED.min_prior_courses_dept,
    min_prior_courses_min_number = EXCLUDED.min_prior_courses_min_number,
    min_prior_courses_max_number = EXCLUDED.min_prior_courses_max_number,
    min_prior_courses_count = EXCLUDED.min_prior_courses_count,
    notes = EXCLUDED.notes;

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
  AND c.course_code IN ('ANT 263','ANT 290','ANT 375','ANT 377','ANT 378','ANT 388')
ON CONFLICT DO NOTHING;

-- Biological Anthropology
INSERT INTO course_subfields(course_id, subfield_id)
SELECT c.id, s.id
FROM courses c
JOIN subfields s ON TRUE
JOIN majors m ON m.id = s.major_id
WHERE m.code = 'ANTH'
  AND s.code = 'BIO'
  AND c.course_code IN ('ANT 205','ANT 221','ANT 225','ANT 324')
ON CONFLICT DO NOTHING;

-- Cultural Anthropology
INSERT INTO course_subfields(course_id, subfield_id)
SELECT c.id, s.id
FROM courses c
JOIN subfields s ON TRUE
JOIN majors m ON m.id = s.major_id
WHERE m.code = 'ANTH'
  AND s.code = 'CULT'
  AND c.course_code IN (
    'ANT 210','ANT 212','ANT 231','ANT 232','ANT 233','ANT 238',
    'ANT 285','ANT 292','ANT 293','ANT 355'
  )
ON CONFLICT DO NOTHING;

-- Linguistic Anthropology
INSERT INTO course_subfields(course_id, subfield_id)
SELECT c.id, s.id
FROM courses c
JOIN subfields s ON TRUE
JOIN majors m ON m.id = s.major_id
WHERE m.code = 'ANTH'
  AND s.code = 'LING'
  AND c.course_code IN ('ANT 250','ANT 260','ANT 265','ANT 268','ANT 365')
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
JOIN courses c ON c.course_code IN (
  'ANT 324','ANT 355','ANT 365','ANT 375','ANT 377','ANT 378','ANT 388'
)
WHERE m.code = 'ANTH'
  AND b.code = 'ANTH_ADV_PATH_A'
ON CONFLICT DO NOTHING;

COMMIT;
