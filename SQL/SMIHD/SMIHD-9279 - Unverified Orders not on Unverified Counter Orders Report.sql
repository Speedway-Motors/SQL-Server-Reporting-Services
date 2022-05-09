-- SMIHD-9279 - Unverified Orders not on Unverified Counter Orders Report

SELECT * 
FROM tblCounterOrderScans OS
LEFT JOIN tblIPAddress IP ON IP.ixIP = OS.ixIP
WHERE IP.sGroup IN ('Carousel', 'Big Pack')
AND ixOrder = '7606968'

select * from tblOrderRouting
where  ixOrder = '7606968'

select * from tblTime where ixTime = 53262 -- 

14:47:42  AvailablePrintDate
15:56:55  Ben scanned

select * from tblIPAddress where ixIP = '192.168.240.16'


SELECT * 
FROM tblCounterOrderScans OS
LEFT JOIN tblIPAddress IP ON IP.ixIP = OS.ixIP
WHERE --IP.sGroup IN ('Carousel', 'Big Pack')
 ixOrder = '	'	









-- verify 

53262
