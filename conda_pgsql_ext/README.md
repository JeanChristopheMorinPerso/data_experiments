https://salsa.debian.org/postgresql/postgresql-debversion

<!-- apt install sudo postgresql-16 postgresql-server-dev-16 make g++ -->
mkdir -p /usr/local/pgsql/data
chown -R postgres /usr/local/pgsql/data

export PATH=/usr/local/pgsql/bin:$PATH
sudo -u postgres /usr/local/pgsql/bin/pg_ctl -D /usr/local/pgsql/data -l /usr/local/pgsql/data/postmaster.log start

sudo -u postgres /usr/local/pgsql/bin/createuser --createdb root

touch regression.out regression.diffs && chown postgres regression.out regression.diffs && chmod 777 regression.out regression.diffs && mkdir -p results && chmod -R 777 results && chown -R postgres results

make CFLAGS=-O0 && make install && sudo -u postgres make installcheck



#  1 means that ver1 > ver2
# -1 means that ver1 < ver2
#  0 means that ver1 = ver2


# Debug

https://wiki.postgresql.org/wiki/Getting_a_stack_trace_of_a_running_PostgreSQL_backend_on_Linux/BSD
https://wiki.postgresql.org/wiki/Developer_FAQ#gdb
https://big-elephants.com/2015-10/writing-postgres-extensions-part-iii/

/usr/lib/postgresql/16/bin/createdb test

then start a psql session with `sudo -u postgres psql test` and run `SELECT pg_backend_pid();`

export DEBUGINFOD_URLS="https://debuginfod.ubuntu.com"
set debuginfod enabled on

then attach to the process

```
handle SIGUSR1 noprint pass
b errordata[errordata_stack_depth].elevel >= 20
```


In the sql session:
```
select pg_backend_pid();
CREATE EXTENSION condaversion;
SET client_min_messages = warning; -- suppress "pkey created" message
CREATE TABLE versions (
  ver condaversion
    CONSTRAINT versions_pkey PRIMARY KEY
);
RESET client_min_messages;
INSERT INTO versions (ver) VALUES ('4.1.5-2');
```