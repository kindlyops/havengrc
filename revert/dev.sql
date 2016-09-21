-- Revert mappamundi:dev from pg

BEGIN;

DROP TABLE mappa.regulation CASCADE;
DROP VIEW "1".regulation;
DROP SCHEMA "1";
DROP SCHEMA mappa;

COMMIT;
