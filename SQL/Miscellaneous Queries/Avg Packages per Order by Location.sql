-- Avg Packages per Order by Location

SELECT O.ixPrimaryShipLocation, 
    FORMAT(count(distinct P.ixOrder),'###,###') 'OrderCount', 
    FORMAT(count(sTrackingNumber),'###,###') 'PkgCount',
    FORMAT((count(sTrackingNumber)* 1.0 / count(distinct P.ixOrder)* 1.0),'###,###.00') 'AvgPkgPerOrder'
FROM tblPackage P
    Left join tblOrder O on O.ixOrder = P.ixOrder
WHERE O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '01/01/2019' and '12/31/2019' -- DATE RANGE
    AND P.flgCanceled = 0 -- these two flags lower the avg a significant amount
    AND P.flgReplaced = 0 -- these two flags lower the avg a significant amount
    AND (O.sShipToCountry = 'US'
         OR O.sShipToCountry IS NULL)
GROUP BY O.ixPrimaryShipLocation
order by O.ixPrimaryShipLocation DESC

-- Are there ship methods that need to be excluded?

/*
ixPrimary
Ship        Order   Pkg     AvgPkg
Location	Count	Count	PerOrder
=========   ======  ======  ========
99	        629,985	762,122	1.21    -- 2018
47	             64	     64	1.00

99	        610,996	734,317	1.20    -- 2019
85	          3,588	  3,817	1.06
47	          4,766	  5,103	1.07
*/
