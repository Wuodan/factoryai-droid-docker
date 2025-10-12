#!/usr/bin/env bash

set -euo pipefail

USERNAME=appuser

APP_UID="$(id -u "$USERNAME")"
APP_GID="$(id -g "$USERNAME")"
TARGET_DIR="${TARGET_DIR:-/home/${USERNAME}/.factory}"

chown -R --no-dereference "$APP_UID:$APP_GID" "$TARGET_DIR" 2>/dev/null || true

exec gosu "$APP_UID:$APP_GID" "$@"
