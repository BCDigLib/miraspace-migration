#!/bin/sh

# This script will iterate through a Becker MARC file and normalize thumbnail filenames.
# There are additional files that require manual editing (see becker_jp2_renaming_notes.txt
# in collection directory for more info).
#
# As always, test first by removing "-i ''" from the sed commands. This will output the 
# results to the console instead of editing the file inline.

sed -i '' 's/[0-9]+_*[0-9]+__//g' becker.mrk
sed -i '' 's/_tif*_jp2000//g' becker.mrk
