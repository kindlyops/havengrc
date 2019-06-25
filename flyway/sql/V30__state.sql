
CREATE OR REPLACE FUNCTION mappa.func_override_state_columns()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.id IS NOT NULL THEN
    RAISE EXCEPTION 'You must not send id field';
  ELSE
    NEW.id = current_setting('request.jwt.claim.sub', true);
  END IF;
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TABLE mappa.states (
  id        UUID        UNIQUE,
  json      JSONB
);

CREATE TRIGGER override_state_cols BEFORE INSERT ON mappa.states FOR EACH ROW EXECUTE PROCEDURE mappa.func_override_state_columns();

GRANT SELECT, INSERT, UPDATE ON mappa.states to member;
