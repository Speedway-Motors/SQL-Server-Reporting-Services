-- SMIHD-14586 - BOM analysis for Carson
select BTM.ixFinishedSKU 'BOM',
    ISNULL(S.sWebDescription, S.sDescription) 'SKU/WEB Description',
     VS.ixVendor 'PV',
    (CASE WHEN NPV.ixFinishedSKU is NOT NULL THEN 'Y'
     ELSE 'N'
     END) '0001 non-primary vendor' ,
     SL.iQOS 'QoH',
     ISNULL(SALES.QtySold12Mo,0) '12Mo Qty Sold',
     ISNULL(BOMU.BOM12MoUsage,0) '12Mo BOM Usage',
     ISNULL(OPQ.OpenQtyOnPOs,0) 'Open Qty On POs',
     (CASE WHEN SL.iQOS = 0
            AND ISNULL(BOMU.BOM12MoUsage,0) = 0
            AND ISNULL(SALES.QtySold12Mo,0) = 0
            AND ISNULL(OPQ.OpenQtyOnPOs,0) = 0
           THEN 'Y'
           ELSE 'N'
      END) 'Dead SKU',
     S.sSEMACategory 'Category',
     S.sSEMASubCategory 'Sub-Cat',
     S.sSEMAPart 'Part',
     S.flgActive
from tblBOMTemplateMaster BTM
    LEFT JOIN tblSKU S on BTM.ixFinishedSKU = S.ixSKU
    LEFT JOIN tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    LEFT JOIN (-- is vendor 0001 a non-primary vendor?
               SELECT BTM.ixFinishedSKU
               from tblBOMTemplateMaster BTM
                left join tblSKU S on BTM.ixFinishedSKU = S.ixSKU
                left join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality <> 1
               WHERE VS.ixVendor = '0001'
                 and VS.iOrdinality <> 1
              ) NPV ON S.ixSKU = NPV.ixFinishedSKU
    LEFT JOIN tblSKULocation SL on SL.ixSKU = S.ixSKU and SL.ixLocation = 99
    LEFT JOIN (-- 12 Mo SALES & QTY SOLD
                SELECT OL.ixSKU,SUM(OL.iQuantity) AS 'QtySold12Mo', 
                    SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
                FROM tblOrderLine OL 
                    left join tblDate D on D.dtDate = OL.dtOrderDate 
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
    LEFT JOIN (-- Open PO Qty
                 SELECT POD.ixSKU, sum(POD.iQuantity-isnull(POD.iQuantityReceivedPending,0)-isnull(POD.iQuantityPosted,0)) OpenQtyOnPOs -- outstanding PO Qty
                         --POD.ixPO,D.dtDate ExpectedDelivery, 
                         from tblPODetail POD
                            join tblPOMaster POM on POM.ixPO = POD.ixPO
                            left join tblDate D on D.ixDate = POD.ixExpectedDeliveryDate
                where POM.flgIssued = 1
                  and POM.flgOpen = 1
                  and (POD.iQuantity-isnull(POD.iQuantityReceivedPending,0)-isnull(POD.iQuantityPosted,0)) > 0
                         group by POD.ixSKU--, POD.ixPO, D.dtDate
                 ) OPQ on OPQ.ixSKU = S.ixSKU
WHERE S.flgDeletedFromSOP = 0 -- 13,480 (5,400 PV = 0001     2,621 0001 is a non-primary vendor)
ORDER BY 'Dead SKU' -- VS.ixVendor --'0001 non-primary vendor' desc


/*
select * from tblVendor
where ixVendor = '0001'

0001 BILL OF MATERIAL
*/