-- Revert mappamundi:dev from pg

BEGIN;
DROP VIEW "1".regulation;
DROP SCHEMA "1";
DROP TABLE mappa.regulation CASCADE;
DROP SCHEMA mappa;

COMMIT;
