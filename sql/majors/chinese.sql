BEGIN;

-- ============================================================
-- Chinese (CHI)
-- ============================================================

-- ------------------------------------------------------------
-- 1) Major
-- ------------------------------------------------------------
INSERT INTO majors(code, name)
VALUES ('CHI', 'Chinese')
ON CONFLICT (code) DO NOTHING;

-- ------------------------------------------------------------
-- 2) Courses
-- ------------------------------------------------------------
INSERT INTO courses(dept, number, course_code, title, credits) VALUES
('CHI',101,'CHI 101','Beginning Chinese I',4),
('CHI',102,'CHI 102','Beginning Chinese II',4),
('CHI',195,'CHI 195','Special Topics Courses',4),
('CHI',221,'CHI 221','Intermediate Chinese I',4),
('CHI',222,'CHI 222','Intermediate Chinese II',4),
('CHI',230,'CHI 230','Chinese Women: Past and Present',4),
('CHI',277,'CHI 277','Modern China through Literature and Film',4),
('CHI',288,'CHI 288','Chinese Food for Thought',4),
('CHI',295,'CHI 295','Special Topics Courses',4),
('CHI',331,'CHI 331','Advanced Chinese I',4),
('CHI',332,'CHI 332','Advanced Chinese II',4),
('CHI',461,'CHI 461','Classical Chinese',4),
('CHI',498,'CHI 498','Readings in Chinese Literature',4),

('EAS',288,'EAS 288',NULL,4)

ON CONFLICT (course_code) DO NOTHING;

-- ------------------------------------------------------------
-- 3) Core requirement blocks
-- ------------------------------------------------------------

-- CHI 221
INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'CHI_CORE_221', 'CHI 221', 'must_take', 10
FROM majors m
WHERE m.code = 'CHI'
ON CONFLICT (major_id, code) DO NOTHING;

-- CHI 222
INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'CHI_CORE_222', 'CHI 222', 'must_take', 20
FROM majors m
WHERE m.code = 'CHI'
ON CONFLICT (major_id, code) DO NOTHING;

-- CHI 331
INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'CHI_CORE_331', 'CHI 331', 'must_take', 30
FROM majors m
WHERE m.code = 'CHI'
ON CONFLICT (major_id, code) DO NOTHING;

-- CHI 332
INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'CHI_CORE_332', 'CHI 332', 'must_take', 40
FROM majors m
WHERE m.code = 'CHI'
ON CONFLICT (major_id, code) DO NOTHING;

-- CHI 461
INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'CHI_CORE_461', 'CHI 461 Classical Chinese', 'must_take', 50
FROM majors m
WHERE m.code = 'CHI'
ON CONFLICT (major_id, code) DO NOTHING;

-- CHI 498
INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'CHI_CORE_498', 'CHI 498 Readings in Chinese Literature', 'must_take', 60
FROM majors m
WHERE m.code = 'CHI'
ON CONFLICT (major_id, code) DO NOTHING;

-- Core 20 / Grinnell minimum summary
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'CHI_CORE_SUMMARY',
       'Core summary: 20 credits, minimum 12 at Grinnell',
       'custom',
       20,
       'Core must total 20 credits and include CHI 221, CHI 222, CHI 331, CHI 332, CHI 461, and CHI 498. A minimum of 12 of these core credits must be taken at Grinnell College.',
       70
FROM majors m
WHERE m.code = 'CHI'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 4) Individual Focus
-- ------------------------------------------------------------

-- Three courses from list
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'CHI_FOCUS_3',
       'Individual Focus: choose 3 courses',
       'choose_n',
       3,
       'Choose three courses from the approved Individual Focus list.',
       80
FROM majors m
WHERE m.code = 'CHI'
ON CONFLICT (major_id, code) DO NOTHING;

-- At least one from required subset in department at Grinnell
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'CHI_FOCUS_REQUIRED_SUBSET',
       'Individual Focus subset: choose at least 1',
       'choose_one',
       1,
       'At least one Individual Focus course must be taken in the Chinese and Japanese department at Grinnell from CHI 230, CHI 277, CHI 288, CHI 498, or EAS 288.',
       90
FROM majors m
WHERE m.code = 'CHI'
ON CONFLICT (major_id, code) DO NOTHING;

-- Individual Focus summary / approved courses
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'CHI_FOCUS_SUMMARY',
       'Individual Focus summary: 12 credits and approvals',
       'custom',
       12,
       'Individual Focus requires 12 credits total. CHI 195, CHI 295, Chinese history, Religious Studies, and other approved courses may count only as approved by the department. Department/grinnell-location rules should be enforced in backend logic.',
       100
FROM majors m
WHERE m.code = 'CHI'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 5) Overall major summary
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'CHI_TOTALS',
       'Major totals: 32 credits beyond prerequisites',
       'custom',
       32,
       'Need at least 32 credits beyond CHI 101 and CHI 102 prerequisites. At least 20 of the 32 credits must be Chinese courses in the department at Grinnell.',
       110
FROM majors m
WHERE m.code = 'CHI'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 6) Attach course options
-- ------------------------------------------------------------

-- Core blocks
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'CHI 221'
WHERE m.code = 'CHI'
  AND b.code = 'CHI_CORE_221'
ON CONFLICT DO NOTHING;

INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'CHI 222'
WHERE m.code = 'CHI'
  AND b.code = 'CHI_CORE_222'
ON CONFLICT DO NOTHING;

INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'CHI 331'
WHERE m.code = 'CHI'
  AND b.code = 'CHI_CORE_331'
ON CONFLICT DO NOTHING;

INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'CHI 332'
WHERE m.code = 'CHI'
  AND b.code = 'CHI_CORE_332'
ON CONFLICT DO NOTHING;

INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'CHI 461'
WHERE m.code = 'CHI'
  AND b.code = 'CHI_CORE_461'
ON CONFLICT DO NOTHING;

INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'CHI 498'
WHERE m.code = 'CHI'
  AND b.code = 'CHI_CORE_498'
ON CONFLICT DO NOTHING;

-- Focus choose 3
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN (
  'CHI 230','CHI 277','CHI 288','CHI 498','CHI 195','CHI 295','EAS 288'
)
WHERE m.code = 'CHI'
  AND b.code = 'CHI_FOCUS_3'
ON CONFLICT DO NOTHING;

-- Required subset
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN (
  'CHI 230','CHI 277','CHI 288','CHI 498','EAS 288'
)
WHERE m.code = 'CHI'
  AND b.code = 'CHI_FOCUS_REQUIRED_SUBSET'
ON CONFLICT DO NOTHING;

COMMIT;