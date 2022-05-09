-- SKUs IN QC BUT ORDERS or BOMs ARE WAITING
SELECT --S.*,
    SL.iQAV, SL.iQC, SL.ixSKU,  S.sDescription, S.mPriceLevel1, S.flgMadeToOrder,
    S.flgActive, S.dtDiscontinuedDate, 
    (CASE WHEN OBT.ixSKU is NOT NULL THEN 'Y'
          ELSE 'N'
      END) 'OpenBOM'
FROM tblSKULocation SL
    join tblSKU S on SL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
    left join (-- Open BOM Transfers
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
                   ) OBT on S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = OBT.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE SL.ixLocation = '99'
    and S.flgIntangible = 0
    and S.flgDeletedFromSOP = 0
    and SL.iQAV < 0 -- 1143
    and SL.iQC > 0
ORDER BY SL.ixSKU

SELECT * from tblBrand where ixBrand in ('10013','10014')



select R.flgStatus              RecStatus,
    CONVERT(VARCHAR, D.dtDate, 101) OnDockDate,
    SUBSTRING(T.chTime,1,5)                  OnDockTime, 
    -- between current timestamp and timestamp on dock)
    ((DATEDIFF(HH,Getdate(),(D.dtDate+T.chTime))*-1)/24.0) DaysDelay, -- determining the total hour dif first then converting to days       
    V.ixVendor                  VendorNum,
    V.sName                     VendorName,
    R.ixPO                      PO,
    R.ixReceiver                Receiver,
    P.sortpriority              SortPriority,
   (case when sortpriority = '1' then 'Hot'
         when sortpriority = '2' then 'Warm'
         else 'Cold'
    end)                        Priority,
    POM.sPaymentTerms             PaymentTerms,
	(select convert(varchar, min(D1.dtDate), 101) from tblReceiver R1 left join tblDate D1 on R1.ixOnDockDate = D1.ixDate where R1.ixPO = R.ixPO) as 'FirstReceiver'
from tblReceiver R
    right join tblVendor V on R.ixVendor = V.ixVendor
    right join tblDate D on R.ixOnDockDate = D.ixDate
    right join tblTime T on R.ixOnDockTime = T.ixTime
    join tblPOMaster POM on POM.ixPO = R.ixPO
    left join (SELECT R.ixReceiver,
                min(case when SKU.iQAV < 0 and POD.iQuantity > POD.iQuantityPosted then 1
                         when SKU.iQAV = 0 and POD.iQuantity > POD.iQuantityPosted then 2
                         else 3
                    end) sortpriority
                FROM tblReceiver R 
                    left join tblPODetail POD on POD.ixPO = R.ixPO
                    left join vwSKULocalLocation SKU on SKU.ixSKU = POD.ixSKU
                WHERE R.flgStatus IN ('Open', 'Closed')
                GROUP BY  R.ixReceiver
                ) P on P.ixReceiver = R.ixReceiver
where R.flgStatus in ('Open', 'Closed')
 and R.flgDeletedFromSOP = 0
order by P.sortpriority,(DATEDIFF(HH,Getdate(),D.dtDate)*-1) desc,T.chTime




