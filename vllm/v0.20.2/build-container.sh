#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
REPO_URL="https://github.com/vllm-project/vllm.git"
TAG_VERSION="v0.20.2"
DIR_NAME="${SCRIPT_DIR}/vllm"

clone_source() {
    # Clone vllm repo
    pushd ${SCRIPT_DIR}
    if [ ! -d ${DIR_NAME} ]; then
        git clone -b ${TAG_VERSION} --depth 1 ${REPO_URL} ${DIR_NAME}
    fi
    popd
}

update_dockerfile() {
    # Overwrite the Dockerfile
    pushd ${SCRIPT_DIR}
    cp Dockerfile vllm/docker/
    popd
}

build_container() {
    pushd ${SCRIPT_DIR}/vllm/
    docker build -f docker/Dockerfile \
        -t vllm-devel:${TAG_VERSION} \
        --build-arg UBUNTU_VERSION=24.04 \
        --build-arg PIP_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple \
        .
}

clone_source
update_dockerfile
build_container
