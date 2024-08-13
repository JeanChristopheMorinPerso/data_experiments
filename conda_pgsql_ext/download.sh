#!/usr/bin/env bash
set -e

apt update
apt install libreadline-dev python3 curl libcurl4-openssl-dev pkg-config libssl-dev cmake g++ libspdlog-dev libfmt-dev libexpected-dev nlohmann-json3-dev libsimdjson-dev libyaml-cpp-dev libsolv-dev libsolvext-dev libcurl4-openssl-dev libarchive-dev

mkdir -p deps
curl -L https://github.com/mamba-org/mamba/archive/refs/tags/2024.07.26.tar.gz -o deps/mamba-2024.07.26.tar.gz
curl https://ftp.postgresql.org/pub/source/v16.4/postgresql-16.4.tar.gz -o deps/postgresql-16.4.tar.gz
# curl -L https://github.com/TartanLlama/expected/archive/refs/tags/v1.1.0.tar.gz -o deps/expected-1.1.0.tar.gz
curl -L https://github.com/DaanDeMeyer/reproc/archive/refs/tags/v14.2.5.tar.gz -o deps/reproc-14.2.5.tar.gz
curl -L https://github.com/openSUSE/libsolv/archive/refs/tags/0.7.30.tar.gz -o deps/libsolv-0.7.30.tar.gz

cd deps
for file in *.tar.gz; do tar -xzf $file; mv $(echo $file | sed 's/\.tar\.gz//g') $(echo $file | cut -d'-' -f1); done


cd postgresql
./configure --enable-cassert --enable-debug CFLAGS="-ggdb"
make -j 12
make install

cd ..

cd reproc
cmake -B build . -DREPROC++=ON -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_INSTALL_PREFIX=/usr
cmake --build build -j 12
cmake --install build

cd ..

cd libsolv
cmake -B build . -DENABLE_CONDA=ON -DCMAKE_INSTALL_PREFIX=/usr
cmake --build build -j 12
cmake --install build

cd ..

cd mamba
cmake -B build . -DBUILD_SHARED=ON -DBUILD_LIBMAMBA=ON -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_INSTALL_PREFIX=/usr
cmake --build build -j 12
cmake --install build
