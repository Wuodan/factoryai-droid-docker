FROM python:slim

# Create non-root user
ARG USERNAME=appuser
ARG USER_UID=1000
ARG USER_GID=1000

# Install ca-certificates, curl and uvx (for mcp servers)
# Create non-root user
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      gosu \
      wget \
    && \
    rm -rf /var/lib/apt/lists/* && \
    curl -LsSf https://astral.sh/uv/install.sh | sh && \
    mv /root/.local/bin/uv  /usr/local/bin/uv && \
    mv /root/.local/bin/uvx /usr/local/bin/uvx && \
    uv --version && \
    uvx --version && \
    groupadd --gid ${USER_GID} ${USERNAME} && \
    useradd  --uid ${USER_UID} --gid ${USER_GID} -m -s /bin/bash ${USERNAME}

# Install as user
USER ${USERNAME}

RUN curl -fsSL https://app.factory.ai/cli | sh && \
    /home/${USERNAME}/.local/bin/droid --version && \
    mkdir /home/${USERNAME}/work

ENV PATH="/home/${USERNAME}/.local/bin:/home/${USERNAME}/.factory/bin:${PATH}"

WORKDIR /home/${USERNAME}/work

# Switch to root for entrypoint
USER root

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default to the interactive CLI; require -it
CMD ["droid"]
