#!/bin/bash
# Module 03 - Validate investigation

# Verify the PV still only uses ~1GB
PV_SIZE=$(pvs --noheadings --units g -o pv_size /dev/vdb | tr -d ' ' | sed 's/g//' | cut -d. -f1)

if [ "$PV_SIZE" -lt 1 ] || [ "$PV_SIZE" -gt 2 ]; then
    echo "FAIL: PV size unexpected. Should still be ~1GB at this stage."
    exit 1
fi

# Verify VG has no significant free space yet
VG_FREE=$(vgs --noheadings --units g -o vg_free app_vg | tr -d ' ' | sed 's/g//' | cut -d. -f1)
if [ "$VG_FREE" -gt 1 ]; then
    echo "FAIL: VG should not have been extended yet"
    exit 1
fi

echo "PASS: Investigation complete, ready to extend VG"
exit 0
