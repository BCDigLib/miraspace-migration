require 'nokogiri'

mets_file = Dir["mets_transformed/*.xml"].first
component_unique_id = File.basename(mets_file, '.xml')
image_path = "jp2s/"
new_file_ids = Dir.glob(image_path + "*.jp2").sort.map { |f| File.basename(f, '.jp2') }

doc = File.open(mets_file) { |f| Nokogiri::XML(f) }
doc.xpath('mets:mets/mets:structMap/mets:div[@TYPE="item"]/mets:div/@LABEL', 'mets' => 'http://www.loc.gov/METS/').each do |label|
  current_label_id = label.to_s
  current_label_sequence = current_label_id.split("_").last.to_i
  new_file_ids.each do |id|
    if id.split("_").last.to_i == current_label_sequence - 1
      current_label_id = id
    end
  end
  label.content = current_label_id
end

File.write(mets_file, doc.to_xml)