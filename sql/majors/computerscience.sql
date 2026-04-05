BEGIN;

-- ============================================================
-- Computer Science (CSC)
-- ============================================================

-- ------------------------------------------------------------
-- 1) Major
-- ------------------------------------------------------------
INSERT INTO majors(code, name)
VALUES ('CSC', 'Computer Science')
ON CONFLICT (code) DO NOTHING;

-- ------------------------------------------------------------
-- 2) Courses
-- ------------------------------------------------------------
INSERT INTO courses(dept, number, course_code, title, credits) VALUES
('CSC',151,'CSC 151','Functional Problem Solving with Lab',4),
('CSC',161,'CSC 161','Imperative Problem Solving with Lab',4),
('CSC',207,'CSC 207','Object-Oriented Problem Solving, Data Structures, and Algorithms',4),
('CSC',208,'CSC 208','Discrete Structures',4),
('CSC',211,'CSC 211','Computer Organization and Architecture',4),
('CSC',213,'CSC 213','Operating Systems and Parallel Algorithms',4),
('CSC',281,'CSC 281','Special Topics / Ineligible Elective Course',4),
('CSC',282,'CSC 282','Special Topics / Ineligible Elective Course',4),
('CSC',301,'CSC 301','Analysis of Algorithms',4),
('CSC',324,'CSC 324','Software Design and Development with Lab',4),
('CSC',326,'CSC 326','Advanced Software Development / Variable Credit',2),
('CSC',341,'CSC 341','Automata, Formal Languages, and Computational Complexity',4),

('MAT',131,'MAT 131','Calculus I',4),
('MAT',208,'MAT 208','Discrete Structures',4),
('MAT',218,'MAT 218','Discrete Bridges to Advanced Mathematics',4),

('STA',209,'STA 209','Applied Statistics',4),
('MAT',335,'MAT 335',NULL,4),
('STA',335,'STA 335',NULL,4),
('MAT',336,'MAT 336',NULL,4),
('STA',336,'STA 336',NULL,4)

ON CONFLICT (course_code) DO NOTHING;

-- ------------------------------------------------------------
-- 3) Introductory Sequence
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'CSC_INTRO_151', 'CSC 151', 'must_take', 10
FROM majors m
WHERE m.code = 'CSC'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'CSC_INTRO_161', 'CSC 161', 'must_take', 20
FROM majors m
WHERE m.code = 'CSC'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'CSC_INTRO_207', 'CSC 207', 'must_take', 30
FROM majors m
WHERE m.code = 'CSC'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 4) Systems
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'CSC_SYSTEMS',
       'Systems: CSC 211 or CSC 213',
       'choose_one',
       1,
       'Systems requires one of CSC 211 or CSC 213. Taking both is recommended; if both are taken, one may count toward the elective requirement.',
       40
FROM majors m
WHERE m.code = 'CSC'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 5) Upper-Level Theory
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'CSC_THEORY_301', 'CSC 301', 'must_take', 50
FROM majors m
WHERE m.code = 'CSC'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'CSC_THEORY_341', 'CSC 341', 'must_take', 60
FROM majors m
WHERE m.code = 'CSC'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 6) Software Development
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'CSC_SOFTWARE_324', 'CSC 324', 'must_take', 70
FROM majors m
WHERE m.code = 'CSC'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 7) Elective
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'CSC_ELECTIVE',
       'Elective: 4 credits in CSC at 200-level or higher',
       'custom',
       4,
       'Need 4 credits in Computer Science at the 200-level or higher. CSC 281, CSC 282, guided reading, independent study, directed research, and MAPs may not be used. Up to 2 credits of CSC 326 may count. If both CSC 211 and CSC 213 are taken, one may be used for the elective requirement.',
       80
FROM majors m
WHERE m.code = 'CSC'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 8) Also Required: discrete structures
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'CSC_DISCRETE',
       'Discrete Structures requirement',
       'choose_one',
       1,
       'Complete one of MAT 208, CSC 208, or MAT 218.',
       90
FROM majors m
WHERE m.code = 'CSC'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 9) Math elective
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'CSC_MATH_ELECTIVE',
       'Math elective',
       'custom',
       4,
       'Complete one math course numbered above MAT 131, or any statistics course creditable toward the Mathematics major.',
       100
FROM majors m
WHERE m.code = 'CSC'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 10) Summary / policy constraints
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'CSC_TOTALS_AND_POLICIES',
       'Major totals and policy constraints',
       'custom',
       32,
       'Need at least 32 credits for the major. Computer Science courses below CSC 151 do not satisfy the major. No more than 4 credits taken outside of Grinnell may count toward the 16 required credits in systems, upper-level theory, and software development. Students must complete at least 20 credits of CSC coursework creditable toward the major at Grinnell College.',
       110
FROM majors m
WHERE m.code = 'CSC'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 11) Attach course options
-- ------------------------------------------------------------

-- Intro sequence
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'CSC 151'
WHERE m.code = 'CSC'
  AND b.code = 'CSC_INTRO_151'
ON CONFLICT DO NOTHING;

INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'CSC 161'
WHERE m.code = 'CSC'
  AND b.code = 'CSC_INTRO_161'
ON CONFLICT DO NOTHING;

INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'CSC 207'
WHERE m.code = 'CSC'
  AND b.code = 'CSC_INTRO_207'
ON CONFLICT DO NOTHING;

-- Systems
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN ('CSC 211','CSC 213')
WHERE m.code = 'CSC'
  AND b.code = 'CSC_SYSTEMS'
ON CONFLICT DO NOTHING;

-- Theory
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'CSC 301'
WHERE m.code = 'CSC'
  AND b.code = 'CSC_THEORY_301'
ON CONFLICT DO NOTHING;

INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'CSC 341'
WHERE m.code = 'CSC'
  AND b.code = 'CSC_THEORY_341'
ON CONFLICT DO NOTHING;

-- Software Development
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'CSC 324'
WHERE m.code = 'CSC'
  AND b.code = 'CSC_SOFTWARE_324'
ON CONFLICT DO NOTHING;

-- Discrete requirement
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN ('MAT 208','CSC 208','MAT 218')
WHERE m.code = 'CSC'
  AND b.code = 'CSC_DISCRETE'
ON CONFLICT DO NOTHING;

COMMIT;