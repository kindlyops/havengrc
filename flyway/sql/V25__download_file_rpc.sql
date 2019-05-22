CREATE OR REPLACE FUNCTION "1".download_file(fileid uuid)
RETURNS bytea AS $$
DECLARE
    _header text;
BEGIN
    _header := '[{"Content-Disposition": "attachment; filename=\"' ||
            (SELECT name
                FROM "1".files
            WHERE  user_id = current_setting('request.jwt.claim.sub', true)::uuid
            AND uuid = fileid) || '\""}]';
    -- RAISE EXCEPTION 'header is (%)', _header USING HINT = 'is it json?';
    PERFORM set_config('response.headers',
        _header, true);
    RETURN (SELECT file
    FROM "1".files
        WHERE user_id = current_setting('request.jwt.claim.sub', true)::uuid 
        AND uuid = fileid);
END; 
$$ language plpgsql VOLATILE STRICT;

REVOKE ALL PRIVILEGES ON FUNCTION "1".download_file(fileid uuid) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION "1".download_file(fileid uuid) TO member;