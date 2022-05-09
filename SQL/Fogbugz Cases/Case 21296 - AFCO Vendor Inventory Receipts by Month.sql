SELECT D.sMonth AS DueDate
     , D2.sMonth AS CreateDate 
     , VS.ixVendor      
     , BTM.ixFinishedSKU 
     , SUM(BTM.iCompletedQuantity) AS Qty
     , (VS.mCost * SUM(BTM.iCompletedQuantity)) AS TotalCost
FROM tblBOMTransferMaster BTM 
LEFT JOIN tblVendorSKU VS ON VS.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = BTM.ixFinishedSKU COLLATE SQL_Latin1_General_CP1_CS_AS AND iOrdinality = 1 
LEFT JOIN tblDate D ON D.ixDate = BTM.ixDueDate 
LEFT JOIN tblDate D2 ON D2.ixDate = BTM.ixCreateDate 
WHERE BTM.ixCreateDate BETWEEN 16438 AND 16802 --15067 rows
  AND BTM.dtCanceledDate IS NULL --14518 rows
  AND VS.ixVendor IN ('0008', '0018', '0019', '6298', '0001', '5566', '0003', '5567') --9672 rows 
  --AND BTM.ixFinishedSKU = '80142-S-NA-N'
GROUP BY D.iMonth
       , D.sMonth
       , D2.sMonth
       , BTM.ixFinishedSKU 
       , VS.ixVendor
       , VS.mCost
ORDER BY D.iMonth 
       , VS.ixVendor
       , BTM.ixFinishedSKU 
       , TotalCost 
       

/***********
   Summary
Data for 2013 
*************/   

SELECT VS.ixVendor      
     , SUM(BTM.iCompletedQuantity) AS Qty
     , SUM(VS.mCost * (BTM.iCompletedQuantity)) AS TotalCost
FROM tblBOMTransferMaster BTM 
LEFT JOIN tblVendorSKU VS ON VS.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = BTM.ixFinishedSKU COLLATE SQL_Latin1_General_CP1_CS_AS AND iOrdinality = 1 
WHERE BTM.ixCreateDate BETWEEN 16438 AND 16802 
  AND BTM.dtCanceledDate IS NULL 
  AND VS.ixVendor IN ('0008', '0018', '0019', '6298', '0001', '5566', '0003', '5567') --9672 rows 
GROUP BY VS.ixVendor
ORDER BY VS.ixVendor
          