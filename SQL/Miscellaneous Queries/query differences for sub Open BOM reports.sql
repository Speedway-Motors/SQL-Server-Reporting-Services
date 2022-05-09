--  QUERY DIFFERENCES FOR SUB- OPEN BOM reports

-- mgmt 1712
SELECT
   BTM.ixFinishedSKU                                  ixSKU,
   BTM.ixTransferNumber,
   BTM.iQuantity                                      QtyRequested,
   BTM.iCompletedQuantity                             QtyCompleted,
   (BTM.iQuantity-isnull(BTM.iCompletedQuantity,0))   QtyRemaining,
   (D.dtDate)                                         DeliveryDate
from tblBOMTransferMaster BTM
   join tblDate D on D.ixDate = BTM.ixDueDate
where --BTM.ixFinishedSKU = @SKU
    BTM.flgReverseBOM = 0
   and flgClosed = 0 

   and BTM.dtCanceledDate is NULL   
   and (ISNULL(BTM.iCompletedQuantity,0) < BTM.iQuantity 
                    OR iOpenQuantity > 0) 
ORDER BY DeliveryDate
                    
                    
                    
--purch 314
SELECT
   BTM.ixFinishedSKU                                  ixSKU,
   BTM.ixTransferNumber,
   BTM.iQuantity                                      QtyRequested,
   BTM.iCompletedQuantity                             QtyCompleted,
   (BTM.iQuantity-isnull(BTM.iCompletedQuantity,0))   QtyRemaining,
   (D.dtDate)                                         DeliveryDate
from tblBOMTransferMaster BTM
   join tblDate D on D.ixDate = BTM.ixDueDate
where --BTM.ixFinishedSKU = @SKU
        BTM.dtCanceledDate is NULL
   and flgReverseBOM = 0 
           
   and ISNULL(BTM.iCompletedQuantity,0) < BTM.iQuantity 
   and (iOpenQuantity > 0
         OR iReleasedQuantity <> 0) 
 and flgClosed = 1
ORDER BY DeliveryDate                    