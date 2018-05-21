# Renames METS files from format PID.xml to OBJID.xml. Must be run in same directory as METS files.

require 'nokogiri'

Dir.glob('*.xml') do |file|
  puts "Adding handle to #{file}..."
  de_fname = "#{File.basename(file, '_mets.xml')}.xml"
  mets_doc = File.open(file) { |f| Nokogiri::XML(f) }
  de_doc = File.open("../digital_entities/de_transformed/#{de_fname}") { |f| Nokogiri::XML(f) }
  objid = mets_doc.at_xpath('mets:mets/@OBJID', 'mets' => 'http://www.loc.gov/METS/')
  handle = 'http://hdl.handle.net/' + de_doc.xpath('object/objectIdentifier/objectIdentifierValue').text
  objid.content = handle
  File.write(file, mets_doc.to_xml)

  puts "Renaming #{file}..."
  identifier = mets_doc.at_xpath('/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:identifier[@type="local"]/text()', 'mets' => 'http://www.loc.gov/METS/', 'mods' => 'http://www.loc.gov/mods/v3')
  File.rename(file, "brooker_#{identifier.to_s}.xml")
end

puts "\n"

Dir.glob('*.xml') do |file|
  puts "Adding identifier to #{file}..."
  mets_doc = File.open(file) { |f| Nokogiri::XML(f) }
  identifier = mets_doc.at_xpath('/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:identifier[@type="local"]/text()', 'mets' => 'http://www.loc.gov/METS/', 'mods' => 'http://www.loc.gov/mods/v3')
  component_unique_id = File.basename(file, ".xml")
  identifier.content = component_unique_id
  File.write(file, mets_doc.to_xml)
end