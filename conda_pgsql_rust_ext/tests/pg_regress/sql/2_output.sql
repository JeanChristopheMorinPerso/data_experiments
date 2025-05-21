-- Test the output function
BEGIN;

CREATE EXTENSION conda_pgsql_rust_ext;

SELECT '1.2.3'::condaversion::text;

ROLLBACK;
