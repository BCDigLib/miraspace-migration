# Renames METS files from format PID.xml to OBJID.xml. Must be run in same directory as METS files.

require 'nokogiri'

Dir.glob('*.xml') do |file|
  puts "Processing #{file}..."
  mets_doc = Nokogiri::XML(File.open(file))
  objid = mets_doc.remove_namespaces!.xpath('/mets/@OBJID').to_s.split('/').last
  File.rename(file, "MS2001_039_#{objid}.xml")
end
