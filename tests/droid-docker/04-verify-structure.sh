#!/usr/bin/env bash
# Test 04: Verify Structure
# Purpose: Verify that all files and directories were created correctly
# Usage: ./04-verify-structure.sh

set -euo pipefail

echo "=== Test 04: Verify Structure ==="

# First verify that the test directory exists and clean up output files
TEST_DIR="/tmp/droid-docker-test"
if [ -d "$TEST_DIR" ]; then
    echo "✅ Test directory exists"

    # Remove output files (these are expected from tests)
    rm -f "$TEST_DIR"/output*.log
    echo "✅ Cleaned up test output files"

    # Check that no unexpected files remain
    UNEXPECTED_FILES=$(find "$TEST_DIR" -type f | wc -l)
    if [ "$UNEXPECTED_FILES" -eq 0 ]; then
        echo "✅ Test directory is clean (no unexpected files)"
    else
        echo "❌ Test directory contains $UNEXPECTED_FILES unexpected files"
        find "$TEST_DIR" -type f
        exit 1
    fi
else
    echo "❌ Test directory does not exist"
    exit 1
fi

# Get paths
CUR_PATH="$TEST_DIR"
APP_CACHE="${HOME}/.factoryai-droid-docker/${CUR_PATH}"
ENV_FILE="$APP_CACHE/.env"
GITIGNORE_FILE="$APP_CACHE/.gitignore"
FACTORY_DIR="$APP_CACHE/.factory"

echo "1. Verifying APP_CACHE directory exists..."
if [ -d "$APP_CACHE" ]; then
    echo "   ✅ APP_CACHE exists: $APP_CACHE"
else
    echo "   ❌ APP_CACHE does not exist"
    exit 1
fi

echo "2. Verifying .env file exists and has correct content..."
if [ -f "$ENV_FILE" ]; then
    echo "   ✅ .env file exists"
    echo "   Content:"
    cat "$ENV_FILE"

    # Verify it contains FACTORY_API_KEY with non-blank value
    if grep -Eq "FACTORY_API_KEY='[^']+'" "$ENV_FILE"; then
        echo "   ✅ Contains FACTORY_API_KEY with non-blank value"
    else
        echo "   ❌ Missing FACTORY_API_KEY or has blank value"
        exit 1
    fi
else
    echo "   ❌ .env file does not exist"
    exit 1
fi

echo "3. Verifying .gitignore file exists and has correct content..."
if [ -f "$GITIGNORE_FILE" ]; then
    echo "   ✅ .gitignore file exists"
    echo "   Content:"
    cat "$GITIGNORE_FILE"

    # Verify it contains all expected entries from the script
    EXPECTED_GITIGNORE="# contains API key
.env
# contains API key
**/.factory/settings.json
# can contain API keys
**/.factory/mcp.json"

    if [ "$(cat "$GITIGNORE_FILE")" = "$(echo "$EXPECTED_GITIGNORE")" ]; then
        echo "   ✅ .gitignore content matches expected"
    else
        echo "   ❌ .gitignore content does not match expected"
        echo "   Expected:"
        echo "$EXPECTED_GITIGNORE"
        echo "   Actual:"
        cat "$GITIGNORE_FILE"
        exit 1
    fi
else
    echo "   ❌ .gitignore file does not exist"
    exit 1
fi

echo "4. Verifying .factory directory exists..."
if [ -d "$FACTORY_DIR" ]; then
    echo "   ✅ .factory directory exists: $FACTORY_DIR"
else
    echo "   ❌ .factory directory does not exist"
    exit 1
fi

echo "5. Verifying .env file permissions..."
PERMS=$(stat -c "%a" "$ENV_FILE")
if [ "$PERMS" = "600" ]; then
    echo "   ✅ .env file has correct permissions: $PERMS"
else
    echo "   ❌ .env file has wrong permissions: $PERMS (expected 600)"
    exit 1
fi

echo "6. Showing complete directory structure..."
find "$APP_CACHE" -type f | sort

echo "✅ Structure verification completed successfully"
