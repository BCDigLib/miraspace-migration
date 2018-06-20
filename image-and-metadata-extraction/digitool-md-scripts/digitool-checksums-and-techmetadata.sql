SELECT x.pid, x.label, x.ingestid, x.ingestname, x.filename, x.internalpath, x.fileextension, x.usagetype, x.metadata.extract('/mix:mix/mix:BasicImageParameters/mix:File/mix:Checksum[mix:ChecksumMethod/text()="MD5"]/mix:ChecksumValue/text()','xmlns:mix="http://www.loc.gov/mix/"').getStringVal() AS md5
FROM
(SELECT hc.pid AS pid, XMLTYPE(hdm.value) AS metadata, hc.label AS label, hc.ingestid AS ingestid, hc.ingestname AS ingestname, hs.filename AS filename, hs.internalpath AS internalpath, hs.fileextension AS fileextension, hc.usagetype AS usagetype
FROM D31_REP00.HDECONTROL hc, D31_REP00.HDESTREAMREF hs, D31_REP00.HDEMETADATA hdm, 
D31_REP00.HDEPIDMID hdp
WHERE hc.id = hs.id
AND hc.usagetype = 'ARCHIVE' 
AND hc.pid = hdp.pid
AND hdp.mid = hdm.mid 
AND hdm.mdid = '12'
AND hc.ingestname LIKE '%anvey%'
) x;

