-- SCDS Survey

INSERT INTO mappa.ipsative_surveys(name, description, instructions, author) VALUES
  (
    'SCDS_1',
    'Survey to identify existing security culture in an organization.',
    'For each question, assign a total of 10 points, divided among the four statements based on how accurately you think each describes your organization.',
    'Lance Hayden'

    );

-- SCDS Questions

INSERT INTO mappa.ipsative_questions(survey_id, title)
SELECT 
  (SELECT id from mappa.ipsative_surveys where name = 'SCDS_1'),
  title 
FROM (values 
  ('What''s valued most?'),
  ('How does the organization work?'),
  ('What does security mean?'),
  ('How is information managed and controlled?'),
  ('How are operations managed?'),
  ('How is technology managed?'),
  ('How are people managed?'),
  ('How is risk managed?'),
  ('How is accountability achieved?'),
  ('How is performance evaluated?')
) ipsative_questions_data (title);

-- Each answer for each question

INSERT INTO mappa.ipsative_answers(question_id, category, answer)
SELECT 
  (SELECT id from mappa.ipsative_questions where title = 'What''s valued most?'),
  category, answer 
FROM (values 
  ('Process',  'Stability and reliability are valued most by the organization. It is critical that everyone knows the rules and follows them. The organization cannot succeed if people are all doing things different ways without centralized visibility.'),
  ('Compliance',  'Successfully meeting external requirements is valued most by the organization. The organization is under a lot of scrutiny. It cannot succeed if people fail audits or do not live up to the expectations of those watching.'),
  ('Autonomy',  'Adapting quickly and competing aggressively are valued most by the organization. Results are what matters. The organization cannot succeed if bureaucracy and red tape impair people''s ability to be agile.'),
  ('Trust',  'People and a sense of community are valued most by the organization. Everyone is in it together. The organization cannot succeed unless people are given the opportunities and skills to succeed on their own.')

) ipsative_answers_data (category, answer);



INSERT INTO mappa.ipsative_answers(question_id, category, answer)
SELECT 
  (SELECT id from mappa.ipsative_questions where title = 'How does the organization work?'),
  category, answer 
FROM (values 
('Process',  'The organization works on authority, policy, and standard ways of doing things. Organizational charts are formal and important. The organization is designed to ensure control and efficiency.'),
('Compliance',  'The organization works on outside requirements and regular reviews. Audits are a central feature of life. The organization is designed to ensure everyone meets their obligations.'),
('Autonomy',  'The organization works on independent action and giving people decision authority. There''s no one right way to do things. The organization is designed to ensure that the right things get done in the right situations.'),
('Trust',  'The organization works on teamwork and cooperation. It is a community. The organization is designed to ensure everyone is constantly learning, growing, and supporting one another.')

) ipsative_answers_data (category, answer);


INSERT INTO mappa.ipsative_answers(question_id, category, answer)
SELECT 
  (SELECT id from mappa.ipsative_questions where title = 'What does security mean?'),
  category, answer 
FROM (values 
('Process',  'Security means policies, procedures, and standards, automated wherever possible using technology. When people talk about security they are talking about the infrastructures in place to protect the organization''s information assets.'),
('Compliance',  'Security means showing evidence of visibility and control, particularly to external parties. When people talk about security they are talking about passing an audit or meeting a regulatory requirement.'),
('Autonomy',  'Security means enabling the organization to adapt and compete, not hindering it or saying “no” to everything. When people talk about security they are talking about balancing risks and rewards.'),
('Trust',  'Security means awareness and shared responsibility. When people talk about security they are talking about the need for everyone to be an active participant in protecting the organization.')

) ipsative_answers_data (category, answer);


INSERT INTO mappa.ipsative_answers(question_id, category, answer)
SELECT 
  (SELECT id from mappa.ipsative_questions where title = 'How is information managed and controlled?'),
  category, answer 
FROM (values 
('Process',  'Information is seen as a direct source of business value, accounted for, managed, and controlled like any other business asset. Formal rules and policies govern information use and control.'),
('Compliance',  'Information is seen as a sensitive and protected resource, entrusted to the organization by others and subject to review and audit. Information use and control must always be documented and verified.'),
('Autonomy',  'Information is seen as a flexible tool that is the key to agility and adaptability in the organization''s environment. Information must be available where and when it is needed by the business, with a minimum of restrictive control.'),
('Trust',  'Information is seen as key to people''s productivity, collaboration, and success. Information must be a shared resource, minimally restricted, and available throughout the community to empower people and make them more successful.')

) ipsative_answers_data (category, answer);


INSERT INTO mappa.ipsative_answers(question_id, category, answer)
SELECT 
  (SELECT id from mappa.ipsative_questions where title = 'How are operations managed?'),
  category, answer 
FROM (values 
('Process',  'Operations are controlled and predictable, managed according to the same standards throughout the organization.'),
('Compliance',  'Operations are visible and verifiable, managed and documented in order to support audits and outside reviews.'),
('Autonomy',  'Operations are agile and adaptable, managed with minimal bureaucracy and capable of fast adaptation and flexible execution to respond to changes in the environment.'),
('Trust',  'Operations are inclusive and supportive, allowing people to master new skills and responsibilities and to grow within the organization.')

) ipsative_answers_data (category, answer);


INSERT INTO mappa.ipsative_answers(question_id, category, answer)
SELECT 
  (SELECT id from mappa.ipsative_questions where title = 'How is technology managed?'),
  category, answer 
FROM (values 
('Process',  'Technology is centrally managed. Standards and formal policies exist to ensure uniform performance internally.'),
('Compliance',  'Technology is regularly reviewed. Audits and evaluations exist to ensure the organization meets its obligations to others.'),
('Autonomy',  'Technology is locally managed. Freedom exists to ensure innovation, adaptation, and results.'),
('Trust',  'Technology is accessible to everyone. Training and support exists to empower users and maximize productivity.')

) ipsative_answers_data (category, answer);


INSERT INTO mappa.ipsative_answers(question_id, category, answer)
SELECT 
  (SELECT id from mappa.ipsative_questions where title = 'How are people managed?'),
  category, answer 
FROM (values 
('Process',  'People must conform to the needs of the organization. They must adhere to policies and standards of behavior. The success of the organization is built on everyone following the rules.'),
('Compliance',  'People must demonstrate that they are doing things correctly. They must ensure the organization meets its obligations. The success of the organization is built on everyone regularly proving that they are doing things properly.'),
('Autonomy',  'People must take risks and make quick decisions. They must not wait for someone else to tell them what''s best. The success of the organization is built on everyone experimenting and innovating in the face of change.'),
('Trust',  'People must work as a team and support one other. They must know that everyone is doing their part. The success of the organization is built on everyone learning and growing together.')

) ipsative_answers_data (category, answer);


INSERT INTO mappa.ipsative_answers(question_id, category, answer)
SELECT 
  (SELECT id from mappa.ipsative_questions where title = 'How is risk managed?'),
  category, answer 
FROM (values 
('Process',  'Risk is best managed by getting rid of deviations in the way things are done. Increased visibility and control reduce uncertainty and negative outcomes. The point is to create a reliable standard.'),
('Compliance',  'Risk is best managed by documentation and regular review. Frameworks and evaluations reduce uncertainty and negative outcomes. The point is to keep everyone on their toes.'),
('Autonomy',  'Risk is best managed by decentralizing authority. Negative outcomes are always balanced by potential opportunities. The point is to let those closest to the decision make the call.'),
('Trust',  'Risk is best managed by sharing information and knowledge. Education and support reduce uncertainty and negative outcomes. The point is to foster a sense of shared responsibility.')

) ipsative_answers_data (category, answer);


INSERT INTO mappa.ipsative_answers(question_id, category, answer)
SELECT 
  (SELECT id from mappa.ipsative_questions where title = 'How is accountability achieved?'),
  category, answer 
FROM (values 
('Process',  'Accountability is stable and formalized. People know what to expect and what is expected of them. The same rewards and consequences are found throughout the organization.'),
('Compliance',  'Accountability is enabled through review and audit. People know that they will be asked to justify their actions. Rewards and consequences are contingent upon external expectations and judgments.'),
('Autonomy',  'Accountability is results-driven. People know there are no excuses for failing. Rewards and consequences are a product of successful execution on the organization''s business.'),
('Trust',  'Accountability is shared among the group. People know there are no rock stars or scapegoats. Rewards and consequences apply to everyone because everyone is a stakeholder in the organization.')

) ipsative_answers_data (category, answer);


INSERT INTO mappa.ipsative_answers(question_id, category, answer)
SELECT 
  (SELECT id from mappa.ipsative_questions where title = 'How is performance evaluated?'),
  category, answer 
FROM (values 
('Process',  'Performance is evaluated against formal strategies and goals. Success criteria are unambiguous.'),
('Compliance',  'Performance is evaluated against the organization''s ability to meet external requirements. Audits define success.'),
('Autonomy',  'Performance is evaluated on the basis of specific decisions and outcomes. Business success is the primary criteria.'),
('Trust',  'Performance is evaluated by the organizational community. Success is defined through shared values, commitment, and mutual respect.')

) ipsative_answers_data (category, answer);