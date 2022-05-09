-- Receivers with open BOM quantities (1st level of sub-components only)
SELECT R.ixReceiver,
--SKU.iQAV,
 (CASE WHEN OBT.ixSKU is NOT NULL THEN 'Y'
          ELSE 'N'
      END) 'OpenBOM',
                min(case when SKU.iQAV < 0 and POD.iQuantity > POD.iQuantityPosted then 1
                         when SKU.iQAV = 0 and POD.iQuantity > POD.iQuantityPosted then 2
                         else 3
                    end) sortpriority
                FROM tblReceiver R 
                    left join tblPODetail POD on POD.ixPO = R.ixPO
                    left join vwSKULocalLocation SKU on SKU.ixSKU = POD.ixSKU
LEFT JOIN (-- Open BOM Transfers
               -- code from  "sub - Open BOM Transfers.rdl" (AFCO/Purchasing)
                SELECT
                   BTM.ixFinishedSKU                                  ixSKU--,
                 --  BTM.ixTransferNumber,
                 --  BTM.iQuantity                                      QtyRequested,
                 --  BTM.iCompletedQuantity                             QtyCompleted,
                 --  (BTM.iQuantity-isnull(BTM.iCompletedQuantity,0))   QtyRemaining,
                 --  (D.dtDate)                                         DeliveryDate
                from tblBOMTransferMaster BTM
                   join tblDate D on D.ixDate = BTM.ixDueDate
                where --BTM.ixFinishedSKU = @SKU
                    ISNULL(BTM.iCompletedQuantity,0) < BTM.iQuantity 
                   and BTM.dtCanceledDate is NULL
                   and (iOpenQuantity > 0
                         OR iReleasedQuantity <> 0) 
                   and flgReverseBOM = 0  
                   ) OBT on SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = OBT.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS                 
                WHERE R.flgStatus IN ('Open', 'Closed')
                GROUP BY  R.ixReceiver,
                --SKU.iQAV,
                (CASE WHEN OBT.ixSKU is NOT NULL THEN 'Y'
          ELSE 'N'
      END) 
                
                
-- code from  "sub - Open BOM Transfers.rdl" (AFCO/Purchasing)
SELECT
   BTM.ixFinishedSKU                                  ixSKU--,
 --  BTM.ixTransferNumber,
 --  BTM.iQuantity                                      QtyRequested,
 --  BTM.iCompletedQuantity                             QtyCompleted,
 --  (BTM.iQuantity-isnull(BTM.iCompletedQuantity,0))   QtyRemaining,
 --  (D.dtDate)                                         DeliveryDate
from tblBOMTransferMaster BTM
   join tblDate D on D.ixDate = BTM.ixDueDate
where --BTM.ixFinishedSKU = @SKU
    ISNULL(BTM.iCompletedQuantity,0) < BTM.iQuantity 
   and BTM.dtCanceledDate is NULL
   and (iOpenQuantity > 0
         OR iReleasedQuantity <> 0) 
   and flgReverseBOM = 0  
ORDER BY DeliveryDate 







                