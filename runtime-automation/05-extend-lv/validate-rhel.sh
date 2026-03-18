#!/bin/bash
# Module 05 - Validate that LV and filesystem have been extended

# Check that LV has been extended
LV_SIZE=$(lvs --noheadings --units g -o lv_size /dev/app_vg/app_lv | tr -d ' ' | sed 's/g//' | sed 's/\..*//')

if [ "$LV_SIZE" -lt 4 ]; then
    echo "FAIL: Logical volume has not been extended. Expected ~5GB, got ${LV_SIZE}GB"
    echo "HINT: Run 'lvextend -l +100%FREE /dev/app_vg/app_lv'"
    exit 1
fi

# Check that filesystem has been resized
FS_SIZE=$(df -BG /app | tail -1 | awk '{print $2}' | sed 's/G//')

if [ "$FS_SIZE" -lt 4 ]; then
    echo "FAIL: Filesystem has not been resized. Expected ~5GB, got ${FS_SIZE}GB"
    echo "HINT: Run 'xfs_growfs /app' or 'resize2fs /dev/app_vg/app_lv' depending on filesystem type"
    exit 1
fi

# Check that filesystem is no longer full
USAGE=$(df /app | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$USAGE" -gt 50 ]; then
    echo "FAIL: Filesystem should have more free space now. Currently ${USAGE}% used"
    exit 1
fi

# Test that we can write to the filesystem
if ! echo "Validation test" > /app/.validation_test 2>/dev/null; then
    echo "FAIL: Cannot write to /app filesystem"
    exit 1
fi
rm -f /app/.validation_test

echo "PASS: Logical volume and filesystem have been successfully extended!"
echo "Filesystem now has plenty of free space (${USAGE}% used)."
echo ""
echo "=== Congratulations! ==="
echo "You have successfully resolved the disk space issue!"
echo "The application can now write data to /app without errors."

exit 0
