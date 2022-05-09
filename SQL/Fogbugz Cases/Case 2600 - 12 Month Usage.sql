SELECT
    SKU.ixSKU               SKU,
    SKU.sDescription        Description,
    isnull(SKU.iQOS,0)      QoH,
    isnull(YTD.YTDQTYSold,0)  Sales12Mo,
    isnull(BOMYTD.QTY,0)    BOM12Mo,
    isnull(SKU.mAverageCost,0) Cost,
    ((isnull(YTD.YTDQTYSold,0) + isnull(BOMYTD.QTY,0)) * isnull(SKU.mAverageCost,0)) ExCost
FROM tblSKU SKU
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
   SUM(BOMTD.iQuantity) QTY 
   FROM tblBOMTransferMaster BOMTM 
        join tblBOMTransferDetail BOMTD on BOMTD.ixTransferNumber = BOMTM.ixTransferNumber
        join tblDate D on D.ixDate = BOMTM.ixCreateDate
                      and D.dtDate >= DATEADD(mm, DATEDIFF(mm,0,getdate())-12, 0)    -- 12 months ago
   GROUP BY BOMTD.ixSKU
   ) BOMYTD on BOMYTD.ixSKU = YTD.ixSKU

WHERE SKU.ixSKU not like 'UP%'
and (isnull(YTD.YTDQTYSold,0) > 0 OR isnull(BOMYTD.QTY,0) <> 0)
and SKU.flgActive = 1