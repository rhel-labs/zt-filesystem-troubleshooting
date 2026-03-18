#!/bin/bash
# Module 04 - Validate that VG free space has been verified

# Find the VG containing app_lv
VG_NAME=$(lvs --noheadings -o vg_name app_lv 2>/dev/null | tr -d ' ')

if [ -z "$VG_NAME" ]; then
    echo "FAIL: Could not find app_lv logical volume"
    exit 1
fi

# Check that VG still has free space (hasn't been allocated to LV yet)
VG_FREE=$(vgs --noheadings --units g -o vg_free $VG_NAME | tr -d ' ' | sed 's/g//' | sed 's/\..*//')

if [ "$VG_FREE" -lt 2 ]; then
    echo "FAIL: Volume group should still have free space. Found ${VG_FREE}GB"
    exit 1
fi

# Verify app_lv hasn't been extended yet
LV_SIZE=$(lvs --noheadings --units g -o lv_size app_lv | tr -d ' ' | sed 's/g//' | sed 's/\..*//')

if [ "$LV_SIZE" -gt 2 ]; then
    echo "FAIL: Logical volume should not be extended yet (found ${LV_SIZE}GB)"
    echo "Save the extension for the next module!"
    exit 1
fi

echo "PASS: Volume group space verified!"
echo "VG has ${VG_FREE}GB available for extending app_lv (currently ${LV_SIZE}GB)"
echo "Ready to extend the logical volume!"
exit 0
