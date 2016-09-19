-- Revert mappamundi:appschema from pg

BEGIN;

DROP SCHEMA mappa;

COMMIT;
