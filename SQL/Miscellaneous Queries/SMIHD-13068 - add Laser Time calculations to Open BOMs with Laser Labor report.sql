-- SMIHD-13068 - add Laser Time calculations to Open BOMs with Laser Labor report
SELECT
   BTM.ixFinishedSKU                         'SKU',
   ISNULL(S.sWebDescription, S.sDescription) 'SKU_Description',
   BTM.ixTransferNumber                      'Transfer_#',
   BTM.iQuantity                             'Qty_Requested',
   BTM.iCompletedQuantity                    'Qty_Completed',
   (BTM.iQuantity-isnull(BTM.iCompletedQuantity,0)) 'Qty_Remaining',
   ISNULL(SALES.QtySold12Mo,0)                'QtySold12Mo',
   ISNULL(BOMU.BOM12MoUsage,0)                'BOM12MoUsage',
   FORMAT(D2.dtDate,'yyyy-MM-dd')             'BOM_Transfer_Create_Date',
   FORMAT(D.dtDate,'yyyy-MM-dd')             'Due_Date',
   isnull(MATSKU.Material_SKU,'No Material SKU') 'Material_SKU',
   MATSKU.Material_SKU_Description            'Material_SKU_Description',
   MATSKU.QtyPerBOM                          'Qty_Per_BOM',
   (CAST((BTM.iQuantity-isnull(BTM.iCompletedQuantity,0)) AS INT) * (MATSKU.QtyPerBOM)) AS 'Total_Units_Needed',
   LT.LaserTimePerBOM 'Laser_Seconds_Per_BOM',
   (CAST((BTM.iQuantity-isnull(BTM.iCompletedQuantity,0)) AS INT) * (LT.LaserTimePerBOM)) AS 'Total_Laser_Seconds_Needed'
   --into #LaserLaborMaterialSummary
from tblBOMTransferMaster BTM
   left join tblDate D on D.ixDate = BTM.ixDueDate
   left join tblDate D2 on D2.ixDate = BTM.ixCreateDate
   left join tblSKU S on BTM.ixFinishedSKU = S.ixSKU
   left join (-- Material SKU
              select ixFinishedSKU, TD.ixSKU 'Material_SKU', ISNULL(S.sWebDescription, S.sDescription) 'Material_SKU_Description', iQuantity 'QtyPerBOM'
              from tblBOMTemplateDetail TD
                left join tblSKU S on TD.ixSKU = S.ixSKU
              where TD.ixSKU like 'M%') MATSKU on MATSKU.ixFinishedSKU = BTM.ixFinishedSKU
   left join (-- LaserTime
              select ixFinishedSKU, TD.ixSKU 'LASERTIME', ISNULL(S.sWebDescription, S.sDescription) 'Laser_SKU_Description', iQuantity 'LaserTimePerBOM'
              from tblBOMTemplateDetail TD
                left join tblSKU S on TD.ixSKU = S.ixSKU
              where TD.ixSKU = '916108') LT on LT.ixFinishedSKU = BTM.ixFinishedSKU
    LEFT JOIN (-- 12 Mo SALES & Quantity Sold
                SELECT OL.ixSKU
                    ,SUM(OL.iQuantity) AS 'QtySold12Mo', SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
                FROM tblOrderLine OL 
                    join tblDate D on D.dtDate = OL.dtOrderDate 
                WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                    and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                GROUP BY OL.ixSKU
                ) SALES on SALES.ixSKU = BTM.ixFinishedSKU 
    LEFT JOIN (-- 12 Month BOM USAGE
                SELECT BOMTD.ixSKU
                    , isnull(SUM(CAST(BOMTD.iQuantity AS INT)*CAST(BOMTM.iCompletedQuantity AS INT)),0) 'BOM12MoUsage' 
                FROM tblBOMTransferMaster BOMTM 
                    join tblBOMTransferDetail BOMTD on BOMTD.ixTransferNumber = BOMTM.ixTransferNumber
                    join tblDate D on D.ixDate = BOMTM.ixCreateDate
                WHERE D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                    and BOMTM.flgReverseBOM = 0 -- exclude reverse BOMs
                GROUP BY BOMTD.ixSKU
                ) BOMU on BOMU.ixSKU = BTM.ixFinishedSKU 
WHERE BTM.ixFinishedSKU in (select distinct ixFinishedSKU
                            from tblBOMTemplateDetail
                            where ixSKU = '916108' -- 1,441
                            and flgDeletedFromSOP = 0
                            )
   and BTM.flgReverseBOM = 0
   and BTM.flgClosed = 0
   and BTM.dtCanceledDate is NULL
   and (ISNULL(BTM.iCompletedQuantity,0) < BTM.iQuantity 
                    OR iOpenQuantity > 0) 
ORDER BY Due_Date -- 141

/*
select --TD.ixFinishedSKU, 
DISTINCT
    TD.ixSKU, TD.iQuantity, 
    S.sDescription
from tblBOMTemplateDetail TD
    left join tblSKU S on TD.ixSKU = S.ixSKU
where ixFinishedSKU in ('350900.2.11','350900.2.5-LH','350900.2.5-RH','350900.2.8','350900.4.1-LH','350900.4.1-RH','350900.4.2-LH','350900.4.2-RH','350900.4.3-LH','350900.4.3-RH','350900.4.4-LH','350900.4.4-RH','350900.4.5','350900.3.3','350900.2.1.2','350900.2.1.4','350900.2.2.1','350900.2.2.2','350900.2.2.3','350900.2.3.1','350900.2.3.2','350900.2.4.1-LH','350900.2.4.1-RH','350900.2.4.2-LH','350900.2.4.2-RH','350900.2.6.2','350900.2.7.5','350900.2.7.2.1','350900.2.7.3.1','350900.2.9.1-LH','350900.2.9.1-RH','350900.3.1.1-LH','350900.3.1.1-RH','350900.3.1.2-LH','350900.3.1.2-RH','350900.3.1.3-LH','350900.3.1.3-RH','350900.3.2.1','350900.3.2.2-LH','350900.3.2.2-RH','350900.3.5.1','350900.3.5.2','94713222-5544','91140412','91035700.6','91668041.1.3','91668044.4','91668041.1.1','91668041.1.2','91657025.2.L','91657025.2.R','91004754.5','91004754.6L','91004754.6R','91027001-1.1.2','91027001-1.1.3','91027001-1.1.4','91140171','91140212.2','91140218.2','91618009-PASS','3003600.2','3003600.4','91004754.13-R','91655571.2-LH','91655571.2-RH','3008101','91657013.2.LH','91657013.2.RH','3003600.3','9801020','9801021','91063540.2','91004754.13-L','91140246.1','91140246.1','3003600.1','91139530.2','9101978.1','555009','91027001-1.1.1','910471-1.375','91032109.1','3008102','350004.1.1-LH','350004.1.1-RH','91032700.1','3008103','91054032.1')
    and TD.ixSKU <> '916108'
    and TD.ixSKU NOT LIKE 'M%'
order by TD.ixFinishedSKU, TD.ixSKU


*/

select * from tblBOMTemplateDetail where ixFinishedSKU = '555009' -- 20 laser seconds/BOM