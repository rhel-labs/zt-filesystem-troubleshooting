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
echo "3. Check volume groups:"
echo "   vgs"
echo ""
vgs
echo ""
echo "   vgdisplay (for details)"
echo ""
vgdisplay
echo ""
echo "4. Check logical volumes:"
echo "   lvs"
echo ""
lvs
echo ""
echo "   lvdisplay (for app_lv details)"
echo ""
lvdisplay app_lv
echo ""
echo "=== Key Finding ==="
echo "Notice that:"
echo "- The app_lv logical volume is only ~1GB"
echo "- The volume group has several GB of FREE space"
echo "- This free space is available for extending the LV!"
echo ""
echo "Scott created a small LV but left plenty of space in the VG."

exit 0
