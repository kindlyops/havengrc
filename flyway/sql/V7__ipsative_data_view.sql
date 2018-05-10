CREATE OR REPLACE VIEW mappa.ipsative_data AS
SELECT 
S.id as survey_id
-- ,S.name as survey_name
,Q.id as question_id
,Q.title as question_title
,A.id as answer_id
,A.category as answer_category
,A.answer as answer_answer

FROM mappa.ipsative_surveys S
JOIN mappa.ipsative_questions Q  on S.id = Q.survey_id
JOIN mappa.ipsative_answers A on Q.id = A.question_id;



CREATE OR REPLACE VIEW "1".ipsative_data as
  SELECT *
  FROM mappa.ipsative_data;


GRANT SELECT, INSERT ON mappa.ipsative_data to member;
GRANT all ON "1".ipsative_data to member;
