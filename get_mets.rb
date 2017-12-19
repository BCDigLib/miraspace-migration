# Generates shell script to copy a collection's METS files from DigiTool.
# Requires a CSV of the collection's VIEW_MAIN pids and internalpaths.

require 'csv'

unless File.file?('mets-locations.csv')
  puts "Error: must be executed in the same directory as mets-locations.csv"
  abort
end

locations = {}
initialize_script = %x[touch 'copy_mets.sh' && echo '#!/bin/sh' >> 'copy_mets.sh']

CSV.foreach('mets-locations.csv') { |row| locations[row[0]] = row[1] }

locations.each do |pid, location|
  File.open('copy_mets.sh', 'a') do |file|
    file.write("cp /exlibris3/bcd01storage#{location} mets/#{pid}.xml\n")
  end
end
