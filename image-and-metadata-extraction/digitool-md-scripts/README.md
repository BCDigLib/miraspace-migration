### Transferring images from DigiTool
1. Export a list of file locations from the db in a text file
2. Run the following command: `rsync -aczP --files-from="list_of_file_locations.txt" --no-relative username@digitool_server_name.bc.edu:/path/to/images /image/destination/dir/`
3. Rename the images using rename_image_files.rb or a method of your choice
