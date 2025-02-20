#! /bin/bash

#List the serial number we are targetting
rocket="5C81E704-4277-3D1D-9913-F41D23F86708"

#Determine drive connection state. 1 for connected and 0 for disconnected. Default is disconnected
d_state=0

# Use system_profiler to ge the list of connected drives
connected_drive=$(system_profiler SPUSBDataType | grep 'Volume UUID' | awk '{print $3}')

#Tell the user the uuid that is connected
echo "The currently connected drive is "$connected_drive""

# Logic
if [[ "$connected_drive" == "5C81E704-4277-3D1D-9913-F41D23F86708" ]]; then 
	echo "drive is connected"
	d_state=1
else
	echo "Drive not detected."
	d_state=0
fi

#checking if the drive is mounted

drive_ID="ROCKET-nano"

if mount | grep -q "$drive_ID"; then
	echo "$drive_ID is already mounted."
else
	if [ d_state == 1 ]; then
		echo "$drive_ID is not mounted. Attempting to mount..."
	else
		echo "$drive_ID is not connected. Skipping mount"
	fi
	echo $d_state
fi


# Get the mount point of the rocket nano using the volume name

mount=$(mount | grep "$drive_ID" | awk '{print $3}')

if [ -z "$mount" ]; then
	echo "Volume $drive_ID is not mounted."
else
	echo "Volume $drive_ID is mounted at $mount."
fi

# Mount the drive if it's not already mounted


#Set Folder Structure

# Define the target backup directory
backup_dir="$mount/MacUp"

# Check if the directory exists
if [ ! -d "$backup_dir" ]; then
    echo "Backup directory not found. Creating $backup_dir..."
    mkdir -p "$backup_dir"
    if [ $? -eq 0 ]; then
        echo "Directory created successfully."
    else
        echo "Failed to create directory."
        exit 1
    fi
else
    echo "Backup directory already exists at $backup_dir."
fi

#Making the directory structure
# Get the computer name
hostname=$(scutil --get ComputerName)

# Define the backup directory
backup_dir="$mount/MacUp/$hostname/$(date +%Y-%m-%d)"


# Check if the directory exists
if [ ! -d "$backup_dir" ]; then
    echo "Backup directory not found. Creating $backup_dir..."
    mkdir -p "$backup_dir"
    if [ $? -eq 0 ]; then
        echo "Directory created successfully at $backup_dir."
    else
        echo "Failed to create directory."
        exit 1
    fi
else
    echo "Backup directory already exists at $backup_dir."
fi


# Define log file location
log_file="$backup_dir/backup_log.txt"

# Start logging
echo "Backup started at $(date)" >> "$log_file"

#Writing files with rsync

backup_source=("$HOME/Documents" "$HOME/Desktop" "$HOME/Pictures")  # Add more folders if needed

for folder in "${backup_source[@]}"; do
    if [ -d "$folder" ]; then
        echo "Syncing $folder to $backup_dir..."
        rsync -av --progress "$folder" "$backup_dir/" 2>&1 | tee -a "$log_file"
    else
        echo "Skipping $folder (not found)."
    fi
done

#end log
echo "Backup completed at $(date)" >> "$log_file"
