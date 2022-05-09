-- SERVER SPEED TESTS
SELECT COUNT(*) FROM tblSnapshotSKU

SELECT format(count(*),'###,###,###') FROM tblSnapshotSKU -- 337,416,173   12:54

SELECT COUNT(*) FROM tblSKUTransaction -- 30,996,603


select SUM(mMerchandise) 'GrossSales', D.iYear -- 34 seconds
from tblOrder O
join tblDate D on O.ixOrderDate = D.ixDate
where ixOrder NOT LIKE 'Q%'
    and ixOrder NOT LIKE 'P%'
    and sOrderStatus <> 'Cancelled'
group by  D.iYear
order by  D.iYear desc
/*
GrossSales		iYear
124342801.77	2017
117978424.70	2016
107192582.89	2015
99745511.18		2014
95329688.45		2013
89960117.40		2012
77336965.80		2011
69046287.82		2010
62898789.88		2009
60198775.08		2008
53485822.33		2007
44664274.19		2006
79.85			1997
382.75			1996
2042.50		1995
*/



SELECT ixDate, COUNT(*) -- 361 rows 4:25
FROM tblSnapshotSKU
where ixDate >= 17899 -- 1/1/2017
group by ixDate
order by ixDate desc

-- most recent orders 4 sec