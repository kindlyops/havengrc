-- Deploy mappamundi:roles to pg

BEGIN;

CREATE ROLE anonymous nologin;
CREATE ROLE admin nologin;
CREATE ROLE member nologin;

GRANT member, admin, anonymous TO postgres;

COMMIT;
