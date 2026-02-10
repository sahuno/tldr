#!/bin/bash

# Docker build and push script for tldr
# Usage: docker/docker_build.sh [OPTIONS]
#   -u, --username    DockerHub username (default: sahuno)
#   -t, --tag         Image tag (default: latest)
#   -p, --push        Push to DockerHub after build
#   -h, --help        Show this help message

set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Parent directory is the project root
PROJECT_ROOT="$( cd "${SCRIPT_DIR}/.." && pwd )"

# Default values
DOCKER_USERNAME="sahuno"
IMAGE_NAME="tldr"
TAG="latest"
PUSH=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--username)
            DOCKER_USERNAME="$2"
            shift 2
            ;;
        -t|--tag)
            TAG="$2"
            shift 2
            ;;
        -p|--push)
            PUSH=true
            shift
            ;;
        -h|--help)
            echo "Usage: docker/docker_build.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -u, --username    DockerHub username (default: sahuno)"
            echo "  -t, --tag         Image tag (default: latest)"
            echo "  -p, --push        Push to DockerHub after build"
            echo "  -h, --help        Show this help message"
            echo ""
            echo "Examples:"
            echo "  docker/docker_build.sh                    # Build only"
            echo "  docker/docker_build.sh -p                 # Build and push"
            echo "  docker/docker_build.sh -t v1.3.0 -p       # Build and push with version tag"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Full image name
FULL_IMAGE="${DOCKER_USERNAME}/${IMAGE_NAME}:${TAG}"

echo "============================================"
echo "Building tldr Docker image"
echo "============================================"
echo "Image: ${FULL_IMAGE}"
echo "============================================"

# Get version from setup.py
VERSION=$(grep "version=" "${PROJECT_ROOT}/setup.py" | sed "s/.*version='\(.*\)'.*/\1/")
echo "tldr version: ${VERSION}"

# Build the image
echo ""
echo "Building Docker image..."
docker build \
    --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
    --build-arg VCS_REF=$(git rev-parse --short HEAD) \
    -f "${SCRIPT_DIR}/Dockerfile" \
    -t "${FULL_IMAGE}" \
    -t "${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}" \
    "${PROJECT_ROOT}"

echo ""
echo "✅ Build successful!"
echo ""
echo "Tagged as:"
echo "  - ${FULL_IMAGE}"
echo "  - ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}"

# Test the image
echo ""
echo "Testing Docker image..."
docker run --rm "${FULL_IMAGE}" tldr -v

# Push if requested
if [ "$PUSH" = true ]; then
    echo ""
    echo "============================================"
    echo "Pushing to DockerHub"
    echo "============================================"

    # Check if logged in
    if ! docker info | grep -q Username; then
        echo "Not logged in to DockerHub. Please run: docker login"
        exit 1
    fi

    echo "Pushing ${FULL_IMAGE}..."
    docker push "${FULL_IMAGE}"

    echo "Pushing ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}..."
    docker push "${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}"

    echo ""
    echo "✅ Push successful!"
    echo ""
    echo "Image available at:"
    echo "  docker pull ${FULL_IMAGE}"
    echo "  docker pull ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}"
else
    echo ""
    echo "Build complete. To push to DockerHub, run:"
    echo "  docker/docker_build.sh -p"
    echo ""
    echo "Or manually:"
    echo "  docker login"
    echo "  docker push ${FULL_IMAGE}"
    echo "  docker push ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}"
fi

echo ""
echo "============================================"
echo "Usage Examples"
echo "============================================"
echo ""
echo "# Show help"
echo "docker run --rm ${FULL_IMAGE}"
echo ""
echo "# Run with your data (mount current directory)"
echo "docker run --rm -v \$(pwd):/data ${FULL_IMAGE} tldr \\"
echo "  -b /data/aligned_reads.bam \\"
echo "  -e \${TLDR_REF_HUMAN} \\"
echo "  -r /data/reference.fa"
echo ""
echo "# Interactive mode"
echo "docker run --rm -it -v \$(pwd):/data ${FULL_IMAGE} bash"
echo ""
