-- Revert mappamundi:dev from pg

BEGIN;
DROP VIEW "1".comment;
DROP SCHEMA "1";
DROP TABLE mappa.comment CASCADE;
DROP SCHEMA mappa;

COMMIT;
