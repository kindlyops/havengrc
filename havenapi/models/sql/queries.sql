-- queries.sql
-- we use the sql coding style from https://masteringpostgresql.com/

-- name: commentcount
select count(*)
  from mappa.comment;

-- name: insertfile
insert into mappa.files (name, file) values($1, $2);
