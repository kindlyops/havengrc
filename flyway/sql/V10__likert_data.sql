-- SCDS Survey

INSERT INTO mappa.likert_surveys(name, description, instructions, author) VALUES
  (
    'Security FORCE Survey',
    'Survey to identify existing security culture in an organization.',
    'To complete this Security FORCE Survey, please indicate your level of agreement with each of the following statements regarding information security values and practices within your organization. Choose one response per statement. Please respond to all statements.',
    'Lance Hayden'

    );

-- SCDS Questions

INSERT INTO mappa.likert_questions(survey_id, title)
SELECT 
  (SELECT id from mappa.likert_surveys where name = 'Security FORCE Survey'),
  title 
FROM (values 
  ('Security Value of Failure'),
  ('Security Value of Operations'),
  ('Security Value of Resilience'),
  ('Security Value of Complexity'),
  ('Security Value of Expertise')
) likert_questions_data (title);

-- Each answer for each question

INSERT INTO mappa.likert_answers(question_id, answer)
SELECT 
  (SELECT id from mappa.likert_questions where title = 'Security Value of Failure'),
  answer 
FROM (values 
  ('I feel confident I could predict where the organization’s next security incident will happen.'),
  ('I regularly identify security problems while doing my job.'),
  ('I feel very comfortable reporting security problems up the management chain.'),
  ('I know that security problems I report will be taken seriously.'),
  ('When a security problem is found, it gets fixed.')

) likert_answers_data (answer);



INSERT INTO mappa.likert_answers(question_id, answer)
SELECT 
  (SELECT id from mappa.likert_questions where title = 'Security Value of Operations'),
  answer 
FROM (values 
  ('I know that someone is constantly keeping watch over how secure the organization is.'),
  ('I am confident that information security in the organization actually works the way that people and policies say it does.'),
  ('I feel like there are many experts around the organization willing and able to help me understand how things work.'),
  ('Management and the security team regularly share information about security assessments.'),
  ('Management stays actively involved in security and makes sure appropriate resources are available.')

) likert_answers_data (answer);


INSERT INTO mappa.likert_answers(question_id, answer)
SELECT 
  (SELECT id from mappa.likert_questions where title = 'Security Value of Resilience'),
  answer 
FROM (values 
  ('I feel like people are trained to know more about security than just the minimum level necessary.'),
  ('The organization has reserves of skill and expertise to call on in the event of a security incident or crisis.'),
  ('I feel like everyone in the organization is encouraged to “get out of their comfort zone” and be part of security challenges. '),
  ('I feel like people are interested in what I know about security, and willing to share their own skills to help me as well.'),
  ('The organization often conducts drills and scenarios to test how well we respond to security incidents and failures.')

) likert_answers_data (answer);


INSERT INTO mappa.likert_answers(question_id, answer)
SELECT 
  (SELECT id from mappa.likert_questions where title = 'Security Value of Complexity'),
  answer 
FROM (values 
  ('I feel like people in the organization prefer complex explanations over simple ones.'),
  ('I feel like people are open to being challenged or questioned about how they arrived at an The organization always has plenty of data to explain and justify its decisions.'),
  ('People from outside the security team are encouraged to participate and question security plans and decisions.'),
  ('The organization formally reviews strategies and predictions to make sure they were accurate, and adjusts accordingly.')

) likert_answers_data (answer);


INSERT INTO mappa.likert_answers(question_id, answer)
SELECT 
  (SELECT id from mappa.likert_questions where title = 'Security Value of Expertise'),
  answer 
FROM (values 
  ('I know exactly where to go in the organization when I need an expert.'),
  ('I think everyone in the organization feels that monitoring security is part of their job.'),
  ('In the event of a security incident, people can legitimately bypass the bureaucracy to get things done.'),
  ('People in the organization are encouraged to help other groups if they have the right skills to help them.'),
  ('I feel empowered to take action myself, if something is about to cause a security failure.')
) likert_answers_data (answer);

