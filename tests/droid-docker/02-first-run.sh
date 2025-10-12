#!/usr/bin/env bash
# Test 02: First Run Scenario
# Purpose: Test first run of droid-docker script with valid API key
# Usage: ./02-first-run.sh

set -euo pipefail

echo "=== Test 02: First Run Scenario ==="

# Get the real API key from project's .env file
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REAL_API_KEY=$(grep FACTORY_API_KEY "$SCRIPT_DIR/../../.env" | cut -d'=' -f2 | tr -d "'")

if [ -z "$REAL_API_KEY" ]; then
    echo "❌ Could not find FACTORY_API_KEY in $SCRIPT_DIR/../../.env"
    exit 1
fi

echo "Found API key from project .env file"

# Create test directory in /tmp and cd to it
TEST_DIR="/tmp/droid-docker-test"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "Testing from directory: $(pwd)"

# Verify clean starting state - entire .factoryai-droid-docker should not exist
FACTORY_BASE="${HOME}/.factoryai-droid-docker"
if [ -d "$FACTORY_BASE" ]; then
    echo "❌ $FACTORY_BASE already exists - run cleanup first"
    exit 1
fi

echo "✅ Confirmed clean starting state"

# Use SCRIPT_DIR to get path to droid-docker script
DROID_DOCKER="$SCRIPT_DIR/../../droid-docker"

# Run the script with timeout and pseudo-TTY (from the test directory)
echo "Running droid-docker script from test directory..."
cd "$TEST_DIR"
timeout 10s script -q -c "$DROID_DOCKER <<< '$REAL_API_KEY'" /dev/null > output.log 2>&1

# Check if script ran successfully
if [ $? -eq 124 ]; then
    echo "❌ Script timed out after 10 seconds"
    echo "Output was:"
    cat output.log
    exit 1
fi

echo "✅ Script completed within timeout"

# Analyze output for success indicators
if grep -q "Welcome to Factory CLI" output.log; then
    echo "✅ Found 'Welcome to Factory CLI' - API key is valid and Docker started"
elif grep -q "Please login or create a Factory account to continue" output.log; then
    echo "❌ Found 'Please login or create a Factory account to continue' - API key is invalid"
    echo "Output was:"
    cat output.log
    exit 1
elif grep -q "API key saved to" output.log; then
    echo "⚠️  API key was saved but Docker container may have failed to start"
    echo "This suggests script setup works but Docker/environment issue"
    echo "Output was:"
    cat output.log
    # For now, let's fail the test since Docker should start
    exit 1
else
    echo "❌ Expected success message not found in output"
    echo "Output was:"
    cat output.log
    exit 1
fi

echo "✅ First run test completed successfully"
