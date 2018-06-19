# Concatenates multiple OAI files into a single OAI XML file

require 'nokogiri'

if ARGV.empty?
  puts "Usage: ruby concat_oai.rb path/to/oai_files/"
  exit
end

oai_dir = ARGV[0]
input_xml = Dir["#{oai_dir}/*"]
first_file = input_xml.shift

doc = File.open(first_file) { |f| Nokogiri::XML(f) }
doc.xpath('//oai:resumptionToken', 'oai' => 'http://www.openarchives.org/OAI/2.0/').remove

records = doc.at_xpath('//oai:ListRecords', 'oai' => 'http://www.openarchives.org/OAI/2.0/')

input_xml.each do |inp|
  curr_oai = File.open(inp) { |f| Nokogiri::XML(f) }

  curr_oai.xpath('//oai:record', 'oai' => 'http://www.openarchives.org/OAI/2.0/').each do |node|
    records << node
  end
end

doc.xpath('//oai:ListRecords', 'oai' => 'http://www.openarchives.org/OAI/2.0/').remove
doc.at_xpath('//oai:OAI-PMH', 'oai' => 'http://www.openarchives.org/OAI/2.0/').add_child(records)

output = File.new('oai_combined.xml', 'w')
output.write(doc)
output.close
