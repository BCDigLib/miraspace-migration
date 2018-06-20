# Takes a CSV containing a DigiTool db export of labels and techmd values as 
# input, then writes the techmd in the CSV to file. This can be adapted to any 
# metadata stream stored in the DigiTool database.

require 'csv'

filenames = {}

CSV.foreach('mix.csv') do |row|
  filenames[row[0]] = row[1] unless (row[0] == 'LABEL' || row[0] == '')
end

filenames.each do |label, value|
  File.open("#{label}.xml", 'a') { |file| file.write(value) }
end