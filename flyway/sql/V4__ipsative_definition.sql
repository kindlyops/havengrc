-- TODO: The trigger functions are commented out because when inserting data, 
--  even if I have declared the id/created_at/updated_at as explicitly NULL,
--  the function still gets an id at creation time

-- Restricts id, created_at, inserted_at. Creates default timestamp for created_at, inserted_at

-- CREATE OR REPLACE FUNCTION mappa.override_ipsative_insert()
-- RETURNS TRIGGER AS $$
-- BEGIN
--   IF NEW.id IS NOT NULL THEN
--     RAISE EXCEPTION 'You must not send id field';
--   END IF;
--   IF NEW.created_at IS NOT NULL THEN
--     RAISE EXCEPTION 'You must not send created_at field';
--   ELSE
--     NEW.created_at = now();
--   END IF;
--   IF NEW.updated_at IS NOT NULL THEN
--     RAISE EXCEPTION 'You must not send updated_at field';
--   ELSE
--     NEW.updated_at = now();
--   END IF;
--   RETURN NEW;
-- END;
-- $$ language 'plpgsql';

-- Same as above but doesn't change created_at

-- CREATE OR REPLACE FUNCTION mappa.override_ipsative_update()
-- RETURNS TRIGGER AS $$
-- BEGIN
--   IF NEW.id IS NOT NULL THEN
--     RAISE EXCEPTION 'You must not send id field';
--   END IF;
--   IF NEW.created_at IS NOT NULL THEN
--     RAISE EXCEPTION 'You must not send created_at field';
--   END IF;
--   IF NEW.updated_at IS NOT NULL THEN
--     RAISE EXCEPTION 'You must not send updated_at field';
--   ELSE
--     NEW.updated_at = now();
--   END IF;
--   RETURN NEW;
-- END;
-- $$ language 'plpgsql';

-- TABLE DEFINITIONS

CREATE TABLE mappa.ipsative_surveys (
  id SERIAL NOT NULL PRIMARY KEY,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  name TEXT,
  description TEXT,
  instructions TEXT,
  author TEXT
);

CREATE TABLE mappa.ipsative_questions (
  id SERIAL NOT NULL PRIMARY KEY,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  survey_id INTEGER REFERENCES mappa.ipsative_surveys(id),
  title TEXT
);
CREATE TABLE mappa.ipsative_answers (
  id SERIAL NOT NULL PRIMARY KEY,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  question_id INTEGER REFERENCES mappa.ipsative_questions(id),
  category TEXT,
  answer TEXT
);

-- INSERT TRIGGERS

-- TODO: Commented out (see notes above)

-- CREATE TRIGGER trigger_ipsative_survey_insert
-- BEFORE INSERT ON mappa.ipsative_surveys
-- FOR EACH ROW
-- EXECUTE PROCEDURE mappa.override_ipsative_insert();

-- CREATE TRIGGER trigger_ipsative_question_insert
-- BEFORE INSERT ON mappa.ipsative_questions
-- FOR EACH ROW
-- EXECUTE PROCEDURE mappa.override_ipsative_insert();

-- CREATE TRIGGER trigger_ipsative_answer_insert
-- BEFORE INSERT ON mappa.ipsative_answers
-- FOR EACH ROW
-- EXECUTE PROCEDURE mappa.override_ipsative_insert();



-- UPDATE TRIGGERS

-- CREATE TRIGGER trigger_ipsative_survey_update
-- BEFORE UPDATE ON mappa.ipsative_surveys
-- FOR EACH ROW
-- EXECUTE PROCEDURE mappa.override_ipsative_update();


-- CREATE TRIGGER trigger_ipsative_question_update
-- BEFORE UPDATE ON mappa.ipsative_questions
-- FOR EACH ROW
-- EXECUTE PROCEDURE mappa.override_ipsative_update();

-- CREATE TRIGGER trigger_ipsative_answer_update
-- BEFORE UPDATE ON mappa.ipsative_answers
-- FOR EACH ROW
-- EXECUTE PROCEDURE mappa.override_ipsative_update();



-- POSTGREST VIEWS

CREATE OR REPLACE VIEW "1".ipsative_surveys as
  SELECT
    id,
    created_at,
    updated_at,
    name,
    description,
    instructions,
    author
  FROM mappa.ipsative_surveys;

CREATE OR REPLACE VIEW "1".ipsative_questions as
  SELECT
    id,
    created_at,
    updated_at,
    survey_id,
    title
  FROM mappa.ipsative_questions;

CREATE OR REPLACE VIEW "1".ipsative_answers as
  SELECT
    id,
    created_at,
    updated_at,
    question_id,
    category,
    answer
  FROM mappa.ipsative_answers;

-- POSTGREST PERMISSIONS

GRANT SELECT, INSERT ON mappa.ipsative_surveys to member;
GRANT all ON "1".ipsative_surveys to member;

GRANT SELECT, INSERT ON mappa.ipsative_questions to member;
GRANT all ON "1".ipsative_questions to member;

GRANT SELECT, INSERT ON mappa.ipsative_answers to member;
GRANT all ON "1".ipsative_answers to member;

