# Renames METS files from format PID_mets.xml to component_unique_id.xml. 
# Must be run in same directory as METS files.

require 'nokogiri'

Dir.glob('*.xml') do |file|
  puts "Processing #{file}..."
  doc = Nokogiri::XML(File.open(file))
  fname_arr = doc.xpath('/mets:mets/mets:fileSec/mets:fileGrp[@USE="archive image"]/mets:file[1]/mets:FLocat/@xlink:href', 'mets' => 'http://www.loc.gov/METS/', 'xlink' => 'http://www.w3.org/1999/xlink').to_s.split('/').last.split('-')
  component_unique_id = "#{fname_arr[0]}_#{fname_arr[1]}_#{fname_arr[2]}" + '-' + fname_arr[3]
  File.rename(file, "#{component_unique_id}.xml")
end
