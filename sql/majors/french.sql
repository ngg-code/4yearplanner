BEGIN;

-- ============================================================
-- French (FRN)
-- ============================================================

-- ------------------------------------------------------------
-- 1) Major
-- ------------------------------------------------------------
INSERT INTO majors(code, name)
VALUES ('FRN', 'French')
ON CONFLICT (code) DO NOTHING;

-- ------------------------------------------------------------
-- 2) Courses
-- ------------------------------------------------------------
INSERT INTO courses(dept, number, course_code, title, credits) VALUES
('FRN',101,'FRN 101','Elementary French I',4),
('FRN',102,'FRN 102','Elementary French II',4),
('FRN',103,'FRN 103','Elementary French III',4),

('FRN',221,'FRN 221','Intermediate French I',4),
('FRN',222,'FRN 222','Intermediate French II',4),

('FRN',301,'FRN 301','Advanced French Language',4),
('FRN',303,'FRN 303','Cultures of the French-Speaking World',4),
('FRN',304,'FRN 304','Cultures of the French-Speaking World',4),
('FRN',305,'FRN 305','Cultures of the French-Speaking World',4),
('FRN',312,'FRN 312','Creative Works in French',4),
('FRN',313,'FRN 313','Creative Works in French',4),

('FRN',327,'FRN 327','Social Climbers and Rebels',4),
('FRN',328,'FRN 328','Comedy in French Literature Prior to the Revolution',4),
('FRN',329,'FRN 329','Literature and Society in 19th-Century and Belle Epoque France',4),
('FRN',330,'FRN 330','Innovation and Transgression in French from 1870 to 1945',4),
('FRN',341,'FRN 341','Contemporary French Writing',4),
('FRN',342,'FRN 342','Orientalism Revisited',4),
('FRN',346,'FRN 346','The Francophone Caribbean World: From Plantation to Emancipation',4),
('FRN',348,'FRN 348','Fictions of Francophone African Cities',4),
('FRN',350,'FRN 350','Advanced Topics in Literature and Civilization',4),
('FRN',395,'FRN 395','Special Topics Course',4)

ON CONFLICT (course_code) DO NOTHING;

-- ------------------------------------------------------------
-- 3) Required content-area course: FRN 303 or 304 or 305
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'FRN_REQUIRED_CULTURE',
       'Required: FRN 303 or FRN 304 or FRN 305',
       'choose_one',
       1,
       'Complete one of FRN 303, FRN 304, or FRN 305.',
       10
FROM majors m
WHERE m.code = 'FRN'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 4) Required creative works course: FRN 312 or 313
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'FRN_REQUIRED_CREATIVE',
       'Required: FRN 312 or FRN 313',
       'choose_one',
       1,
       'Complete one of FRN 312 or FRN 313.',
       20
FROM majors m
WHERE m.code = 'FRN'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 5) Required seminar
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'FRN_REQUIRED_SEMINAR',
       'Required: one four-credit seminar',
       'choose_one',
       1,
       'Complete one four-credit seminar from the approved French seminar list.',
       30
FROM majors m
WHERE m.code = 'FRN'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 6) 300-level minimum / department-at-Grinnell rule
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'FRN_300_LEVEL_MINIMUM',
       'Minimum three 300-level French courses at Grinnell',
       'custom',
       12,
       'Major requires a minimum of three 300-level courses (12 credits) taken in the Department of French at Grinnell.',
       40
FROM majors m
WHERE m.code = 'FRN'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 7) Overall totals
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'FRN_TOTALS',
       'Major totals',
       'custom',
       32,
       'Need at least 32 credits, excluding FRN 101, FRN 102, and FRN 103. At least 20 credits overall and a minimum of three 300-level courses (12 credits) must be taken in the Department of French at Grinnell.',
       50
FROM majors m
WHERE m.code = 'FRN'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 8) Honors note
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, notes, sort_order
)
SELECT m.id,
       'FRN_HONORS_NOTE',
       'Honors note',
       'custom',
       'For honors in French, students must complete two 300-level seminars, with at least one taken in the senior year, and must be recommended by the faculty in French based on seminar performance.',
       60
FROM majors m
WHERE m.code = 'FRN'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 9) Attach course options
-- ------------------------------------------------------------

-- FRN 303 / 304 / 305
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN ('FRN 303','FRN 304','FRN 305')
WHERE m.code = 'FRN'
  AND b.code = 'FRN_REQUIRED_CULTURE'
ON CONFLICT DO NOTHING;

-- FRN 312 / 313
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN ('FRN 312','FRN 313')
WHERE m.code = 'FRN'
  AND b.code = 'FRN_REQUIRED_CREATIVE'
ON CONFLICT DO NOTHING;

-- Seminar list
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN (
  'FRN 327','FRN 328','FRN 329','FRN 330','FRN 341',
  'FRN 342','FRN 346','FRN 348','FRN 350','FRN 395'
)
WHERE m.code = 'FRN'
  AND b.code = 'FRN_REQUIRED_SEMINAR'
ON CONFLICT DO NOTHING;

COMMIT;