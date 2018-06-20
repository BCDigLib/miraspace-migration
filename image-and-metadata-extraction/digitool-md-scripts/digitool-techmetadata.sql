SELECT hc.pid, hc.label, hc.ingestid, hc.ingestname, hs.filename, hs.internalpath, hs.fileextension
FROM D31_REP00.HDECONTROL hc, D31_REP00.HDESTREAMREF hs
WHERE hc.id = hs.id AND hs.filename LIKE '%bh01482%' AND hs.fileextension = 'tif';