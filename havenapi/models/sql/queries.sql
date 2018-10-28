-- queries.sql
-- we use the sql coding style from https://masteringpostgresql.com/

-- name: commentcount
select count(*)
  from mappa.comments;

-- name: insertfile
insert into mappa.files (name, file) values($1, $2);

-- name: registeruser
insert into mappa.registration_funnel_1 (email, ip_address, survey_results) values($1, $2, $3);

-- name: setemailclaim
select set_config('request.jwt.claim.email', $1, true);

-- name: setsubclaim
select set_config('request.jwt.claim.sub', $1, true);

-- name: setorgclaim
select set_config('request.jwt.claim.org', $1, true);

-- name: setrole
select setrole($1);
