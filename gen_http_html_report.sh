#!/bin/bash

# -----------------------------------------------------------------------------
# gen_http_html_report.sh
#
# Generates the HTML HTTP fingerprinting report.
#
# Input:
#   1. url_codes.txt
#
# Output:
#   HTML report written to stdout.
#
# The report correlates:
#   - Alive URLs
#   - HTTP status codes
#   - HTML titles
#   - Saved HTTP response source code
#   - Corresponding port scan results
# -----------------------------------------------------------------------------

external_js="js_files/http.js"
external_css="js_files/http.css"

echo '<html><head><title>HTTP Fingerprinting Report For Your Target</title><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">'
echo "<link rel=\"stylesheet\" href=\"$external_css\"></head>"
echo '<body><table class="table table-striped" id="example"><thead><tr id="my-header-123"><th scope="col">#</th><th scope="col">URL</th><th scope="col">Status Code & Title</th><th scope="col">HTTPQ Source Code</th><th>Port Scans</th></tr><tbody>'

port_report_url="../dns_stuff/port_scanning_report.html?sub="

# Generate one table row for each fingerprinted URL.
count=1
while read line; do
  fields=($(echo $line | tr '>' '\n'))
  sub="${fields[0]}"
  hostname=${sub/"https://"/""}
  hostname=${dom/"http://"/""}
  hostname=${dom:0:-1}

  protocol="${sub%%://*}"     
  rest="${sub#*://}"          
  host="${rest%%/*}"          

  # Construct the expected filename for the archived HTTP response.
  source_filename="${protocol}.${host}"
  httpq_source_file="httpq_sources/"$source_filename".txt"

  if [ ! -f "$httpq_source_file" ]; then
    httpq_source_file="${httpq_source_file/http./http.www.}"
    httpq_source_file="${httpq_source_file/https./https.www.}"
  fi

  echo "<tr><td scope=\"row\">$count</td><td><a href=\"$sub\" target=\"_blank\">$sub</a></td><td>$status_code</td><td><a href=\"$httpq_source_file\" target=\"_blank\">View Source</a></td>"

  echo "<td><a href=\"$port_report_url$dom\" target=\"_blank\">Ports</a></td></tr>"

  count=$((count + 1))
done < "$1"

echo '</tbody></table><script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script><script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script><script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script><script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>'
echo "<script src=\""$external_js"\"></script></body></html>"