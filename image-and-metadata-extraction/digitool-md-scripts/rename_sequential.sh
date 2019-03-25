# renames all files in directory sequentially starting at counter
# counter is both starting number and max digits desired 
# retains file extension

rename -N [counter] -X -e '$_ = "[fileprefix]_$N"' *

# e.g. to rename files starting at "MS2009_030_63004_0000.tif":

# rename -N 0000 -X -e '$_ = "MS2009_030_63004_$N"' * 