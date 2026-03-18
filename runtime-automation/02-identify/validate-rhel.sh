#!/bin/bash
# Module 02 - Validate that user has identified the problem

# Check that the user has run df (we can't actually verify this, so just check the environment)
if ! mountpoint -q /app; then
    echo "FAIL: /app is not mounted"
    exit 1
fi

# Verify /app is still full
USAGE=$(df /app | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$USAGE" -lt 90 ]; then
    echo "FAIL: /app should still be nearly full at this stage"
    exit 1
fi

echo "PASS: Ready to proceed to investigation"
exit 0
