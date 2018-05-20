-- TODO: Choices have been left out (Strongly Disagree, Disagree, Neutral, Agree, Strongly Agree)

-- Functionally the same as override_ipsative_insert_columns.
-- TODO: combine override_ipsative_insert_columns and override_likert_insert_columns into just override_survey_insert_columns

CREATE OR REPLACE FUNCTION mappa.override_likert_insert_columns()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.uuid IS NOT NULL THEN
    RAISE EXCEPTION 'You must not send uuid field';
  ELSE
    NEW.uuid = mappa.uuid_generate_v4();
  END IF;
  IF NEW.created_at IS NOT NULL THEN
    RAISE EXCEPTION 'You must not send created_at field';
  ELSE
    NEW.created_at = now();
  END IF;
  RETURN NEW;
END;
$$ language 'plpgsql';


-- Table Definitions

CREATE TABLE mappa.likert_surveys (
  uuid UUID UNIQUE,
  created_at TIMESTAMPTZ,
  name TEXT,
  description TEXT,
  instructions TEXT,
  author TEXT
);

CREATE TABLE mappa.likert_questions (
  uuid UUID UNIQUE,
  created_at TIMESTAMPTZ,
  survey_id UUID REFERENCES mappa.likert_surveys(uuid),
  order_number INTEGER,
  title TEXT
);

CREATE TABLE mappa.likert_choices (
  uuid UUID UNIQUE,
  created_at TIMESTAMPTZ,
  order_number INTEGER,
  choice TEXT
);

CREATE TABLE mappa.likert_answers (
  uuid UUID UNIQUE,
  created_at TIMESTAMPTZ,
  question_id UUID REFERENCES mappa.likert_questions(uuid),
  order_number INTEGER,
  answer TEXT
);

-- Insert Triggers

CREATE TRIGGER trigger_likert_survey_insert
BEFORE INSERT ON mappa.likert_surveys
FOR EACH ROW
EXECUTE PROCEDURE mappa.override_likert_insert_columns();

CREATE TRIGGER trigger_likert_question_insert
BEFORE INSERT ON mappa.likert_questions
FOR EACH ROW
EXECUTE PROCEDURE mappa.override_likert_insert_columns();

CREATE TRIGGER trigger_likert_choice_insert
BEFORE INSERT ON mappa.likert_choices
FOR EACH ROW
EXECUTE PROCEDURE mappa.override_likert_insert_columns();

CREATE TRIGGER trigger_likert_answer_insert
BEFORE INSERT ON mappa.likert_answers
FOR EACH ROW
EXECUTE PROCEDURE mappa.override_likert_insert_columns();

-- Postrest Views


CREATE OR REPLACE VIEW "1".likert_surveys as
  SELECT
    uuid,
    created_at,
    name,
    description,
    instructions,
    author
  FROM mappa.likert_surveys;

CREATE OR REPLACE VIEW "1".likert_questions as
  SELECT
    uuid,
    created_at,
    survey_id,
    order_number,
    title
  FROM mappa.likert_questions;

CREATE OR REPLACE VIEW "1".likert_choices as
  SELECT
    uuid,
    created_at,
    order_number,
    choice
  FROM mappa.likert_choices;


CREATE OR REPLACE VIEW "1".likert_answers as
  SELECT
    uuid,
    created_at,
    question_id,
    order_number,
    answer
  FROM mappa.likert_answers;

-- Postgrest Permissions

GRANT SELECT, INSERT ON mappa.likert_surveys to member;
GRANT all ON "1".likert_surveys to member;

GRANT SELECT, INSERT ON mappa.likert_questions to member;
GRANT all ON "1".likert_questions to member;

GRANT SELECT, INSERT ON mappa.likert_choices to member;
GRANT all ON "1".likert_choices to member;

GRANT SELECT, INSERT ON mappa.likert_answers to member;
GRANT all ON "1".likert_answers to member;

