Physics · SQL
Copy

BEGIN;
 
-- ============================================================
-- Physics (PHY)
-- ============================================================
 
-- ------------------------------------------------------------
-- 1) Major
-- ------------------------------------------------------------
INSERT INTO majors(code, name)
VALUES ('PHY', 'Physics')
ON CONFLICT (code) DO NOTHING;
 
-- ------------------------------------------------------------
-- 2) Courses
-- ------------------------------------------------------------
INSERT INTO courses(dept, number, course_code, title, credits) VALUES
-- Core Physics
('PHY',131,'PHY 131','General Physics I',4),
('PHY',132,'PHY 132','General Physics II',4),
('PHY',232,'PHY 232','Modern Physics',4),
('PHY',234,'PHY 234','Mechanics with Lab',4),
('PHY',335,'PHY 335','Electromagnetic Theory',4),
('PHY',337,'PHY 337','Optics Wave Phenomena',4),
('PHY',462,'PHY 462','Advanced Laboratory',2),
 
-- Electives
('PHY',220,'PHY 220','Electronics',4),
('PHY',310,'PHY 310','Computational Physics',4),
('PHY',314,'PHY 314','Thermodynamics and Statistical Physics',4),
('PHY',340,'PHY 340','Topics in Astrophysics',4),
('PHY',360,'PHY 360','Solid State Physics',4),
('PHY',456,'PHY 456','Introduction to Quantum Theory',4),
('PHY',457,'PHY 457','Advanced Quantum Theory',4),
 
-- Also Required: Math
('MAT',131,'MAT 131','Calculus I',4),
('MAT',133,'MAT 133','Calculus II',4),
('MAT',215,'MAT 215','Linear Algebra',4),
('MAT',220,'MAT 220','Differential Equations',4),
 
-- Recommended
('CSC',161,'CSC 161','Imperative Problem Solving with Lab',4)
 
ON CONFLICT (course_code) DO NOTHING;
 
-- ------------------------------------------------------------
-- 3) Core: PHY 131
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'PHY_CORE_131', 'PHY 131 General Physics I', 'must_take', 10
FROM majors m
WHERE m.code = 'PHY'
ON CONFLICT (major_id, code) DO NOTHING;
 
-- ------------------------------------------------------------
-- 4) Core: PHY 132
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'PHY_CORE_132', 'PHY 132 General Physics II', 'must_take', 20
FROM majors m
WHERE m.code = 'PHY'
ON CONFLICT (major_id, code) DO NOTHING;
 
-- ------------------------------------------------------------
-- 5) Core: PHY 232
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'PHY_CORE_232', 'PHY 232 Modern Physics', 'must_take', 30
FROM majors m
WHERE m.code = 'PHY'
ON CONFLICT (major_id, code) DO NOTHING;
 
-- ------------------------------------------------------------
-- 6) Core: PHY 234
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'PHY_CORE_234', 'PHY 234 Mechanics with Lab', 'must_take', 40
FROM majors m
WHERE m.code = 'PHY'
ON CONFLICT (major_id, code) DO NOTHING;
 
-- ------------------------------------------------------------
-- 7) Core: PHY 335
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'PHY_CORE_335', 'PHY 335 Electromagnetic Theory', 'must_take', 50
FROM majors m
WHERE m.code = 'PHY'
ON CONFLICT (major_id, code) DO NOTHING;
 
-- ------------------------------------------------------------
-- 8) Core: PHY 337
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'PHY_CORE_337', 'PHY 337 Optics Wave Phenomena', 'must_take', 60
FROM majors m
WHERE m.code = 'PHY'
ON CONFLICT (major_id, code) DO NOTHING;
 
-- ------------------------------------------------------------
-- 9) Core: PHY 462
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'PHY_CORE_462', 'PHY 462 Advanced Laboratory', 'must_take', 70
FROM majors m
WHERE m.code = 'PHY'
ON CONFLICT (major_id, code) DO NOTHING;
 
-- ------------------------------------------------------------
-- 10) Core summary: 26 credits
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'PHY_CORE_SUMMARY',
       'Core summary: 26 credits',
       'custom',
       26,
       'Core consists of PHY 131, PHY 132, PHY 232, PHY 234, PHY 335, PHY 337 (each 4 credits) and PHY 462 (2 credits), totaling 26 credits.',
       80
FROM majors m
WHERE m.code = 'PHY'
ON CONFLICT (major_id, code) DO NOTHING;
 
-- ------------------------------------------------------------
-- 11) Electives: 6 credits
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'PHY_ELECTIVES',
       'Electives: 6 credits from approved PHY elective list',
       'choose_credits',
       6,
       'Choose at least 6 credits from PHY 220, PHY 310, PHY 314, PHY 340, PHY 360, PHY 456, PHY 457. PHY 314 and PHY 456 are recommended for students planning graduate work in physics or astronomy.',
       90
FROM majors m
WHERE m.code = 'PHY'
ON CONFLICT (major_id, code) DO NOTHING;
 
-- ------------------------------------------------------------
-- 12) Also Required: Math sequence
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'PHY_REQ_MAT131', 'MAT 131 Calculus I', 'must_take', 100
FROM majors m
WHERE m.code = 'PHY'
ON CONFLICT (major_id, code) DO NOTHING;
 
INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'PHY_REQ_MAT133', 'MAT 133 Calculus II', 'must_take', 110
FROM majors m
WHERE m.code = 'PHY'
ON CONFLICT (major_id, code) DO NOTHING;
 
INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'PHY_REQ_MAT215', 'MAT 215 Linear Algebra', 'must_take', 120
FROM majors m
WHERE m.code = 'PHY'
ON CONFLICT (major_id, code) DO NOTHING;
 
INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'PHY_REQ_MAT220', 'MAT 220 Differential Equations', 'must_take', 130
FROM majors m
WHERE m.code = 'PHY'
ON CONFLICT (major_id, code) DO NOTHING;
 
-- ------------------------------------------------------------
-- 13) Overall totals
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'PHY_TOTALS',
       'Major totals and policy constraints',
       'custom',
       32,
       'Minimum 32 credits total: 26 credits of core PHY courses plus 6 elective credits. MAT 131, MAT 133, MAT 215, and MAT 220 are also required but are not counted toward the 32 PHY credits. CSC 161 is recommended for all majors.',
       140
FROM majors m
WHERE m.code = 'PHY'
ON CONFLICT (major_id, code) DO NOTHING;
 
-- ------------------------------------------------------------
-- 14) Attach course options
-- ------------------------------------------------------------
 
-- Core courses
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'PHY 131'
WHERE m.code = 'PHY' AND b.code = 'PHY_CORE_131'
ON CONFLICT DO NOTHING;
 
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'PHY 132'
WHERE m.code = 'PHY' AND b.code = 'PHY_CORE_132'
ON CONFLICT DO NOTHING;
 
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'PHY 232'
WHERE m.code = 'PHY' AND b.code = 'PHY_CORE_232'
ON CONFLICT DO NOTHING;
 
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'PHY 234'
WHERE m.code = 'PHY' AND b.code = 'PHY_CORE_234'
ON CONFLICT DO NOTHING;
 
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'PHY 335'
WHERE m.code = 'PHY' AND b.code = 'PHY_CORE_335'
ON CONFLICT DO NOTHING;
 
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'PHY 337'
WHERE m.code = 'PHY' AND b.code = 'PHY_CORE_337'
ON CONFLICT DO NOTHING;
 
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'PHY 462'
WHERE m.code = 'PHY' AND b.code = 'PHY_CORE_462'
ON CONFLICT DO NOTHING;
 
-- Electives
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN (
  'PHY 220','PHY 310','PHY 314','PHY 340',
  'PHY 360','PHY 456','PHY 457'
)
WHERE m.code = 'PHY' AND b.code = 'PHY_ELECTIVES'
ON CONFLICT DO NOTHING;
 
-- Math requirements
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'MAT 131'
WHERE m.code = 'PHY' AND b.code = 'PHY_REQ_MAT131'
ON CONFLICT DO NOTHING;
 
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'MAT 133'
WHERE m.code = 'PHY' AND b.code = 'PHY_REQ_MAT133'
ON CONFLICT DO NOTHING;
 
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'MAT 215'
WHERE m.code = 'PHY' AND b.code = 'PHY_REQ_MAT215'
ON CONFLICT DO NOTHING;
 
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'MAT 220'
WHERE m.code = 'PHY' AND b.code = 'PHY_REQ_MAT220'
ON CONFLICT DO NOTHING;
 
COMMIT;