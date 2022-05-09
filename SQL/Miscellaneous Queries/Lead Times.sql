SELECT
    SKU.ixSKU               SKU,
    SKU.sDescription        Description,
    isnull(SKU.iQOS,0)      QoH,
    isnull(YTD.YTDQTYSold,0)  Sales12Mo,
    isnull(BOMYTD.QTY,0)    BOM12Mo,
    isnull((isnull(YTD.YTDQTYSold,0)  +  isnull(BOMYTD.QTY,0)),0) TotalUsage12Mo,
    SKU.iLeadTime,
   VS.ixVendor
FROM tblSKU SKU
    join PJC_Recently_Used_SKUs RUS on RUS.ixSKU = SKU.ixSKU
    left join tblVendorSKU VS on VS.ixSKU = SKU.ixSKU
    left join 
    -- 12 month sales
      (SELECT                               
       AMS.ixSKU,
        SUM(AMS.AdjustedQTYSold)	YTDQTYSold
      FROM vwAdjustedDailySKUSales AMS
      WHERE AMS.dtDate >= DATEADD(mm, DATEDIFF(mm,0,getdate())-12, 0)    -- 12 months ago
            and AMS.dtDate < getdate() -- previous month
      GROUP BY AMS.ixSKU
      ) YTD on YTD.ixSKU = SKU.ixSKU
    left join 
    -- 12 month BOM Qty consumed
  (SELECT BOMTD.ixSKU,
   SUM(CAST(BOMTD.iQuantity AS INT)*CAST(BOMTM.iCompletedQuantity AS INT)) QTY 
   FROM tblBOMTransferMaster BOMTM 
        join tblBOMTransferDetail BOMTD on BOMTD.ixTransferNumber = BOMTM.ixTransferNumber
        join tblDate D on D.ixDate = BOMTM.ixCreateDate
                      and D.dtDate >= DATEADD(mm, DATEDIFF(mm,0,getdate())-12, 0)    -- 12 months ago
   GROUP BY BOMTD.ixSKU
   ) BOMYTD on BOMYTD.ixSKU = YTD.ixSKU
WHERE SKU.ixSKU not like 'UP%'
  and SKU.flgIsKit = 0
  and SKU.flgActive = 1
  and SKU.flgIntangible = 0
  and SKU.iLeadTime < 1
--  and SKU.iLeadTime is not NULL
  and VS.iOrdinality = 1





select distinct ixSKU
into PJC_Recently_Used_SKUs
from tblSKU
where ixSKU in (select distinct SKU.ixSKU
                from tblSKU SKU
                   join tblCatalogDetail CD on SKU.ixSKU = CD.ixSKU
                   join tblCatalogMaster CM on CM.ixCatalog = CD.ixCatalog
                where CM.dtStartDate >= '03/01/2010')