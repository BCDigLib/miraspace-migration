#!/bin/sh

# -0 is included in the test because convert renames processed two-page tiffs using this convention.
for file in *.tif; do
  if [ ! -f "`basename $file .tif`-0.jp2" ]; then
    echo "`date` Converting $file" >> output.txt && convert $file `basename $file .tif`.jp2 2>> output.txt
  fi
done
