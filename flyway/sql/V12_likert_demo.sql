-- FORCE Survey

INSERT INTO mappa.likert_surveys(name, description, instructions, author) VALUES
  (
    'Multiple_ChoiceGroup_Demo',
    'Survey to show different question groups being used.',
    'The likert survey system allows users to have multiple "Choice Groups". The choice groups are keyed by question, so a single survey can use many choice groups.',
    'David Streeter'
    );

-- Adding a "Gender" choice group

INSERT INTO mappa.likert_choice_groups(name) VALUES
  ('Gender');
  

-- Gender choices, note that "order_number" is for how the choices will display in the survey (left to right)

INSERT INTO mappa.likert_choices(choice_group_id, order_number, choice)
SELECT
  (SELECT uuid from mappa.likert_choice_groups where name = 'Gender'),
  order_number,
  choice
FROM (VALUES 
  (1, 'Female'),
  (2, 'Male')
  ) likert_choices_data (order_number, choice);

-- Demo Questions

INSERT INTO mappa.likert_questions(survey_id, choice_group_id, order_number, title)
SELECT 
  (SELECT uuid from mappa.likert_surveys where name = 'Multiple_ChoiceGroup_Demo'),
  (SELECT uuid from mappa.likert_choice_groups where name = 'Standard'),
  1,
  'Standard Choice Group';

INSERT INTO mappa.likert_questions(survey_id, choice_group_id, order_number, title)
SELECT 
  (SELECT uuid from mappa.likert_surveys where name = 'Multiple_ChoiceGroup_Demo'),
  (SELECT uuid from mappa.likert_choice_groups where name = 'Small'),
  2,
  'Small Choice Group';

INSERT INTO mappa.likert_questions(survey_id, choice_group_id, order_number, title)
SELECT 
  (SELECT uuid from mappa.likert_surveys where name = 'Multiple_ChoiceGroup_Demo'),
  (SELECT uuid from mappa.likert_choice_groups where name = 'Gender'),
  3,
  'Gender Choice Group';

-- Each answer for each question

INSERT INTO mappa.likert_answers(question_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.likert_questions where title = 'Standard Choice Group'),
  order_number, answer 
FROM (values 
  (1,'Answer 1'),
  (2,'Answer 2'),
  (3,'Answer 3'),
  (4,'Answer 4')
) likert_answers_data (order_number, answer);

INSERT INTO mappa.likert_answers(question_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.likert_questions where title = 'Small Choice Group'),
  order_number, answer 
FROM (values 
  (1,'Answer 1'),
  (2,'Answer 2'),
  (3,'Answer 3'),
  (4,'Answer 4')
) likert_answers_data (order_number, answer);


INSERT INTO mappa.likert_answers(question_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.likert_questions where title = 'Gender Choice Group'),
  order_number, answer 
FROM (values 
  (1,'Answer 1'),
  (2,'Answer 2'),
  (3,'Answer 3'),
  (4,'Answer 4')
) likert_answers_data (order_number, answer);



