#!/bin/bash
# Module 02 - Solve: Show the solution commands

echo "=== Solution for Module 02: Identifying the Full Filesystem ==="
echo ""
echo "1. Check disk usage:"
echo "   df -h"
echo ""
echo "2. Try to write a test file (this will fail):"
echo "   echo 'Test data' > /app/test.txt"
echo ""
echo "3. Check disk usage in /app:"
echo "   du -sh /app/*"
echo ""
echo "Running these commands now..."
echo ""

df -h
echo ""
echo "Attempting to write test file..."
echo "Test data" > /app/test.txt 2>&1 || echo "As expected, cannot write - disk is full"
echo ""
du -sh /app/*

exit 0
