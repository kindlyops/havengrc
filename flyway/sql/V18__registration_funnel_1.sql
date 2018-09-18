-- for some columns we never let the caller control the contents
CREATE OR REPLACE FUNCTION mappa.override_registration_funnel_columns()
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
  IF NEW.email IS NULL THEN
    RAISE EXCEPTION 'Must provide an email address';
  END IF;
  IF NEW.survey_results IS NULL THEN
    RAISE EXCEPTION 'You must submit survey results';
  END IF;
  IF NEW.ip_address IS NULL THEN
    RAISE EXCEPTION 'Client IP is required';
  END IF;
  IF NEW.registered IS NOT NULL THEN
    RAISE EXCEPTION 'You must not send the registered field';
  ELSE
    NEW.registered = FALSE;
  END IF;

  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TABLE mappa.registration_funnel_1 (
  uuid           UUID        UNIQUE,
  created_at     TIMESTAMPTZ,
  email          NAME,
  ip_address     TEXT,
  survey_results JSONB,
  registered     BOOLEAN
);

CREATE TRIGGER override_registration_funnel_columns BEFORE INSERT ON mappa.registration_funnel_1 FOR EACH ROW EXECUTE PROCEDURE mappa.override_registration_funnel_columns();

CREATE OR REPLACE VIEW "1".registration_funnel_1 as
  SELECT uuid, created_at, email, ip_address, survey_results, registered from mappa.registration_funnel_1;

GRANT INSERT ON "1".registration_funnel_1 to anonymous;
GRANT INSERT ON mappa.registration_funnel_1 to anonymous;