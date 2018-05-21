# Renames METS files from format PID.xml to OBJID.xml. Must be run in same directory as METS files.

require 'nokogiri'

Dir.glob('*.xml') do |file|
  puts "Renaming #{file}..."
  mets_doc = Nokogiri::XML(File.open(file))
  identifier = mets_doc.at_xpath('/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:identifier[@type="local"]/text()', 'mets' => 'http://www.loc.gov/METS/', 'mods' => 'http://www.loc.gov/mods/v3')
  File.rename(file, "brooker_#{identifier.to_s}.xml")
end

puts "\n"

Dir.glob('*.xml') do |file|
  puts "Adding identifier to #{file}..."
  mets_doc = Nokogiri::XML(File.open(file))
  identifier = mets_doc.at_xpath('/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:identifier[@type="local"]/text()', 'mets' => 'http://www.loc.gov/METS/', 'mods' => 'http://www.loc.gov/mods/v3')
  component_unique_id = File.basename(file, ".xml")
  identifier.content = component_unique_id
  File.write(file, mets_doc.to_xml)
end