

SELECT DISTINCT S.ixSKU AS 'SKU #' 
     , S.ixPGC AS 'PGC' 
     , SL.iQOS AS 'Qty. on Hand'
     , SL.iQAV AS 'Qty. Available'
   --  , S.dtDiscontinuedDate
   --  , S.flgActive
   --  , VS.ixVendor   
     , ISNULL((dbo.BOM12MonthUsageNEW (S.ixSKU)),0) AS '12 Mo. BOM Usage'
FROM tblSKU S
LEFT JOIN tblSKULocation SL ON SL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU 
LEFT JOIN tblVendorSKU VS ON VS.ixSKU = S.ixSKU 
LEFT JOIN (SELECT DISTINCT ST.ixSKU 
                , SUM(ST.iQty) AS TotalQty 
           FROM tblSKUTransaction ST
           LEFT JOIN tblDate D ON D.ixDate = ST.ixDate 
           WHERE D.dtDate BETWEEN DATEADD(yy, -1, GETDATE()) AND GETDATE() 
             and ST.sTransactionType = 'BOM'
             and ST.iQty < 0
           GROUP BY ST.ixSKU
          ) TTBOM ON S.ixSKU = TTBOM.ixSKU      
WHERE SL.iQOS > 0
  and (S.flgActive = '0' OR S.dtDiscontinuedDate < GETDATE() OR VS.ixVendor IN ('0999', '9999'))
  and S.dtDiscontinuedDate < GETDATE() --@CurrentDate
  and S.flgDeletedFromSOP = '0'
  and SL.ixLocation = '99'   
  and VS.iOrdinality = 1
--ORDER BY '12 Mo. BOM Usage' DESC