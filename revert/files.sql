-- Revert mappamundi:files from pg

BEGIN;

DROP VIEW "1".files;
DROP TABLE mappa.files CASCADE;

COMMIT;
