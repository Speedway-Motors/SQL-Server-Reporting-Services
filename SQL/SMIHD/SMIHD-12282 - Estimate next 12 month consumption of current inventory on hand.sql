-- SMIHD-12282 -- Estimate next 12 month consumption of current inventory on hand

-- STEP 1
    -- DROP TABLE [SMITemp].dbo.PJC_SMIHD12282_FIFODetail_ixDate18571
    select * 
    into [SMITemp].dbo.PJC_SMIHD12282_FIFODetail_ixDate18571 -- 249,934
    from tblFIFODetail FD
    where FD.ixDate = 18571



-- QUERY FOR MASTER SPREADSHEET
-- output for spreadsheet
-- IMPORTANT!  
-- add calc in spreadsheet for Qty consumed * avg cost (or latest cost). 
-- Subtract that extended cost from the current value.
-- ONLY TOTAL THE SKUS WITH A POSITIVE BALANCE!!!!   
--      (e.g. we may have $5k worth of a SKU but project to sell $20k of it.  we do not want to add -15k to the total)
SELECT  
    FD.ixSKU, -- 76,869 NOW RUNS IN 4 SECONDS!
    ISNULL(SKU.sWebDescription, SKU.sDescription) 'SKUDescription',
    SKU.mPriceLevel1 'PriceLevel1', 
    SKUL.iQOS 'QOS', 
	SUM(FD.iFIFOQuantity) as 'FIFOQty', 
    SUM(FD.iFIFOQuantity*FD.mFIFOCost) as 'FIFOCost',
	--SUM(FD.iFIFOQuantity*convert(money, SKU.mPriceLevel1)) as 'RetailResaleValue',
    SKU.mAverageCost 'AvgCost',
    SKU.mLatestCost 'LatestCost',
    ISNULL(SALES.QtySold12Mo,0) 'Proj12MoDirectSalesQty',
    ISNULL(BOM.BOMQty,0) 'Proj12MoBOMConsumption',
    ISNULL(KITSALES.QtySold12MoKitComp,0) 'Proj12MoKitComponentSalesQty',
    SKU.sSEMACategory 'SEMACat',
    SKU.sSEMASubCategory 'SEMASubCat',
    SKU.sSEMAPart 'SEMAPart',
    SKU.flgActive,
    SKU.flgIntangible,
    SKU.flgIsKit,
    SKU.flgUnitOfMeasure,
    (CASE WHEN BOMTM.ixFinishedSKU is NOT NULL THEN 1
     ELSE 0
     END) as 'flgBOM'
FROM -- tblFIFODetail FD
    [SMITemp].dbo.PJC_SMIHD12282_FIFODetail_ixDate18571 FD -- only has 249,934 rows
	LEFT JOIN tblSKU SKU on FD.ixSKU = SKU.ixSKU
	--LEFT JOIN tblDate D on FD.ixDate = D.ixDate
    LEFT JOIN (-- 12 Mo SALES & Quantity Sold DIRECT SALES (non-kit component)
                SELECT OL.ixSKU
                    ,SUM(OL.iQuantity) AS 'QtySold12Mo'--, SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
                FROM tblOrderLine OL 
                   -- join tblDate D on D.dtDate = OL.dtOrderDate 
                WHERE OL.ixOrderDate between 18209 and 18573 -- 11/07/2017 and 11/06/2018
                    -- D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                    and OL.flgLineStatus IN ('Shipped','Dropshipped')
                    and OL.flgKitComponent = 0
                GROUP BY OL.ixSKU
                ) SALES on SALES.ixSKU = SKU.ixSKU  
    LEFT JOIN (-- 12 Mo KIT SALES & Quantity Sold DIRECT SALES (kit component)
                SELECT OL.ixSKU
                    ,SUM(OL.iQuantity) AS 'QtySold12MoKitComp'--, SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
                FROM tblOrderLine OL 
                   -- join tblDate D on D.dtDate = OL.dtOrderDate 
                WHERE OL.ixOrderDate between 18209 and 18573 -- 11/07/2017 and 11/06/2018
                    and OL.flgLineStatus IN ('Shipped','Dropshipped')
                    and OL.flgKitComponent = 1
                 --   and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                GROUP BY OL.ixSKU
                ) KITSALES on KITSALES.ixSKU = SKU.ixSKU  
    LEFT JOIN (-- 12 Mo BOM Usage
                SELECT BOMTD.ixSKU, SUM(CAST(BOMTD.iQuantity AS INT)*CAST(BOMTM.iCompletedQuantity AS INT)) BOMQty 
                FROM    tblBOMTransferMaster BOMTM 
                    join tblBOMTransferDetail BOMTD on BOMTD.ixTransferNumber = BOMTM.ixTransferNumber
                    --join tblDate D on D.ixDate = BOMTM.ixCreateDate
                WHERE BOMTM.ixCreateDate between 18209 and 18573 -- 11/07/2017 and 11/06/2018
                --D.dtDate between DATEADD(yy, -1, getdate()) and getdate()
                    and BOMTM.flgReverseBOM = 0
                GROUP BY BOMTD.ixSKU) BOM on BOM.ixSKU = SKU.ixSKU
    LEFT JOIN tblSKULocation SKUL on SKUL.ixSKU = SKU.ixSKU and SKUL.ixLocation = 99
    LEFT JOIN tblBOMTemplateMaster BOMTM on BOMTM.ixFinishedSKU = SKU.ixSKU
WHERE --FD.ixDate = 18571 --dtDate = '11/04/2018' ---@parmFIFODate
     SKU.flgDeletedFromSOP = 0
GROUP BY FD.ixSKU, SKU.mAverageCost, SKU.mLatestCost, 
    ISNULL(SALES.QtySold12Mo,0),
    ISNULL(BOM.BOMQty,0),
    ISNULL(SKU.sWebDescription, SKU.sDescription),
    ISNULL(KITSALES.QtySold12MoKitComp,0),
    SKU.mPriceLevel1,
    SKUL.iQOS,
    SKU.sSEMACategory,
    SKU.sSEMASubCategory,
    SKU.sSEMAPart,
    SKU.flgActive,
    SKU.flgIntangible,
    SKU.flgIsKit,
    SKU.flgUnitOfMeasure,
    (CASE WHEN BOMTM.ixFinishedSKU is NOT NULL THEN 1
     ELSE 0
     END)
--HAVING SUM(FD.iFIFOQuantity*FD.mFIFOCost) > 0
--ORDER BY SUM(FD.iFIFOQuantity*FD.mFIFOCost) 


/*

-- FIFO data from 18572 -- 10/05/2018
-- DROP TABLE [SMITemp].dbo.PJC_SMIHD12282_FIFODetail_ixDate18571
select * 
into [SMITemp].dbo.PJC_SMIHD12282_FIFODetail_ixDate18571
from tblFIFODetail FD
where FD.ixFIFODate = 18571



SELECT ixFIFODate, count(*)
from tblFIFODetail
where ixFIFODate >= 18000
group by ixFIFODate
order by ixFIFODate desc



select count(*)
from tblSKULocation
where ixLocation = 99 and iQAV > 0



select
	SUM(FD.iFIFOQuantity) as 'FIFOQty', 
	SUM(FD.iFIFOQuantity*FD.mFIFOCost) as 'FIFOCost',
	SUM(FD.iFIFOQuantity*convert(money, SKU.mPriceLevel1)) as 'Retail Resale Value'
from
	tblFIFODetail FD
	left join tblSKU SKU on FD.ixSKU = SKU.ixSKU
	--left join tblDate D on FD.ixDate = D.ixDate
where
	FD.ixDate = 18571 --dtDate = '11/04/2018' ---@parmFIFODate


    */