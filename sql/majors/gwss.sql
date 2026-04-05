BEGIN;

-- ============================================================
-- Gender, Women's, and Sexuality Studies (GWS)
-- ============================================================

-- ------------------------------------------------------------
-- 1) Major
-- ------------------------------------------------------------
INSERT INTO majors(code, name)
VALUES ('GWS', 'Gender, Women’s, and Sexuality Studies')
ON CONFLICT (code) DO NOTHING;

-- ------------------------------------------------------------
-- 2) Core Courses
-- ------------------------------------------------------------
INSERT INTO courses(dept, number, course_code, title, credits) VALUES
('GWS',111,'GWS 111','Introduction to Gender, Women’s, and Sexuality Studies',4),
('GWS',249,'GWS 249','Theory and Methodology in GWSS',4),
('GWS',495,'GWS 495','Senior Seminar',4)
ON CONFLICT (course_code) DO NOTHING;

-- ------------------------------------------------------------
-- 3) Core Requirements
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'GWS_CORE_111', 'GWS 111', 'must_take', 10
FROM majors m WHERE m.code='GWS'
ON CONFLICT DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'GWS_CORE_249', 'GWS 249', 'must_take', 20
FROM majors m WHERE m.code='GWS'
ON CONFLICT DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'GWS_CORE_495', 'GWS 495 Senior Seminar', 'must_take', 30
FROM majors m WHERE m.code='GWS'
ON CONFLICT DO NOTHING;

-- ------------------------------------------------------------
-- 4) Topic Areas (A–D)
-- ------------------------------------------------------------

-- A: Sexuality and Queer Studies
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'GWS_AREA_A',
       'Area A: Sexuality and Queer Studies',
       'choose_one',
       1,
       'Choose one course from Area A list. Courses cross-listed or variable topics require approval.',
       40
FROM majors m WHERE m.code='GWS'
ON CONFLICT DO NOTHING;

-- B: Cross-Cultural
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'GWS_AREA_B',
       'Area B: Cross-Cultural and Transnational Approaches',
       'choose_one',
       1,
       'Choose one course from Area B list.',
       50
FROM majors m WHERE m.code='GWS'
ON CONFLICT DO NOTHING;

-- C: Literary / Visual
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'GWS_AREA_C',
       'Area C: Literary Criticism and Visual Culture',
       'choose_one',
       1,
       'Choose one course from Area C list.',
       60
FROM majors m WHERE m.code='GWS'
ON CONFLICT DO NOTHING;

-- D: Political / Social
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'GWS_AREA_D',
       'Area D: Political / Social Analyses',
       'choose_one',
       1,
       'Choose one course from Area D list.',
       70
FROM majors m WHERE m.code='GWS'
ON CONFLICT DO NOTHING;

-- ------------------------------------------------------------
-- 5) Area diversity requirement
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'GWS_AREA_DIVERSITY',
       'Area requirement: at least 3 distinct areas',
       'custom',
       3,
       'Must take three courses from at least three different topic areas (A–D). Courses listed in multiple areas can only count toward one.',
       80
FROM majors m WHERE m.code='GWS'
ON CONFLICT DO NOTHING;

-- ------------------------------------------------------------
-- 6) 300-level requirement
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'GWS_300_LEVEL',
       '300-level requirement',
       'custom',
       2,
       'At least two courses must be at the 300-level from approved GWSS-related lists.',
       90
FROM majors m WHERE m.code='GWS'
ON CONFLICT DO NOTHING;

-- ------------------------------------------------------------
-- 7) Overall totals
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'GWS_TOTALS',
       'Major totals',
       'custom',
       32,
       'Minimum of 32 credits total including core and area requirements.',
       100
FROM majors m WHERE m.code='GWS'
ON CONFLICT DO NOTHING;

-- ------------------------------------------------------------
-- 8) Attach course options (sample subset)
-- ------------------------------------------------------------

-- Area A sample
INSERT INTO courses(dept, number, course_code, title, credits) VALUES
('GWS',211,'GWS 211','Foundations of LGBTQ Studies',4),
('SOC',260,'SOC 260','Human Sexuality in the United States',4),
('ENG',274,'ENG 274','Sex, Gender, and Critical Theory',4)
ON CONFLICT DO NOTHING;

INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id=b.major_id
JOIN courses c ON c.course_code IN ('GWS 211','SOC 260','ENG 274')
WHERE m.code='GWS' AND b.code='GWS_AREA_A'
ON CONFLICT DO NOTHING;

-- Area B sample
INSERT INTO courses(dept, number, course_code, title, credits) VALUES
('CHI',230,'CHI 230','Chinese Women: Past and Present',4),
('GWS',324,'GWS 324','Critical Race Feminisms',4)
ON CONFLICT DO NOTHING;

INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id=b.major_id
JOIN courses c ON c.course_code IN ('CHI 230','GWS 324')
WHERE m.code='GWS' AND b.code='GWS_AREA_B'
ON CONFLICT DO NOTHING;

-- Area C sample
INSERT INTO courses(dept, number, course_code, title, credits) VALUES
('ENG',223,'ENG 223','The Tradition of English Literature I',4),
('ENG',390,'ENG 390','Literary Theory',4)
ON CONFLICT DO NOTHING;

INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id=b.major_id
JOIN courses c ON c.course_code IN ('ENG 223','ENG 390')
WHERE m.code='GWS' AND b.code='GWS_AREA_C'
ON CONFLICT DO NOTHING;

-- Area D sample
INSERT INTO courses(dept, number, course_code, title, credits) VALUES
('SOC',270,'SOC 270','Gender and Society',4),
('PHI',261,'PHI 261','Philosophy of Race and Gender',4)
ON CONFLICT DO NOTHING;

INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id=b.major_id
JOIN courses c ON c.course_code IN ('SOC 270','PHI 261')
WHERE m.code='GWS' AND b.code='GWS_AREA_D'
ON CONFLICT DO NOTHING;

COMMIT;