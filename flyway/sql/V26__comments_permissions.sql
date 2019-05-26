-- callers can only read their own comments

CREATE OR REPLACE VIEW "1".comments as
  SELECT uuid, user_email, user_id, org, created_at, message
    FROM mappa.comments
    WHERE user_id = current_setting('request.jwt.claim.sub', true)::uuid;
