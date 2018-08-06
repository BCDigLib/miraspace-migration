# Takes a IIIF manifest as input and outputs a handle redirect that can be added 
# to a handle server batch file.

require 'json'
require 'pathname'

if ARGV.empty?
  puts "Error: no argument supplied"
  puts "Usage: ruby redirect_handle.rb path/to/manifest.json"
elsif File.extname(ARGV[0]) != '.json'
  puts "Input file must be a IIIF manifest JSON file"
elsif !Pathname(ARGV[0]).exist?
  puts "Error: could not find #{ARGV[0]}"
end

input_file = ARGV[0]
manifest = JSON.parse(File.read(input_file))
handle_uri = manifest['metadata'][0]['handle']
handle = handle_uri.split('/')[-2] + '/' + handle_uri.split('/')[-1]

modify_statement = <<-EOF
MODIFY #{handle}
201 URL 86400 1110 UTF8 http://bclib.bc.edu/libsearch/bc/hdl/#{handle}
  EOF

puts modify_statement
puts ""