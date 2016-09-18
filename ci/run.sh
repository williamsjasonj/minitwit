#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

script_dir="$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd -P)"

cd "${script_dir}"

echo "DOCKER_IMG_TAR: ${DOCKER_IMG_TAR}"
echo "DOCKER_IMG_TAG: ${DOCKER_IMG_TAG}"

docker load --input "${DOCKER_IMG_TAR}"

DOCKER_CID="$(docker run -d "${DOCKER_IMG_TAG}")"
echo "DOCKER_CID: ${DOCKER_CID}"
