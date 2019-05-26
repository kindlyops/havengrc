-- remove put support from files view, only allow reading owned files

CREATE OR REPLACE VIEW "1".files as
  SELECT uuid, user_id, org, created_at, name, file
    FROM mappa.files
    WHERE user_id = current_setting('request.jwt.claim.sub', true)::uuid;

REVOKE insert ON "1".files FROM member;