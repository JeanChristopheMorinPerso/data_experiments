BEGIN;
CREATE EXTENSION conda_pgsql_rust_ext;

SELECT NULL::condaversion;

ROLLBACK;
