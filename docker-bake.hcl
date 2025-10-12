# docker-bake.hcl — build 'fetch' and 'final' and push multi-arch images
# Local build and push:
#   docker buildx bake --push
# Override image name / version:
#   docker buildx bake --push --set IMAGE_NAME=docker.io/you/factoryai-droid --set DROID_VERSION=0.19.8

# variable "IMAGE_NAME" { default = "ghcr.io/OWNER/factoryai-droid" }
variable "IMAGE_NAME" { default = "factoryai-droid" }
variable "DROID_VERSION" { default = "0.19.8" }

group "default" { targets = ["fetch", "final"] }

# 1) Fetch image: produces /out/droid and /out/rg
target "fetch" {
  dockerfile = "Dockerfile.fetch"
  context = "."
  # tags = ["${IMAGE_NAME}:fetch-${DROID_VERSION}"]
  # platforms = ["linux/amd64","linux/arm64"]
  args = {
    DROID_VERSION = "${DROID_VERSION}"
  }
}

# 2) Final image: copies artifacts from the fetch image via named context
target "final" {
  dockerfile = "Dockerfile.final"
  context = "."
  # platforms = ["linux/amd64","linux/arm64"]

  # Expose the fetch image as a named context "fetch" so Dockerfile.final can COPY --from=fetch
  contexts = {
    # fetch = "docker-image://${IMAGE_NAME}:fetch-${DROID_VERSION}"
    fetch = "target:fetch"
  }

  tags = [
    "${IMAGE_NAME}:${DROID_VERSION}",
    "${IMAGE_NAME}:latest"
  ]
}
