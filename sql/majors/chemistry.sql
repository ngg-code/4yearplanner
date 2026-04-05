BEGIN;

-- ============================================================
-- Chemistry (CHM)
-- ============================================================

-- ------------------------------------------------------------
-- 1) Major
-- ------------------------------------------------------------
INSERT INTO majors(code, name)
VALUES ('CHM', 'Chemistry')
ON CONFLICT (code) DO NOTHING;

-- ------------------------------------------------------------
-- 2) Courses
-- ------------------------------------------------------------
INSERT INTO courses(dept, number, course_code, title, credits) VALUES
('CHM',129,'CHM 129','General Chemistry',4),
('CHM',210,'CHM 210','Analytical Chemistry',4),
('CHM',221,'CHM 221','Organic Chemistry I',4),
('CHM',222,'CHM 222','Organic Chemistry II',4),
('CHM',232,'CHM 232','Foundations in Inorganic Chemistry',4),
('CHM',240,'CHM 240','Environmental Chemistry',4),
('CHM',325,'CHM 325','Advanced Organic Chemistry',4),
('CHM',330,'CHM 330','Bioorganic Chemistry',4),
('CHM',332,'CHM 332','Biophysical Chemistry',4),
('CHM',340,'CHM 340','Aquatic Geochemistry',4),
('CHM',358,'CHM 358','Instrumental Analysis',4),
('CHM',363,'CHM 363','Physical Chemistry I',4),
('CHM',364,'CHM 364','Physical Chemistry II',4),
('CHM',423,'CHM 423','Advanced Inorganic Chemistry',4),
('CHM',499,'CHM 499','Mentored Advanced Project',4),

('BCM',262,'BCM 262','Introduction to Biological Chemistry',4),

('MAT',131,'MAT 131','Calculus I',4),
('MAT',133,'MAT 133','Calculus II',4),
('STA',209,'STA 209','Applied Statistics',4),
('STA',230,'STA 230','Introduction to Data Science',4),

('PHY',131,'PHY 131','General Physics I',4),
('PHY',132,'PHY 132','General Physics II',4)

ON CONFLICT (course_code) DO NOTHING;

-- ------------------------------------------------------------
-- 3) Core Requirements
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'CHM_CORE_129', 'CHM 129', 'must_take', 10
FROM majors m
WHERE m.code = 'CHM'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'CHM_CORE_221', 'CHM 221', 'must_take', 20
FROM majors m
WHERE m.code = 'CHM'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'CHM_CORE_363', 'CHM 363', 'must_take', 30
FROM majors m
WHERE m.code = 'CHM'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, notes, sort_order)
SELECT m.id, 'CHM_CORE_499', 'CHM 499 Mentored Advanced Project', 'must_take',
       'Participation in the Chemistry Colloquium is required for CHM 499 projects.',
       40
FROM majors m
WHERE m.code = 'CHM'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 4) Intermediate Electives
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'CHM_INTERMEDIATE_8',
       'Intermediate Electives: 8 credits',
       'choose_credits',
       8,
       'Take 8 credits from CHM 210, CHM 222, CHM 232, CHM 240, BCM 262.',
       50
FROM majors m
WHERE m.code = 'CHM'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 5) Advanced Electives
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'CHM_ADVANCED_8',
       'Advanced Electives: 8 credits',
       'choose_credits',
       8,
       'Take 8 credits from CHM 325, CHM 330, CHM 332, CHM 340, CHM 358, CHM 364, CHM 423.',
       60
FROM majors m
WHERE m.code = 'CHM'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 6) Elective distribution rules
-- ------------------------------------------------------------
-- Need one elective from:
-- CHM 222, CHM 232, BCM 262, CHM 325, CHM 330, CHM 332, CHM 423
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'CHM_DISTRIBUTION_A',
       'Elective distribution A: choose 1',
       'choose_one',
       1,
       'At least one elective must come from CHM 222, CHM 232, BCM 262, CHM 325, CHM 330, CHM 332, or CHM 423.',
       70
FROM majors m
WHERE m.code = 'CHM'
ON CONFLICT (major_id, code) DO NOTHING;

-- Need one elective from:
-- CHM 210, CHM 240, CHM 340, CHM 358, CHM 364
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'CHM_DISTRIBUTION_B',
       'Elective distribution B: choose 1',
       'choose_one',
       1,
       'At least one elective must come from CHM 210, CHM 240, CHM 340, CHM 358, or CHM 364.',
       80
FROM majors m
WHERE m.code = 'CHM'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 7) Also Required
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'CHM_REQ_MAT131', 'MAT 131', 'must_take', 90
FROM majors m
WHERE m.code = 'CHM'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'CHM_REQ_MATH_OR',
       'MAT 133 or STA 209 or STA 230',
       'choose_one',
       1,
       'Students with AP/IB/CAPE/A-level credit for MAT 131 must complete MAT 133 at Grinnell.',
       100
FROM majors m
WHERE m.code = 'CHM'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'CHM_REQ_PHY131', 'PHY 131', 'must_take', 110
FROM majors m
WHERE m.code = 'CHM'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'CHM_REQ_PHY132', 'PHY 132', 'must_take', 120
FROM majors m
WHERE m.code = 'CHM'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 8) Summary / custom cap block
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'CHM_TOTALS_AND_OUTSIDE',
       'Major totals + outside-department cap',
       'custom',
       32,
       'Need at least 32 credits total for the major. With permission, up to 4 of the minimum 32 credits may be taken in related studies outside the department.',
       130
FROM majors m
WHERE m.code = 'CHM'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 9) Attach course options
-- ------------------------------------------------------------

-- Core: CHM 129
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'CHM 129'
WHERE m.code = 'CHM'
  AND b.code = 'CHM_CORE_129'
ON CONFLICT DO NOTHING;

-- Core: CHM 221
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'CHM 221'
WHERE m.code = 'CHM'
  AND b.code = 'CHM_CORE_221'
ON CONFLICT DO NOTHING;

-- Core: CHM 363
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'CHM 363'
WHERE m.code = 'CHM'
  AND b.code = 'CHM_CORE_363'
ON CONFLICT DO NOTHING;

-- Core: CHM 499
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'CHM 499'
WHERE m.code = 'CHM'
  AND b.code = 'CHM_CORE_499'
ON CONFLICT DO NOTHING;

-- Intermediate electives
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c
  ON c.course_code IN ('CHM 210','CHM 222','CHM 232','CHM 240','BCM 262')
WHERE m.code = 'CHM'
  AND b.code = 'CHM_INTERMEDIATE_8'
ON CONFLICT DO NOTHING;

-- Advanced electives
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c
  ON c.course_code IN ('CHM 325','CHM 330','CHM 332','CHM 340','CHM 358','CHM 364','CHM 423')
WHERE m.code = 'CHM'
  AND b.code = 'CHM_ADVANCED_8'
ON CONFLICT DO NOTHING;

-- Distribution A
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c
  ON c.course_code IN ('CHM 222','CHM 232','BCM 262','CHM 325','CHM 330','CHM 332','CHM 423')
WHERE m.code = 'CHM'
  AND b.code = 'CHM_DISTRIBUTION_A'
ON CONFLICT DO NOTHING;

-- Distribution B
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c
  ON c.course_code IN ('CHM 210','CHM 240','CHM 340','CHM 358','CHM 364')
WHERE m.code = 'CHM'
  AND b.code = 'CHM_DISTRIBUTION_B'
ON CONFLICT DO NOTHING;

-- Math: MAT 131
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'MAT 131'
WHERE m.code = 'CHM'
  AND b.code = 'CHM_REQ_MAT131'
ON CONFLICT DO NOTHING;

-- Math OR
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c
  ON c.course_code IN ('MAT 133','STA 209','STA 230')
WHERE m.code = 'CHM'
  AND b.code = 'CHM_REQ_MATH_OR'
ON CONFLICT DO NOTHING;

-- Physics: PHY 131
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'PHY 131'
WHERE m.code = 'CHM'
  AND b.code = 'CHM_REQ_PHY131'
ON CONFLICT DO NOTHING;

-- Physics: PHY 132
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'PHY 132'
WHERE m.code = 'CHM'
  AND b.code = 'CHM_REQ_PHY132'
ON CONFLICT DO NOTHING;

COMMIT;