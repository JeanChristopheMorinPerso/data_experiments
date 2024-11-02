
This folder contains a PostgreSQL extention that adds a new type `condaversion`.

# Setup development environment
```bash
adduser postgres --disabled-password
mkdir -p /usr/local/pgsql/data
chown -R postgres /usr/local/pgsql/data

export PATH=/usr/local/pgsql/bin:$PATH
sudo -u postgres /usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data
sudo -u postgres /usr/local/pgsql/bin/pg_ctl -D /usr/local/pgsql/data -l /usr/local/pgsql/data/postmaster.log start

sudo -u postgres /usr/local/pgsql/bin/createuser --createdb root

touch regression.out regression.diffs && chown postgres regression.out regression.diffs && chmod 777 regression.out regression.diffs && mkdir -p results && chmod -R 777 results && chown -R postgres results

sudo -u postgres /usr/local/pgsql/bin/createdb test
make CFLAGS="-O0 -g" CXXFLAGS="-O0 -g" && make install && sudo -u postgres make installcheck
```

# How to debug

1. Start a psql session with `sudo -u postgres /usr/local/pgsql/bin/psql test` and run `SELECT pg_backend_pid();`.
   This will allow to get the PID of the process to attach to from GDB.
1. From psql, run `CREATE EXTENSION condaversion;`
1. `export DEBUGINFOD_URLS="https://debuginfod.ubuntu.com"`
1. `set debuginfod enabled on`
1. Then attach to the process with `gdb -p <PID>`

In GDB, you can also run `set filename-display absolute` to get absolute paths.

# References

Inspirations:
* https://github.com/openhive-network/haf/blob/2a174a94624691703a30eee1d22441764ad8519e/src/hive_fork_manager/shared_lib/from_jsonb.cpp
* https://salsa.debian.org/postgresql/postgresql-debversion

Debug information:
* https://wiki.postgresql.org/wiki/Getting_a_stack_trace_of_a_running_PostgreSQL_backend_on_Linux/BSD
* https://wiki.postgresql.org/wiki/Developer_FAQ#gdb
* https://big-elephants.com/2015-10/writing-postgres-extensions-part-iii/

Other:
* https://github.com/dvarrazzo/jsonb_parser/blob/78128f3094e976a55adb04c9fe287b7ac2045e60/pg_ubjson/ubjson.c

