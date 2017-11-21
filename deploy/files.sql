-- Deploy mappamundi:files to pg

BEGIN;

-- for these three columns we never let the caller control the contents
CREATE OR REPLACE FUNCTION mappa.func_override_file_columns()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.uuid IS NOT NULL THEN
    RAISE EXCEPTION 'You must not send uuid field';
  ELSE
    NEW.uuid = uuid_generate_v4();
  END IF;
  IF NEW.created_at IS NOT NULL THEN
    RAISE EXCEPTION 'You must not send created_at field';
  ELSE
    NEW.created_at = now();
  END IF;
  IF NEW.user_id IS NOT NULL THEN
    RAISE EXCEPTION 'You must not send the user_id field';
  ELSE
    NEW.user_id = current_setting('request.jwt.claim.sub', true);
  END IF;

  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TABLE mappa.file (
  uuid        UUID        UNIQUE,
  created_at  TIMESTAMPTZ,
  user_id     UUID,
  file        TEXT
);

CREATE TRIGGER override_file_cols BEFORE INSERT ON mappa.file FOR EACH ROW EXECUTE PROCEDURE mappa.func_override_file_columns();

CREATE OR REPLACE VIEW "1".file as
  SELECT uuid, user_id, created_at, file from mappa.file;

GRANT SELECT, INSERT ON mappa.file to member;
GRANT all ON "1".file to member;


COMMIT;
