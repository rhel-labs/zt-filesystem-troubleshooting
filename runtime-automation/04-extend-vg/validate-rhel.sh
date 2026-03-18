#!/bin/bash
# Module 04 - Validate that PV and VG have been extended

# Check that PV has been extended to use most of the 5GB disk
PV_SIZE=$(pvs --noheadings --units g -o pv_size /dev/vdb | tr -d ' ' | sed 's/g//' | sed 's/\..*//')

if [ "$PV_SIZE" -lt 4 ]; then
    echo "FAIL: Physical volume has not been extended. Expected ~5GB, got ${PV_SIZE}GB"
    echo "HINT: Run 'pvresize /dev/vdb' to extend the PV"
    exit 1
fi

# Check that VG has significant free space now
VG_FREE=$(vgs --noheadings --units g -o vg_free app_vg | tr -d ' ' | sed 's/g//' | sed 's/\..*//')

if [ "$VG_FREE" -lt 3 ]; then
    echo "FAIL: Volume group does not have enough free space. Expected ~4GB free, got ${VG_FREE}GB"
    exit 1
fi

echo "PASS: Physical volume and volume group have been extended successfully!"
echo "VG now has ${VG_FREE}GB of free space available."
exit 0
