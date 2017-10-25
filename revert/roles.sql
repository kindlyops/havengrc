-- Revert mappamundi:roles from pg

BEGIN;

REVOKE member, admin, anonymous FROM postgres;

DROP ROLE anonymous;
DROP ROLE admin;
DROP ROLE member;

COMMIT;
