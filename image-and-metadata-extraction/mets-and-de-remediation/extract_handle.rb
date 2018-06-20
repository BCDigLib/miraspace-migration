require 'nokogiri'

Dir.glob('*.xml') do |file|
  puts "Extracting handle for #{file}..."
  de_doc = Nokogiri::XML(File.open(file))
  pres_md = de_doc.at_xpath('xb:digital_entity_call/xb:digital_entity/mds/md[name="preservation"]/value', 'xb' => 'http://com/exlibris/digitool/repository/api/xmlbeans').content
  pres_md = Nokogiri::XML(pres_md)
  pres_md.remove_namespaces!.xpath('object/objectIdentifier/objectIdentifierValue').text
  File.write("de_transformed/#{File.basename(file)}", pres_md.to_xml)
end