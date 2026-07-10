## Modified `httpq`

This project includes a lightly modified version of the open-source **httpq** project.

### Why?

The original `httpq` utility prints useful HTTP metadata such as the response status code and HTML title. During bug bounty reconnaissance, I also wanted to preserve the raw HTTP responses for offline analysis.

Saving the responses allows previously fingerprinted applications to be searched later without repeating the reconnaissance process. For example, if a new technology fingerprint or zero-day vulnerability is disclosed, the archived responses can be searched to quickly identify potentially affected targets.

### What Changed?

A single enhancement was added to the original project:

* Save the HTTP response body for each fingerprinted URL to a user-specified output directory.

The existing fingerprinting behavior, including HTTP status codes and page titles, remains unchanged.

The original project and its Apache License 2.0 are preserved in the `httpq/` directory.
