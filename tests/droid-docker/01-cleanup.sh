#!/usr/bin/env bash
# Test 01: Clean Environment Test
# Purpose: Remove any existing APP_CACHE directories and verify clean starting state
# Usage: ./01-cleanup.sh

set -euo pipefail

echo "=== Test 01: Clean Environment ==="
echo "Removing existing APP_CACHE directories..."

# Clean up any existing test data
rm -rf "${HOME}/.factoryai-droid-docker"

# Also clean up the test directory in /tmp
rm -rf "/tmp/droid-docker-test"

echo "✅ Cleaned existing APP_CACHE directories"
echo "✅ Cleaned test directory in /tmp"
echo "✅ Environment is clean - ready for testing"
