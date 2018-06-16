CREATE OR REPLACE VIEW mappa.ipsative_response_grouped AS

SELECT group_number
  ,category
  ,sum(points_assigned)
FROM mappa.ipsative_responses ir
JOIN mappa.ipsative_answers ia on ia.uuid = ir.answer_id
JOIN mappa.ipsative_categories ic on ic.uuid = ia.category_id
group by group_number
  ,category;
  
CREATE OR REPLACE VIEW "1".ipsative_response_grouped as
  SELECT *
  FROM mappa.ipsative_response_grouped;

GRANT SELECT, INSERT ON mappa.ipsative_response_grouped to member;
GRANT all ON "1".ipsative_response_grouped to member;

---------------------
CREATE OR REPLACE VIEW mappa.ipsative_responses_grouped_two AS

SELECT iq.survey_id
	,ips.name
	,ir.group_number
	,ic.category
	,sum(ir.points_assigned)
FROM mappa.ipsative_responses ir
JOIN mappa.ipsative_answers ia on ia.uuid = ir.answer_id
JOIN mappa.ipsative_categories ic on ic.uuid = ia.category_id
JOIN mappa.ipsative_questions iq on iq.uuid = ia.question_id
JOIN mappa.ipsative_surveys ips on ips.uuid = iq.survey_id
group by iq.survey_id
	,ips.name
	,ir.group_number
	,ic.category
order by group_number;


CREATE OR REPLACE VIEW "1".ipsative_responses_grouped_two as
  SELECT *
  FROM mappa.ipsative_responses_grouped_two;

GRANT SELECT, INSERT ON mappa.ipsative_responses_grouped_two to member;
GRANT all ON "1".ipsative_responses_grouped_two to member;