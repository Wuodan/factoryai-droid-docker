# FactoryAI Droid Docker Wrapper

## Overview

FactoryAI Droid Docker provides a thin wrapper around the
`wuodan/factoryai-droid` image so developers can launch FactoryAI Droid inside
an isolated Docker environment with per-project persistence.

## Core Components

- `droid-docker`: Bash helper that prepares per-project cache directories,
  manages API keys, and runs the container with the appropriate mounts and
  environment.
- `Dockerfile` and `entrypoint.sh`: Build the base image that installs the
  FactoryAI CLI tooling and sets up the runtime user environment.
- Docs (`README.md`, `droid-docker.md`, `BUILDING.md`): Explain installation,
  usage, and build instructions for the wrapper and image.

## Target Audience

The tooling is aimed at developers (internal or external) who are comfortable
running Docker but want a ready-made workflow for launching FactoryAI Droid
with persistent configuration per project.

## Integration Notes

Aside from sharing the entrypoint used by the published image, the wrapper
operates independently of other tooling; adjustments to the image or entrypoint
are possible if future features require them.
