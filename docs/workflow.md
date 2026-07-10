# Recon Automation Pipeline Workflow

This document describes the end-to-end workflow executed by the Recon Automation Pipeline.

## Overview

The pipeline automates post-enumeration reconnaissance by combining several open-source tools into a single workflow. Starting from a list of subdomains, it performs DNS resolution, port scanning, service detection, HTTP fingerprinting, and generates HTML reports summarizing the results.

```
Input Subdomains
        │
        ▼
MassDNS Resolution
        │
Resolvable Hosts
        │
        ▼
Masscan
        │
Open Ports
        │
        ▼
Nmap Service Detection
        │
        ▼
Port Scanning HTML Report
        │
────────├──────────────
        ▼              
HTTP Discovery         
 (httprobe)            
        │              
Alive URLs             
        │              
        ▼              
HTTP Fingerprinting    
 (httpq)               
        │
        ▼
Save HTTP Source Code
        │
        ▼
HTTP HTML Report
```

---

## Step 1 – DNS Resolution

The supplied subdomains are resolved using **MassDNS**.

Only successfully resolved subdomains continue through the pipeline. This avoids unnecessary scanning of invalid or inactive assets.

Output:

* `massdns.out`
* `subs-ips.txt`

---

## Step 2 – Port Discovery

The resolved IP addresses are scanned using **Masscan** against a predefined list of commonly used ports.

Only hosts with open ports continue to service detection.

Output:

* `massscan.out`
* `ips-ports.txt`

---

## Step 3 – Service Detection

Each discovered host is scanned with **Nmap** using service detection against only the open ports identified during the previous stage.

This significantly reduces scan time compared to scanning every host with a full Nmap scan.

Output:

* Individual Nmap scan files
* Port scanning HTML report

---

## Step 4 – HTTP Discovery

Resolvable subdomains are checked using **httprobe** to determine whether they expose an HTTP or HTTPS service.

Only reachable web services continue to HTTP fingerprinting.

Output:

* `alive_subs.txt`

---

## Step 5 – HTTP Fingerprinting

Alive web applications are processed using a modified version of **httpq**.

For each URL the pipeline records:

* HTTP status code
* HTML page title

The HTML source code is also archived for future offline analysis.

Output:

* `httpq_out.txt`
* `httpq_sources/`

---

## Step 6 – Report Generation

Two HTML reports are generated.

### Port Scanning Report

Contains:

* IP address
* Corresponding subdomain
* Open ports
* Number of open ports

### HTTP Report

Contains:

* Alive URL
* HTTP status code
* HTML title

---

## Generated Artifacts

Each execution creates a timestamped report directory containing:

* DNS resolution output
* Masscan output
* Nmap scans
* HTTP fingerprinting output
* Archived HTTP responses
* HTML reports

This organization allows previous reconnaissance runs to be preserved for future reference.

## Architecture

The project is organized as a linear pipeline.

The main entry point (`all_together.sh`) creates a timestamped report directory and orchestrates two independent stages:

- Infrastructure reconnaissance (`together_1.sh`)
- HTTP reconnaissance (`together_2.sh`)

Each stage is responsible for producing the input required by the next stage while preserving all intermediate artifacts.

Report generation is intentionally separated into dedicated scripts (`gen_html_report.sh` and `gen_http_html_report.sh`) to keep data collection and presentation independent.

This modular structure makes each stage easier to understand, maintain, and modify without affecting the overall workflow.