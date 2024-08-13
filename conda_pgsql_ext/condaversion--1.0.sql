CREATE TYPE condaversion;

CREATE OR REPLACE FUNCTION condaversion_in(cstring)
  RETURNS condaversion
  AS 'condaversion'
  LANGUAGE C
  IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION condaversion_out(condaversion)
  RETURNS cstring
  AS 'condaversion'
  LANGUAGE C
  IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION condaversion_recv(internal)
  RETURNS condaversion
  AS 'textrecv'
  LANGUAGE internal
  STABLE STRICT;

CREATE OR REPLACE FUNCTION condaversion_send(condaversion)
  RETURNS bytea
  AS 'textsend'
  LANGUAGE internal
  STABLE STRICT;

CREATE TYPE condaversion (
    LIKE           = text,
    INPUT          = condaversion_in,
    OUTPUT         = condaversion_out,
    RECEIVE        = condaversion_recv,
    SEND           = condaversion_send,
    INTERNALLENGTH = VARIABLE,
    -- make it a non-preferred member of string type category
    CATEGORY       = 'S',
    PREFERRED      = false
);

COMMENT ON TYPE condaversion IS 'Conda package version number';

-- CREATE OR REPLACE FUNCTION condaversion(bpchar)
--   RETURNS condaversion
--   AS 'rtrim1'
--   LANGUAGE internal
--   IMMUTABLE STRICT;

-- TODO: Probably needs a custom function for version -> text and varchar?
CREATE CAST (condaversion AS text)    WITH INOUT AS IMPLICIT;
CREATE CAST (condaversion AS varchar) WITH INOUT AS IMPLICIT;
-- bpchar is blank trimmed.
CREATE CAST (condaversion AS bpchar)  WITHOUT FUNCTION AS ASSIGNMENT;
CREATE CAST (text AS condaversion)    WITHOUT FUNCTION AS ASSIGNMENT;
CREATE CAST (varchar AS condaversion) WITHOUT FUNCTION AS ASSIGNMENT;
-- CREATE CAST (bpchar AS condaversion)  WITH FUNCTION condaversion(bpchar);

CREATE OR REPLACE FUNCTION condaversion_cmp (version1 condaversion,
       	  	  	   		   version2 condaversion)
  RETURNS integer AS 'condaversion'
  LANGUAGE C
  IMMUTABLE STRICT;
COMMENT ON FUNCTION condaversion_cmp (condaversion, condaversion)
  IS 'Compare Conda versions';

CREATE OR REPLACE FUNCTION condaversion_eq (version1 condaversion,
       	  	  	   		  version2 condaversion)
  RETURNS boolean AS 'condaversion'
  LANGUAGE C
  IMMUTABLE STRICT;
COMMENT ON FUNCTION condaversion_eq (condaversion, condaversion)
  IS 'condaversion equal';

CREATE OR REPLACE FUNCTION condaversion_ne (version1 condaversion,
       	  	  	   		  version2 condaversion)
  RETURNS boolean AS 'condaversion'
  LANGUAGE C
  IMMUTABLE STRICT;
COMMENT ON FUNCTION condaversion_ne (condaversion, condaversion)
  IS 'condaversion not equal';

CREATE OR REPLACE FUNCTION condaversion_lt (version1 condaversion,
       	  	  	   		  version2 condaversion)
  RETURNS boolean AS 'condaversion'
  LANGUAGE C
  IMMUTABLE STRICT;
COMMENT ON FUNCTION condaversion_lt (condaversion, condaversion)
  IS 'condaversion less-than';

CREATE OR REPLACE FUNCTION condaversion_gt (version1 condaversion,
       	  	  	   		  version2 condaversion)
  RETURNS boolean AS 'condaversion'
  LANGUAGE C
  IMMUTABLE STRICT;
COMMENT ON FUNCTION condaversion_gt (condaversion, condaversion)
  IS 'condaversion greater-than';

CREATE OR REPLACE FUNCTION condaversion_le (version1 condaversion,
       	  	  	   		  version2 condaversion)
  RETURNS boolean AS 'condaversion'
  LANGUAGE C
  IMMUTABLE STRICT;
COMMENT ON FUNCTION condaversion_le (condaversion, condaversion)
  IS 'condaversion less-than-or-equal';

CREATE OR REPLACE FUNCTION condaversion_ge (version1 condaversion,
       	  	  	   		  version2 condaversion)
  RETURNS boolean AS 'condaversion'
  LANGUAGE C
  IMMUTABLE STRICT;
COMMENT ON FUNCTION condaversion_ge (condaversion, condaversion)
  IS 'condaversion greater-than-or-equal';

CREATE OPERATOR = (
  PROCEDURE = condaversion_eq,
  LEFTARG = condaversion,
  RIGHTARG = condaversion,
  COMMUTATOR = =,
  NEGATOR = !=,
  RESTRICT = eqsel,
  JOIN = eqjoinsel
);
COMMENT ON OPERATOR = (condaversion, condaversion)
  IS 'condaversion equal';

CREATE OPERATOR != (
  PROCEDURE = condaversion_ne,
  LEFTARG = condaversion,
  RIGHTARG = condaversion,
  COMMUTATOR = !=,
  NEGATOR = =,
  RESTRICT = neqsel,
  JOIN = neqjoinsel
);
COMMENT ON OPERATOR != (condaversion, condaversion)
  IS 'condaversion not equal';

CREATE OPERATOR < (
  PROCEDURE = condaversion_lt,
  LEFTARG = condaversion,
  RIGHTARG = condaversion,
  COMMUTATOR = >,
  NEGATOR = >=,
  RESTRICT = scalarltsel,
  JOIN = scalarltjoinsel
);
COMMENT ON OPERATOR < (condaversion, condaversion)
  IS 'condaversion less-than';

CREATE OPERATOR > (
  PROCEDURE = condaversion_gt,
  LEFTARG = condaversion,
  RIGHTARG = condaversion,
  COMMUTATOR = <,
  NEGATOR = >=,
  RESTRICT = scalargtsel,
  JOIN = scalargtjoinsel
);
COMMENT ON OPERATOR > (condaversion, condaversion)
  IS 'condaversion greater-than';

CREATE OPERATOR <= (
  PROCEDURE = condaversion_le,
  LEFTARG = condaversion,
  RIGHTARG = condaversion,
  COMMUTATOR = >=,
  NEGATOR = >,
  RESTRICT = scalarltsel,
  JOIN = scalarltjoinsel
);
COMMENT ON OPERATOR <= (condaversion, condaversion)
  IS 'condaversion less-than-or-equal';

CREATE OPERATOR >= (
  PROCEDURE = condaversion_ge,
  LEFTARG = condaversion,
  RIGHTARG = condaversion,
  COMMUTATOR = <=,
  NEGATOR = <,
  RESTRICT = scalargtsel,
  JOIN = scalargtjoinsel
);
COMMENT ON OPERATOR >= (condaversion, condaversion)
  IS 'condaversion greater-than-or-equal';

CREATE OPERATOR CLASS condaversion_ops
DEFAULT FOR TYPE condaversion USING btree AS
  OPERATOR 1 <  (condaversion, condaversion),
  OPERATOR 2 <= (condaversion, condaversion),
  OPERATOR 3 =  (condaversion, condaversion),
  OPERATOR 4 >= (condaversion, condaversion),
  OPERATOR 5 >  (condaversion, condaversion),
  FUNCTION 1 condaversion_cmp(condaversion, condaversion);

CREATE OR REPLACE FUNCTION condaversion_hash(condaversion)
  RETURNS int4
  AS 'condaversion'
  LANGUAGE C
  IMMUTABLE STRICT;

CREATE OPERATOR CLASS condaversion_ops
DEFAULT FOR TYPE condaversion USING hash AS
  OPERATOR 1 = (condaversion, condaversion),
  FUNCTION 1 condaversion_hash(condaversion);

-- CREATE OR REPLACE FUNCTION condaversion_smaller(version1 condaversion,
-- 					      version2 condaversion)
--   RETURNS condaversion
--   AS 'condaversion'
--   LANGUAGE C
--   IMMUTABLE STRICT;

-- CREATE OR REPLACE FUNCTION condaversion_larger(version1 condaversion,
-- 					     version2 condaversion)
--   RETURNS condaversion
--   AS 'condaversion'
--   LANGUAGE C
--   IMMUTABLE STRICT;

-- CREATE AGGREGATE min(condaversion)  (
--   SFUNC = condaversion_smaller,
--   STYPE = condaversion,
--   SORTOP = <
-- );

-- CREATE AGGREGATE max(condaversion)  (
--   SFUNC = condaversion_larger,
--   STYPE = condaversion,
--   SORTOP = >
-- );
