require 'nokogiri'

Dir.glob('*.xml') do |file|
  puts "Processing #{file}..."

  doc = File.open(file) { |file| Nokogiri::XML(file) }

  marc_node = doc.at_xpath('xb:digital_entity_call/xb:digital_entity/mds/md[type="marc"]/value').content
  marc_node = Nokogiri::XML(marc_node)

  premis_node = doc.at_xpath('xb:digital_entity_call/xb:digital_entity/mds/md[type="preservation_md"]/value').content
  premis_node = Nokogiri::XML(premis_node)

  local_collection = marc_node.xpath('marc:record/marc:datafield[@tag="940"]/marc:subfield[@code="a"]', 'marc' => 'http://www.loc.gov/MARC21/slim').map { |node| node.text }

  if local_collection.include?("LITURGY AND LIFE")
    resource_id = "BC2013_017"
  elsif local_collection.include?("BECKER COLLECTION")
    resource_id = "becker_"
  elsif local_collection.include?("CONGRESSIONAL ARCHIVES")
    resource_id = "CA2009_001"
  elsif marc_record.include?("Boston Gas")
    resource_id = "MS1986_088"
  end

  hdl = premis_node.xpath('premis:object/premis:objectIdentifier/premis:objectIdentifierValue', 'premis' => 'http://www.loc.gov/standards/premis').text
  hdl_suffix = hdl.split('/').last
  component_unique_id = resource_id + "_" + hdl_suffix

  File.rename(file, "#{component_unique_id}.xml")
end