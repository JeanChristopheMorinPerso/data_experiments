-- Test the hash function
BEGIN;

CREATE EXTENSION conda_pgsql_rust_ext;

SELECT DISTINCT v FROM (VALUES 
    ('1.1.0'::condaversion),
    ('1.01.0'::condaversion),
    ('2.0.4'::condaversion),
    ('1.0.0'::condaversion)
) v(v);

ROLLBACK;
