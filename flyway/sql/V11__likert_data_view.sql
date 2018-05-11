CREATE OR REPLACE VIEW mappa.likert_data AS
SELECT 
S.id as survey_id
-- ,S.name as survey_name
,Q.id as question_id
,Q.title as question_title
,A.id as answer_id
,A.answer as answer_answer

FROM mappa.likert_surveys S
JOIN mappa.likert_questions Q  on S.id = Q.survey_id
JOIN mappa.likert_answers A on Q.id = A.question_id;



CREATE OR REPLACE VIEW "1".likert_data as
  SELECT *
  FROM mappa.likert_data;


GRANT SELECT, INSERT ON mappa.likert_data to member;
GRANT all ON "1".likert_data to member;
