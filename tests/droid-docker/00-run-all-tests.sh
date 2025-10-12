#!/usr/bin/env bash
# Master Test Runner
# Purpose: Orchestrate the testing loop with 3-iteration limit
# Usage: ./00-run-all-tests.sh

set -euo pipefail

echo "=== Droid-Docker Test Suite ==="
echo "Starting test loop with 3-iteration limit..."
echo

# Track overall success
OVERALL_SUCCESS=false

for iteration in 1 2 3; do
    echo "=== Test Iteration $iteration ==="

    # Run all tests
    echo "Running cleanup..."
    if ./01-cleanup.sh; then
        echo "✅ Cleanup passed"
    else
        echo "❌ Cleanup failed"
        continue
    fi

    echo "Running first run test..."
    if ./02-first-run.sh; then
        echo "✅ First run test passed"
    else
        echo "❌ First run test failed"
        continue
    fi

    echo "Running consecutive run test..."
    if ./03-consecutive-run.sh; then
        echo "✅ Consecutive run test passed"
    else
        echo "❌ Consecutive run test failed"
        continue
    fi

    echo "Running structure verification..."
    if ./04-verify-structure.sh; then
        echo "✅ Structure verification passed"
    else
        echo "❌ Structure verification failed"
        continue
    fi

    # If we get here, all tests passed
    echo
    echo "🎉 SUCCESS! All tests passed in iteration $iteration"
    OVERALL_SUCCESS=true
    break

done

echo
if [ "$OVERALL_SUCCESS" = true ]; then
    echo "=== FINAL RESULT: SUCCESS ==="
    echo "All tests passed! The droid-docker script is working correctly."
    exit 0
else
    echo "=== FINAL RESULT: FAILURE ==="
    echo "Tests failed after 3 iterations."
    echo "Need to adapt testing approach or fix script issues."
    exit 1
fi
