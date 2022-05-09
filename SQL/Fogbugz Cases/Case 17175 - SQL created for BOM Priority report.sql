SELECT TM.ixTransferNumber AS 'Transfer'
     , D.dtDate AS CreateDate 
     , TM.ixFinishedSKU AS FinishedPart 
     , Comp.CompSKU 
     , Comp.CompQtyReq
     , Comp.CompSKUQAV
     , Comp.DefaultBuyer
     --Add PO Subreport in here 
     , XferQty.TotQty AS XferQty --  = SUM(iCompletedQuantity) for all finishedSKUs (open transfers only?) 
     , ISNULL(TMQ.Qty,0) AS TwelveMonthSales
     , SL.iQAV
     , TM.iQuantity 
     , TM.iCompletedQuantity
     , (dbo.BOMQAV (TM.ixTransferNumber)) AS BOMQAV 
     , ISNULL(TMQ.Qty,0) / 11 AS PerMonth -- = 12 month sales / 11 
     --, (CASE WHEN (ISNULL(TMQ.Qty,0)/11) = 0 THEN '0'
     --        ELSE ((SL.iQAV) / (ISNULL(TMQ.Qty,0) / 11))
     --   END) AS ETA -- = FinishSKU QAV / Per Month 
     , (CASE WHEN (ISNULL(TMQ.Qty,0)/11) = 0 THEN '0'
             ELSE (CAST(SL.iQAV AS decimal (10,2)) / (ISNULL(TMQ.Qty,0) / 11))
        END) AS ETA -- = FinishSKU QAV / Per Month 
     , TM.flgReverseBOM AS RBOM  
     , (CASE WHEN ((TM.iQuantity - TM.iCompletedQuantity) > (dbo.BOMQAV (TM.ixTransferNumber))) THEN 'TRUE' 
             ELSE 'FALSE'
        END) AS 'Status'  -- =IF(G2-H2>I2,TRUE)
FROM tblBOMTransferMaster TM 
--To get a more readable date format 
LEFT JOIN tblDate D ON D.ixDate = TM.ixCreateDate
--To calculate 12. month sales on the finished SKU 
LEFT JOIN (SELECT OL.ixSKU AS ixSKU 
                , SUM (ISNULL(OL.iQuantity,0)) AS Qty
           FROM tblOrderLine OL
           LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
           WHERE O.dtShippedDate BETWEEN DATEADD(dd,-365,GETDATE()) AND GETDATE()
            -- AND O.sOrderType <> 'Internal' --?? 
            -- AND O.sOrderChannel <> 'INTERNAL' --?? 
            -- AND O.mMerchandise > 0 --??
             AND O.sOrderStatus IN ('Shipped', 'Dropshipped')
           GROUP BY OL.ixSKU   
           ) TMQ ON TMQ.ixSKU = TM.ixFinishedSKU   --TMQ = Twelve Month Quantity 
--To determine QAV            
LEFT JOIN tblSKULocation SL ON SL.ixSKU = TM.ixFinishedSKU   
    AND ixLocation = '99' --SMI     
--To determine the total completed quantity for any finished SKU with open transfers pending          
LEFT JOIN (SELECT ixFinishedSKU AS SKU 
                , SUM(ISNULL(iCompletedQuantity,0)) AS TotQty
		   FROM tblBOMTransferMaster 
		   LEFT JOIN tblDate D ON D.ixDate = ixCreateDate 
		   WHERE iCompletedQuantity < iQuantity --Open Transfers  
		   GROUP BY ixFinishedSKU
		  ) XferQty ON XferQty.SKU = TM.ixFinishedSKU  
LEFT JOIN (SELECT TD.ixTransferNumber AS XferNumber
                , TD.ixSKU AS CompSKU 
                , TD.iQuantity AS CompQtyReq
                , SL.iQAV AS CompSKUQAV
                , V.ixBuyer AS DefaultBuyer 
           FROM tblBOMTransferDetail TD 
           LEFT JOIN tblSKULocation SL ON SL.ixSKU = TD.ixSKU 
                 AND SL.ixLocation = '99'
           LEFT JOIN tblVendorSKU VS ON VS.ixSKU = TD.ixSKU 
                 AND VS.iOrdinality = '1' 
           LEFT JOIN tblVendor V ON V.ixVendor = VS.ixVendor        
           ) Comp ON Comp.XferNumber = TM.ixTransferNumber 
WHERE (CASE WHEN ((TM.iQuantity - TM.iCompletedQuantity) > (dbo.BOMQAV (TM.ixTransferNumber))) THEN 'TRUE' 
             ELSE 'FALSE'
        END) = 'TRUE'
 -- AND dtDate BETWEEN '01/10/13' AND '01/11/13'     
