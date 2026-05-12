#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
REPO_URL="https://github.com/sgl-project/sglang.git"
TAG_VERSION="v0.5.2"
DIR_NAME="${SCRIPT_DIR}/sglang"

clone_source() {
    # Clone sglang repo
    pushd ${SCRIPT_DIR}
    if [ ! -d ${DIR_NAME} ]; then
        git clone -b ${TAG_VERSION} --depth 1 ${REPO_URL} ${DIR_NAME}
    fi
    popd
}

update_dockerfile() {
    # Overwrite the Dockerfile
    pushd ${SCRIPT_DIR}
    cp Dockerfile sglang/docker/
    popd
}

build_container() {
    pushd ${SCRIPT_DIR}/sglang/
    docker build -f docker/Dockerfile -t sglang-devel:${TAG_VERSION} .
}

clone_source
update_dockerfile
build_container
