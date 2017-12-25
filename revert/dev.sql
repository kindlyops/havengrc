-- Revert mappamundi:dev from pg

BEGIN;
DROP VIEW "1".comments;
DROP SCHEMA "1";
DROP TABLE mappa.comments CASCADE;
DROP SCHEMA mappa CASCADE;

COMMIT;
