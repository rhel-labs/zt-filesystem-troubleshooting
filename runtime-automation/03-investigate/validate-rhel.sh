#!/bin/bash
# Module 03 - Validate investigation

# Find the VG containing app_lv
VG_NAME=$(lvs --noheadings -o vg_name app_lv 2>/dev/null | tr -d ' ')

if [ -z "$VG_NAME" ]; then
    echo "FAIL: Could not find app_lv logical volume"
    exit 1
fi

# Verify VG has free space available
VG_FREE=$(vgs --noheadings --units g -o vg_free $VG_NAME | tr -d ' ' | sed 's/g//' | sed 's/\..*//')

if [ "$VG_FREE" -lt 2 ]; then
    echo "FAIL: VG should have at least 2GB of free space for students to extend into"
    echo "Found: ${VG_FREE}GB free"
    exit 1
fi

# Verify app_lv is still small (not extended yet)
LV_SIZE=$(lvs --noheadings --units g -o lv_size app_lv | tr -d ' ' | sed 's/g//' | sed 's/\..*//')

if [ "$LV_SIZE" -gt 2 ]; then
    echo "FAIL: app_lv should still be small at this stage (found ${LV_SIZE}GB)"
    exit 1
fi

echo "PASS: Investigation complete"
echo "VG has ${VG_FREE}GB free, app_lv is ${LV_SIZE}GB - ready to extend!"
exit 0
