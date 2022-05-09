SELECT ST.ixSKU AS SKU 
     , S.sDescription AS Description 
     , CONVERT(VARCHAR,D.dtDate,101) AS ReceiverDate 
     , SUM(ST.iQty) AS Quantity 
     , R.ixPO AS PO 
     , (R.ixVendor + ' ('+V.sName+')') AS POVendor  
     , (SELECT VS1.ixVendor +' ('+V1.sName+')' 
        FROM tblVendorSKU VS1 
        LEFT JOIN tblVendor V1 ON V1.ixVendor = VS1.ixVendor 
        WHERE VS1.ixSKU = ST.ixSKU 
          AND VS1.iOrdinality = 1) AS PrimeVendor 
FROM tblSKUTransaction ST 
LEFT JOIN tblReceiver R ON R.ixReceiver = ST.ixReceiver
LEFT JOIN tblDate D ON D.ixDate = R.ixCreateDate
LEFT JOIN tblVendorSKU VS ON VS.ixVendor = R.ixVendor AND VS.iOrdinality = 1 AND VS.ixSKU = ST.ixSKU
LEFT JOIN tblSKU S ON S.ixSKU = ST.ixSKU 
LEFT JOIN tblVendor V ON V.ixVendor = R.ixVendor
WHERE R.ixReceiver IS NOT NULL 
  AND D.dtDate = @Date -- IN VB set to always point to yesterday (=DateAdd(DateInterval.Day,-1,Today))
  AND VS.ixVendor IS NULL  
GROUP BY ST.ixSKU 
       , S.sDescription 
       , CONVERT(VARCHAR,D.dtDate,101) 
       , R.ixPO 
       , (R.ixVendor + ' ('+V.sName+')')
       
       
