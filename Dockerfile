# factoryai-droid-docker — concise multi-stage (Debian or Alpine)
# Build:
#   docker build -t wuodan/factoryai-droid:0.19.8 --build-arg DROID_VERSION=0.19.8 .
# Multi-arch (manifest for amd64 + arm64):
#   docker buildx build --platform linux/amd64,linux/arm64 -t wuodan:factoryai-droid:0.19.8 --push .

ARG BASE_IMAGE=debian:bookworm-slim
FROM ${BASE_IMAGE} AS fetch

ARG DROID_VERSION=0.19.8
ARG TARGETARCH=amd64
ENV FACTORY_BASE_URL=https://downloads.factory.ai

RUN --mount=type=bind,source=./install-droid.sh,target=/tmp/install-droid.sh \
    bash /tmp/install-droid.sh

RUN set -eu && \
    apt-get update && apt-get install -y --no-install-recommends ca-certificates curl coreutils && \
    rm -rf /var/lib/apt/lists/* && \
    case "${TARGETARCH}" in amd64) ARCH_NAME="x64" ;; arm64) ARCH_NAME="arm64" ;; \
      *) echo "Unsupported TARGETARCH: ${TARGETARCH}" >&2; exit 1 ;; \
    esac && \
    mkdir -p /out && \
    curl -fsSL -o /out/droid "${FACTORY_BASE_URL}/factory-cli/releases/${DROID_VERSION}/linux/${ARCH_NAME}/droid" && \
    curl -fsSL -o /out/rg    "${FACTORY_BASE_URL}/ripgrep/linux/${ARCH_NAME}/rg" && \
    chmod +x /out/droid /out/rg

FROM ${BASE_IMAGE}

ARG USERNAME=appuser
ARG USER_UID=1000
ARG USER_GID=1000
RUN set -eu && \
    #      apt-get update && apt-get install -y --no-install-recommends ca-certificates && \
#      rm -rf /var/lib/apt/lists/* && \
    groupadd --gid ${USER_GID} ${USERNAME} && useradd --uid ${USER_UID} --gid ${USER_GID} -m -s /bin/bash ${USERNAME};

# Copy only the downloaded binaries
COPY --from=fetch /out/droid /usr/local/bin/droid
COPY --from=fetch /out/rg    /usr/local/bin/rg
#RUN chmod +x /usr/local/bin/droid /usr/local/bin/rg

USER ${USERNAME}
WORKDIR /app

# Smoke test
# RUN droid --version || droid -v

CMD ["droid"]
