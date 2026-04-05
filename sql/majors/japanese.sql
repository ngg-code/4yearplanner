BEGIN;

-- ============================================================
-- Japanese (JPN)
-- ============================================================

-- ------------------------------------------------------------
-- 1) Major
-- ------------------------------------------------------------
INSERT INTO majors(code, name)
VALUES ('JPN', 'Japanese')
ON CONFLICT (code) DO NOTHING;

-- ------------------------------------------------------------
-- 2) Courses
-- ------------------------------------------------------------
INSERT INTO courses(dept, number, course_code, title, credits) VALUES
('JPN',101,'JPN 101','Beginning Japanese I',4),
('JPN',102,'JPN 102','Beginning Japanese II',4),
('JPN',120,'JPN 120','Japanese Popular Culture and Society',4),
('JPN',195,'JPN 195','Special Topics Courses',4),
('JPN',221,'JPN 221','Intermediate Japanese I',4),
('JPN',222,'JPN 222','Intermediate Japanese II',4),
('JPN',241,'JPN 241','Japanese Horror: Past and Present',4),
('JPN',295,'JPN 295','Special Topics Courses',4),
('JPN',331,'JPN 331','Advanced Japanese I',4),
('JPN',332,'JPN 332','Advanced Japanese II',4),
('JPN',398,'JPN 398','Advanced Japanese Seminar',4),

('ARH',211,'ARH 211','Arts and Visual Cultures of China',4),
('ARH',212,'ARH 212','The Global Mongol Century: In the Footsteps of Marco Polo',4),
('ARH',213,'ARH 213','Gender and Sexuality in East Asian Art',4),
('ARH',215,'ARH 215','Collecting the "Orient"',4),
('CHI',230,'CHI 230','Chinese Women: Past and Present',4),
('CHI',277,'CHI 277','Modern China through Literature and Film',4),
('CHI',288,'CHI 288','Chinese Food for Thought',4),
('HIS',277,'HIS 277','China''s Rise',4),
('REL',224,'REL 224','Zen Buddhism',4),
('REL',256,'REL 256','Religion and Politics in Modern China',4),
('EAS',213,'EAS 213',NULL,4),
('EAS',288,'EAS 288',NULL,4),
('GLS',277,'GLS 277',NULL,4)

ON CONFLICT (course_code) DO NOTHING;

-- ------------------------------------------------------------
-- 3) Part 1 - Language Core
-- ------------------------------------------------------------

INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'JPN_CORE_221', 'JPN 221', 'must_take', 10
FROM majors m
WHERE m.code = 'JPN'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'JPN_CORE_222', 'JPN 222', 'must_take', 20
FROM majors m
WHERE m.code = 'JPN'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'JPN_CORE_331', 'JPN 331', 'must_take', 30
FROM majors m
WHERE m.code = 'JPN'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, sort_order)
SELECT m.id, 'JPN_CORE_332', 'JPN 332', 'must_take', 40
FROM majors m
WHERE m.code = 'JPN'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'JPN_CORE_SUMMARY',
       'Language Core summary: 16 credits, minimum 8 at Grinnell',
       'custom',
       16,
       'Language Core requires 16 credits. A minimum of 8 of these credits must be taken at Grinnell College. Approved off-campus language courses beyond the 300-level may count as approved by the department.',
       50
FROM majors m
WHERE m.code = 'JPN'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 4) Part 2 - Individual Focus
-- ------------------------------------------------------------

INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'JPN_FOCUS_2',
       'Individual Focus: choose 2 courses',
       'choose_n',
       2,
       'Choose two approved courses for Individual Focus.',
       60
FROM majors m
WHERE m.code = 'JPN'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'JPN_FOCUS_GRINNELL_ONE',
       'Individual Focus: at least 1 in department at Grinnell',
       'choose_one',
       1,
       'At least one Individual Focus course must be taken in the Chinese and Japanese department at Grinnell.',
       70
FROM majors m
WHERE m.code = 'JPN'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'JPN_FOCUS_SUMMARY',
       'Individual Focus summary: 8 credits and approvals',
       'custom',
       8,
       'Individual Focus requires 8 credits total. Courses from other disciplines and off-campus courses may count only as approved by the department.',
       80
FROM majors m
WHERE m.code = 'JPN'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 5) Part 3 - Regional Context
-- ------------------------------------------------------------

INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'JPN_REGIONAL_CONTEXT',
       'Regional Context: choose 1 course',
       'choose_one',
       1,
       'Choose one course focusing on East Asia or an East Asian country other than Japan. Special Topics and off-campus study may count with department approval.',
       90
FROM majors m
WHERE m.code = 'JPN'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 6) Part 4 - Capstone
-- ------------------------------------------------------------

INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, notes, sort_order
)
SELECT m.id,
       'JPN_CAPSTONE_398',
       'Capstone: JPN 398',
       'must_take',
       'JPN 398 Advanced Japanese Seminar satisfies the standard capstone option.',
       100
FROM majors m
WHERE m.code = 'JPN'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'JPN_CAPSTONE_SUMMARY',
       'Capstone summary: approved seminar/project option',
       'custom',
       4,
       'Capstone requires 4 credits. This may be JPN 398, a Mentored Advanced Project, or a 4-credit Independent Study as approved by the department.',
       110
FROM majors m
WHERE m.code = 'JPN'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 7) Overall major summary
-- ------------------------------------------------------------

INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'JPN_TOTALS',
       'Major totals: 32 credits beyond prerequisites',
       'custom',
       32,
       'Need at least 32 credits beyond JPN 101 and JPN 102 prerequisites. At least 20 of the 32 credits must be Japanese courses in the department at Grinnell.',
       120
FROM majors m
WHERE m.code = 'JPN'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 8) Attach course options
-- ------------------------------------------------------------

-- Language core
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'JPN 221'
WHERE m.code = 'JPN'
  AND b.code = 'JPN_CORE_221'
ON CONFLICT DO NOTHING;

INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'JPN 222'
WHERE m.code = 'JPN'
  AND b.code = 'JPN_CORE_222'
ON CONFLICT DO NOTHING;

INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'JPN 331'
WHERE m.code = 'JPN'
  AND b.code = 'JPN_CORE_331'
ON CONFLICT DO NOTHING;

INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'JPN 332'
WHERE m.code = 'JPN'
  AND b.code = 'JPN_CORE_332'
ON CONFLICT DO NOTHING;

-- Individual focus
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN ('JPN 120','JPN 241','JPN 195','JPN 295')
WHERE m.code = 'JPN'
  AND b.code = 'JPN_FOCUS_2'
ON CONFLICT DO NOTHING;

INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN ('JPN 120','JPN 241','JPN 195','JPN 295')
WHERE m.code = 'JPN'
  AND b.code = 'JPN_FOCUS_GRINNELL_ONE'
ON CONFLICT DO NOTHING;

-- Regional context
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN (
  'ARH 211','ARH 212','ARH 213','ARH 215',
  'CHI 230','CHI 277','CHI 288',
  'HIS 277','REL 224','REL 256',
  'EAS 213','EAS 288','GLS 277'
)
WHERE m.code = 'JPN'
  AND b.code = 'JPN_REGIONAL_CONTEXT'
ON CONFLICT DO NOTHING;

-- Capstone JPN 398
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'JPN 398'
WHERE m.code = 'JPN'
  AND b.code = 'JPN_CAPSTONE_398'
ON CONFLICT DO NOTHING;

COMMIT;