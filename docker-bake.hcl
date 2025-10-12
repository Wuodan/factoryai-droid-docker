variable "IMAGE_NAME" { default = "factoryai-droid" }
variable "DROID_VERSION" { default = "0.19.8" }

group "default" { targets = ["fetch", "final"] }

# 1) Fetch image: produces /out/droid and /out/rg
target "fetch" {
  dockerfile = "Dockerfile.fetch"
  context = "."
  args = {
    DROID_VERSION = "${DROID_VERSION}"
  }
}

# 2) Final image: copies artifacts from the fetch image via named context
target "final" {
  dockerfile = "Dockerfile.final"
  context = "."

  # Expose the fetch image as a named context "fetch" so Dockerfile.final can COPY --from=fetch
  contexts = {
    fetch = "target:fetch"
  }

  tags = [
    "${IMAGE_NAME}:${DROID_VERSION}",
    "${IMAGE_NAME}:latest"
  ]
}