#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

script_dir="$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd -P)"

cd "${script_dir}"

GIT_REV_SHORT="$(git rev-parse --short HEAD)"
echo "GIT_REV_SHORT: ${GIT_REV_SHORT}"

DOCKER_IMG_NAME="${DOCKER_IMG_NAME:-karlkfi/minitwit}"
DOCKER_IMG_VERSION="dev-${GIT_REV_SHORT}"
DOCKER_IMG_TAG="${DOCKER_IMG_NAME}:${DOCKER_IMG_VERSION}"
echo "DOCKER_IMG_TAG: ${DOCKER_IMG_TAG}"

docker build -t "${DOCKER_IMG_TAG}" .

DOCKER_IMG_TAR="minitwit-${GIT_REV_SHORT}.tar"
echo "DOCKER_IMG_TAR: ${DOCKER_IMG_TAR}"

docker save --output "${DOCKER_IMG_TAR}" "${DOCKER_IMG_TAG}"
