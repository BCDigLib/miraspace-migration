# Renames METS files from format PID.xml to OBJID.xml. Must be run in same directory as METS files.

require 'nokogiri'

Dir.glob('*.xml') do |file|
  puts "Processing #{file}..."
  mets_doc = Nokogiri::XML(File.open(file))
  identifier = mets_doc.xpath('/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:identifier[@type="local"]/text()', 'mets' => 'http://www.loc.gov/METS/', 'mods' => 'http://www.loc.gov/mods/v3').to_s
  File.rename(file, "brooker_#{identifier}.xml")
end