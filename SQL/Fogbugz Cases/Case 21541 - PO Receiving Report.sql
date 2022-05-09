SELECT dtDate 
     , POD.ixSKU 
     , SUM(iQuantityPosted) AS Received 
     , POD.ixPO 
     , SL.sPickingBin AS Location 
     , ISNULL(iQC,0) + ISNULL(iQCB,0) + ISNULL(iQCBOM,0) + ISNULL(iQCXFER,0) AS QtyCommitted -- all types of commits
     , ISNULL(BO.Qty,0) AS QtyBackordered -- iQCB AS QtyBackordered 
FROM tblPOMaster POM
LEFT JOIN tblPODetail POD ON POD.ixPO = POM.ixPO 
LEFT JOIN tblDate D ON D.ixDate = POD.ixFirstReceivedDate 
LEFT JOIN tblSKULocation SL ON SL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = POD.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS AND ixLocation = 99 
LEFT JOIN (SELECT DISTINCT ixSKU 
                , SUM(ISNULL(iQuantity,0)) AS Qty
		   FROM tblOrder O 
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
		   WHERE O.sOrderStatus = 'Backordered' 
			 AND OL.flgLineStatus = 'Backordered' 
			 AND OL.ixSKU = '25175HTX' 
		   GROUP BY ixSKU 	 
		  ) BO ON BO.ixSKU = POD.ixSKU 
WHERE dtDate = '02/26/14'
  AND flgIssued = '1' 
  AND iQuantityPosted > 0 
  AND POD.ixSKU = '25175HTX' 
GROUP BY dtDate 
       , POD.ixSKU 
       , POD.ixPO 
       , SL.sPickingBin 
       , ISNULL(iQC,0) + ISNULL(iQCB,0) + ISNULL(iQCBOM,0) + ISNULL(iQCXFER,0)
       , ISNULL(BO.Qty,0) -- iQCB
    

SELECT *
FROM tblBinSku 
WHERE ixSKU = '25175HTX' 
SELECT *
FROM tblSKULocation
WHERE ixSKU = '25175HTX' 

SELECT D.dtDate 
     , TT.sDescription 
     , ST.*
FROM tblSKUTransaction ST 
LEFT JOIN tblDate D ON D.ixDate = ST.ixDate
LEFT JOIN tblTransactionType TT ON TT.ixTransactionType = ST.sTransactionType 
WHERE dtDate = '02/26/14'
  AND ixSKU = '25175HTX' 
  AND sLocation = 99 
  
-- grab everything with that PO which gives all CIDs then grab max date/time CID sToBin 
