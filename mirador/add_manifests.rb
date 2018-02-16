require 'json'
require 'pathname'

def handle_inputs(json_file, txt_file)
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
  elsif !Pathname(txt_file).exist?
    puts "Error: #{txt_file} could not be found"
    exit
  end
end

def construct_mirador_object(manifest_uri, handle)
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
        # TODO: pull handles from JSON
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

def build_document(mirador_object, identifier)
end


manifest = ARGV[0]
manifest_list = './manifests.txt'

handle_inputs(manifest, manifest_list)

#manifest_hash = JSON.parse(manifest)
#puts manifest_hash.to_json