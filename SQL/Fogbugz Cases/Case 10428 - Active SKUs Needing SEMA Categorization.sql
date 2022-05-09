--31466 SKUs as of 08/15/2012  

SELECT DISTINCT S.ixSKU AS SKU 
     , S.sDescription AS Description
     , S.ixPGC AS PGC
     , Detail.QAV AS QAV 
     , ISNULL(Detail.Qty,0) AS QtySold
     , ISNULL(Detail.GP,0) AS GP
     , ISNULL(Detail.Qty,0) * ISNULL(Detail.GP,0) AS '12MOGP'
FROM tblSKU S
LEFT JOIN tblCatalogDetail CD ON CD.ixSKU = S.ixSKU
LEFT JOIN tblCatalogMaster CM ON CM.ixCatalog = CD.ixCatalog
LEFT JOIN (SELECT DISTINCT tblOrderLine.ixSKU AS SKU 
                , SL.iQAV AS QAV
                , SUM(iQuantity) AS Qty
                , SUM(mExtendedPrice - mExtendedCost) AS GP
           FROM tblOrderLine
           LEFT JOIN tblSKULocation SL ON SL.ixSKU = tblOrderLine.ixSKU
           WHERE dtShippedDate BETWEEN '08/21/11' AND '08/21/12'
             and flgLineStatus = 'Shipped' 
             and mExtendedPrice > '0' 
             and SL.ixLocation = '99' 
           GROUP BY tblOrderLine.ixSKU
                  , SL.iQAV 
           ) Detail ON Detail.SKU = S.ixSKU 
WHERE (S.sSEMACategory IS NULL 
        OR S.sSEMASubCategory IS NULL
        OR S.sSEMAPart IS NULL
       ) 
  AND flgDeletedFromSOP = '0' 
  AND flgActive = '1'
  AND flgIntangible = '0'
  AND CD.ixCatalog LIKE '%WEB%'
  AND  GETDATE() BETWEEN CM.dtStartDate and CM.dtEndDate
ORDER BY '12MOGP' DESC
       , QtySold
       , QAV

