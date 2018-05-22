#!/bin/sh

for file in *.jpg; do
  if [ ! -f "`basename $file .jpg`.jp2" ]; then
    echo "`date` Converting $file" >> output.txt && convert $file `basename $file .jpg`.jp2 2>> output.txt
  fi
done
