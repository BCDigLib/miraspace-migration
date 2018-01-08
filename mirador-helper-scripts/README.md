## add_manifests.js
This script creates a Mirador Javascript object containing links to IIIF
manifests on library.bc.edu, which can be added to an existing Mirador instance.

This is for testing purposes only, as we probably won't need a public-facing list
of all digital objects in Mirador.

Usage:
1. Install [nodejs](https://nodejs.org/en/) or another javascript runtime.
2. Create txt file with manifest locations by running the following from the
directory where your manifests are located:
```bash
for manifest in manifests/*.json; do echo "https://library.bc.edu/iiif/manifests/$manifest" >> manifests.txt; done
```
3. Copy the output to Mirador's index.html file. Rather than copying the whole
Mirador Javascript object, add its contents to the existing Mirador object so
you don't overwrite any manifest links that are already in the viewer.
