FROM debian:bookworm-slim

# Minimal dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        coreutils && \
    rm -rf /var/lib/apt/lists/*

# Select Droid version (override at build time)
ARG DROID_VERSION=0.19.8
ARG TARGETARCH=amd64
ENV FACTORY_BASE_URL=https://downloads.factory.ai

# Map TARGETARCH -> Factory arch and download
RUN set -eu && \
    case "${TARGETARCH}" in \
      amd64) ARCH_NAME="x64" ;; \
      arm64) ARCH_NAME="arm64" ;; \
      *) echo "Unsupported TARGETARCH: ${TARGETARCH}"; exit 1 ;; \
    esac && \
    curl -fsSL -o /usr/local/bin/droid \
      "${FACTORY_BASE_URL}/factory-cli/releases/${DROID_VERSION}/linux/${ARCH_NAME}/droid" && \
    curl -fsSL -o /usr/local/bin/rg \
      "${FACTORY_BASE_URL}/ripgrep/linux/${ARCH_NAME}/rg" && \
    chmod +x /usr/local/bin/droid /usr/local/bin/rg

# Create non-root user
ARG USERNAME=appuser
ARG USER_UID=1000
ARG USER_GID=1000
RUN groupadd --gid ${USER_GID} ${USERNAME} && \
    useradd --uid ${USER_UID} --gid ${USER_GID} -m -s /bin/bash ${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Smoke test (won’t fail build if flags change)
RUN droid --version || droid -v || true

CMD ["/bin/bash"]
