-- Take a repodata JSON file and import it into a duckdb table.

-- To read the file, use ".read asd.sql" in duckdb

INSTALL icu;
LOAD icu;

-- If we don't do that, DuckDB will display dates in the local timezone.
SET TimeZone = 'UTC';

-- Import the data into the raw_repodata (and create the table)
CREATE TABLE tmp_linux_64 AS SELECT *
FROM read_json(
    'https://repo.anaconda.com/pkgs/main/linux-64/repodata.json.zst',
    columns = {
        info: 'STRUCT(subdir VARCHAR)',
        packages: 'MAP(VARCHAR, STRUCT(build VARCHAR, build_number UBIGINT, "depends" VARCHAR[], license VARCHAR, license_family VARCHAR, md5 VARCHAR, "name" VARCHAR, sha256 VARCHAR, size UBIGINT, subdir VARCHAR, "timestamp" UBIGINT, "version" VARCHAR, track_features VARCHAR, "constraints" VARCHAR[], namespace VARCHAR, revoked BOOLEAN, app_entry VARCHAR, app_type VARCHAR, summary VARCHAR, "type" VARCHAR, icon VARCHAR, app_cli_opts JSON, namespace_in_name BOOLEAN))',
        "packages.conda": 'MAP(VARCHAR, STRUCT(build VARCHAR, build_number UBIGINT, "depends" VARCHAR[], license VARCHAR, license_family VARCHAR, md5 VARCHAR, "name" VARCHAR, sha256 VARCHAR, size UBIGINT, subdir VARCHAR, "timestamp" UBIGINT, "version" VARCHAR, track_features VARCHAR, "constraints" VARCHAR[], namespace VARCHAR, revoked BOOLEAN, app_entry VARCHAR, app_type VARCHAR, summary VARCHAR, "type" VARCHAR, icon VARCHAR, app_cli_opts JSON, namespace_in_name BOOLEAN))',
        removed: "VARCHAR[]",
        repodata_version: "UBIGINT"
    },
    maximum_object_size = 300000000
);
CREATE TABLE tmp_linux_aarch64 AS SELECT *
FROM read_json(
    'https://repo.anaconda.com/pkgs/main/linux-aarch64/repodata.json.zst',
    columns = {
        info: 'STRUCT(subdir VARCHAR)',
        packages: 'MAP(VARCHAR, STRUCT(build VARCHAR, build_number UBIGINT, "depends" VARCHAR[], license VARCHAR, license_family VARCHAR, md5 VARCHAR, "name" VARCHAR, sha256 VARCHAR, size UBIGINT, subdir VARCHAR, "timestamp" UBIGINT, "version" VARCHAR, track_features VARCHAR, "constraints" VARCHAR[], namespace VARCHAR, revoked BOOLEAN, app_entry VARCHAR, app_type VARCHAR, summary VARCHAR, "type" VARCHAR, icon VARCHAR, app_cli_opts JSON, namespace_in_name BOOLEAN))',
        "packages.conda": 'MAP(VARCHAR, STRUCT(build VARCHAR, build_number UBIGINT, "depends" VARCHAR[], license VARCHAR, license_family VARCHAR, md5 VARCHAR, "name" VARCHAR, sha256 VARCHAR, size UBIGINT, subdir VARCHAR, "timestamp" UBIGINT, "version" VARCHAR, track_features VARCHAR, "constraints" VARCHAR[], namespace VARCHAR, revoked BOOLEAN, app_entry VARCHAR, app_type VARCHAR, summary VARCHAR, "type" VARCHAR, icon VARCHAR, app_cli_opts JSON, namespace_in_name BOOLEAN))',
        removed: "VARCHAR[]",
        repodata_version: "UBIGINT"
    },
    maximum_object_size = 300000000
);
CREATE TABLE tmp_linux_s390x AS SELECT *
FROM read_json(
    'https://repo.anaconda.com/pkgs/main/linux-s390x/repodata.json.zst',
    columns = {
        info: 'STRUCT(subdir VARCHAR)',
        packages: 'MAP(VARCHAR, STRUCT(build VARCHAR, build_number UBIGINT, "depends" VARCHAR[], license VARCHAR, license_family VARCHAR, md5 VARCHAR, "name" VARCHAR, sha256 VARCHAR, size UBIGINT, subdir VARCHAR, "timestamp" UBIGINT, "version" VARCHAR, track_features VARCHAR, "constraints" VARCHAR[], namespace VARCHAR, revoked BOOLEAN, app_entry VARCHAR, app_type VARCHAR, summary VARCHAR, "type" VARCHAR, icon VARCHAR, app_cli_opts JSON, namespace_in_name BOOLEAN))',
        "packages.conda": 'MAP(VARCHAR, STRUCT(build VARCHAR, build_number UBIGINT, "depends" VARCHAR[], license VARCHAR, license_family VARCHAR, md5 VARCHAR, "name" VARCHAR, sha256 VARCHAR, size UBIGINT, subdir VARCHAR, "timestamp" UBIGINT, "version" VARCHAR, track_features VARCHAR, "constraints" VARCHAR[], namespace VARCHAR, revoked BOOLEAN, app_entry VARCHAR, app_type VARCHAR, summary VARCHAR, "type" VARCHAR, icon VARCHAR, app_cli_opts JSON, namespace_in_name BOOLEAN))',
        removed: "VARCHAR[]",
        repodata_version: "UBIGINT"
    },
    maximum_object_size = 300000000
);
CREATE TABLE tmp_linux_ppc64le AS SELECT *
FROM read_json(
    'https://repo.anaconda.com/pkgs/main/linux-ppc64le/repodata.json.zst',
    columns = {
        info: 'STRUCT(subdir VARCHAR)',
        packages: 'MAP(VARCHAR, STRUCT(build VARCHAR, build_number UBIGINT, "depends" VARCHAR[], license VARCHAR, license_family VARCHAR, md5 VARCHAR, "name" VARCHAR, sha256 VARCHAR, size UBIGINT, subdir VARCHAR, "timestamp" UBIGINT, "version" VARCHAR, track_features VARCHAR, "constraints" VARCHAR[], namespace VARCHAR, revoked BOOLEAN, app_entry VARCHAR, app_type VARCHAR, summary VARCHAR, "type" VARCHAR, icon VARCHAR, app_cli_opts JSON, namespace_in_name BOOLEAN))',
        "packages.conda": 'MAP(VARCHAR, STRUCT(build VARCHAR, build_number UBIGINT, "depends" VARCHAR[], license VARCHAR, license_family VARCHAR, md5 VARCHAR, "name" VARCHAR, sha256 VARCHAR, size UBIGINT, subdir VARCHAR, "timestamp" UBIGINT, "version" VARCHAR, track_features VARCHAR, "constraints" VARCHAR[], namespace VARCHAR, revoked BOOLEAN, app_entry VARCHAR, app_type VARCHAR, summary VARCHAR, "type" VARCHAR, icon VARCHAR, app_cli_opts JSON, namespace_in_name BOOLEAN))',
        removed: "VARCHAR[]",
        repodata_version: "UBIGINT"
    },
    maximum_object_size = 300000000
);
CREATE TABLE tmp_osx_64 AS SELECT *
FROM read_json(
    'https://repo.anaconda.com/pkgs/main/osx-64/repodata.json.zst',
    columns = {
        info: 'STRUCT(subdir VARCHAR)',
        packages: 'MAP(VARCHAR, STRUCT(build VARCHAR, build_number UBIGINT, "depends" VARCHAR[], license VARCHAR, license_family VARCHAR, md5 VARCHAR, "name" VARCHAR, sha256 VARCHAR, size UBIGINT, subdir VARCHAR, "timestamp" UBIGINT, "version" VARCHAR, track_features VARCHAR, "constraints" VARCHAR[], namespace VARCHAR, revoked BOOLEAN, app_entry VARCHAR, app_type VARCHAR, summary VARCHAR, "type" VARCHAR, icon VARCHAR, app_cli_opts JSON, namespace_in_name BOOLEAN))',
        "packages.conda": 'MAP(VARCHAR, STRUCT(build VARCHAR, build_number UBIGINT, "depends" VARCHAR[], license VARCHAR, license_family VARCHAR, md5 VARCHAR, "name" VARCHAR, sha256 VARCHAR, size UBIGINT, subdir VARCHAR, "timestamp" UBIGINT, "version" VARCHAR, track_features VARCHAR, "constraints" VARCHAR[], namespace VARCHAR, revoked BOOLEAN, app_entry VARCHAR, app_type VARCHAR, summary VARCHAR, "type" VARCHAR, icon VARCHAR, app_cli_opts JSON, namespace_in_name BOOLEAN))',
        removed: "VARCHAR[]",
        repodata_version: "UBIGINT"
    },
    maximum_object_size = 300000000
);
CREATE TABLE tmp_osx_arm64 AS SELECT *
FROM read_json(
    'https://repo.anaconda.com/pkgs/main/osx-arm64/repodata.json.zst',
    columns = {
        info: 'STRUCT(subdir VARCHAR)',
        packages: 'MAP(VARCHAR, STRUCT(build VARCHAR, build_number UBIGINT, "depends" VARCHAR[], license VARCHAR, license_family VARCHAR, md5 VARCHAR, "name" VARCHAR, sha256 VARCHAR, size UBIGINT, subdir VARCHAR, "timestamp" UBIGINT, "version" VARCHAR, track_features VARCHAR, "constraints" VARCHAR[], namespace VARCHAR, revoked BOOLEAN, app_entry VARCHAR, app_type VARCHAR, summary VARCHAR, "type" VARCHAR, icon VARCHAR, app_cli_opts JSON, namespace_in_name BOOLEAN))',
        "packages.conda": 'MAP(VARCHAR, STRUCT(build VARCHAR, build_number UBIGINT, "depends" VARCHAR[], license VARCHAR, license_family VARCHAR, md5 VARCHAR, "name" VARCHAR, sha256 VARCHAR, size UBIGINT, subdir VARCHAR, "timestamp" UBIGINT, "version" VARCHAR, track_features VARCHAR, "constraints" VARCHAR[], namespace VARCHAR, revoked BOOLEAN, app_entry VARCHAR, app_type VARCHAR, summary VARCHAR, "type" VARCHAR, icon VARCHAR, app_cli_opts JSON, namespace_in_name BOOLEAN))',
        removed: "VARCHAR[]",
        repodata_version: "UBIGINT"
    },
    maximum_object_size = 300000000
);
CREATE TABLE tmp_win_64 AS SELECT *
FROM read_json(
    'https://repo.anaconda.com/pkgs/main/win-64/repodata.json.zst',
    columns = {
        info: 'STRUCT(subdir VARCHAR)',
        packages: 'MAP(VARCHAR, STRUCT(build VARCHAR, build_number UBIGINT, "depends" VARCHAR[], license VARCHAR, license_family VARCHAR, md5 VARCHAR, "name" VARCHAR, sha256 VARCHAR, size UBIGINT, subdir VARCHAR, "timestamp" UBIGINT, "version" VARCHAR, track_features VARCHAR, "constraints" VARCHAR[], namespace VARCHAR, revoked BOOLEAN, app_entry VARCHAR, app_type VARCHAR, summary VARCHAR, "type" VARCHAR, icon VARCHAR, app_cli_opts JSON, namespace_in_name BOOLEAN))',
        "packages.conda": 'MAP(VARCHAR, STRUCT(build VARCHAR, build_number UBIGINT, "depends" VARCHAR[], license VARCHAR, license_family VARCHAR, md5 VARCHAR, "name" VARCHAR, sha256 VARCHAR, size UBIGINT, subdir VARCHAR, "timestamp" UBIGINT, "version" VARCHAR, track_features VARCHAR, "constraints" VARCHAR[], namespace VARCHAR, revoked BOOLEAN, app_entry VARCHAR, app_type VARCHAR, summary VARCHAR, "type" VARCHAR, icon VARCHAR, app_cli_opts JSON, namespace_in_name BOOLEAN))',
        removed: "VARCHAR[]",
        repodata_version: "UBIGINT"
    },
    maximum_object_size = 300000000
);
CREATE TABLE tmp_noarch AS SELECT *
FROM read_json(
    'https://repo.anaconda.com/pkgs/main/noarch/repodata.json.zst',
    columns = {
        info: 'STRUCT(subdir VARCHAR)',
        packages: 'MAP(VARCHAR, STRUCT(build VARCHAR, build_number UBIGINT, "depends" VARCHAR[], license VARCHAR, license_family VARCHAR, md5 VARCHAR, "name" VARCHAR, sha256 VARCHAR, size UBIGINT, subdir VARCHAR, "timestamp" UBIGINT, "version" VARCHAR, track_features VARCHAR, "constraints" VARCHAR[], namespace VARCHAR, revoked BOOLEAN, app_entry VARCHAR, app_type VARCHAR, summary VARCHAR, "type" VARCHAR, icon VARCHAR, app_cli_opts JSON, namespace_in_name BOOLEAN))',
        "packages.conda": 'MAP(VARCHAR, STRUCT(build VARCHAR, build_number UBIGINT, "depends" VARCHAR[], license VARCHAR, license_family VARCHAR, md5 VARCHAR, "name" VARCHAR, sha256 VARCHAR, size UBIGINT, subdir VARCHAR, "timestamp" UBIGINT, "version" VARCHAR, track_features VARCHAR, "constraints" VARCHAR[], namespace VARCHAR, revoked BOOLEAN, app_entry VARCHAR, app_type VARCHAR, summary VARCHAR, "type" VARCHAR, icon VARCHAR, app_cli_opts JSON, namespace_in_name BOOLEAN))',
        removed: "VARCHAR[]",
        repodata_version: "UBIGINT"
    },
    maximum_object_size = 300000000
);

CREATE TYPE archive_type AS ENUM ('conda', 'tar.bz2');

CREATE SEQUENCE id_sequence START 1;

-- Create the "packages" table
CREATE TABLE packages (
    id INTEGER DEFAULT nextval('id_sequence'),
    app_cli_opts JSON,
    app_entry VARCHAR,
    app_type VARCHAR,
    archive_type archive_type,
    build VARCHAR,
    build_number UBIGINT,
    channel VARCHAR,
    constraints VARCHAR[],
    depends VARCHAR[],
    filename VARCHAR,
    icon VARCHAR,
    license VARCHAR,
    license_family VARCHAR,
    md5 VARCHAR,
    name VARCHAR,
    namespace VARCHAR,
    namespace_in_name BOOLEAN,
    revoked BOOLEAN,
    sha256 VARCHAR,
    size UBIGINT,
    subdir VARCHAR,
    summary VARCHAR,
    timestamp UBIGINT,
    track_features VARCHAR,
    type VARCHAR,
    version VARCHAR,
    url VARCHAR AS (concat_ws('/', channel, subdir, filename)),
    PRIMARY KEY (filename, channel, subdir),
);

-- Insert all packages into the "packages" table.
INSERT INTO packages BY NAME (
    SELECT unnest(item.value), 'tar.bz2' AS archive_type, item.key AS filename, 'https://repo.anaconda.com/pkgs/main' AS channel FROM (SELECT unnest(map_entries(packages)) AS item FROM tmp_linux_64)
    UNION ALL
    SELECT unnest(item.value), 'conda' AS archive_type, item.key AS filename, 'https://repo.anaconda.com/pkgs/main' AS channel FROM (SELECT unnest(map_entries("packages.conda")) AS item FROM tmp_linux_64)

    UNION ALL
    SELECT unnest(item.value), 'tar.bz2' AS archive_type, item.key AS filename, 'https://repo.anaconda.com/pkgs/main' AS channel FROM (SELECT unnest(map_entries(packages)) AS item FROM tmp_linux_aarch64)
    UNION ALL
    SELECT unnest(item.value), 'conda' AS archive_type, item.key AS filename, 'https://repo.anaconda.com/pkgs/main' AS channel FROM (SELECT unnest(map_entries("packages.conda")) AS item FROM tmp_linux_aarch64)

    UNION ALL
    SELECT unnest(item.value), 'tar.bz2' AS archive_type, item.key AS filename, 'https://repo.anaconda.com/pkgs/main' AS channel FROM (SELECT unnest(map_entries(packages)) AS item FROM tmp_linux_s390x)
    UNION ALL
    SELECT unnest(item.value), 'conda' AS archive_type, item.key AS filename, 'https://repo.anaconda.com/pkgs/main' AS channel FROM (SELECT unnest(map_entries("packages.conda")) AS item FROM tmp_linux_s390x)

    UNION ALL
    SELECT unnest(item.value), 'tar.bz2' AS archive_type, item.key AS filename, 'https://repo.anaconda.com/pkgs/main' AS channel FROM (SELECT unnest(map_entries(packages)) AS item FROM tmp_linux_ppc64le)
    UNION ALL
    SELECT unnest(item.value), 'conda' AS archive_type, item.key AS filename, 'https://repo.anaconda.com/pkgs/main' AS channel FROM (SELECT unnest(map_entries("packages.conda")) AS item FROM tmp_linux_ppc64le)

    UNION ALL
    SELECT unnest(item.value), 'tar.bz2' AS archive_type, item.key AS filename, 'https://repo.anaconda.com/pkgs/main' AS channel FROM (SELECT unnest(map_entries(packages)) AS item FROM tmp_osx_64)
    UNION ALL
    SELECT unnest(item.value), 'conda' AS archive_type, item.key AS filename, 'https://repo.anaconda.com/pkgs/main' AS channel FROM (SELECT unnest(map_entries("packages.conda")) AS item FROM tmp_osx_64)

    UNION ALL
    SELECT unnest(item.value), 'tar.bz2' AS archive_type, item.key AS filename, 'https://repo.anaconda.com/pkgs/main' AS channel FROM (SELECT unnest(map_entries(packages)) AS item FROM tmp_osx_arm64)
    UNION ALL
    SELECT unnest(item.value), 'conda' AS archive_type, item.key AS filename, 'https://repo.anaconda.com/pkgs/main' AS channel FROM (SELECT unnest(map_entries("packages.conda")) AS item FROM tmp_osx_arm64)

    UNION ALL
    SELECT unnest(item.value), 'tar.bz2' AS archive_type, item.key AS filename, 'https://repo.anaconda.com/pkgs/main' AS channel FROM (SELECT unnest(map_entries(packages)) AS item FROM tmp_win_64)
    UNION ALL
    SELECT unnest(item.value), 'conda' AS archive_type, item.key AS filename, 'https://repo.anaconda.com/pkgs/main' AS channel FROM (SELECT unnest(map_entries("packages.conda")) AS item FROM tmp_win_64)

    UNION ALL
    SELECT unnest(item.value), 'tar.bz2' AS archive_type, item.key AS filename, 'https://repo.anaconda.com/pkgs/main' AS channel FROM (SELECT unnest(map_entries(packages)) AS item FROM tmp_noarch)
    UNION ALL
    SELECT unnest(item.value), 'conda' AS archive_type, item.key AS filename, 'https://repo.anaconda.com/pkgs/main' AS channel FROM (SELECT unnest(map_entries("packages.conda")) AS item FROM tmp_noarch)
);

-- Convert the timestamp column to a real TIMESTAMP type.
ALTER TABLE packages ALTER timestamp SET DATA TYPE TIMESTAMPTZ USING to_timestamp(timestamp/1000);

-- Drop the temporary tables to regain some memory.
DROP TABLE tmp_linux_64;
DROP TABLE tmp_linux_aarch64;
DROP TABLE tmp_linux_s390x;
DROP TABLE tmp_linux_ppc64le;
DROP TABLE tmp_osx_64;
DROP TABLE tmp_osx_arm64;
DROP TABLE tmp_win_64;
DROP TABLE tmp_noarch;

-- CREATE TABLE downloads AS SELECT * FROM read_parquet('s3://anaconda-package-data/conda/monthly/*/*.parquet') WHERE data_source = 'anaconda';
-- ALTER TABLE downloads ALTER time SET DATA TYPE TIMESTAMPTZ USING strptime(format('{}Z', time), '%Y-%m%Z');

CREATE TYPE path_type AS ENUM ('softlink', 'hardlink');
CREATE TYPE file_mode AS ENUM ('text', 'binary');

CREATE TABLE paths (
    package_id INTEGER,
    path VARCHAR,
    file_mode file_mode,
    prefix_placeholder VARCHAR,
    type path_type,
    sha256 varchar,
    size UBIGINT,
);


CREATE TABLE tmp_paths_linux_64 AS (SELECT * FROM read_csv('paths.csv'));

INSERT INTO paths BY NAME (
    SELECT COLUMNS(c -> c != url) FROM (
        SELECT packages.id AS package_id, tmp_paths_linux_64.* FROM tmp_paths_linux_64 JOIN packages ON (tmp_paths_linux_64.url = packages.url)
    )
);

DROP TABLE tmp_paths_linux_64;
