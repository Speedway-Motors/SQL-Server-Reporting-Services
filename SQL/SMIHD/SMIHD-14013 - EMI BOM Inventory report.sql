-- SMIHD-14013 - EMI BOM Inventory report

-- vendor code 1410

/*
Columns:
    SKU #
    Description
    Is BOM for this sku currently open Y/N
    Current 12 month BOM QTY
    Current 12 month qty sold
    Quantity on hand
    Quantity available
*/

SELECT QS.ixSKU 'SKU',
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    ISNULL(OBOMT.QtyOnOpenBOMTransfers, 0) 'QtyOnOpenBOMTransfers',
    ISNULL(BOMU.BOM12MoUsage,0) 'BOM12MoUsage',
    ISNULL(SALES.QtySold12Mo,0) 'QtySold12Mo',
    ISNULL(BOMU.BOM12MoUsage,0) + ISNULL(SALES.QtySold12Mo,0) 'Tot12MoUsage',
    --(ISNULL(BOMU.BOM12MoUsage,0) + ISNULL(SALES.QtySold12Mo,0))/12 as 'EstMonthlyUsage',
    SKULL.iQAV 'SMI_QAV',
    SKULL2.iQAV 'EMI_QAV',
    (SKULL.iQAV+SKULL2.iQAV) 'CombQAV',
    SKULL.iQOS 'SMI_QOH',
    SKULL2.iQOS 'EMI_QOH',
    (SKULL.iQOS+SKULL2.iQOS) 'CombQOS',
    -- not asked for
    S.dtCreateDate
   -- S.dtDiscontinuedDate
FROM (-- QUALIFYING SKUS - EMI BOMs
      SELECT S.ixSKU
      FROM tblSKU S
        left join tblBOMTemplateMaster BTM on S.ixSKU = BTM.ixFinishedSKU 
        left join tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
      WHERE S.flgDeletedFromSOP = 0
        and BTM.ixFinishedSKU is NOT NULL -- SKU is a BOM  13,367
        and VS.ixVendor = '1410' -- 451
        and S.flgActive = 1
      ) QS
    LEFT JOIN tblSKU S on QS.ixSKU = S.ixSKU
    LEFT JOIN tblSKULocation SKULL on SKULL.ixSKU = S.ixSKU and SKULL.ixLocation = 99
    LEFT JOIN tblSKULocation SKULL2 on SKULL2.ixSKU = S.ixSKU and SKULL2.ixLocation = 98
	LEFT JOIN (-- 12 Mo Sales & Qty Sold
				SELECT OL.ixSKU
					,SUM(OL.iQuantity) AS 'QtySold12Mo', SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
				FROM tblOrderLine OL 
					join tblDate D on D.dtDate = OL.dtOrderDate 
				WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
					and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
				GROUP BY OL.ixSKU
				) SALES on SALES.ixSKU = S.ixSKU
    LEFT JOIN (-- 12 Month BOM USAGE
                SELECT BOMTD.ixSKU
                    , isnull(SUM(CAST(BOMTD.iQuantity AS INT)*CAST(BOMTM.iCompletedQuantity AS INT)),0) 'BOM12MoUsage' 
                FROM tblBOMTransferMaster BOMTM 
                    join tblBOMTransferDetail BOMTD on BOMTD.ixTransferNumber = BOMTM.ixTransferNumber
                    join tblDate D on D.ixDate = BOMTM.ixCreateDate
                WHERE D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                    and BOMTM.flgReverseBOM = 0 -- exclude reverse BOMs
                GROUP BY BOMTD.ixSKU
                ) BOMU on BOMU.ixSKU = S.ixSKU
    LEFT JOIN (-- Qty on Open BOM Transfers
                SELECT ABTM.ixFinishedSKU, SUM(ABTM.QtyRemaining) 'QtyOnOpenBOMTransfers'
                FROM (-- ALL Open BOM Transfers
                        SELECT BTM.ixFinishedSKU,
                           (BTM.iQuantity-isnull(BTM.iCompletedQuantity,0))   QtyRemaining
                        from tblBOMTransferMaster BTM
                        where BTM.flgReverseBOM = 0
                           and BTM.dtCanceledDate is NULL
                           and isnull(BTM.iCompletedQuantity,0) < BTM.iQuantity
                        ) ABTM
                GROUP BY ABTM.ixFinishedSKU
                ) OBOMT ON OBOMT.ixFinishedSKU = S.ixSKU
    --LEFT JOIN tblBOMTemplateMaster BTM on S.ixSKU = BTM.ixFinishedSKU
--WHERE 
    --ISNULL(BOMU.BOM12MoUsage,0) + ISNULL(SALES.QtySold12Mo,0) <=5
    --ISNULL(OBOMT.QtyOnOpenBOMTransfers, 0) > 0
ORDER BY ISNULL(BOMU.BOM12MoUsage,0) + ISNULL(SALES.QtySold12Mo,0)
--S.dtDiscontinuedDate -- ISNULL(OBOMT.QtyOnOpenBOMTransfers, 0) desc
    --SKULL2.iQAV+SKULL2.iQOS desc
    
 /*
Rules:

Highlight RED – All shu’s where QAV is less than or equal to 5

Highlight*
*ORANGE – All sku’s where QAV is within 20% of 12 month QTY sold

Highlight+
+YELLOW – All sku’s where QAV is within 35% of 12 month QTY sold

Highlight open BOM column GREEN if the BOM is open
*/
 
/*
With this setup, all skus with sufficient qty will be on the report as well, but will not have any color coding. 
I want to be able to see everything we make at all times so we can watch inventory changes daily with this report.

The objective for this report is to show us not only what work needs to be done, 
but to help us prioritize what to build, and or order, without having to waste time 
sorting through part numbers daily. Once we get a sample of this I will sit down with
 my production coordinator and look through it. We will make some notes for any revisions
  we want to add from there. Hopefully this will be much simpler than the last one you and 
  I worked on so we don’t take up too much of your time!!!


--select * from tblLocation 

SELECT
   BTM.ixFinishedSKU                                  ixSKU,
   BTM.ixTransferNumber,
   BTM.iQuantity                                      QtyRequested,
   BTM.iCompletedQuantity                             QtyCompleted,
   (BTM.iQuantity-isnull(BTM.iCompletedQuantity,0))   QtyRemaining,
   (D.dtDate)                                         DeliveryDate
from tblBOMTransferMaster BTM
   join tblDate D on D.ixDate = BTM.ixDueDate
where BTM.ixFinishedSKU = @SKU
   and BTM.flgReverseBOM = 0
   and BTM.dtCanceledDate is NULL
   and isnull(BTM.iCompletedQuantity,0) < BTM.iQuantity
ORDER BY DeliveryDate

(-- Qty on Open BOM Transfers
SELECT ABTM.ixFinishedSKU, SUM(ABTM.QtyRemaining) 'QtyOnOpenBOMTransfers'
FROM (-- ALL Open BOM Transfers
        SELECT BTM.ixFinishedSKU,
           (BTM.iQuantity-isnull(BTM.iCompletedQuantity,0))   QtyRemaining
        from tblBOMTransferMaster BTM
        where BTM.flgReverseBOM = 0
           and BTM.dtCanceledDate is NULL
           and isnull(BTM.iCompletedQuantity,0) < BTM.iQuantity
        ) ABTM
GROUP BY ABTM.ixFinishedSKU
)
*/