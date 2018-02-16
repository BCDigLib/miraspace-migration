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

def load_manifest_data(manifest_uri)
end

def build_document(mirador_object, identifier, handle)
end

manifest = ARGV[0]
manifest_list = './manifests.txt'

handle_inputs(manifest, manifest_list)

#manifest_hash = JSON.parse(manifest)
#puts manifest_hash.to_json