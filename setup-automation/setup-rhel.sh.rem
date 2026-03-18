#!/bin/bash
# Setup script for the filesystem troubleshooting lab
# This script configures the RHEL system with a deliberately small LVM volume for /app
# The system has a 30GB disk, but we'll create a 1GB /app volume, leaving ~9GB free for students to extend into

set -e

echo "=== Filesystem Troubleshooting Lab Setup ==="

# Find the root volume group (usually 'rhel' or similar)
echo "Finding root volume group..."
ROOT_VG=$(vgs --noheadings -o vg_name | head -1 | tr -d ' ')

if [ -z "$ROOT_VG" ]; then
    echo "ERROR: Could not find root volume group"
    exit 1
fi

echo "Found root VG: $ROOT_VG"

# Check available free space in the VG
VG_FREE_GB=$(vgs --noheadings --units g -o vg_free $ROOT_VG | tr -d ' ' | sed 's/g//' | cut -d. -f1)
echo "Available free space in VG: ${VG_FREE_GB}GB"

if [ "$VG_FREE_GB" -lt 5 ]; then
    echo "WARNING: Less than 5GB free in VG. Need to make space..."

    # Find the root LV
    ROOT_LV=$(lvs --noheadings -o lv_name,vg_name | grep $ROOT_VG | grep -v swap | head -1 | awk '{print $1}')

    if [ -z "$ROOT_LV" ]; then
        echo "ERROR: Could not find root logical volume"
        exit 1
    fi

    echo "Found root LV: $ROOT_LV"

    # Reduce the root LV by 10GB to free up space
    echo "Reducing root LV size by 10GB to make room for /app..."
    echo "Note: This is Scott's 'optimization' - he made root smaller to save space!"

    # First, shrink the filesystem (only works with ext4, not XFS)
    # For XFS systems, we'll need to work with existing free space
    FS_TYPE=$(lsblk -no FSTYPE /dev/$ROOT_VG/$ROOT_LV)

    if [ "$FS_TYPE" = "xfs" ]; then
        echo "Root filesystem is XFS - cannot shrink. Using existing free space instead."
    else
        # Shrink ext4 filesystem (would need to be unmounted, not practical for root)
        echo "Filesystem shrinking not practical for mounted root. Using existing free space."
    fi
fi

# Create a small logical volume for /app (only 1GB, simulating Scott's mistake)
echo "Creating logical volume for /app with only 1GB..."
echo "This simulates Scott's 'space-saving' configuration!"

lvcreate -L 1G -n app_lv $ROOT_VG

# Format with XFS filesystem
echo "Creating XFS filesystem..."
mkfs.xfs /dev/$ROOT_VG/app_lv

# Create mount point
echo "Creating mount point /app..."
mkdir -p /app

# Add to fstab for persistent mounting
echo "Adding to /etc/fstab..."
echo "/dev/$ROOT_VG/app_lv /app xfs defaults 0 0" >> /etc/fstab

# Mount the filesystem
echo "Mounting filesystem..."
mount /app

# Create some application directories to make it look realistic
echo "Creating application directory structure..."
mkdir -p /app/{data,logs,config,temp}

# Fill up the filesystem to make it nearly full (leaving just a bit of space)
echo "Filling filesystem to simulate the disk space problem..."
# Calculate size to fill (leave about 10MB free)
FREE_SPACE=$(df -BM /app | tail -1 | awk '{print $4}' | sed 's/M//')
FILL_SIZE=$((FREE_SPACE - 10))

if [ $FILL_SIZE -gt 0 ]; then
    dd if=/dev/zero of=/app/data/customer_data.bin bs=1M count=$FILL_SIZE 2>/dev/null || true
fi

# Create some fake log files
for i in {1..5}; do
    echo "Application log entry $i - $(date)" >> /app/logs/app.log
done

# Create a config file
cat > /app/config/app.conf << EOF
# Customer Portal Application Configuration
# Deployed by Manager Scott
database_path=/app/data
log_path=/app/logs
max_file_size=unlimited
# Note from Scott: I configured this perfectly, no issues here!
EOF

# Set permissions
chown -R root:root /app
chmod -R 755 /app

echo ""
echo "=== Setup Complete! ==="
echo "Configuration Summary:"
echo "- Volume Group: $ROOT_VG"
echo "- /app Logical Volume: 1GB (nearly full)"
echo "- Free space in VG for expansion:"
vgs $ROOT_VG
echo ""
echo "Filesystem status:"
df -h /app
echo ""
echo "Scott's misconfiguration is in place - /app is full but VG has free space!"
