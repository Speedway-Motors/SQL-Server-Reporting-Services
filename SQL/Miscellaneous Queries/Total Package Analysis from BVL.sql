--- Package Counts by Week For Boonville | One Table for AFCO one for SMI 
  --- Similar to Packages Shipped by Date BUT YTD 
--- Start week on Monday (iISOWeek would do this for this year) 


--- On the AFCO Side [Use AFCO Reporting]


SELECT iISOWeek 
     , iShipMethod
     , SM.sDescription
     , COUNT(DISTINCT sTrackingNumber) AS PackageCount 
FROM tblOrder O 
LEFT JOIN tblPackage P ON P.ixOrder = O.ixOrder
LEFT JOIN tblDate D ON D.ixDate = O.ixShippedDate
LEFT JOIN tblShipMethod SM ON SM.ixShipMethod = O.iShipMethod     
WHERE O.dtShippedDate >= '1/1/15' 
  AND O.sOrderStatus = 'Shipped' 
  AND O.ixOrder NOT LIKE '%-%' 
  AND ixPrimaryShipLocation = '99' 
  AND iShipMethod <> 1 
  AND P.flgCanceled = 0 
GROUP BY iISOWeek
       , iShipMethod
       , SM.sDescription
ORDER BY iISOWeek
       , iShipMethod
       
       
       
--- On the SMI Side [Use SMI Reporting]


SELECT iISOWeek 
     , iShipMethod
     , SM.sDescription
     , COUNT(DISTINCT sTrackingNumber) AS PackageCount 
FROM tblOrder O 
LEFT JOIN tblPackage P ON P.ixOrder = O.ixOrder
LEFT JOIN tblDate D ON D.ixDate = O.ixShippedDate
LEFT JOIN tblShipMethod SM ON SM.ixShipMethod = O.iShipMethod     
WHERE O.dtShippedDate >= '1/1/15' 
  AND O.sOrderStatus = 'Shipped' 
  AND O.ixOrder NOT LIKE '%-%' 
  AND ixPrimaryShipLocation = '47' 
  AND iShipMethod <> 1 
  AND P.flgCanceled = 0 
GROUP BY iISOWeek
       , iShipMethod
       , SM.sDescription
ORDER BY iISOWeek
       , iShipMethod
              




	
	
