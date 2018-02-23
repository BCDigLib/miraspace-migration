# Creates a Mirador view for a single manifest. Requires manifest file generated 
# by metsiiif gem (https://github.com/BCLibraries/mets-to-iiif)

require 'json'
require 'pathname'

def handle_input(file)
    if ARGV.empty?
    puts "Error: no argument supplied"
    puts "Usage: ruby add_manifests.rb some_iiif_manifest.json\n"
    exit
  elsif ARGV.length > 1
    puts "Error: takes only one argument\n"
    puts "Usage: ruby add_manifests.rb some_iiif_manifest.json\n"
    exit
  elsif File.extname(file) != '.json'
    puts "Error: argument must be a JSON file\n"
    puts "Usage: ruby add_manifests.rb some_iiif_manifest.json\n"
    exit
  elsif !Pathname(file).exist?
    puts "Error: #{file} could not be found"
    exit
  end
end

def parse_manifest_file(file)
  f = File.read(file)
  JSON.parse(f)
end

def construct_mirador_object(file)
  manifest_hash = parse_manifest_file(file)
  handle = manifest_hash["metadata"][0]["handle"]
  manifest_uri = manifest_hash["@id"]

  @mirador_hash = {
    "id": "viewer",
    "mainMenuSettings": {
      "buttons": {
        "bookmark": false,
        "fullScreenViewer": false
      },
      "userButtons": [{
        "label": "View Library Record",
        "iconClass": "fa fa-external-link",
        "attributes": { "class": "handle", "href": handle, "target": "_blank" }
      }],
      "userLogo": {
        "label": "Boston College Library",
        "attributes": {
          "id": "bc-logo",
          "href": "https://library.bc.edu"
        }
      }
    },
    "data": [{ "manifestUri": manifest_uri, "location": "Boston College" }],
    "windowObjects": [{ "loadedManifest": manifest_uri, "viewType": "ImageView" }]
  }
end

def build_document(file)
  construct_mirador_object(file)
  identifier = File.basename(file, File.extname(file))
  mirador = JSON.pretty_generate(@mirador_hash)
  
  doc = <<-EOF
<!DOCTYPE html>
<html>

<head>
  <title>#{identifier}</title>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" type="text/css" href="build/mirador/css/mirador-combined.css"></link>
  <link rel="stylesheet" type="text/css" href="build/mirador/css/mirador-bc.css"></link>
  <script src="build/mirador/mirador.js"></script>
</head>

<body>
  <div id="viewer"></div>
  <script type="text/javascript">
    $(function() {
      Mirador(#{mirador});
    });
  </script>
</body>

</html>
  EOF

  puts doc
end

input_file = ARGV[0]
handle_input(input_file)
build_document(input_file)
