require 'csv'
require 'nokogiri'
require 'pathname'

input_txt = ARGV[0]
input_xml = ARGV[1]

if ARGV.empty? || ARGV.length == 1
  puts "Error: not enough arguments supplied"
  puts "Usage: ruby modify_solr.rb input_txt_file input_solr_xml_file"
  exit
elsif ARGV.length > 2
  puts "Error: takes only two arguments"
  puts "Usage: ruby modify_solr.rb input_txt_file input_solr_xml_file"
  exit
elsif !Pathname(input_txt).exist?
  puts "Error: could not find #{input_txt}"
  exit
elsif !Pathname(input_xml).exist?
  puts "Error: could not find #{input_xml}"
  exit
end

input_txt_rel = File.basename(input_txt.split('/').last.to_s, ".txt")
output_xml = "modded_solr_#{input_txt_rel}.xml"
tsv = CSV.readlines(input_txt, :col_sep => "\t")
solr_xml = File.open(input_xml) { |f| Nokogiri::XML(f) }

File.write(output_xml, Nokogiri::XML::Builder.new)
File.write(output_xml, '<add>')

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

  File.write(output_xml, doc.to_xml, mode: 'a')
end

File.write(output_xml, '</add>', mode: 'a')
