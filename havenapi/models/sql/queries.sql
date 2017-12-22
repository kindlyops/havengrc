-- queries.sql
-- we use the sql coding style from https://masteringpostgresql.com/

-- name: commentcount
select count(*)
  from mappa.comments;

-- name: insertfile
insert into mappa.files (name, file) values($1, $2);

-- name: setemailclaim
set local request.jwt.claim.email to $1;

-- name: setsubclaim
set local request.jwt.claim.sub to $1;