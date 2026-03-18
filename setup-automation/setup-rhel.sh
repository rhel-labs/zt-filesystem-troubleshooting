#!/bin/bash
# Setup script for the filesystem troubleshooting lab
# This script configures the RHEL system with a deliberately misconfigured LVM setup

set -e

# Wait for the second disk to be available
echo "Waiting for additional disk to be available..."
timeout=60
elapsed=0
while [ ! -b /dev/vdb ] && [ $elapsed -lt $timeout ]; do
    sleep 1
    elapsed=$((elapsed + 1))
done

if [ ! -b /dev/vdb ]; then
    echo "ERROR: /dev/vdb not found after ${timeout} seconds"
    exit 1
fi

echo "Found /dev/vdb"

# Create a physical volume using only 1GB of the 5GB disk
# This simulates Scott's "configuration mistake"
echo "Creating physical volume with only 1GB of 5GB disk..."
pvcreate --setphysicalvolumesize 1G /dev/vdb

# Create volume group
echo "Creating volume group app_vg..."
vgcreate app_vg /dev/vdb

# Create logical volume using most of the available space (leaving a tiny bit free)
echo "Creating logical volume app_lv..."
lvcreate -l 95%FREE -n app_lv app_vg

# Format with XFS filesystem
echo "Creating XFS filesystem..."
mkfs.xfs /dev/app_vg/app_lv

# Create mount point
echo "Creating mount point /app..."
mkdir -p /app

# Add to fstab for persistent mounting
echo "Adding to /etc/fstab..."
echo "/dev/app_vg/app_lv /app xfs defaults 0 0" >> /etc/fstab

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

echo "Setup complete!"
echo "Filesystem is now nearly full as expected."
df -h /app
