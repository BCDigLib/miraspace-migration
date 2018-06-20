# Make sure filenames are set to MS or BC # 

exiftool -FileName -FileSize# -FileType -ImageSize -XResolution -BitsPerSample -ColorSpaceData -csv [filepath] > [csvname].csv
