BEGIN;

-- ============================================================
-- English (ENG)
-- ============================================================

-- ------------------------------------------------------------
-- 1) Major
-- ------------------------------------------------------------
INSERT INTO majors(code, name)
VALUES ('ENG', 'English')
ON CONFLICT (code) DO NOTHING;

-- ------------------------------------------------------------
-- 2) Courses
-- ------------------------------------------------------------
INSERT INTO courses(dept, number, course_code, title, credits) VALUES
('ENG',120,'ENG 120','Literary Analysis',4),
('ENG',121,'ENG 121','Introduction to Shakespeare',4),

('ENG',204,'ENG 204','The Craft of Argument',4),
('ENG',205,'ENG 205','The Craft of Fiction',4),
('ENG',206,'ENG 206','The Craft of Poetry',4),
('ENG',207,'ENG 207','Craft of Creative Nonfiction',4),
('ENG',210,'ENG 210','Studies in Genre',4),
('ENG',215,'ENG 215','Reading and Writing Youth and Youth Culture',4),

('ENG',223,'ENG 223','The Tradition of English Literature I',4),
('ENG',224,'ENG 224','The Tradition of English Literature II',4),
('ENG',225,'ENG 225','Introduction to Postcolonial Literatures',4),
('ENG',226,'ENG 226','The Tradition of English Literature III',4),
('ENG',227,'ENG 227','American Literary Traditions I',4),
('ENG',228,'ENG 228','American Literary Traditions II',4),
('ENG',229,'ENG 229','The Tradition of African American Literature',4),
('ENG',230,'ENG 230','English Historical Linguistics',4),
('ENG',231,'ENG 231','American Literary Traditions III',4),
('ENG',232,'ENG 232','Traditions of Ethnic American Literature',4),
('ENG',240,'ENG 240','Lighting the Page: Digital Methods in Literary Studies',4),
('ENG',273,'ENG 273','Transnational and Postcolonial Feminisms',4),
('ENG',274,'ENG 274','Sex, Gender, and Critical Theory',4),
('ENG',290,'ENG 290','Introduction to Literary Theory',4),
('ENG',295,'ENG 295','Special Topics in English',4),

('ENG',303,'ENG 303','Chaucer',4),
('ENG',310,'ENG 310','Studies in Shakespeare',4),
('ENG',314,'ENG 314','Milton',4),
('ENG',316,'ENG 316','Studies in English Renaissance Literature',4),
('ENG',323,'ENG 323','Studies in English Literature: 1660–1798',4),
('ENG',325,'ENG 325','Studies in Ethnic American Literatures',4),
('ENG',326,'ENG 326','Studies in American Poetry I',4),
('ENG',327,'ENG 327','The Romantics',4),
('ENG',328,'ENG 328','Studies in American Poetry II',4),
('ENG',329,'ENG 329','Studies in African American Literature',4),
('ENG',330,'ENG 330','Studies in American Prose I',4),
('ENG',331,'ENG 331','Studies in American Prose II',4),
('ENG',332,'ENG 332','The Victorians',4),
('ENG',337,'ENG 337','The British Novel I',4),
('ENG',338,'ENG 338','The British Novel II',4),
('ENG',346,'ENG 346','Studies in Modern Prose',4),
('ENG',349,'ENG 349','Medieval Literature',4),

('ENG',360,'ENG 360','Seminar in Postcolonial Literature',4),
('ENG',385,'ENG 385','Writing Seminar: Fiction',4),
('ENG',386,'ENG 386','Writing Seminar: Poetry',4),
('ENG',388,'ENG 388','Writing Seminar: Screenwriting/Television Writing/Variable Genre',4),
('ENG',390,'ENG 390','Literary Theory',4)

ON CONFLICT (course_code) DO NOTHING;

-- ------------------------------------------------------------
-- 3) Core Intro: ENG 120 or ENG 121
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'ENG_CORE_INTRO',
       'Core Intro: ENG 120 or ENG 121',
       'choose_one',
       1,
       'Complete ENG 120 or ENG 121.',
       10
FROM majors m
WHERE m.code = 'ENG'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 4) 200-level Group Requirements
-- ------------------------------------------------------------

-- Early literature
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'ENG_200_EARLY',
       '200-level Group: Early Literature',
       'choose_one',
       1,
       'Choose one from ENG 223 or ENG 227.',
       20
FROM majors m
WHERE m.code = 'ENG'
ON CONFLICT (major_id, code) DO NOTHING;

-- British or Postcolonial literature
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'ENG_200_BRIT_POSTCOL',
       '200-level Group: British or Postcolonial Literature',
       'choose_one',
       1,
       'Choose one from ENG 223, ENG 224, ENG 225, or ENG 226.',
       30
FROM majors m
WHERE m.code = 'ENG'
ON CONFLICT (major_id, code) DO NOTHING;

-- American literature
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'ENG_200_AMERICAN',
       '200-level Group: American Literature',
       'choose_one',
       1,
       'Choose one from ENG 227, ENG 228, ENG 229, ENG 231, or ENG 232.',
       40
FROM majors m
WHERE m.code = 'ENG'
ON CONFLICT (major_id, code) DO NOTHING;

-- Genre or Methods
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_count, notes, sort_order
)
SELECT m.id,
       'ENG_200_GENRE_METHODS',
       '200-level Group: Genre or Methods',
       'choose_one',
       1,
       'Choose one from ENG 204, ENG 205, ENG 206, ENG 207, ENG 210, ENG 230, ENG 240, ENG 273, ENG 274, or ENG 290.',
       50
FROM majors m
WHERE m.code = 'ENG'
ON CONFLICT (major_id, code) DO NOTHING;

-- Core summary
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'ENG_CORE_SUMMARY',
       'Core summary: 20 credits',
       'custom',
       20,
       'Core requires ENG 120 or ENG 121 plus four 200-level English courses, one from each required group.',
       60
FROM majors m
WHERE m.code = 'ENG'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 5) 300-level Requirement
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'ENG_300_REQUIREMENT',
       '300-level Requirement: three 300-level English courses',
       'custom',
       12,
       'Need three four-credit 300-level courses in the English department at Grinnell, excluding individual study. At least two must be literature courses. Possible 300-level courses include ENG 303, 310, 314, 316, 323, 325, 326, 327, 328, 329, 330, 331, 332, 337, 338, 346, 349, 360, 385, 386, 388, and 390.',
       70
FROM majors m
WHERE m.code = 'ENG'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 6) Elective
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'ENG_ELECTIVE',
       'Elective: one four-credit English course',
       'custom',
       4,
       'Complete one additional four-credit English course. This should be treated as an extra course beyond the core and 300-level requirements in backend audit logic.',
       80
FROM majors m
WHERE m.code = 'ENG'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 7) Also Required: HUM / GLS / literature in another language
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'ENG_OUTSIDE_LIT_HUM',
       'Outside requirement: HUM / GLS / literature in another language',
       'custom',
       4,
       'Complete one four-credit HUM or GLS course, or one four-credit literature course taught in another language department at the 200-level or above.',
       90
FROM majors m
WHERE m.code = 'ENG'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 8) Language competency
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, notes, sort_order
)
SELECT m.id,
       'ENG_LANGUAGE_COMPETENCY',
       'Non-native language competency',
       'custom',
       'Demonstrate knowledge of a non-native language by completion of second-semester college coursework in a non-native language, or by examination at Grinnell showing equivalent competence.',
       100
FROM majors m
WHERE m.code = 'ENG'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 9) Overall totals
-- ------------------------------------------------------------
INSERT INTO requirement_blocks(
  major_id, code, title, rule_type, min_credits, notes, sort_order
)
SELECT m.id,
       'ENG_TOTALS',
       'Major totals',
       'custom',
       36,
       'Need at least 36 credits in English, including at least 24 credits in the Department of English at Grinnell.',
       110
FROM majors m
WHERE m.code = 'ENG'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 10) Attach course options
-- ------------------------------------------------------------

-- Core intro
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN ('ENG 120','ENG 121')
WHERE m.code = 'ENG'
  AND b.code = 'ENG_CORE_INTRO'
ON CONFLICT DO NOTHING;

-- Early literature
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN ('ENG 223','ENG 227')
WHERE m.code = 'ENG'
  AND b.code = 'ENG_200_EARLY'
ON CONFLICT DO NOTHING;

-- British / Postcolonial literature
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN ('ENG 223','ENG 224','ENG 225','ENG 226')
WHERE m.code = 'ENG'
  AND b.code = 'ENG_200_BRIT_POSTCOL'
ON CONFLICT DO NOTHING;

-- American literature
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN ('ENG 227','ENG 228','ENG 229','ENG 231','ENG 232')
WHERE m.code = 'ENG'
  AND b.code = 'ENG_200_AMERICAN'
ON CONFLICT DO NOTHING;

-- Genre / Methods
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id = b.major_id
JOIN courses c ON c.course_code IN (
  'ENG 204','ENG 205','ENG 206','ENG 207','ENG 210',
  'ENG 230','ENG 240','ENG 273','ENG 274','ENG 290'
)
WHERE m.code = 'ENG'
  AND b.code = 'ENG_200_GENRE_METHODS'
ON CONFLICT DO NOTHING;

COMMIT;