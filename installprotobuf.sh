#!/bin/bash
# install ONNX - Build from source
export PB_VERSION=2.6.1
export local pb_dir="$HOME/.cache/pb"
export NUMCORES=2
mkdir -p "$pb_dir"
pip3 install --upgrade pip
wget -qO- "https://github.com/google/protobuf/releases/download/v${PB_VERSION}/protobuf-${PB_VERSION}.tar.gz" | tar -xz -C "$pb_dir" --strip-components 1
ccache -z
cd "$pb_dir" && ./configure && make -j2 && make check && make install && ldconfig && cd -
ccache -s
pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U
pip3 install pytest-cov nbval
export PATH="/usr/lib/ccache:$PATH"
ccache --max-size 1G
