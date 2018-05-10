-- TODO: This migration for the likert data has the same issue as
--  the ipsative one where the triggers to protect some fields have
--  been left out

-- TODO: Choices have been left out (Strongly Disagree, Disagree, Neutral, Agree, Strongly Agree)

-- TABLE DEFINITIONS

CREATE TABLE mappa.likert_surveys (
  id SERIAL NOT NULL PRIMARY KEY,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  name TEXT,
  description TEXT,
  instructions TEXT,
  author TEXT
);

CREATE TABLE mappa.likert_questions (
  id SERIAL NOT NULL PRIMARY KEY,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  survey_id INTEGER REFERENCES mappa.likert_surveys(id),
  title TEXT
);
CREATE TABLE mappa.likert_answers (
  id SERIAL NOT NULL PRIMARY KEY,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  question_id INTEGER REFERENCES mappa.likert_questions(id),
  answer TEXT
);

-- POSTGREST VIEWS

CREATE OR REPLACE VIEW "1".likert_surveys as
  SELECT
    id,
    created_at,
    updated_at,
    name,
    description,
    instructions,
    author
  FROM mappa.likert_surveys;

CREATE OR REPLACE VIEW "1".likert_questions as
  SELECT
    id,
    created_at,
    updated_at,
    survey_id,
    title
  FROM mappa.likert_questions;

CREATE OR REPLACE VIEW "1".likert_answers as
  SELECT
    id,
    created_at,
    updated_at,
    question_id,
    answer
  FROM mappa.likert_answers;

-- POSTGREST PERMISSIONS

GRANT SELECT, INSERT ON mappa.likert_surveys to member;
GRANT all ON "1".likert_surveys to member;

GRANT SELECT, INSERT ON mappa.likert_questions to member;
GRANT all ON "1".likert_questions to member;

GRANT SELECT, INSERT ON mappa.likert_answers to member;
GRANT all ON "1".likert_answers to member;

