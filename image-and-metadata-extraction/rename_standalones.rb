# Renames fileSec hrefs to reflect new component unique ID and zero-idnexed 
# file sequence. Run from collection directory

require 'nokogiri'

mets_file = Dir["mets_transformed/*.xml"].first
component_unique_id = File.basename(mets_file, '.xml')
image_path = "jp2s/"

puts "Renaming files..."
Dir.glob(image_path + "*.jp2").each { |f| File.rename(f, image_path + component_unique_id + "_" + File.basename(f)) unless f.include?(component_unique_id) }
new_file_ids = Dir.glob(image_path + "*.jp2").sort.map { |f| File.basename(f, '.jp2') }

puts "Transforming METS..."
doc = File.open(mets_file) { |f| Nokogiri::XML(f) }
doc.xpath('mets:mets/mets:fileSec/mets:fileGrp[@USE="archive image"]/mets:file/mets:FLocat/@xlink:href', 'mets' => 'http://www.loc.gov/METS/', 'xlink' => 'http://www.w3.org/1999/xlink').each do |href|
  current_file_id = href.content.split("/").last.chomp(".tif")
  current_file_sequence = current_file_id.split("_").last.to_i
  new_file_ids.each do |id|
    if id.split("_").last.to_i == current_file_sequence - 1
      current_file_id = id
    end
  end
  href.content = "file://streams/#{current_file_id}.tif"
end

File.write(mets_file, doc.to_xml)