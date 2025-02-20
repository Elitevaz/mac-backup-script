# Macup

This script is designed to make an automated simple backup to an external drive on Mac. In this code it is hard coded to a specific drive, but improvements will likely include a way to select a drive. This is a personal project and my original idea was to have some folders get copied to a directory on this drive upon connection. Other drives would be ignored.

## Features

- Identify and mount the external drive if it matches the serial number
- Backs up user and picture folder while ignoring system files
- retain only 90 days worth of files

## Installation

Download backup_script.sh to your computer and then run from shell

## Usage

If you want to use this, you will need to edit the script to have the serial that you want targetting. Then you would just run backup_script.sh in your terminal application on your mac.

## Requirements

MacOS or Linux
diskutil is used to get the serial number
a shell interface like terminal



