## Mirador Utilities and Stylesheets
#### add_manifests.js
Creates a Mirador Javascript object containing links to IIIF
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

#### mirador-bc.css
Includes local customizations to Mirador's appearance. This stylesheet should be 
loaded after 'mirador-combined.css'.

#### mirador-plugins
A plugin suite developed by the Bavarian State Library. We currently use the 
Bookmarkable Viewer State Plugin, or [ViewFromUrl](https://github.com/dbmdz/mirador-plugins#bookmarkable-viewer-state),
to link directly to manifests and canvases.

## Mirador Usage Notes
#### Linking to thumbnails, manifests, and canvases
To request a thumbnail, use the syntax provided by the [IIIF Image API](http://iiif.io/api/image/2.1/#image-request-uri-syntax). 
The parameters can be adjusted as needed. E.g., to request a 200x200 thumbnail: 
http://loris_server.bc.edu/image_id.jp2/full/!200,200/0/default.jpg

We use a [Bavarian State Library plugin](https://github.com/dbmdz/mirador-plugins#bookmarkable-viewer-state) 
to link directly to manifests and canvases. Links should be constructed using query 
string syntax, e.g.: 

```
http://mirador_server.bc.edu/mirador_dir/?view=ImageView&manifest=https://library.bc.edu/path_to_manifest.json&canvas=http://loris_server.bc.edu/canvas_id/page_id
```

In the example above, the canvas parameter is optional. The view parameter can be 
set to any of the following:

* ImageView (preferred): loads specified canvas (defaults to first in sequence) 
with other canvases listed below 
* BookView: loads two canvases in the viewer at once
* ThumbnailsView: lists all canvases in a gallery view

#### Generating manifests
[metsiiif](https://github.com/BCLibraries/mets-to-iiif) is a Ruby gem that converts 
a METS file to a IIIF manifest. This has been tested only with METS that conforms 
to the BC application profile. We will publish it to rubygems.org once we confirm 
broader compatibility. Feeback and pull requests are welcome.
