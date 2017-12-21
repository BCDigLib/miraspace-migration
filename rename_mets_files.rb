# Renames METS files from format PID.xml to OBJID.xml. Must be run in same directory as METS files.

require 'nokogiri'

Dir.glob('*.xml') do |file|
  mets_doc = Nokogiri::XML(File.open(file))
  objid = mets_doc.xpath('/mets:mets/@objid', 'mets' => 'http://www.loc.gov/METS')
  File.rename(file, "#{objid}.xml")
end