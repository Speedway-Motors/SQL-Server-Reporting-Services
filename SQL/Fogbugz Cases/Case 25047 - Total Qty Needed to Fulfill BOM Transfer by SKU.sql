SELECT BTD.ixTransferNumber 
     , BTD.iQuantity * iOpenQuantity AS TotalQty
FROM tblBOMTransferDetail BTD 
LEFT JOIN tblBOMTransferMaster BTM ON BTM.ixTransferNumber = BTD.ixTransferNumber
WHERE ixSKU = '60-60202-1'
  AND BTM.flgClosed = 0 
  AND BTM.flgReverseBOM = 0 
  AND BTM.dtCanceledDate IS NULL 
  AND (ISNULL(BTM.iCompletedQuantity,0) < BTM.iQuantity 
                    OR iOpenQuantity > 0)   
  
  
SELECT SUM(BTD.iQuantity * iOpenQuantity) AS TotalQty
FROM tblBOMTransferDetail BTD 
LEFT JOIN tblBOMTransferMaster BTM ON BTM.ixTransferNumber = BTD.ixTransferNumber
WHERE ixSKU = '60-60202-1'
  AND BTM.flgClosed = 0 
  AND BTM.flgReverseBOM = 0 
  AND BTM.dtCanceledDate IS NULL 
  AND (ISNULL(BTM.iCompletedQuantity,0) < BTM.iQuantity 
                    OR iOpenQuantity > 0)     
                    
                    
SELECT ixSKU 
     , SUM(BTD.iQuantity * iOpenQuantity) AS TotalQty
FROM tblBOMTransferDetail BTD 
LEFT JOIN tblBOMTransferMaster BTM ON BTM.ixTransferNumber = BTD.ixTransferNumber
WHERE --ixSKU = '60-60202-1'
 -- AND
  BTM.flgClosed = 0 
  AND BTM.flgReverseBOM = 0 
  AND BTM.dtCanceledDate IS NULL 
  AND (ISNULL(BTM.iCompletedQuantity,0) < BTM.iQuantity 
                    OR iOpenQuantity > 0)     
GROUP BY ixSKU                        