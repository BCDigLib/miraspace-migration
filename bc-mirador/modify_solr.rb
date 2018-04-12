require 'csv'
require 'nokogiri'
require 'pathname'

input_txt = ARGV[0]
tsv = CSV.readlines("commencement-bc1988027marc.txt", :col_sep => "\t")

input_xml = 'solr-xml/all_solr.xml'
output_xml = 'modded_solr.xml'

solr_xml = File.open(input_file) { |f| Nokogiri::XML(f) }

File.write(output_file, "<add>")

tsv.each do |line|
  doc = solr_xml.at("doc:has(field[text()='https://bclsco.bc.edu/catalog/oai:dcollections.bc.edu:#{line[0]}'])")
  id = doc.xpath("field[@name='id']").first
  thumb_mt = doc.xpath("field[@name='mods_location_url_access_preview_mt']").first
  thumb_ms = doc.xpath("field[@name='mods_location_url_access_preview_ms']").first
  raw_obj_mt = doc.xpath("field[@name='mods_location_url_access_raw_object_mt']").first
  raw_obj_ms = doc.xpath("field[@name='mods_location_url_access_raw_object_ms']").first

  thumb_mt.content = "https://scenery.bc.edu/#{line[2]}/full/!200,200/0/default.jpg"
  thumb_ms.content = "https://scenery.bc.edu/#{line[2]}/full/!200,200/0/default.jpg"
  raw_obj_mt.content = line[1]
  raw_obj_ms.content = line[1]

  File.write(output_file, doc.to_xml, mode: 'a')
end

File.write(output_file, "</add>", mode: 'a')
