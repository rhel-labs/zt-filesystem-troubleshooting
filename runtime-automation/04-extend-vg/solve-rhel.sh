#!/bin/bash
# Module 04 - Solve: Extend the physical volume and verify VG

echo "=== Solution for Module 04: Extending the Volume Group ==="
echo ""
echo "1. Check current PV size:"
echo "   pvs"
echo ""
pvs
echo ""
echo "2. Extend the physical volume to use full disk:"
echo "   pvresize /dev/vdb"
echo ""
pvresize /dev/vdb
echo ""
echo "3. Verify the PV is now larger:"
echo "   pvs"
echo ""
pvs
echo ""
echo "   pvdisplay"
echo ""
pvdisplay
echo ""
echo "4. Check that VG now has free space:"
echo "   vgs"
echo ""
vgs
echo ""
echo "   vgdisplay"
echo ""
vgdisplay
echo ""
echo "=== Success! ==="
echo "The VG now has ~4GB of free space available for the LV."

exit 0
