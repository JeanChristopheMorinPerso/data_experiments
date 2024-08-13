CREATE EXTENSION condaversion;
SELECT '1.0.0'::condaversion = '1.0.0'::condaversion;

-- Just to prove that we are not comparing strings. This will be true.
SELECT '1.0'::condaversion = '1.0.0'::condaversion;

SELECT '1.2.3'::condaversion > '4.5'::condaversion;
SELECT '4.5'::condaversion > '4.5'::condaversion;
SELECT '6.7'::condaversion > '4.5'::condaversion;

SELECT '1.2.3'::condaversion >= '4.5'::condaversion;
SELECT '4.5'::condaversion >= '4.5'::condaversion;
SELECT '6.7'::condaversion >= '4.5'::condaversion;

SELECT '1.2.3'::condaversion < '4.5'::condaversion;
SELECT '4.5'::condaversion < '4.5'::condaversion;
SELECT '6.7'::condaversion < '4.5'::condaversion;

SELECT '1.2.3'::condaversion <= '4.5'::condaversion;
SELECT '4.5'::condaversion <= '4.5'::condaversion;
SELECT '6.7'::condaversion <= '4.5'::condaversion;

SELECT '1.2.3'::condaversion != '4.5'::condaversion;
SELECT '4.5'::condaversion != '4.5'::condaversion;
SELECT '6.7'::condaversion != '4.5'::condaversion;

SELECT '1.2.3'::condaversion = '4.5'::condaversion;
SELECT '4.5'::condaversion = '4.5'::condaversion;
SELECT '6.7'::condaversion = '4.5'::condaversion;
