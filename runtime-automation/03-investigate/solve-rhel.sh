#!/bin/bash
# Module 03 - Solve: Show the investigation commands

echo "=== Solution for Module 03: Investigating Disk Space ==="
echo ""
echo "1. View all block devices:"
echo "   lsblk"
echo ""
lsblk
echo ""
echo "2. Check physical volumes:"
echo "   pvs"
echo ""
pvs
echo ""
echo "   pvdisplay"
echo ""
pvdisplay
echo ""
echo "3. Check volume groups:"
echo "   vgs"
echo ""
vgs
echo ""
echo "   vgdisplay"
echo ""
vgdisplay
echo ""
echo "4. Check logical volumes:"
echo "   lvs"
echo ""
lvs
echo ""
echo "   lvdisplay"
echo ""
lvdisplay
echo ""
echo "=== Key Finding ==="
echo "Notice that the PV only uses ~1GB of the 5GB /dev/vdb disk!"
echo "The remaining ~4GB is unallocated and available for expansion."

exit 0
