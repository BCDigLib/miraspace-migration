require 'nokogiri'
require 'json'
require 'pathname'

manifest_dir = ARGV[0]
input_xml = ARGV[1]

if ARGV.empty?
  puts "Error: not enough arguments"
  puts "Usage: ruby modify_collection_oai.rb path/to/manifest_dir/ path/to/input_oai.xml"
  exit
elsif !Pathname(input_xml).exist?
  puts "Error: could not find #{input_json}"
  exit
elsif !Pathname(input_xml).exist?
  puts "Error: could not find #{input_xml}"
  exit
end

input_json = Dir["#{manifest_dir}/*"]
@doc = File.open(input_xml) { |f| Nokogiri::XML(f) }

input_json.each do |json|
  manifest = JSON.parse(File.read(json))
  manifest_component_unique_id = manifest['@id'].split('/').last.gsub('.json', '')
  manifest_thumb_id = manifest['thumbnail']
  manifest_hdl_suffix = manifest["metadata"][0]["handle"].split('/').last

  @doc.xpath('//mods:mods', 'oai' => 'http://www.openarchives.org/OAI/2.0', 'mods' => 'http://www.loc.gov/mods/v3').each do |node|
    oai_hdl_suffix = node.xpath('mods:identifier[@type="hdl"]', 'mods' => 'http://www.loc.gov/mods/v3').text.split('/').last
    oai_raw_obj = node.at_xpath('mods:location/mods:url[@access="raw object"]', 'mods' => 'http://www.loc.gov/mods/v3')
    oai_thumb = node.at_xpath('mods:location/mods:url[@access="preview"]', 'mods' => 'http://www.loc.gov/mods/v3')

    if oai_hdl_suffix == manifest_hdl_suffix
      oai_raw_obj.content = "https://library.bc.edu/iiif/view/#{manifest_component_unique_id}"
      oai_thumb.content = manifest_thumb_id
    end
  end
end

input_xml_rel = File.basename(input_xml.split('/').last.to_s, ".xml")
output_xml = "#{input_xml_rel}_modded.xml"
file = File.new(output_xml, "w")
file.write(@doc)
file.close