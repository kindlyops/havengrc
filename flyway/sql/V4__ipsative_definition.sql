-- Restricts uuid and created_at

CREATE OR REPLACE FUNCTION mappa.override_survey_insert_columns()
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

CREATE TABLE mappa.ipsative_surveys (
  uuid UUID UNIQUE,
  created_at TIMESTAMPTZ,
  name TEXT,
  description TEXT,
  instructions TEXT,
  author TEXT
);

CREATE TABLE mappa.ipsative_questions (
  uuid UUID UNIQUE,
  created_at TIMESTAMPTZ,
  survey_id UUID REFERENCES mappa.ipsative_surveys(uuid),
  order_number INTEGER,
  title TEXT
);

CREATE TABLE mappa.ipsative_categories (
  uuid UUID UNIQUE,
  created_at TIMESTAMPTZ,
  category TEXT
);

CREATE TABLE mappa.ipsative_answers (
  uuid UUID UNIQUE,
  created_at TIMESTAMPTZ,
  question_id UUID REFERENCES mappa.ipsative_questions(uuid),
  category_id UUID REFERENCES mappa.ipsative_categories(uuid),
  order_number INTEGER,
  answer TEXT
);

-- Insert Triggers

CREATE TRIGGER trigger_ipsative_survey_insert
BEFORE INSERT ON mappa.ipsative_surveys
FOR EACH ROW
EXECUTE PROCEDURE mappa.override_survey_insert_columns();

CREATE TRIGGER trigger_ipsative_question_insert
BEFORE INSERT ON mappa.ipsative_questions
FOR EACH ROW
EXECUTE PROCEDURE mappa.override_survey_insert_columns();

CREATE TRIGGER trigger_ipsative_category_insert
BEFORE INSERT ON mappa.ipsative_categories
FOR EACH ROW
EXECUTE PROCEDURE mappa.override_survey_insert_columns();

CREATE TRIGGER trigger_ipsative_answer_insert
BEFORE INSERT ON mappa.ipsative_answers
FOR EACH ROW
EXECUTE PROCEDURE mappa.override_survey_insert_columns();


-- Postrest Views

CREATE OR REPLACE VIEW "1".ipsative_surveys as
  SELECT
    uuid,
    created_at,
    name,
    description,
    instructions,
    author
  FROM mappa.ipsative_surveys;

CREATE OR REPLACE VIEW "1".ipsative_questions as
  SELECT
    uuid,
    created_at,
    survey_id,
    order_number,
    title
  FROM mappa.ipsative_questions;

CREATE OR REPLACE VIEW "1".ipsative_categories as
  SELECT
    uuid,
    created_at,
    category
  FROM mappa.ipsative_categories;

CREATE OR REPLACE VIEW "1".ipsative_answers as
  SELECT
    uuid,
    created_at,
    question_id,
    category_id,
    order_number,
    answer
  FROM mappa.ipsative_answers;

-- Postgrest Permissions

GRANT SELECT, INSERT ON mappa.ipsative_surveys to member;
GRANT all ON "1".ipsative_surveys to member;

GRANT SELECT, INSERT ON mappa.ipsative_questions to member;
GRANT all ON "1".ipsative_questions to member;

GRANT SELECT, INSERT ON mappa.ipsative_categories to member;
GRANT all ON "1".ipsative_categories to member;

GRANT SELECT, INSERT ON mappa.ipsative_answers to member;
GRANT all ON "1".ipsative_answers to member;

