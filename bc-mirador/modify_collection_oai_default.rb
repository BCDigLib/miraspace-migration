# TODO: figure out what to for collections with tricky image IDs (e.g., Hanvey)

require 'csv'
require 'nokogiri'
require 'pathname'

input_xml = ARGV[0]

if ARGV.empty?
  puts "Error: not enough arguments"
  puts "Usage: ruby modify_collection_oai.rb input_oai_xml_file"
  exit
elsif ARGV.length > 1
  puts "Error: too many arguments"
  puts "Usage: ruby modify_collection_oai.rb input_oai_xml_file"
  exit
elsif !Pathname(input_xml).exist?
  puts "Error: could not find #{input_xml}"
  exit
end

doc = File.open(input_xml) { |f| Nokogiri::XML(f) }
doc.xpath('//mods:mods', 'oai' => 'http://www.openarchives.org/OAI/2.0', 'mods' => 'http://www.loc.gov/mods/v3').each do |node|
  component_unique_id = node.xpath('mods:identifier[@type="hdl"]', 'mods' => 'http://www.loc.gov/mods/v3').text.split('/').last
  raw_obj = node.at_xpath('mods:location/mods:url[@access="raw object"]', 'mods' => 'http://www.loc.gov/mods/v3')
  thumb = node.at_xpath('mods:location/mods:url[@access="preview"]', 'mods' => 'http://www.loc.gov/mods/v3')

  raw_obj.content = "https://library.bc.edu/iiif/view/#{component_unique_id}"
  thumb.content = "https://scenery.bc.edu/#{component_unique_id}_0001.jp2/full/!200,200/0/default.jpg"
end

input_xml_rel = File.basename(input_xml.split('/').last.to_s, ".xml")
output_xml = "#{input_xml_rel}_modded.xml"
file = File.new(output_xml, "w")
file.write(doc)
file.close