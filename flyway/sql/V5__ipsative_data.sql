-- SCDS Survey

INSERT INTO mappa.ipsative_surveys(name, description, instructions, author) VALUES
  (
    'SCDS_1',
    'Survey to identify existing security culture in an organization.',
    'For each question, assign a total of 10 points, divided among the four statements based on how accurately you think each describes your organization.',
    'Lance Hayden'
    );

-- SCDS Questions

INSERT INTO mappa.ipsative_questions(survey_id, order_number, title)
SELECT 
  (SELECT uuid from mappa.ipsative_surveys where name = 'SCDS_1'),
  order_number,
  title 
FROM (values 
  (1, 'What''s valued most?'),
  (2, 'How does the organization work?'),
  (3, 'What does security mean?'),
  (4, 'How is information managed and controlled?'),
  (5, 'How are operations managed?'),
  (6, 'How is technology managed?'),
  (7, 'How are people managed?'),
  (8, 'How is risk managed?'),
  (9, 'How is accountability achieved?'),
  (10, 'How is performance evaluated?')
) ipsative_questions_data (order_number,title);


-- SCDS Categories

INSERT INTO mappa.ipsative_categories(category) VALUES 
  ('Process'),
  ('Compliance'),
  ('Autonomy'),
  ('Trust');


-- Each answer for each question

INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'What''s valued most?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Process'),
  1,
  'Stability and reliability are valued most by the organization. It is critical that everyone knows the rules and follows them. The organization cannot succeed if people are all doing things different ways without centralized visibility.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'What''s valued most?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Compliance'),
  2,
  'Successfully meeting external requirements is valued most by the organization. The organization is under a lot of scrutiny. It cannot succeed if people fail audits or do not live up to the expectations of those watching.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'What''s valued most?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Autonomy'),
  3,
  'Adapting quickly and competing aggressively are valued most by the organization. Results are what matters. The organization cannot succeed if bureaucracy and red tape impair people''s ability to be agile.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'What''s valued most?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Trust'),
  4,
  'People and a sense of community are valued most by the organization. Everyone is in it together. The organization cannot succeed unless people are given the opportunities and skills to succeed on their own.'
;  



INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How does the organization work?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Process'),
  1,
  'The organization works on authority, policy, and standard ways of doing things. Organizational charts are formal and important. The organization is designed to ensure control and efficiency.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How does the organization work?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Compliance'),
  2,
  'The organization works on outside requirements and regular reviews. Audits are a central feature of life. The organization is designed to ensure everyone meets their obligations.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How does the organization work?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Autonomy'),
  3,
  'The organization works on independent action and giving people decision authority. There''s no one right way to do things. The organization is designed to ensure that the right things get done in the right situations.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How does the organization work?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Trust'),
  4,
  'The organization works on teamwork and cooperation. It is a community. The organization is designed to ensure everyone is constantly learning, growing, and supporting one another.'
;  




INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'What does security mean?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Process'),
  1,
  'Security means policies, procedures, and standards, automated wherever possible using technology. When people talk about security they are talking about the infrastructures in place to protect the organization''s information assets.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'What does security mean?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Compliance'),
  2,
  'Security means showing evidence of visibility and control, particularly to external parties. When people talk about security they are talking about passing an audit or meeting a regulatory requirement.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'What does security mean?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Autonomy'),
  3,
  'Security means enabling the organization to adapt and compete, not hindering it or saying “no” to everything. When people talk about security they are talking about balancing risks and rewards.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'What does security mean?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Trust'),
  4,
  'Security means awareness and shared responsibility. When people talk about security they are talking about the need for everyone to be an active participant in protecting the organization.'
;  






INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How is information managed and controlled?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Process'),
  1,
  'Information is seen as a direct source of business value, accounted for, managed, and controlled like any other business asset. Formal rules and policies govern information use and control.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How is information managed and controlled?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Compliance'),
  2,
  'Information is seen as a sensitive and protected resource, entrusted to the organization by others and subject to review and audit. Information use and control must always be documented and verified.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How is information managed and controlled?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Autonomy'),
  3,
  'Information is seen as a flexible tool that is the key to agility and adaptability in the organization''s environment. Information must be available where and when it is needed by the business, with a minimum of restrictive control.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How is information managed and controlled?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Trust'),
  4,
  'Information is seen as key to people''s productivity, collaboration, and success. Information must be a shared resource, minimally restricted, and available throughout the community to empower people and make them more successful.'
;  




INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How are operations managed?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Process'),
  1,
  'Operations are controlled and predictable, managed according to the same standards throughout the organization.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How are operations managed?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Compliance'),
  2,
  'Operations are visible and verifiable, managed and documented in order to support audits and outside reviews.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How are operations managed?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Autonomy'),
  3,
  'Operations are agile and adaptable, managed with minimal bureaucracy and capable of fast adaptation and flexible execution to respond to changes in the environment.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How are operations managed?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Trust'),
  4,
  'Operations are inclusive and supportive, allowing people to master new skills and responsibilities and to grow within the organization.'
;  



INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How is technology managed?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Process'),
  1,
  'Technology is centrally managed. Standards and formal policies exist to ensure uniform performance internally.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How is technology managed?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Compliance'),
  2,
  'Technology is regularly reviewed. Audits and evaluations exist to ensure the organization meets its obligations to others.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How is technology managed?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Autonomy'),
  3,
  'Technology is locally managed. Freedom exists to ensure innovation, adaptation, and results.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How is technology managed?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Trust'),
  4,
  'Technology is accessible to everyone. Training and support exists to empower users and maximize productivity.'
;  





INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How are people managed?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Process'),
  1,
  'People must conform to the needs of the organization. They must adhere to policies and standards of behavior. The success of the organization is built on everyone following the rules.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How are people managed?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Compliance'),
  2,
  'People must demonstrate that they are doing things correctly. They must ensure the organization meets its obligations. The success of the organization is built on everyone regularly proving that they are doing things properly.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How are people managed?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Autonomy'),
  3,
  'People must take risks and make quick decisions. They must not wait for someone else to tell them what''s best. The success of the organization is built on everyone experimenting and innovating in the face of change.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How are people managed?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Trust'),
  4,
  'People must work as a team and support one other. They must know that everyone is doing their part. The success of the organization is built on everyone learning and growing together.'
;  




INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How is risk managed?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Process'),
  1,
  'Risk is best managed by getting rid of deviations in the way things are done. Increased visibility and control reduce uncertainty and negative outcomes. The point is to create a reliable standard.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How is risk managed?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Compliance'),
  2,
  'Risk is best managed by documentation and regular review. Frameworks and evaluations reduce uncertainty and negative outcomes. The point is to keep everyone on their toes.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How is risk managed?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Autonomy'),
  3,
  'Risk is best managed by decentralizing authority. Negative outcomes are always balanced by potential opportunities. The point is to let those closest to the decision make the call.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How is risk managed?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Trust'),
  4,
  'Risk is best managed by sharing information and knowledge. Education and support reduce uncertainty and negative outcomes. The point is to foster a sense of shared responsibility.'
;  




INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How is accountability achieved?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Process'),
  1,
  'Accountability is stable and formalized. People know what to expect and what is expected of them. The same rewards and consequences are found throughout the organization.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How is accountability achieved?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Compliance'),
  2,
  'Accountability is enabled through review and audit. People know that they will be asked to justify their actions. Rewards and consequences are contingent upon external expectations and judgments.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How is accountability achieved?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Autonomy'),
  3,
  'Accountability is results-driven. People know there are no excuses for failing. Rewards and consequences are a product of successful execution on the organization''s business.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How is accountability achieved?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Trust'),
  4,
  'Accountability is shared among the group. People know there are no rock stars or scapegoats. Rewards and consequences apply to everyone because everyone is a stakeholder in the organization.'
;  


INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How is performance evaluated?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Process'),
  1,
  'Performance is evaluated against formal strategies and goals. Success criteria are unambiguous.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How is performance evaluated?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Compliance'),
  2,
  'Performance is evaluated against the organization''s ability to meet external requirements. Audits define success.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How is performance evaluated?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Autonomy'),
  3,
  'Performance is evaluated on the basis of specific decisions and outcomes. Business success is the primary criteria.'
;  
INSERT INTO mappa.ipsative_answers(question_id, category_id, order_number, answer)
SELECT 
  (SELECT uuid from mappa.ipsative_questions where title = 'How is performance evaluated?'),
  (SELECT uuid from mappa.ipsative_categories where category = 'Trust'),
  4,
  'Performance is evaluated by the organizational community. Success is defined through shared values, commitment, and mutual respect.'
;  