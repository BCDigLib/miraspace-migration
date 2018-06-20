#!/bin/sh

for file in *.tif; do
  if [ ! -f "`basename $file .tif`.jp2" ]; then
    echo "`date` Converting $file" >> output.txt && convert $file `basename $file .tif`.jp2 2>> output.txt
  fi
done
