-- queries.sql
-- we use the sql coding style from https://masteringpostgresql.com/

-- name: commentcount
select count(*)
  from mappa.comments;

-- name: insertfile
insert into mappa.files (name, file) values($1, $2);

-- name: setemailclaim
select set_config('request.jwt.claim.email', quote_literal($1), true);

-- name: setsubclaim
select set_config('request.jwt.claim.sub', quote_literal($1), true);
