SELECT P.ixTrailer + ' - ' + T.sDescription AS Trailer 
     , COUNT(DISTINCT(ISNULL(sTrackingNumber,0))) AS Packages 
     , SUM(ISNULL(dBillingWeight,0)) AS BilledWeight
     , SUM(ISNULL(dActualWeight,0)) AS ActualWeight
FROM tblPackage P
LEFT JOIN tblTrailer T ON T.ixTrailer = P.ixTrailer 
LEFT JOIN tblDate D ON D.ixDate = P.ixShipDate
WHERE D.dtDate BETWEEN '12/28/13' AND '12/29/13'
GROUP BY P.ixTrailer + ' - ' + T.sDescription
ORDER BY Packages DESC

-- ytd where trailer is null count on packges by day

SELECT dtDate 
     , COUNT(DISTINCT(ISNULL(sTrackingNumber,0))) AS Packages 
FROM tblPackage P
LEFT JOIN tblTrailer T ON T.ixTrailer = P.ixTrailer 
LEFT JOIN tblDate D ON D.ixDate = P.ixShipDate
WHERE D.dtDate BETWEEN '1/1/14' AND GETDATE()
  AND P.ixTrailer IS NULL
GROUP BY dtDate       
ORDER BY dtDate DESC