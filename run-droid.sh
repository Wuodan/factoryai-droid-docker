#!/usr/bin/env bash
# run-droid.sh — tiny helper to start Droid with persistence
# Usage:
#   ./run-droid.sh                 # interactive TUI
#   ./run-droid.sh exec --output-format json "list files"  # headless exec
#
# Env overrides:
#   HOME_VOL=~/.factory ./run-droid.sh

set -euo pipefail

IMAGE="wuodan/factoryai-droid"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
#FACTORY_VOL="${SCRIPT_DIR}/.factory"
FACTORY_VOL="$(pwd)/.factory"

#mkdir -p "${SCRIPT_DIR}/${FACTORY_VOL"
mkdir -p "${FACTORY_VOL}"

if [ "$#" -ne 0 ] && [ "$1" != "droid" ]; then
  set -- droid "$@"
fi

source "${SCRIPT_DIR}/.env"

exec docker run --rm -it --init \
  -v "${FACTORY_VOL}":/home/appuser/.factory \
  -e "FACTORY_API_KEY=${FACTORY_API_KEY}" \
  "${IMAGE}" # "$@"
