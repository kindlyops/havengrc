CREATE OR REPLACE VIEW mappa.likert_data AS

SELECT 
S.uuid as survey_id,
Q.uuid as question_id,
Q.title as question_title,
Q.choice_group_id as question_choice_group,
Q.order_number as question_order_number,
A.uuid as answer_id,
A.answer as answer,
A.order_number as answer_order_number
FROM mappa.likert_surveys S
JOIN mappa.likert_questions Q  on S.uuid = Q.survey_id
JOIN mappa.likert_answers A on Q.uuid = A.question_id
JOIN mappa.likert_choice_groups CG on CG.uuid = Q.choice_group_id;



CREATE OR REPLACE VIEW "1".likert_data as
  SELECT *
  FROM mappa.likert_data;


GRANT SELECT, INSERT ON mappa.likert_data to member;
GRANT all ON "1".likert_data to member;



-- Choice Groups

CREATE OR REPLACE VIEW mappa.likert_distinct_choice_groups AS

SELECT DISTINCT
S.uuid as survey_id,
CG.uuid as choice_group_id,
C.choice as choice,
C.order_number as order_number
FROM mappa.likert_surveys S
JOIN mappa.likert_questions Q  on S.uuid = Q.survey_id
JOIN mappa.likert_choice_groups CG on CG.uuid = Q.choice_group_id
JOIN mappa.likert_choices C on C.choice_group_id = CG.uuid;



CREATE OR REPLACE VIEW "1".likert_distinct_choice_groups as
  SELECT *
  FROM mappa.likert_distinct_choice_groups;


GRANT SELECT, INSERT ON mappa.likert_distinct_choice_groups to member;
GRANT all ON "1".likert_distinct_choice_groups to member;
