## Mirador Utilities and Stylesheets
#### generate_mirador_view.rb
Takes a IIIF manifest as input and outputs an HTML landing page for Mirador.

As currently written, this script creates one page per manifest. We are testing 
this method as an alternative to the Bavarian State Library's 
[Bookmarkable Viewer State plugin](https://github.com/dbmdz/mirador-plugins#bookmarkable-viewer-state) 
(see ['Linking to thumbnails, manifests, and canvases'](#linking-to-thumbnails-manifests-and-canvases)
for more information).

Usage:

1. Create one or more IIIF manifests using the [metsiiif gem](https://github.com/BCLibraries/mets-to-iiif)).

2. Run generate_mirador_view.rb on the manifest you created, e.g.:

```bash
ruby generate_mirador_view.rb BC1988_027_ref57.json > BC1988_027_ref57
```

Or use a 'for' loop if you are generating multiple Mirador pages at once:

```bash
for manifest in ./commencement-photos/manifests/*.json; do ruby generate_mirador_view.rb $manifest > `basename $manifest .json`; done
```

3. Copy the output file(s) to the Mirador server. You should now be able to view 
a manifest in Mirador using its ArchivesSpace identifier in the URI, e.g.: 
`https://library.bc.edu/iiif/view/BC1988_027_ref57`

#### mirador-bc.css
Includes local customizations to Mirador's appearance. This stylesheet should be 
loaded in the Mirador landing page after 'mirador-combined.css'. 

#### download_canvas.js
A work-in-progress plugin to allow end users to download the currently displayed 
canvas at full resolution.

## Mirador Usage Notes
#### Linking to thumbnails, manifests, and canvases
To request a thumbnail, use the syntax provided by the [IIIF Image API](http://iiif.io/api/image/2.1/#image-request-uri-syntax). 
The parameters can be adjusted as needed. E.g., to request a 200x200 thumbnail: 
`https://scenery.bc.edu/image_id.jp2/full/!200,200/0/default.jpg`

Manifests can be rendered in Mirador using the following formula, where 
manifest_id is the handle suffix/resource ID:
`https://library.bc.edu/iiif/view/manifest_id`

Manifests can also be viewed and downloaded as JSON:
`https://library.bc.edu/iiif/manifests/manifest_id.json`

#### Generating manifests
[metsiiif](https://github.com/BCLibraries/mets-to-iiif) is a Ruby gem that converts 
a METS file to a IIIF manifest. This has been tested only with METS that conforms 
to the BC application profile. We will publish it to rubygems.org once we confirm 
broader compatibility. Feeback and pull requests are welcome.
