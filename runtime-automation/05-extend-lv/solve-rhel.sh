#!/bin/bash
# Module 05 - Solve: Extend the logical volume and filesystem

# Find VG name
VG_NAME=$(lvs --noheadings -o vg_name app_lv 2>/dev/null | tr -d ' ')

echo "=== Solution for Module 05: Extending the Logical Volume and Filesystem ==="
echo ""
echo "1. Check current LV size:"
echo "   lvs app_lv"
echo ""
lvs app_lv
echo ""
echo "2. Check current filesystem size:"
echo "   df -h /app"
echo ""
df -h /app
echo ""
echo "3. Extend the logical volume to use all free space:"
echo "   lvextend -l +100%FREE /dev/$VG_NAME/app_lv"
echo ""
lvextend -l +100%FREE /dev/$VG_NAME/app_lv
echo ""
echo "4. Verify LV is now larger:"
echo "   lvs"
echo ""
lvs
echo ""
echo "5. Check filesystem type:"
echo "   df -T /app"
echo ""
FS_TYPE=$(df -T /app | tail -1 | awk '{print $2}')
df -T /app
echo ""
echo "6. Resize the filesystem (filesystem type: $FS_TYPE):"

if [ "$FS_TYPE" = "xfs" ]; then
    echo "   xfs_growfs /app"
    echo ""
    xfs_growfs /app
elif [ "$FS_TYPE" = "ext4" ] || [ "$FS_TYPE" = "ext3" ] || [ "$FS_TYPE" = "ext2" ]; then
    echo "   resize2fs /dev/app_vg/app_lv"
    echo ""
    resize2fs /dev/app_vg/app_lv
else
    echo "   Unknown filesystem type: $FS_TYPE"
    exit 1
fi

echo ""
echo "7. Verify the filesystem is now larger:"
echo "   df -h /app"
echo ""
df -h /app
echo ""
echo "8. Test writing a file:"
echo "   echo 'Success!' > /app/test.txt"
echo ""
echo "Success! The filesystem is no longer full." > /app/test.txt
cat /app/test.txt
rm /app/test.txt
echo ""
echo "=== Success! ==="
echo "The /app filesystem now has plenty of space!"

exit 0
