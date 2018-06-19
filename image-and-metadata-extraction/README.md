#### modify_collection_oai.rb
Transforms an OAI XML file be IIIF-friendly by by iterating through manifests in 
a directory and updating the mods:url links to point to Mirador and Loris. The 
output file can be transformed to Solr XML using the [oaiMODS2tosolr XSLT](https://github.com/BCDigLib/Interim-Solution-XSLT/blob/master/oaiMODS2solr.xsl).

#### modify_solr.rb
Replaces object and thumbnail links in a Solr XML file with links to Mirador/Loris. 
Requires as input a tab-delimited text file with three columns: DigiTool PID, 
link to Mirador view, and filename for the image to use as thumbnail. (See 
modify_solr_sample_input.txt for a sample input file.)

### Transferring images from DigiTool
1. Export a list of file locations from the db in a text file
2. Run the following command: `rsync -aczP --files-from="list_of_file_locations.txt" --no-relative username@digitool_server_name.bc.edu:/path/to/images /image/destination/dir/`
3. Rename the images using rename_image_files.rb or a method of your choice
