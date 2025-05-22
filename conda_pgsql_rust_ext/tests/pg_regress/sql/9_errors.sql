BEGIN;
CREATE EXTENSION conda_pgsql_rust_ext;

SELECT 'asd }{}'::condaversion;

ROLLBACK;
