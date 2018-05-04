-- Deploy mappamundi:roles to pg

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'anonymous') THEN
        CREATE ROLE anonymous;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'member') THEN
        CREATE ROLE member;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'admin') THEN
        CREATE ROLE admin;
    END IF;
END
$$;

GRANT member, admin, anonymous TO ${databaseUser};


-- the schema "1" is our versioned public API
-- the schema mappa is private
-- grants are done to the private schema "mappa" because
-- the view needs to read from that schema with the role
-- of the authenticated caller


GRANT usage ON schema mappa to member;
GRANT usage ON schema "1" to member;
