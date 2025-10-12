#!/usr/bin/env bash
# Test 03: Consecutive Run Scenario
# Purpose: Test that second run of droid-docker works without API key prompt
# Usage: ./03-consecutive-run.sh

set -euo pipefail

echo "=== Test 03: Consecutive Run Scenario ==="

# Use the same test directory as test 02
TEST_DIR="/tmp/droid-docker-test"
cd "$TEST_DIR"

echo "Testing from directory: $(pwd)"

# Verify that APP_CACHE structure exists from previous test
FACTORY_BASE="${HOME}/.factoryai-droid-docker"
CUR_PATH="$(pwd)"
APP_CACHE="${FACTORY_BASE}/${CUR_PATH}"

if [ ! -d "$APP_CACHE" ]; then
    echo "❌ APP_CACHE does not exist - run test 02 first"
    exit 1
fi

if [ ! -f "$APP_CACHE/.env" ]; then
    echo "❌ .env file does not exist - run test 02 first"
    exit 1
fi

echo "✅ Confirmed APP_CACHE structure exists from previous test"

# Get absolute path to droid-docker script using SCRIPT_DIR method
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DROID_DOCKER="$SCRIPT_DIR/../../droid-docker"

# Run the script again - should NOT prompt for API key
echo "Running droid-docker script again (should use existing .env)..."
timeout 10s "$DROID_DOCKER" > output2.log 2>&1

# Check if script ran successfully
if [ $? -eq 124 ]; then
    echo "❌ Script timed out after 10 seconds"
    echo "Output was:"
    cat output2.log
    exit 1
fi

echo "✅ Script completed within timeout"

# Analyze output - should NOT contain API key prompt
if grep -q "FACTORY_API_KEY not found" output2.log; then
    echo "❌ Script prompted for API key again (should not happen)"
    echo "Output was:"
    cat output2.log
    exit 1
fi

echo "✅ No API key prompt - using existing .env correctly"

# Check for success indicators
if grep -q "Welcome to Factory CLI" output2.log; then
    echo "✅ Found 'Welcome to Factory CLI' - consecutive run successful"
elif grep -q "Please login or create a Factory account to continue" output2.log; then
    echo "❌ Found login error - API key may be invalid"
    echo "Output was:"
    cat output2.log
    exit 1
else
    echo "❌ Expected success message not found in output"
    echo "Output was:"
    cat output2.log
    exit 1
fi

echo "✅ Consecutive run test completed successfully"
