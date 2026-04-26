BEGIN;

-- ============================================================
-- 1) Users & Planning
-- ============================================================

CREATE TABLE IF NOT EXISTS users (
  id            BIGSERIAL PRIMARY KEY,
  name          TEXT NOT NULL,
  email         TEXT UNIQUE,
  created_at    TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS majors (
  id            BIGSERIAL PRIMARY KEY,
  code          TEXT NOT NULL UNIQUE,   -- e.g. 'ANTH'
  name          TEXT NOT NULL           -- e.g. 'Anthropology'
);

CREATE TABLE IF NOT EXISTS user_majors (
  user_id       BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  major_id      BIGINT NOT NULL REFERENCES majors(id) ON DELETE CASCADE,
  kind          TEXT NOT NULL CHECK (kind IN ('major','concentration')),
  PRIMARY KEY (user_id, major_id, kind)
);

CREATE TABLE IF NOT EXISTS plans (
  id            BIGSERIAL PRIMARY KEY,
  user_id       BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name          TEXT NOT NULL           -- e.g. 'Plan A', 'Plan B'
);

-- ============================================================
-- 2) Course Catalog
-- ============================================================

CREATE TABLE IF NOT EXISTS courses (
  id            BIGSERIAL PRIMARY KEY,
  dept          TEXT NOT NULL,          -- e.g. 'ANT'
  number        INT  NOT NULL,          -- e.g. 104
  course_code   TEXT NOT NULL UNIQUE,   -- e.g. 'ANT 104'
  title         TEXT,
  credits       INT  NOT NULL DEFAULT 4,
  level         INT GENERATED ALWAYS AS ((number / 100) * 100) STORED,
  active        BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS course_terms (
  course_id     BIGINT NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  term          TEXT NOT NULL CHECK (term IN ('Fall','Spring','Summer','Winter')),
  PRIMARY KEY (course_id, term)
);

CREATE TABLE IF NOT EXISTS course_prerequisites (
  course_id                 BIGINT NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  prerequisite_course_id    BIGINT NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  PRIMARY KEY (course_id, prerequisite_course_id),
  CHECK (course_id <> prerequisite_course_id)
);

CREATE TABLE IF NOT EXISTS course_prerequisite_groups (
  course_id                 BIGINT NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  group_code                TEXT NOT NULL,
  prerequisite_course_id    BIGINT NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  can_be_corequisite        BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (course_id, group_code, prerequisite_course_id),
  CHECK (course_id <> prerequisite_course_id)
);

CREATE TABLE IF NOT EXISTS course_registration_rules (
  course_id                         BIGINT PRIMARY KEY REFERENCES courses(id) ON DELETE CASCADE,
  min_semester_index                INT,
  min_prior_courses_dept            TEXT,
  min_prior_courses_min_number      INT,
  min_prior_courses_max_number      INT,
  min_prior_courses_count           INT,
  notes                             TEXT
);

CREATE TABLE IF NOT EXISTS plan_courses (
  plan_id       BIGINT NOT NULL REFERENCES plans(id) ON DELETE CASCADE,
  course_id     BIGINT NOT NULL REFERENCES courses(id),
  year          INT NOT NULL,
  term          TEXT NOT NULL CHECK (term IN ('Fall','Spring','Summer','Winter')),
  status        TEXT NOT NULL DEFAULT 'planned'
                CHECK (status IN ('planned','enrolled','completed','dropped')),
  grade         TEXT,
  PRIMARY KEY (plan_id, course_id, year, term)
);

-- ============================================================
-- 3) Requirement Modeling
-- ============================================================

CREATE TABLE IF NOT EXISTS requirement_blocks (
  id            BIGSERIAL PRIMARY KEY,
  major_id      BIGINT NOT NULL REFERENCES majors(id) ON DELETE CASCADE,
  code          TEXT NOT NULL,
  title         TEXT NOT NULL,
  rule_type     TEXT NOT NULL CHECK (
                  rule_type IN (
                    'must_take',
                    'choose_one',
                    'choose_n',
                    'choose_credits',
                    'or_group',
                    'custom'
                  )
                ),
  min_count     INT,
  min_credits   INT,
  notes         TEXT,
  sort_order    INT NOT NULL DEFAULT 0,
  UNIQUE (major_id, code)
);

CREATE TABLE IF NOT EXISTS block_course_options (
  block_id      BIGINT NOT NULL REFERENCES requirement_blocks(id) ON DELETE CASCADE,
  course_id     BIGINT NOT NULL REFERENCES courses(id),
  min_level     INT,
  max_level     INT,
  PRIMARY KEY (block_id, course_id)
);

CREATE TABLE IF NOT EXISTS block_or_children (
  parent_block_id BIGINT NOT NULL REFERENCES requirement_blocks(id) ON DELETE CASCADE,
  child_block_id  BIGINT NOT NULL REFERENCES requirement_blocks(id) ON DELETE CASCADE,
  PRIMARY KEY (parent_block_id, child_block_id),
  CHECK (parent_block_id <> child_block_id)
);

-- ============================================================
-- 4) Subfields
-- ============================================================

CREATE TABLE IF NOT EXISTS subfields (
  id            BIGSERIAL PRIMARY KEY,
  major_id      BIGINT NOT NULL REFERENCES majors(id) ON DELETE CASCADE,
  code          TEXT NOT NULL,
  name          TEXT NOT NULL,
  UNIQUE (major_id, code)
);

CREATE TABLE IF NOT EXISTS course_subfields (
  course_id     BIGINT NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  subfield_id   BIGINT NOT NULL REFERENCES subfields(id) ON DELETE CASCADE,
  PRIMARY KEY (course_id, subfield_id)
);

-- ============================================================
-- 5) Group claims for cross-listed / multi-group logic
-- ============================================================

CREATE TABLE IF NOT EXISTS plan_course_group_claims (
  plan_id       BIGINT NOT NULL REFERENCES plans(id) ON DELETE CASCADE,
  course_id     BIGINT NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  group_code    TEXT NOT NULL CHECK (group_code IN ('G1','G2','G3')),
  PRIMARY KEY (plan_id, course_id)
);

COMMIT;
