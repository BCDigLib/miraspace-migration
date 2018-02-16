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
  elsif json_file.slice(-5, 5) != '.json'
    puts "Error: input file must be JSON\n"
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
  manifest_uri = "https://library.bc.edu/iiif/manifests/#{identifier}"
  handle = manifest_hash

  mirador = {
    "id": "viewer",
    "mainMenuSettings": {
      "buttons": {
        "bookmark": false,
        "fullScreenViewer": false
      },
      "userButtons": [{
        "label": "View Library Record",
        "iconClass": "fa fa-external-link",
        "attributes": {}
      }],
      "userLogo": {
        "label": "Boston College Library",
        "attributes": {
          "id": "bc-logo",
          "href": "https://library.bc.edu"
        }
      }
    },
    "data": [],
    "windowObjects": []
  }
  location = { "manifestUri": manifest_uri, "location": "Boston College" }
  loaded = { "loadedManifest": manifest_uri, "viewType": "ImageView" }
  hdl_button = { "class": "handle", "href": handle }

  mirador[:data].push(location)
  mirador[:windowObjects].push(loaded)
  mirador[:mainMenuSettings][:userButtons][0][:attributes] = hdl_button
end

def build_document(mirador_object)
  identifer = 
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
      Mirador(#{mirador_object.to_json});
  </script>
</body>

</html>
  EOF
end

input_file = ARGV[0]
handle_input(input_file)