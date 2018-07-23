#### modify_collection_oai.rb
Transforms an OAI XML file be IIIF-friendly by by iterating through manifests in 
a directory and updating the mods:url links to point to Mirador and Loris. The 
output file can be transformed to Solr XML using the [oaiMODS2tosolr XSLT](https://github.com/BCDigLib/Interim-Solution-XSLT/blob/master/oaiMODS2solr.xsl).

#### modify_solr.rb
Replaces object and thumbnail links in a Solr XML file with links to Mirador/Loris. 
Requires as input a tab-delimited text file with three columns: DigiTool PID, 
link to Mirador view, and filename for the image to use as thumbnail. (See 
modify_solr_sample_input.txt for a sample input file.)
