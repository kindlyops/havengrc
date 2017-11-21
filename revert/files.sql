-- Revert mappamundi:files from pg

BEGIN;

DROP VIEW "1".file;
DROP TABLE mappa.file CASCADE;

COMMIT;
