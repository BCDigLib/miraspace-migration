# Run from directory containing METS files.

require 'nokogiri'

Dir.glob('*.xml') do |file|
  puts "Processing #{file}..."
  doc = Nokogiri::XML(File.open(file))
  component_unique_id = "<mods:identifier type='local'>" + File.basename(file, ".xml") + "</mods:identifier>"

  sequence_div_label = doc.at_xpath('/mets:mets/mets:structMap[@TYPE="physical"]/mets:div/@LABEL')
  sequence_div_label.content = "MS.1986.041"

  title_info = doc.at_xpath('/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:titleInfo', 'mods' => 'http://www.loc.gov/mods/v3', 'mets' => 'http://www.loc.gov/METS/')
  title_info.add_next_sibling(component_unique_id)

  File.write(file, doc.to_xml)
end
