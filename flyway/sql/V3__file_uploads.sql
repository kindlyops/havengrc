-- Deploy mappamundi:files to pg

-- for these three columns we never let the caller control the contents
CREATE OR REPLACE FUNCTION mappa.func_override_file_columns()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.uuid IS NOT NULL THEN
    RAISE EXCEPTION 'You must not send uuid field';
  ELSE
    NEW.uuid = mappa.uuid_generate_v4();
  END IF;
  IF NEW.created_at IS NOT NULL THEN
    RAISE EXCEPTION 'You must not send created_at field';
  ELSE
    NEW.created_at = now();
  END IF;
  IF NEW.name IS NULL THEN
    RAISE EXCEPTION 'Must specify file name';
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

CREATE TABLE mappa.files (
  uuid        UUID        UNIQUE,
  created_at  TIMESTAMPTZ,
  user_id     UUID,
  name        TEXT,
  org         JSONB,
  file        BYTEA
);

CREATE TRIGGER override_file_cols BEFORE INSERT ON mappa.files FOR EACH ROW EXECUTE PROCEDURE mappa.func_override_file_columns();

CREATE OR REPLACE VIEW "1".files as
  SELECT uuid, user_id, org, created_at, name, file from mappa.files;

GRANT SELECT, INSERT ON mappa.files to member;
GRANT all ON "1".files to member;