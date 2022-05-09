SELECT S.ixSKU
     , S.sDescription
     , S.ixPGC
     , SL.iQOS
     , SL.iQAV 
     , SL.iQC AS QtyCommitted
     , SL.iQCB + iQCBOM + iQCXFER AS 'QTY BKR/BOM/XFER' 
     , BOM.[Next Delivery Date] AS 'BOM Next Delivery Date' 
     , PO.[PO Delivery Date] AS 'PO Next Delivery Date' 
FROM tblSKU S
LEFT JOIN tblSKULocation SL ON SL.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = S.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
LEFT JOIN (SELECT MIN(D.dtDate) AS 'Next Delivery Date' 
                , BTM.ixFinishedSKU
           FROM tblBOMTransferMaster BTM 
           LEFT JOIN tblDate D ON D.ixDate = BTM.ixDueDate
           WHERE ISNULL(BTM.iCompletedQuantity,0) < BTM.iQuantity 
             AND dtCanceledDate IS NULL 
             AND (iOpenQuantity > 0
                    OR iReleasedQuantity <> 0) 
             AND flgReverseBOM = 0          
           GROUP BY BTM.ixFinishedSKU    
          ) BOM ON BOM.ixFinishedSKU COLLATE SQL_Latin1_General_CP1_CS_AS = S.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
LEFT JOIN (SELECT ixSKU 
                , MIN(dtDate) AS 'PO Delivery Date' 
           FROM tblPODetail POD 
           LEFT JOIN tblPOMaster POM ON POM.ixPO = POD.ixPO 
           LEFT JOIN tblDate D ON D.ixDate = POD.ixExpectedDeliveryDate 
           WHERE iQuantity > iQuantityPosted 
             AND flgOpen = 1 
           GROUP BY ixSKU
          ) PO ON PO.ixSKU = S.ixSKU      
WHERE SL.ixLocation = '99' 
 -- AND S.ixSKU = 'SM300'
ORDER BY S.ixSKU 


