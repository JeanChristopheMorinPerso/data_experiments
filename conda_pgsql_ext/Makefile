MODULE_big = condaversion
EXTENSION = condaversion
OBJS = condaversion.o
DATA = \
	condaversion--1.0.sql

TESTS = $(wildcard tests/sql/*.sql) # use tests/sql/*.sql as test files

# find the sql and expected directories under tests
# load base36 extension into test db
# load plpgsql into test db
REGRESS_OPTS = --inputdir=./tests
               # --load-extension=condaversion
REGRESS = $(patsubst tests/sql/%.sql,%,$(TESTS))

PG_CONFIG = /usr/local/pgsql/bin/pg_config
PG_CXXFLAGS = -I./deps/mamba/libmamba/include -I./deps/expected/include
PG_CPPFLAGS = -I./deps/mamba/libmamba/include -I./deps/expected/include
PG_LDFLAGS = -lmamba -lfmt
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
# CXXFLAGS += -fPIC
# LDFLAGS += -lapt-pkg
