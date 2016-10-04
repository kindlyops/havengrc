-- Deploy mappamundi:roles to pg

BEGIN;

CREATE USER authenticator NOINHERIT;
CREATE ROLE anonymous;
CREATE ROLE admin;
CREATE ROLE superadmin;
CREATE ROLE member;

GRANT member, admin, superadmin, anonymous TO authenticator;

COMMIT;
