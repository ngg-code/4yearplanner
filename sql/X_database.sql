
-- 1) Users & Planning ----------
CREATE TABLE users (
  id            BIGSERIAL PRIMARY KEY,
  name          TEXT NOT NULL,
  email         TEXT UNIQUE,
  created_at    TIMESTAMPTZ DEFAULT now()
);

-- A user can have multiple majors/concentrations
CREATE TABLE majors (
  id            BIGSERIAL PRIMARY KEY,
  code          TEXT NOT NULL UNIQUE,   -- e.g., "ANTH"
  name          TEXT NOT NULL           -- e.g., "Anthropology"
);

CREATE TABLE user_majors (
  user_id       BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  major_id      BIGINT NOT NULL REFERENCES majors(id) ON DELETE CASCADE,
  kind          TEXT NOT NULL CHECK (kind IN ('major','concentration')),
  PRIMARY KEY (user_id, major_id, kind)
);

-- Plan A / Plan B
CREATE TABLE plans (
  id            BIGSERIAL PRIMARY KEY,
  user_id       BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name          TEXT NOT NULL,          -- "Plan A", "Plan B"
);

-- ---------- 2) Course Catalog ----------
CREATE TABLE courses (
  id            BIGSERIAL PRIMARY KEY,
  dept          TEXT NOT NULL,          -- "ANT"
  number        INT  NOT NULL,          -- 104
  course_code   TEXT NOT NULL UNIQUE,   -- "ANT 104"
  title         TEXT,
  credits       INT  NOT NULL DEFAULT 4,
  level         INT  GENERATED ALWAYS AS ((number / 100) * 100) STORED, -- 100/200/300/400
  active        BOOLEAN DEFAULT TRUE
);

-- Student’s planned/taken courses (by plan)
CREATE TABLE plan_courses (
  plan_id       BIGINT NOT NULL REFERENCES plans(id) ON DELETE CASCADE,
  course_id     BIGINT NOT NULL REFERENCES courses(id),
  year          INT  NOT NULL,          -- e.g., 2026
  term          TEXT NOT NULL CHECK (term IN ('Fall','Spring','Summer','Winter')),
  status        TEXT NOT NULL DEFAULT 'planned' CHECK (status IN ('planned','enrolled','completed','dropped')),
  grade         TEXT,
  PRIMARY KEY (plan_id, course_id, year, term)
);

-- ---------- 3) Requirement Modeling (Blocks) ----------
-- A requirement block is a unit you can check:
-- examples: "Must take ANT 104", "Choose 1 Methods course", "Stats requirement"
CREATE TABLE requirement_blocks (
  id            BIGSERIAL PRIMARY KEY,
  major_id      BIGINT NOT NULL REFERENCES majors(id) ON DELETE CASCADE,
  code          TEXT NOT NULL,          -- e.g., "ANTH_CORE_ANT104"
  title         TEXT NOT NULL,          -- display
  rule_type     TEXT NOT NULL CHECK (
                  rule_type IN (
                    'must_take',              -- must take specific course(s)
                    'choose_one',             -- choose 1 from list
                    'choose_n',               -- choose N from list
                    'choose_credits',         -- earn X credits from list
                    'or_group',               -- placeholder parent for OR branches
                    'custom'                  -- computed in code (e.g., 3-of-4 subfields)
                  )
                ),
  min_count     INT,                    -- for choose_n
  min_credits   INT,                    -- for choose_credits
  notes         TEXT,
  sort_order    INT NOT NULL DEFAULT 0,
  UNIQUE (major_id, code)
);

-- Which courses can satisfy a block (course options)
CREATE TABLE block_course_options (
  block_id      BIGINT NOT NULL REFERENCES requirement_blocks(id) ON DELETE CASCADE,
  course_id     BIGINT NOT NULL REFERENCES courses(id),
  min_level     INT,                    -- optional constraint e.g., >=200
  max_level     INT,                    -- optional constraint
  PRIMARY KEY (block_id, course_id)
);

-- OR-branches: parent block (rule_type='or_group') has child blocks
CREATE TABLE block_or_children (
  parent_block_id BIGINT NOT NULL REFERENCES requirement_blocks(id) ON DELETE CASCADE,
  child_block_id  BIGINT NOT NULL REFERENCES requirement_blocks(id) ON DELETE CASCADE,
  PRIMARY KEY (parent_block_id, child_block_id),
  CHECK (parent_block_id <> child_block_id)
);

-- ---------- 4) Subfields (for rules like "3 of 4 subfields") ----------
CREATE TABLE subfields (
  id            BIGSERIAL PRIMARY KEY,
  major_id      BIGINT NOT NULL REFERENCES majors(id) ON DELETE CASCADE,
  code          TEXT NOT NULL,          -- "ARCH", "BIO", "CULT", "LING"
  name          TEXT NOT NULL,
  UNIQUE (major_id, code)
);

CREATE TABLE course_subfields (
  course_id     BIGINT NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  subfield_id   BIGINT NOT NULL REFERENCES subfields(id) ON DELETE CASCADE,
  PRIMARY KEY (course_id, subfield_id)
);

-- ============================================================
-- Anthropology 
-- ============================================================

-- --- Major ---
INSERT INTO majors(code, name) VALUES ('ANTH', 'Anthropology')
ON CONFLICT (code) DO NOTHING;

-- --- Courses ---
INSERT INTO courses(dept, number, course_code, title, credits) VALUES
('ANT',104,'ANT 104','Anthropological Inquiries',4),
('ANT',280,'ANT 280','Theories of Culture',4),
('ANT',265,'ANT 265','Ethnography of Communication: Method and Theory',4),
('ANT',290,'ANT 290','Archaeological Methods',4),
('ANT',291,'ANT 291','Methods of Empirical Investigation',4),
('ANT',292,'ANT 292','Ethnographic Research Methods',4),
('ANT',293,'ANT 293','Applied Research for Community Development',4),

('ANT',263,'ANT 263','Historical Archaeology',4),
('ANT',375,'ANT 375','Experimental Archaeology and Ethnoarchaeology',4),
('ANT',205,'ANT 205','Human Evolution',4),
('ANT',225,'ANT 225','Biological Determinism and the Myth of Race',4),
('ANT',210,'ANT 210','Illness, Healing, and Culture',4),
('ANT',238,'ANT 238','Environmental Anthropology',4),
('ANT',250,'ANT 250','Language Contact',4),
('ANT',260,'ANT 260','Language, Culture, and Society',4),

('ANT',499,'ANT 499','Senior Thesis (MAP)',4),

('SST',115,'SST 115','Introduction to Statistics',4),
('STA',209,'STA 209','Applied Statistics',4)
ON CONFLICT (course_code) DO NOTHING;

-- --- Subfields for ANTH (Four Fields) ---
INSERT INTO subfields(major_id, code, name)
SELECT m.id, v.code, v.name
FROM majors m
JOIN (VALUES
  ('ARCH','Archaeology'),
  ('BIO','Biological Anthropology'),
  ('CULT','Cultural Anthropology'),
  ('LING','Linguistic Anthropology')
) AS v(code,name) ON TRUE
WHERE m.code='ANTH'
ON CONFLICT (major_id, code) DO NOTHING;

-- --- Tag courses to subfields ---
-- Archaeology
INSERT INTO course_subfields(course_id, subfield_id)
SELECT c.id, s.id
FROM courses c, majors m, subfields s
WHERE m.code='ANTH' AND s.major_id=m.id AND s.code='ARCH'
  AND c.course_code IN ('ANT 263','ANT 290','ANT 375')
ON CONFLICT DO NOTHING;

-- Biological
INSERT INTO course_subfields(course_id, subfield_id)
SELECT c.id, s.id
FROM courses c, majors m, subfields s
WHERE m.code='ANTH' AND s.major_id=m.id AND s.code='BIO'
  AND c.course_code IN ('ANT 205','ANT 225')
ON CONFLICT DO NOTHING;

-- Cultural
INSERT INTO course_subfields(course_id, subfield_id)
SELECT c.id, s.id
FROM courses c, majors m, subfields s
WHERE m.code='ANTH' AND s.major_id=m.id AND s.code='CULT'
  AND c.course_code IN ('ANT 210','ANT 238','ANT 292','ANT 293')
ON CONFLICT DO NOTHING;

-- Linguistic
INSERT INTO course_subfields(course_id, subfield_id)
SELECT c.id, s.id
FROM courses c, majors m, subfields s
WHERE m.code='ANTH' AND s.major_id=m.id AND s.code='LING'
  AND c.course_code IN ('ANT 250','ANT 260','ANT 265')
ON CONFLICT DO NOTHING;

-- --- Requirement blocks for ANTH ---
-- Core: must take ANT104, must take ANT280, choose one Methods
INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_count, min_credits, notes, sort_order)
SELECT m.id, 'ANTH_CORE_ANT104', 'Core: ANT 104', 'must_take', NULL, NULL, NULL, 10
FROM majors m WHERE m.code='ANTH'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_count, min_credits, notes, sort_order)
SELECT m.id, 'ANTH_CORE_ANT280', 'Core: ANT 280', 'must_take', NULL, NULL, NULL, 20
FROM majors m WHERE m.code='ANTH'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_count, min_credits, notes, sort_order)
SELECT m.id, 'ANTH_METHODS_1', 'Methods: choose 1 course', 'choose_one', 1, NULL,
       'Choose one Methods course (ANT 265/290/291/292/293).', 30
FROM majors m WHERE m.code='ANTH'
ON CONFLICT (major_id, code) DO NOTHING;

-- Four Fields Coverage: custom rule (3 of 4 subfields, one 200/300-level each)
INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_count, min_credits, notes, sort_order)
SELECT m.id, 'ANTH_FOUR_FIELDS', 'Four Fields Coverage: 3 of 4 subfields (200/300-level)', 'custom', NULL, 12,
       'Need 3 distinct subfields; each satisfied by 1 four-credit 200/300 ANT course from that subfield.', 40
FROM majors m WHERE m.code='ANTH'
ON CONFLICT (major_id, code) DO NOTHING;

-- Advanced coursework OR group
INSERT INTO requirement_blocks(major_id, code, title, rule_type, notes, sort_order)
SELECT m.id, 'ANTH_ADV_OR', 'Advanced Coursework (choose a path)', 'or_group',
       'Either (A) two 300-level ANT courses OR (B) one 300-level ANT + ANT 499.', 50
FROM majors m WHERE m.code='ANTH'
ON CONFLICT (major_id, code) DO NOTHING;

-- Path A: two 300-level ANT (represented as choose_n from listed 300-level options you define)
-- For MVP: you can list approved 300-level courses as options in block_course_options.
INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_count, notes, sort_order)
SELECT m.id, 'ANTH_ADV_PATH_A', 'Path A: take 2 ANT 300-level courses', 'choose_n', 2,
       'Approved 300-level ANT courses (add options to this block).', 51
FROM majors m WHERE m.code='ANTH'
ON CONFLICT (major_id, code) DO NOTHING;

-- Path B: one 300-level ANT + thesis (ANT 499)
INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_count, notes, sort_order)
SELECT m.id, 'ANTH_ADV_PATH_B', 'Path B: 1 ANT 300-level + ANT 499 (thesis)', 'custom', 2,
       'Custom check: (>=1 ANT 300-level) AND (ANT 499).', 52
FROM majors m WHERE m.code='ANTH'
ON CONFLICT (major_id, code) DO NOTHING;

-- Link OR children
INSERT INTO block_or_children(parent_block_id, child_block_id)
SELECT p.id, c.id
FROM requirement_blocks p
JOIN requirement_blocks c ON c.major_id=p.major_id
JOIN majors m ON m.id=p.major_id
WHERE m.code='ANTH' AND p.code='ANTH_ADV_OR' AND c.code IN ('ANTH_ADV_PATH_A','ANTH_ADV_PATH_B')
ON CONFLICT DO NOTHING;

-- Stats requirement: SST115 OR STA209
INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_count, notes, sort_order)
SELECT m.id, 'ANTH_STATS', 'Statistics: SST 115 or STA 209', 'choose_one', 1,
       'Complete SST 115 or STA 209.', 60
FROM majors m WHERE m.code='ANTH'
ON CONFLICT (major_id, code) DO NOTHING;

-- --- Attach course options to blocks ---
-- Must-take blocks: simply put that single course as an option
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id=b.major_id
JOIN courses c ON c.course_code='ANT 104'
WHERE m.code='ANTH' AND b.code='ANTH_CORE_ANT104'
ON CONFLICT DO NOTHING;

INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id=b.major_id
JOIN courses c ON c.course_code='ANT 280'
WHERE m.code='ANTH' AND b.code='ANTH_CORE_ANT280'
ON CONFLICT DO NOTHING;

-- Methods choose-one options
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id=b.major_id
JOIN courses c ON c.course_code IN ('ANT 265','ANT 290','ANT 291','ANT 292','ANT 293')
WHERE m.code='ANTH' AND b.code='ANTH_METHODS_1'
ON CONFLICT DO NOTHING;

-- Stats options
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id=b.major_id
JOIN courses c ON c.course_code IN ('SST 115','STA 209')
WHERE m.code='ANTH' AND b.code='ANTH_STATS'
ON CONFLICT DO NOTHING;

-- Advanced Path A options (example: add known 300-level courses you’ve inserted)
-- Here we include ANT 375 as an example 300-level option.
INSERT INTO block_course_options(block_id, course_id, min_level, max_level)
SELECT b.id, c.id, 300, 399
FROM requirement_blocks b
JOIN majors m ON m.id=b.major_id
JOIN courses c ON c.course_code IN ('ANT 375')
WHERE m.code='ANTH' AND b.code='ANTH_ADV_PATH_A'
ON CONFLICT DO NOTHING;



-- ============================================================
-- Art History
-- ============================================================
CREATE TABLE IF NOT EXISTS plan_course_group_claims (
  plan_id     BIGINT NOT NULL REFERENCES plans(id) ON DELETE CASCADE,
  course_id   BIGINT NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  group_code  TEXT NOT NULL CHECK (group_code IN ('G1','G2','G3')),
  PRIMARY KEY (plan_id, course_id)
);

-- ------------------------------------------------------------
-- 1) Major + Courses (minimal seed from the requirements text)
-- NOTE: You can extend course list later.
-- ------------------------------------------------------------
INSERT INTO majors(code, name) VALUES ('ARH', 'Art History')
ON CONFLICT (code) DO NOTHING;

-- Core + required + group courses mentioned in the requirement text
INSERT INTO courses(dept, number, course_code, title, credits) VALUES
('ARH',103,'ARH 103','Introduction to Art History',4),
('ARH',380,'ARH 380','Theory and Methods of Art History',4),
('ARH',400,'ARH 400','Seminar in Art History (Senior Thesis)',4),
('ARH',295,'ARH 295','Topics / Special Studies (Approved for Groups)',4),

-- Group 1: Trans-cultural
('ARH',212,'ARH 212',NULL,4),
('ARH',213,'ARH 213',NULL,4),
('ARH',215,'ARH 215',NULL,4),
('ARH',233,'ARH 233',NULL,4),
('ARH',234,'ARH 234',NULL,4),
('EAS',213,'EAS 213',NULL,4),

-- Group 2: Pre- and early modern to 1900
('ARH',211,'ARH 211',NULL,4),
('ARH',214,'ARH 214',NULL,4),
('ARH',221,'ARH 221',NULL,4),
('ARH',222,'ARH 222',NULL,4),
('ARH',248,'ARH 248',NULL,4),
('ARH',270,'ARH 270',NULL,4),
('CLS',248,'CLS 248',NULL,4),

-- Group 3: Modern and postmodern after 1900
('ARH',231,'ARH 231',NULL,4),
('ARH',232,'ARH 232',NULL,4),
('ARH',272,'ARH 272',NULL,4),

-- Studio Art 100-level requirement (does NOT count toward ARH major credits)
('ART',111,'ART 111','Introduction to the Studio',4),
('ART',134,'ART 134','Drawing',4)

ON CONFLICT (course_code) DO NOTHING;

-- ------------------------------------------------------------
-- 2) Requirement blocks (ARH)
-- ------------------------------------------------------------

-- Required but NOT counted toward ARH major credits
INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_count, min_credits, notes, sort_order)
SELECT m.id, 'ARH_REQ_ARH103', 'Required (not counted): ARH 103', 'must_take', NULL, NULL,
       'ARH 103 is required to complete the major but does NOT count toward the 32 ARH major credits.', 10
FROM majors m WHERE m.code='ARH'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_count, min_credits, notes, sort_order)
SELECT m.id, 'ARH_REQ_STUDIO100', 'Required (not counted): 1 Studio Art 100-level', 'choose_one', 1, NULL,
       'Take ART 111 or ART 134 (or approved equivalent). Does NOT count toward ARH major credits.', 20
FROM majors m WHERE m.code='ARH'
ON CONFLICT (major_id, code) DO NOTHING;

-- Group coverage: 1 course from each group (student must choose ONE group for cross-listed courses)
INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_count, min_credits, notes, sort_order)
SELECT m.id, 'ARH_G1_ONE', 'Core Group 1 (Trans-cultural): choose 1', 'choose_one', 1, NULL,
       'Choose 1 course from Group 1. If a course could count for multiple Groups, you must choose ONE Group.', 30
FROM majors m WHERE m.code='ARH'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_count, min_credits, notes, sort_order)
SELECT m.id, 'ARH_G2_ONE', 'Core Group 2 (Pre/early modern to 1900): choose 1', 'choose_one', 1, NULL,
       'Choose 1 course from Group 2. Cross-listed courses must be claimed to a single Group.', 40
FROM majors m WHERE m.code='ARH'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_count, min_credits, notes, sort_order)
SELECT m.id, 'ARH_G3_ONE', 'Core Group 3 (Modern/postmodern after 1900): choose 1', 'choose_one', 1, NULL,
       'Choose 1 course from Group 3. Cross-listed courses must be claimed to a single Group.', 50
FROM majors m WHERE m.code='ARH'
ON CONFLICT (major_id, code) DO NOTHING;

-- Core methods + thesis seminar
INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_count, min_credits, notes, sort_order)
SELECT m.id, 'ARH_CORE_380', 'Core: ARH 380 Theory & Methods', 'must_take', NULL, NULL, NULL, 60
FROM majors m WHERE m.code='ARH'
ON CONFLICT (major_id, code) DO NOTHING;

INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_count, min_credits, notes, sort_order)
SELECT m.id, 'ARH_CORE_400', 'Core: ARH 400 Seminar (Senior Thesis)', 'must_take', NULL, NULL,
       'Senior thesis is completed in ARH 400.', 70
FROM majors m WHERE m.code='ARH'
ON CONFLICT (major_id, code) DO NOTHING;

-- Electives: 12 credits beyond ARH 103 (and with permission up to 8 credits outside dept)
-- This needs custom enforcement for outside-dept cap, so make it custom.
INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_count, min_credits, notes, sort_order)
SELECT m.id, 'ARH_ELECTIVES_12', 'Electives: 12 credits beyond ARH 103', 'custom', NULL, 12,
       'Complete 12 additional credits beyond ARH 103. With permission, up to 8 credits may be outside ARH.', 80
FROM majors m WHERE m.code='ARH'
ON CONFLICT (major_id, code) DO NOTHING;

-- Major totals + 200-level-per-group cap: custom summary block
INSERT INTO requirement_blocks(major_id, code, title, rule_type, min_count, min_credits, notes, sort_order)
SELECT m.id, 'ARH_TOTALS_AND_CAPS', 'Major totals + caps (32 credits, >=20 ARH, group 200-level cap)', 'custom', NULL, 32,
       'Need >=32 major credits; >=20 credits in ARH dept. Per-group: no more than 12 credits at 200-level may count (unless approved).',
       90
FROM majors m WHERE m.code='ARH'
ON CONFLICT (major_id, code) DO NOTHING;

-- ------------------------------------------------------------
-- 3) Attach course options to blocks
-- ------------------------------------------------------------

-- Must-take: ARH 103 / 380 / 400
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id=b.major_id
JOIN courses c ON c.course_code='ARH 103'
WHERE m.code='ARH' AND b.code='ARH_REQ_ARH103'
ON CONFLICT DO NOTHING;

INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id=b.major_id
JOIN courses c ON c.course_code='ARH 380'
WHERE m.code='ARH' AND b.code='ARH_CORE_380'
ON CONFLICT DO NOTHING;

INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id=b.major_id
JOIN courses c ON c.course_code='ARH 400'
WHERE m.code='ARH' AND b.code='ARH_CORE_400'
ON CONFLICT DO NOTHING;

-- Studio choose-one options
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id=b.major_id
JOIN courses c ON c.course_code IN ('ART 111','ART 134')
WHERE m.code='ARH' AND b.code='ARH_REQ_STUDIO100'
ON CONFLICT DO NOTHING;

-- Group 1 options (+ ARH 295 allowed by approval; include it as an option)
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id=b.major_id
JOIN courses c ON c.course_code IN ('ARH 212','ARH 213','ARH 215','ARH 233','ARH 234','EAS 213','ARH 295')
WHERE m.code='ARH' AND b.code='ARH_G1_ONE'
ON CONFLICT DO NOTHING;

-- Group 2 options (+ ARH 295)
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id=b.major_id
JOIN courses c ON c.course_code IN ('ARH 211','ARH 212','ARH 213','ARH 214','ARH 221','ARH 222','ARH 248','ARH 270','CLS 248','ARH 295')
WHERE m.code='ARH' AND b.code='ARH_G2_ONE'
ON CONFLICT DO NOTHING;

-- Group 3 options (+ ARH 295)
INSERT INTO block_course_options(block_id, course_id)
SELECT b.id, c.id
FROM requirement_blocks b
JOIN majors m ON m.id=b.major_id
JOIN courses c ON c.course_code IN ('ARH 231','ARH 232','ARH 270','ARH 272','ARH 295')
WHERE m.code='ARH' AND b.code='ARH_G3_ONE'
ON CONFLICT DO NOTHING;

