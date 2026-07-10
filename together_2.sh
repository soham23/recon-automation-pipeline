#!/bin/bash

# -----------------------------------------------------------------------------
# together_2.sh
#
# Performs HTTP reconnaissance.
#
# Workflow:
#   1. Extract resolvable subdomains
#   2. Discover HTTP/HTTPS services using httprobe
#   3. Fingerprint alive web applications using httpq
#   4. Archive HTTP responses
#   5. Generate an HTML HTTP report
#
# Usage:
#   ./together_2.sh <report_directory>
# -----------------------------------------------------------------------------

# Step 1 - Create http_fingerprinting folder & CD into it
report_dir=$1
http_report_dir="http_fingerprinting/"
cd "$report_dir"
mkdir "$http_report_dir"
cd "$http_report_dir"

# Step 2 - Extract resolvable subdomains from the MassDNS output.
massdns_file="../dns_stuff/massdns.out"

awk '{print $1}' "$massdns_file" | sed 's/.$//' > valid_subs.txt


# Step 3 - Assert continuation of the script
no_of_subs=$(wc -l valid_subs.txt | cut -d " " -f 1)
echo "There are $no_of_subs valid subdomains. Proceed with HTTP Fingerprinting?"
read continue_scan

if [ "$continue_scan" != "y" ] && [ "$continue_scan" != "Y" ]; then
	echo "Exiting"
	exit
fi

# Step 4 - Identify subdomains responding over HTTP or HTTPS.
httprobe < valid_subs.txt > alive_subs.txt

# Step 5 - Collect HTTP metadata and save response source code.
mkdir httpq_sources
source_dir="httpq_sources/"
python3 ../../../httpq/httpq_modified.py ./alive_subs.txt -r -o "$source_dir" > httpq_out.txt
awk '{ codes[$2]=$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10} END { for (x in codes) print x">"codes[x]}' httpq_out.txt > url_codes.txt

# Step 5 - Generate Final HTML Report
../../../gen_http_html_report.sh url_codes.txt > http_report.html
xdg-open http_report.html

cd ../../../