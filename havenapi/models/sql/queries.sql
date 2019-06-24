-- queries.sql
-- we use the sql coding style from https://masteringpostgresql.com/

-- name: commentcount
SELECT count(*) FROM mappa.comments;

-- name: insertfile
INSERT INTO mappa.files (name, file) VALUES ($1, $2);

-- name: insertstate
INSERT INTO mappa.states (json) VALUES ($1);

-- name: updatestate
UPDATE mappa.states
SET json = ($1)
WHERE id = current_setting('request.jwt.claim.sub', true)::uuid

-- name: registeruser
INSERT
INTO
    mappa.registration_funnel_1
        (email, ip_address, survey_results)
VALUES
    ($1, $2, $3);

-- name: setemailclaim
SELECT set_config('request.jwt.claim.email', $1, true);

-- name: setsubclaim
SELECT set_config('request.jwt.claim.sub', $1, true);

-- name: setorgclaim
SELECT set_config('request.jwt.claim.org', $1, true);

-- name: setrole
SELECT setrole($1);