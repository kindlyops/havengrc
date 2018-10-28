CREATE OR REPLACE FUNCTION setrole(role text)
RETURNS void AS $$
BEGIN 
    EXECUTE format('SET ROLE %I', role); 
END; 
$$ language plpgsql;
