## Mirador Utilities and Stylesheets
#### add_manifests.js
Generates HTML landing pages for Mirador that load all necessary CSS and 
and JavaScripts and link to IIIF manifests hosted on library.bc.edu. As 
currently written, this script creates one page per manifest.

We are testing this method as an alternative to the Bavarian State Library's 
[Bookmarkable Viewer State plugin](https://github.com/dbmdz/mirador-plugins#bookmarkable-viewer-state) 
(see ['Linking to thumbnails, manifests, and canvases'](#linking-to-thumbnails-manifests-and-canvases)
for more information).

Usage:
1. Install [nodejs](https://nodejs.org/en/).

2. Optionally, install the [pretty nodejs module](https://www.npmjs.com/package/pretty). 
This will pretty-print the outputted HTML document. If you choose not to use this 
package, remove the `pretty()` method from the `doc` variable assignment. Then, 
comment out the line requiring the module:

```javascript
var pretty = require('pretty');
```

3. Create a file with manifest locations by running the following from the
directory where your manifests are located:

```bash
for manifest in manifests/*.json; do echo "https://library.bc.edu/iiif/manifests/$manifest" >> manifests.txt; done
```

4. Run the add_manifests script from the same directory as manifests.txt:

```bash
node add_manifests.js
```

5. Copy the files to the Mirador server. You should now be able to view a 
manifest in Mirador using its ArchivesSpace identifier in the URI, e.g.: 
`http://mirador_server.bc.edu/iiif/BC1988_027_ref57`

#### mirador-bc.css
Includes local customizations to Mirador's appearance. This stylesheet should be 
loaded in the Mirador landing page after 'mirador-combined.css'. 

## Mirador Usage Notes
#### Linking to thumbnails, manifests, and canvases
To request a thumbnail, use the syntax provided by the [IIIF Image API](http://iiif.io/api/image/2.1/#image-request-uri-syntax). 
The parameters can be adjusted as needed. E.g., to request a 200x200 thumbnail: 
`http://loris_server.bc.edu/image_id.jp2/full/!200,200/0/default.jpg`

We use a Bavarian State Library Mirador plugin called [Bookmarkable Viewer State](https://github.com/dbmdz/mirador-plugins#bookmarkable-viewer-state) 
to link directly to manifests and canvases. Links should be constructed using query 
string syntax, e.g.: 

```
`http://mirador_server.bc.edu/iiif/?view=ImageView&manifest=https://library.bc.edu/path_to_manifest.json&canvas=http://loris_server.bc.edu/canvas_id/page_id`
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
