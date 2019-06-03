-- remove support for anonymous insert on registration_funnel_1
REVOKE ALL ON mappa.registration_funnel_1 FROM anonymous;
GRANT INSERT ON mappa.registration_funnel_1 to member;