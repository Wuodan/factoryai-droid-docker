#!/usr/bin/env bash
# Master Test Runner
# Purpose: Run the complete droid-docker test suite once
# Usage: ./00-run-all-tests.sh

set -euo pipefail

echo "=== Droid-Docker Test Suite ==="
echo "Running complete test suite..."
echo

# Run all tests in sequence
echo "1. Running cleanup..."
if ./01-cleanup.sh; then
    echo "   ✅ Cleanup passed"
else
    echo "   ❌ Cleanup failed"
    exit 1
fi

echo "2. Running first run test..."
if ./02-first-run.sh; then
    echo "   ✅ First run test passed"
else
    echo "   ❌ First run test failed"
    exit 1
fi

echo "3. Running consecutive run test..."
if ./03-subsequent-run.sh; then
    echo "   ✅ Consecutive run test passed"
else
    echo "   ❌ Consecutive run test failed"
    exit 1
fi

echo "4. Running structure verification..."
if ./04-verify-structure.sh; then
    echo "   ✅ Structure verification passed"
else
    echo "   ❌ Structure verification failed"
    exit 1
fi

echo
echo "🎉 SUCCESS! All tests passed!"
echo "The droid-docker script is working correctly."
echo
echo "=== Test Summary ==="
echo "✅ Script setup and API key management works"
echo "✅ Docker container starts successfully"
echo "✅ File permissions and structure are correct"
echo "✅ Consecutive runs work without prompting"

exit 0
