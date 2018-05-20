-- FORCE Survey

INSERT INTO mappa.likert_surveys(name, description, instructions, author) VALUES
  (
    'Security FORCE Survey',
    'Survey to identify existing security culture in an organization.',
    'To complete this Security FORCE Survey, please indicate your level of agreement with each of the following statements regarding information security values and practices within your organization. Choose one response per statement. Please respond to all statements.',
    'Lance Hayden'
    );

-- Likert Choice Groups

INSERT INTO mappa.likert_choice_groups(name) VALUES
  ('Standard'),
  ('Small');

-- Example "Small" Choices

INSERT INTO mappa.likert_choices(choice_group_id, order_number, choice)
SELECT
  (SELECT uuid from mappa.likert_choice_groups where name = 'Small'),
  order_number,
  choice
FROM (VALUES 
  (1, 'Disagree'),
  (2, 'Neutral'),
  (3, 'Agree')
  ) likert_choices_data (order_number, choice);

-- Likert Choices

INSERT INTO mappa.likert_choices(choice_group_id, order_number, choice)
SELECT
  (SELECT uuid from mappa.likert_choice_groups where name = 'Standard'),
  order_number,
  choice
FROM (VALUES 
  (1, 'Strongly Disagree'),
  (2, 'Disagree'),
  (3, 'Neutral'),
  (4, 'Agree'),
  (5, 'Strongly Agree')
  ) likert_choices_data (order_number, choice);

-- FORCE Questions

INSERT INTO mappa.likert_questions(survey_id, choice_group_id, order_number, title)
SELECT 
  (SELECT uuid from mappa.likert_surveys where name = 'Security FORCE Survey'),
  (SELECT uuid from mappa.likert_choice_groups where name = 'Standard'),
  order_number,
  title 
FROM (values 
  (1,'Security Value of Failure'),
  (2,'Security Value of Operations'),
  (3,'Security Value of Resilience'),
  (4,'Security Value of Complexity'),
  (5,'Security Value of Expertise')
) likert_questions_data (order_number,title);

-- Each answer for each question

INSERT INTO mappa.likert_answers(question_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.likert_questions where title = 'Security Value of Failure'),
  order_number, answer 
FROM (values 
  (1,'I feel confident I could predict where the organization’s next security incident will happen.'),
  (2,'I regularly identify security problems while doing my job.'),
  (3,'I feel very comfortable reporting security problems up the management chain.'),
  (4,'I know that security problems I report will be taken seriously.'),
  (5,'When a security problem is found, it gets fixed.')

) likert_answers_data (order_number, answer);



INSERT INTO mappa.likert_answers(question_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.likert_questions where title = 'Security Value of Operations'),
  order_number, answer  
FROM (values 
  (1,'I know that someone is constantly keeping watch over how secure the organization is.'),
  (2,'I am confident that information security in the organization actually works the way that people and policies say it does.'),
  (3,'I feel like there are many experts around the organization willing and able to help me understand how things work.'),
  (4,'Management and the security team regularly share information about security assessments.'),
  (5,'Management stays actively involved in security and makes sure appropriate resources are available.')

) likert_answers_data (order_number, answer);


INSERT INTO mappa.likert_answers(question_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.likert_questions where title = 'Security Value of Resilience'),
  order_number, answer  
FROM (values 
  (1,'I feel like people are trained to know more about security than just the minimum level necessary.'),
  (2,'The organization has reserves of skill and expertise to call on in the event of a security incident or crisis.'),
  (3,'I feel like everyone in the organization is encouraged to “get out of their comfort zone” and be part of security challenges. '),
  (4,'I feel like people are interested in what I know about security, and willing to share their own skills to help me as well.'),
  (5,'The organization often conducts drills and scenarios to test how well we respond to security incidents and failures.')

) likert_answers_data (order_number, answer);


INSERT INTO mappa.likert_answers(question_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.likert_questions where title = 'Security Value of Complexity'),
  order_number, answer  
FROM (values 
  (1,'I feel like people in the organization prefer complex explanations over simple ones.'),
  (2,'I feel like people are open to being challenged or questioned about how they arrived at an answer.'),
  (3,'The organization always has plenty of data to explain and justify its decisions.'),
  (4,'People from outside the security team are encouraged to participate and question security plans and decisions.'),
  (5,'The organization formally reviews strategies and predictions to make sure they were accurate, and adjusts accordingly.')

) likert_answers_data (order_number, answer);


INSERT INTO mappa.likert_answers(question_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.likert_questions where title = 'Security Value of Expertise'),
  order_number, answer  
FROM (values 
  (1,'I know exactly where to go in the organization when I need an expert.'),
  (2,'I think everyone in the organization feels that monitoring security is part of their job.'),
  (3,'In the event of a security incident, people can legitimately bypass the bureaucracy to get things done.'),
  (4,'People in the organization are encouraged to help other groups if they have the right skills to help them.'),
  (5,'I feel empowered to take action myself, if something is about to cause a security failure.')
) likert_answers_data (order_number, answer);

