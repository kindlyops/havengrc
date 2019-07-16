ALTER TABLE mappa.comments
RENAME COLUMN uuid TO id;

DROP VIEW "1".comments;

CREATE OR REPLACE VIEW "1".comments as
  SELECT id, user_id, org, created_at, user_email, message
    FROM mappa.comments
    WHERE user_id = current_setting('request.jwt.claim.sub', true)::uuid;

GRANT SELECT ON "1".comments to member;

-- for these three columns we never let the caller control the contents
CREATE OR REPLACE FUNCTION mappa.override_server_columns()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.id IS NOT NULL THEN
    NEW.id = mappa.uuid_generate_v4();
  ELSE
    NEW.id = mappa.uuid_generate_v4();
  END IF;
  IF NEW.created_at IS NOT NULL THEN
    RAISE EXCEPTION 'You must not send created_at field';
  ELSE
    NEW.created_at = now();
  END IF;
  IF NEW.user_email IS NOT NULL THEN
    RAISE EXCEPTION 'You must not send the user_email field';
  ELSE
    NEW.user_email = current_setting('request.jwt.claim.email', true);
  END IF;
  IF NEW.user_id IS NOT NULL THEN
    RAISE EXCEPTION 'You must not send the user_id field';
  ELSE
    NEW.user_id = current_setting('request.jwt.claim.sub', true)::uuid;
  END IF;
  IF NEW.org IS NOT NULL THEN
    RAISE EXCEPTION 'You must not send the org field';
  ELSE
    NEW.org = current_setting('request.jwt.claim.org', true);
  END IF;

  RETURN NEW;
END;
$$ language 'plpgsql';