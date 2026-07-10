# Design Overview

This document describes the design decisions behind the Recon Automation Pipeline.

## Design Goals

The project was designed around three primary goals:

* Automate repetitive reconnaissance tasks.
* Organize scan results into a consistent directory structure.
* Produce reports that are easier to review than raw command-line output.

The project intentionally focuses on orchestration rather than replacing existing reconnaissance tools.

---

## Pipeline Architecture

Rather than implementing custom scanners, the pipeline combines established open-source tools into a single automated workflow.

Each stage produces artifacts that become the input for the next stage.

```
MassDNS
    ↓
Masscan
    ↓
Nmap
    ↓
httprobe
    ↓
httpq
    ↓
HTML Reports
```

This modular approach makes it straightforward to replace or extend individual stages without redesigning the entire pipeline.

---

## Component Responsibilities

### all_together.sh

The main entry point.

Responsible for coordinating the complete reconnaissance workflow and invoking each stage in sequence.

---

### together_1.sh

Handles infrastructure reconnaissance.

Responsibilities include:

* DNS resolution
* Port discovery
* Service detection
* Port report generation

---

### together_2.sh

Handles web reconnaissance.

Responsibilities include:

* HTTP service discovery
* HTTP fingerprinting
* Source code archival
* HTTP report generation

---

### gen_html_report.sh

Generates the HTML report summarizing discovered hosts, open ports, and service information.

---

### gen_http_html_report.sh

Generates the HTML report containing alive URLs, status codes, and page titles.

---

### httpq

A bundled, modified version of the open-source **httpq** project used for HTTP fingerprinting.

The original project and Apache License 2.0 are preserved within the repository.

---

## Output Organization

Each execution creates a dedicated timestamped directory under `reports/`.

This design prevents previous scans from being overwritten and keeps all generated artifacts grouped together.

---

## Design Trade-offs

The pipeline intentionally favors simplicity over feature completeness.

Current design decisions include:

* Sequential execution for easier debugging.
* Linux-only support.
* Reliance on established third-party reconnaissance tools.
* HTML reports for quick manual review.

These choices keep the codebase compact, readable, and easy to modify while still providing a practical reconnaissance workflow.
