-- Test Survey

INSERT INTO mappa.ipsative_surveys(name, description, instructions, author) VALUES
  (
    'Quick Debug Survey',
    'Ipsative survey with 2 questions for quick testing',
    'For each question, assign a total of 10 points, divided among the four statements based on how accurately you think each describes your organization.',
    'David Streeter'

    );

-- Test Questions

INSERT INTO mappa.ipsative_questions(survey_id, title)
SELECT 
  (SELECT id from mappa.ipsative_surveys where name = 'Quick Debug Survey'),
  title 
FROM (values 
  ('Test Question 1'),
  ('Test Question 2')
) ipsative_questions_data (title);

-- Each answer for each question

INSERT INTO mappa.ipsative_answers(question_id, category, answer)
SELECT 
  (SELECT id from mappa.ipsative_questions where title = 'Test Question 1'),
  category, answer 
FROM (values 
  ('Process',  'Process 1'),
  ('Compliance',  'Compliance 1'),
  ('Autonomy',  'Autonomy 1'),
  ('Trust',  'Trust 1')

) ipsative_answers_data (category, answer);



INSERT INTO mappa.ipsative_answers(question_id, category, answer)
SELECT 
  (SELECT id from mappa.ipsative_questions where title = 'Test Question 2'),
  category, answer 
FROM (values 
  ('Process',  'Process 2'),
  ('Compliance',  'Compliance 2'),
  ('Autonomy',  'Autonomy 2'),
  ('Trust',  'Trust 2')

) ipsative_answers_data (category, answer);

