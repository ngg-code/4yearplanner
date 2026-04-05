BEGIN;

-- ============================================================
-- Economics (ECN)
-- ============================================================

-- ------------------------------------------------------------
-- 1) Major
-- ------------------------------------------------------------
INSERT INTO majors(code, name)
VALUES ('ECN', 'Economics')
ON CONFLICT (code) DO NOTHING;

-- ------------------------------------------------------------
-- 2) Courses
-- ------------------------------------------------------------
INSERT INTO courses(dept, number, course_code, title, credits) VALUES
('ECN',111,'ECN 111','Introduction to Economics',4),
('ECN',215,'ECN 215','Labor Economics',4),
('ECN',226,'ECN 226','Economics of Innovation',4),
('ECN',230,'ECN 230','Economic Development',4),
('ECN',233,'ECN 233','International Economics',4),
('ECN',235,'ECN 235','Money and Banking',4),
('ECN',236,'ECN 236','Health Economics',4),
('ECN',238,'ECN 238','Economic History',4),
('ECN',240,'ECN 240','Resource and Environmental Economics',4),
('ECN',250,'ECN 250','Public Economics',4),

('ECN',280,'ECN 280','Microeconomic Analysis',4),
('ECN',282,'ECN 282','Macroeconomic Analysis',4),
('ECN',286,'ECN 286','Econometrics',4),

('ECN',326,'ECN 326','Financial and Managerial Accounting',4),
('ECN',327,'ECN 327','Corporate Finance',4),
('ECN',328,'ECN 328','Time Series Econometrics',4),
('ECN',336,'ECN 336','Behavioral and Experimental Economics',4),
('ECN',338,'ECN 338','Applied Game Theory',4),

('ECN',366,'ECN 366','Seminar in Health Economics',4),
('ECN',369,'ECN 369','Seminar in Environmental Economics',4),
('ECN',370,'ECN 370','Seminar in Political Economy',4),
('ECN',372,'ECN 372','Seminar in Economic Development',4),
('ECN',374,'ECN 374','Seminar in International Trade',4),
('ECN',376,'ECN 376','Seminar in Income Distribution',4),
('ECN',378,'ECN 378','Seminar in Law and Economics',4),
('ECN',379,'ECN 379','Seminar in the Economics of Crime',4),
('ECN',380,'ECN 380','Seminar in Monetary Economics',4),
('ECN',382,'ECN 382','Seminar in Economic History',4),

('MAT',336,'MAT 336','Probability and Statistics II',4)

ON CONFLICT (course_code) DO NOTHING;

-- ------------------------------------------------------------
-- 3) Core Requirements
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'ECN_CORE_111', 'ECN 111', 'must_take', 10
FROM majors m
WHERE m.code = 'ECN'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'ECN_CORE_280', 'ECN 280', 'must_take', 20
FROM majors m
WHERE m.code = 'ECN'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'ECN_CORE_282', 'ECN 282', 'must_take', 30
FROM majors m
WHERE m.code = 'ECN'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 4) Economics Field Course
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'ECN_FIELD',
       'Economics Field Course',
       'choose_one',
       1,
       'Choose one field course from ECN 215, 226, 230, 233, 235, 236, 238, 240, or 250.',
       40
FROM majors m
WHERE m.code = 'ECN'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 5) Empirical Analysis
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'ECN_EMPIRICAL',
       'Empirical Analysis',
       'choose_one',
       1,
       'Choose ECN 286 or MAT 336. MAT 336 satisfies this requirement but does not count toward the eight-course minimum required for the major.',
       50
FROM majors m
WHERE m.code = 'ECN'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 6) Advanced Analysis
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'ECN_ADV_ANALYSIS',
       'Advanced Analysis Course',
       'choose_one',
       1,
       'Choose one Economics course numbered 300-350 from the approved list.',
       60
FROM majors m
WHERE m.code = 'ECN'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 7) Economics Seminars
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'ECN_SEMINARS',
       'Economics Seminars',
       'choose_n',
       2,
       'Take two seminars from the approved seminar list.',
       70
FROM majors m
WHERE m.code = 'ECN'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 8) History Requirement
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'ECN_HISTORY',
       'History Requirement',
       'custom',
       4,
       'Complete one history course above the 100-level from a list approved by the economics department. This course does not count toward the eight-course minimum required for the major. Approved off-campus study courses should be handled by backend or approval metadata.',
       80
FROM majors m
WHERE m.code = 'ECN'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 9) Overall major totals / policy block
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'ECN_TOTALS',
       'Major totals and course-minimum rules',
       'custom',
       32,
       'Need at least 32 credits total. A minimum of eight four-credit Economics courses is required. MAT 336 and the approved history course do not count toward the eight-course minimum.',
       90
FROM majors m
WHERE m.code = 'ECN'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 10) Attach course options
-- ------------------------------------------------------------

-- Core: ECN 111
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'ECN 111'
WHERE m.code = 'ECN'
  AND b.code = 'ECN_CORE_111'
ON CONFLICT DO NOTHING;

-- Core: ECN 280
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'ECN 280'
WHERE m.code = 'ECN'
  AND b.code = 'ECN_CORE_280'
ON CONFLICT DO NOTHING;

-- Core: ECN 282
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'ECN 282'
WHERE m.code = 'ECN'
  AND b.code = 'ECN_CORE_282'
ON CONFLICT DO NOTHING;

-- Field course options
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN (
  'ECN 215','ECN 226','ECN 230','ECN 233','ECN 235',
  'ECN 236','ECN 238','ECN 240','ECN 250'
)
WHERE m.code = 'ECN'
  AND b.code = 'ECN_FIELD'
ON CONFLICT DO NOTHING;

-- Empirical analysis options
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN ('ECN 286','MAT 336')
WHERE m.code = 'ECN'
  AND b.code = 'ECN_EMPIRICAL'
ON CONFLICT DO NOTHING;

-- Advanced analysis options
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN (
  'ECN 326','ECN 327','ECN 328','ECN 336','ECN 338'
)
WHERE m.code = 'ECN'
  AND b.code = 'ECN_ADV_ANALYSIS'
ON CONFLICT DO NOTHING;

-- Seminar options
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN (
  'ECN 366','ECN 369','ECN 370','ECN 372','ECN 374',
  'ECN 376','ECN 378','ECN 379','ECN 380','ECN 382'
)
WHERE m.code = 'ECN'
  AND b.code = 'ECN_SEMINARS'
ON CONFLICT DO NOTHING;

COMMIT;