# Generates shell scripts (.bat and .sh) to rename DigiTool image files from
# their PID to their actual filename based on SQL query results in a CSV.
# For a sample CSV, see sqldata.csv in the bc-commencement subdirectory of 
# the Miraspace-test dir in dennis2.

require 'csv'

unless File.file?('sqldata.csv')
  puts "Error: must be executed in the same directory as sqldata.csv"
  abort
end

filenames = {}

# Note that position might vary; check your csv to make sure that row[0] is 
# the pid and row[4] the filename. Modify the indexes in your local repo as needed.
CSV.foreach('sqldata.csv') { |row| filenames[row[0]] = row[4] }

mac_version = %x[touch 'rename_pids.sh']
win_version = %x[touch 'rename_pids.bat']

# Using the hash we created, add the rename statements to the shell scripts
filenames.each do |pid, fname|
  File.open('rename_pids.sh', 'a') { |file| file.write("mv #{pid} #{fname}\n")}
  File.open('rename_pids.bat', 'a') { |file| file.write("ren #{pid} #{fname}\n")}
end
