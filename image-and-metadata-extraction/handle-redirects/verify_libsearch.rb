# Verifies that libsearch links resolve properly. Takes a handle batch file 
# (e.g., generated by redirect_handle.rb) as input.

require 'net/http'
require 'nokogiri'

input_file = ARGV[0]
lines = File.readlines(input_file)
urls = lines.select { |line| line.include?("URL") }.map { |line| line.gsub(/\n/, '').split(' ') }.flatten.select { |el| el.include?('http') }
results = {}

urls.each do |url|
end