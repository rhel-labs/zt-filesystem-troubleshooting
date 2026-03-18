#!/bin/bash
# Module 01 - Introduction
# Validate that the environment is set up correctly

# Check that /app exists and is mounted
if ! mountpoint -q /app; then
    echo "FAIL: /app is not mounted"
    exit 1
fi

# Check that /app is nearly full
USAGE=$(df /app | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$USAGE" -lt 90 ]; then
    echo "FAIL: /app should be nearly full (at least 90% used)"
    exit 1
fi

echo "PASS: Environment is ready"
exit 0
