#!/bin/bash

# -----------------------------------------------------------------------------
# together_1.sh
#
# Performs infrastructure reconnaissance.
#
# Workflow:
#   1. Resolve subdomains using MassDNS
#   2. Scan common ports using Masscan
#   3. Perform Nmap service detection on open ports
#   4. Generate an HTML port scanning report
#
# Usage:
#   ./together_1.sh <subdomain_file> <report_directory>
# -----------------------------------------------------------------------------

subdomain_file=$1
report_dir=$2

cd "$report_dir"

## Step 1 - Create DNS Folder & CD into it
mkdir dns_stuff
cd dns_stuff

## Step 2 - Resolve Subdomains
massdns -s 100 -r ../../../wordlists/resolvers-trusted.txt -t A -o S -w massdns.out "$subdomain_file"

## Step 3 - Extract unique IP addresses from the MassDNS results.
awk '{print $3}' massdns.out | sort -u | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" > ips-online.txt
no_of_ips=$(wc -l ips-online.txt | cut -d " " -f 1)
echo "There are $no_of_ips IP addresses. Proceed with port scanning (y/n) ?"
read isPort

if [ "$isPort" != "y" ] && [ "$isPort" != "Y" ]; then
	echo "Exiting"
	exit
fi

## Step 4 - Scan a predefined list of commonly exposed service ports.
common_ports="3868,3366,8443,8080,9443,9091,3000,8000,5900,8081,6000,10000,8181,3306,5000,4000,8888,5432,15672,9999,161,4044,7077,4040,9000,8089,443,7447,7080,8880,8983,5673,7443,80,21,22"
extra_ports="9200,2375"
sudo masscan -iL ips-online.txt -p "${common_ports},${extra_ports}" -oL massscan.out
grep -v "#masscan" massscan.out | grep -v "#end" | awk '{x[$4] = $3","x[$4]} END { for (g in x) print g,x[g] }' | sort -u | grep -v " ," > ips-ports.txt

## Step 5 - Run Nmap service detection only against the ports discovered by Masscan.
mkdir nmap_scans
awk '{ print "sudo nmap -sV -p",$2,$1,"-oN nmap_scans/"$1".txt"}' ips-ports.txt | bash -

## Step 6 - Correlate resolved subdomains with IPs and generate the HTML report.
awk '{ if ($2=="A") ips[$1]=$3","ips[$1] } END { for (x in ips) print x">"ips[x] }' massdns.out > subs-ips.txt
../../../gen_html_report.sh ips-ports.txt subs-ips.txt > port_scanning_report.html
xdg-open port_scanning_report.html

cd ../../../