#!/bin/bash

# -----------------------------------------------------------------------------
# all_together.sh
#
# Entry point for the Recon Automation Pipeline.
#
# Creates a timestamped report directory and executes the two major stages:
#   1. Infrastructure reconnaissance (DNS resolution, port scanning, Nmap)
#   2. HTTP fingerprinting and report generation
#
# Usage:
#   ./all_together.sh <subdomain_file>
# -----------------------------------------------------------------------------

REPORTS_DIR="./reports/"

## Step 1 - Create Report Folder with Current Timestamp & CD into it
timestamp=$(date +%Y-%m-%d:%H:%M)
report_dir="$REPORTS_DIR""report_"$timestamp

mkdir -p "$report_dir"

## Step 2 - Execute together_1.sh with the subdomains list (Full Path)
echo "Executing together_1.sh"
./together_1.sh "$1" "$rep_folder"
echo "Finished Executing together_1.sh"

## Step 3 - Execute together_2.sh
echo "Executing together_2.sh"
./together_2.sh "$rep_folder"
echo "Finished Executing together_2.sh"