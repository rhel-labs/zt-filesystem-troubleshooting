#!/bin/bash
# Module 04 - Solve: Verify available space in VG

# Find VG name
VG_NAME=$(lvs --noheadings -o vg_name app_lv 2>/dev/null | tr -d ' ')

echo "=== Solution for Module 04: Verifying Available Space ==="
echo ""
echo "1. Check volume group status:"
echo "   vgs $VG_NAME"
echo ""
vgs $VG_NAME
echo ""
echo "2. Check detailed VG information:"
echo "   vgdisplay $VG_NAME"
echo ""
vgdisplay $VG_NAME
echo ""
echo "3. Check current logical volume size:"
echo "   lvs app_lv"
echo ""
lvs app_lv
echo ""
echo "4. Check current filesystem usage:"
echo "   df -h /app"
echo ""
df -h /app
echo ""
echo "=== Key Findings ==="
echo "- Volume group has several GB of FREE space"
echo "- The app_lv is only ~1GB"
echo "- The /app filesystem is nearly full"
echo "- We can extend app_lv using the VG's free space!"
echo ""
echo "Ready to extend the logical volume in the next module!"

exit 0
