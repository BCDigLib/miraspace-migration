# Generates handle batch files to revert redirects to BCLSCO in case something 
# Goes horribly worng. Takes a handle batch file as input.

require 'net/http'
require 'nokogiri'

if ARGV.empty?
  puts "Error: no argument supplied"
  puts "Usage: ruby redirect_handle.rb path/to/hdl_batch_file.txt"
elsif File.extname(ARGV[0]) != '.txt'
  puts "Input file must be a handle batch txt file"
elsif !Pathname(ARGV[0]).exist?
  puts "Error: could not find #{ARGV[0]}"
end

input_file = ARGV[0]
lines = File.readlines(input_file)
handles = lines.select! { |line| line.include?("MODIFY") }.map { |line| line.gsub(/MODIFY /, '').gsub(/\n/, '') }

handles.each do |handle|
  url = URI.parse("http://hdl.handle.net/#{handle}")
  res = Net::HTTP.get(url)
  page = Nokogiri::HTML(res)
  destination = page.css('a').text

  modify_statement = <<-EOF
MODIFY #{handle}
201 URL 86400 1110 UTF8 #{destination}
    EOF

  puts modify_statement
end
