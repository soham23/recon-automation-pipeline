#!/bin/bash

# -----------------------------------------------------------------------------
# gen_html_report.sh
#
# Generates the HTML port scanning report.
#
# Inputs:
#   1. ips-ports.txt
#   2. subs-ips.txt
#
# Output:
#   HTML report written to stdout.
#
# The report correlates:
#   - Subdomains
#   - Resolved IP addresses
#   - Open ports
#   - Individual Nmap scan results
# -----------------------------------------------------------------------------

declare -A ip_to_ports
external_js="js_files/ports.js"
external_css="js_files/ports.css"
http_report_url="http_fingerprinting/http_report.html?sub="

echo '<html><head><title>Port Scanning Report For Your Target</title><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">'
echo "<link rel=\"stylesheet\" href=\"$external_css\"></head>"
echo '<body><table class="table table-striped" id="example"><thead><tr id="my-header-123"><th scope="col">#</th><th scope="col">Subdomain</th><th scope="col">Resolved IP Address</th><th scope="col">No of Open Ports</th><th scope="col">Open Ports</th></tr></thead><tfoot><tr id="my-header-123"><th scope="col">#</th><th scope="col">Subdomain</th><th scope="col">Resolved IP Address</th><th scope="col">No of Open Ports</th><th scope="col">Open Ports</th></tr></tfoot><tbody>'

# Build a lookup table mapping IP addresses to their open ports.
while read line; do
  fields=($(echo $line | tr ' ' '\n'))
  ip="${fields[0]}"
  ports="${fields[1]}"
  ports=${ports:0:-1}
  ip_to_ports[$ip]=$ports
done < "$1"

# Correlate subdomains with IP addresses and generate table rows.
count=1
while read line; do
  fields=($(echo $line | tr '>' '\n'))
  sub="${fields[0]}"
  ips="${fields[1]}"
  sub=${sub:0:-1}
  ips=${ips:0:-1}
  ip_list=($(echo $ips | tr ',' '\n'))

  for i in "${ip_list[@]}"
  do
  	ports="${ip_to_ports[$i]}"
  	commas="${ports//[^,]}"
  	no_of_ports=$(( ${#commas} + 1 ))

  	if [ $no_of_ports -gt 2 ]
  	then
  		echo "<tr class=\"table-warning\"><td scope=\"row\">$count</td><td><a href=\"$http_report$sub\" target=\"_blank\">$sub</a></td><td><a href=\"nmap_scans/$i.txt\" target=\"_blank\">$i</a></td><td>$no_of_ports</td><td>$ports</td></tr>"
  	else
  		echo "<tr><td scope=\"row\">$count</td><td><a href=\"$http_report_url$sub\" target=\"_blank\">$sub</a></td><td><a href=\"nmap_scans/$i.txt\" target=\"_blank\">$i</a></td><td>$no_of_ports</td><td>$ports</td></tr>"
  	fi

  	count=$((count + 1))
  done
done <"$2"

echo '</tbody></table><script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script><script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script><script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script><script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>'
echo "<script src=\""$external_js"\"></script></body></html>"