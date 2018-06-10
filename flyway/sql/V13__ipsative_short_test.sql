-- Short Ipsative for testing purposes

INSERT INTO mappa.ipsative_surveys(name, description, instructions, author) VALUES
  (
    'Short_Ipsative',
    'Dev purposes',
    'Dev purposes',
    'David Streeter'
    );

-- SCDS Questions

INSERT INTO mappa.ipsative_questions(survey_id, order_number, title)
SELECT 
  (SELECT uuid from mappa.ipsative_surveys where name = 'Short_Ipsative'),
  order_number,
  title 
FROM (values 
  (1, 'Question 1'),
  (2, 'Question 2')
) ipsative_questions_data (order_number,title);


-- Each answer for each question

INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'Question 1'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Process'),
  1,
  'Answer 1'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'Question 1'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Compliance'),
  2,
  'Answer 2'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'Question 1'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Autonomy'),
  3,
  'Answer 3'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'Question 1'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Trust'),
  4,
  'Answer 4'
;  

INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'Question 2'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Process'),
  1,
  'Answer 1'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'Question 2'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Compliance'),
  2,
  'Answer 2'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'Question 2'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Autonomy'),
  3,
  'Answer 3'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'Question 2'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Trust'),
  4,
  'Answer 4'
;  
