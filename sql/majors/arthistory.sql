BEGIN;

-- ============================================================
-- Art History
-- ============================================================

-- ------------------------------------------------------------
-- 1) Major-specific courses
-- ------------------------------------------------------------
INSERT INTO courses(dept, number, course_code, title, credits) VALUES
('ARH',103,'ARH 103','Introduction to Art History',4),
('ARH',211,'ARH 211',NULL,4),
('ARH',212,'ARH 212',NULL,4),
('ARH',213,'ARH 213',NULL,4),
('ARH',214,'ARH 214',NULL,4),
('ARH',215,'ARH 215',NULL,4),
('ARH',221,'ARH 221',NULL,4),
('ARH',222,'ARH 222',NULL,4),
('ARH',231,'ARH 231',NULL,4),
('ARH',232,'ARH 232',NULL,4),
('ARH',233,'ARH 233',NULL,4),
('ARH',234,'ARH 234',NULL,4),
('ARH',248,'ARH 248',NULL,4),
('ARH',270,'ARH 270',NULL,4),
('ARH',272,'ARH 272',NULL,4),
('ARH',295,'ARH 295','Topics / Special Studies (Approved for Groups)',4),
('ARH',380,'ARH 380','Theory and Methods of Art History',4),
('ARH',400,'ARH 400','Seminar in Art History (Senior Thesis)',4)
ON CONFLICT (course_code) DO NOTHING;

-- ------------------------------------------------------------
-- 2) Requirement blocks
-- ------------------------------------------------------------

INSERT INTO requirement_blocks(major_id, code, title, rule_type, notes, sort_order)
SELECT m.id, 'ARH_REQ_ARH103', 'Required (not counted): ARH 103', 'must_take',
       'ARH 103 is required to complete the major but does not count toward the 32 ARH major credits.',
       10
FROM majors m
WHERE m.code = 'ARH'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_count, notes, sort_order)
SELECT m.id, 'ARH_REQ_STUDIO100', 'Required (not counted): 1 Studio Art 100-level', 'choose_one', 1,
       'Take ART 111 or ART 134 (or approved equivalent). Does not count toward ARH major credits.',
       20
FROM majors m
WHERE m.code = 'ARH'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_count, notes, sort_order)
SELECT m.id, 'ARH_G1_ONE', 'Core Group 1 (Trans-cultural): choose 1', 'choose_one', 1,
       'Choose 1 course from Group 1. If a course could count for multiple Groups, choose one Group.',
       30
FROM majors m
WHERE m.code = 'ARH'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_count, notes, sort_order)
SELECT m.id, 'ARH_G2_ONE', 'Core Group 2 (Pre/early modern to 1900): choose 1', 'choose_one', 1,
       'Choose 1 course from Group 2. Cross-listed courses must be claimed to a single Group.',
       40
FROM majors m
WHERE m.code = 'ARH'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_count, notes, sort_order)
SELECT m.id, 'ARH_G3_ONE', 'Core Group 3 (Modern/postmodern after 1900): choose 1', 'choose_one', 1,
       'Choose 1 course from Group 3. Cross-listed courses must be claimed to a single Group.',
       50
FROM majors m
WHERE m.code = 'ARH'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, notes, sort_order)
SELECT m.id, 'ARH_CORE_380', 'Core: ARH 380 Theory & Methods', 'must_take',
       NULL,
       60
FROM majors m
WHERE m.code = 'ARH'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, notes, sort_order)
SELECT m.id, 'ARH_CORE_400', 'Core: ARH 400 Seminar (Senior Thesis)', 'must_take',
       'Senior thesis is completed in ARH 400.',
       70
FROM majors m
WHERE m.code = 'ARH'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_credits, notes, sort_order)
SELECT m.id, 'ARH_ELECTIVES_12', 'Electives: 12 credits beyond ARH 103', 'custom', 12,
       'Complete 12 additional credits beyond ARH 103. With permission, up to 8 credits may be outside ARH.',
       80
FROM majors m
WHERE m.code = 'ARH'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_credits, notes, sort_order)
SELECT m.id, 'ARH_TOTALS_AND_CAPS', 'Major totals + caps (32 credits, >=20 ARH, group 200-level cap)', 'custom', 32,
       'Need at least 32 major credits and at least 20 credits in ARH. Per-group: no more than 12 credits at the 200-level may count unless approved.',
       90
FROM majors m
WHERE m.code = 'ARH'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 3) Block course options
-- ------------------------------------------------------------

-- ARH 103
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'ARH 103'
WHERE m.code = 'ARH'
  AND b.code = 'ARH_REQ_ARH103'
ON CONFLICT DO NOTHING;

-- ARH 380
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'ARH 380'
WHERE m.code = 'ARH'
  AND b.code = 'ARH_CORE_380'
ON CONFLICT DO NOTHING;

-- ARH 400
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code = 'ARH 400'
WHERE m.code = 'ARH'
  AND b.code = 'ARH_CORE_400'
ON CONFLICT DO NOTHING;

-- Studio requirement
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN ('ART 111','ART 134')
WHERE m.code = 'ARH'
  AND b.code = 'ARH_REQ_STUDIO100'
ON CONFLICT DO NOTHING;

-- Group 1
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN (
  'ARH 212','ARH 213','ARH 215','ARH 233','ARH 234','EAS 213','ARH 295'
)
WHERE m.code = 'ARH'
  AND b.code = 'ARH_G1_ONE'
ON CONFLICT DO NOTHING;

-- Group 2
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN (
  'ARH 211','ARH 212','ARH 213','ARH 214','ARH 221','ARH 222','ARH 248','ARH 270','CLS 248','ARH 295'
)
WHERE m.code = 'ARH'
  AND b.code = 'ARH_G2_ONE'
ON CONFLICT DO NOTHING;

-- Group 3
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN (
  'ARH 231','ARH 232','ARH 270','ARH 272','ARH 295'
)
WHERE m.code = 'ARH'
  AND b.code = 'ARH_G3_ONE'
ON CONFLICT DO NOTHING;

COMMIT;