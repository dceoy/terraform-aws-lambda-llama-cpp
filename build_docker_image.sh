#!/usr/bin/env bash
#
# Usage:
#   ./build_docker_image.sh [<image_name>]

set -euox pipefail

SRC_DIR="$(realpath "${0}" | xargs dirname)/src"
IMAGE_NAME="${1:-llama-cpp-server}"
AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
AWS_REGION="$(aws configure get region)"
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
TAG_NAME="sha-$(git rev-parse --short HEAD)"
BUILD_TARGET='app'
PLATFORMS='linux/arm64'

docker buildx build \
  --tag "${ECR_REGISTRY}/${IMAGE_NAME}:${TAG_NAME}" \
  --target "${BUILD_TARGET}" \
  --platform "${PLATFORMS}" \
  --provenance false \
  "${SRC_DIR}"
