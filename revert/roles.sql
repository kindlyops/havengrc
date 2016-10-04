-- Revert mappamundi:roles from pg

BEGIN;

REVOKE member, admin, superadmin, anonymous FROM authenticator;

DROP USER authenticator;
DROP ROLE anonymous;
DROP ROLE admin;
DROP ROLE superadmin;
DROP ROLE member;

COMMIT;
