-- SMIHD-9152 - tblSKU PriceLevel1 vs tblCatalogDetail PriceLevel1

-- SELECT TOP 10 * FROM tblCatalogDetail where ixCatalog = 'WEB.17'

SELECT S.ixSKU
    , ISNULL(S.sWebDescription,S.sDescription) 'SKUDescription' 
    , S.mPriceLevel1 'InventoryPLvl1'  --
    , CD.mPriceLevel1 'WEB.17PLvl1'
    , ABS(S.mPriceLevel1-CD.mPriceLevel1) 'Delta'
    , S.dtCreateDate 
    , S.sSEMACategory 'Category'
    , S.sSEMASubCategory 'Sub-Category'
    , S.sSEMAPart 'Part'
    , SALES.QtySold12Mo
    , BOMU.BOM12MoUsage
    , (CASE WHEN CABOM.ixSKU IS NOT NULL THEN 'Y'
       ELSE 'N'
       END) AS 'ComponentOfActiveBOM'
    , VS.ixVendor 'PV'
    , V.sName 'PVName'
--INTO [SMITemp].dbo.PJC_SMIHD9152_SKUsWPL1Deltas  
-- DROP TABLE [SMITemp].dbo.PJC_SMIHD9152_SKUsWPL1Deltas  
from tblSKU S
    left join tblCatalogDetail CD on S.ixSKU = CD.ixSKU and CD.ixCatalog = 'WEB.17' 
    left join vwGarageSaleSKUs GS on S.ixSKU = GS.ixSKU
    left join (-- 12 Month BOM USAGE
                SELECT BOMTD.ixSKU
                    , isnull(SUM(CAST(BOMTD.iQuantity AS INT)*CAST(BOMTM.iCompletedQuantity AS INT)),0) 'BOM12MoUsage' 
                FROM tblBOMTransferMaster BOMTM 
                    join tblBOMTransferDetail BOMTD on BOMTD.ixTransferNumber = BOMTM.ixTransferNumber
                    join tblDate D on D.ixDate = BOMTM.ixCreateDate
                WHERE D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                    and BOMTM.flgReverseBOM = 0 -- exclude reverse BOMs
                GROUP BY BOMTD.ixSKU) BOMU on BOMU.ixSKU = S.ixSKU
    left join (-- 12 Mo QTY SOLD
                SELECT OL.ixSKU
                    ,SUM(OL.iQuantity) AS 'QtySold12Mo'
                FROM tblOrderLine OL 
                    join tblDate D on D.dtDate = OL.dtOrderDate 
                WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                    and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                GROUP BY OL.ixSKU) SALES on SALES.ixSKU = S.ixSKU 
    left join vwComponentSKUsOfActiveBOMs CABOM on CABOM.ixSKU = S.ixSKU                         
    left join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on VS.ixVendor = V.ixVendor
WHERE S.flgDeletedFromSOP = 0
    and S.flgActive = 1               --259,386
    and S.flgIntangible = 0           --259,322
    and S.mPriceLevel1 > 0          --242,580
 --   AND VS.ixVendor NOT IN ('3706','2095','1142','1018')
 --   AND S.dtCreateDate <> '06/17/2017'
    and ABS(S.mPriceLevel1-CD.mPriceLevel1) > 0 -- has a Delta    
    and GS.ixSKU is NULL -- excludes Garage Sale SKUs
ORDER BY V.sName --ABS(S.mPriceLevel1-CD.mPriceLevel1) DESC



-- Possible PSEUDO LOGIC FOR Tracking SKU price changes
1) Trunacte YesterdaysSKUPriceLvl1 
2) insert into YesterdaysSKUPriceLvl1  
    SELECT SKU, InventoryPLvl1, WEB.17PLvl1, Date
    FROM TodaysSKUPriceLvl1
3) Trunacte TodaysSKUPriceLvl1  
4) insert into YesterdaysSKUPriceLvl1   
    SELECT SKU, InventoryPLvl1, WEB.17PLvl1, Date
    FROM TodaysSKUPriceLvl1 

5) run report to show SKUs with changed PriceLvl1 values


select * from tblCatalogDetail where ixCatalog = 'WEB.17' -- 274,456



SELECT S.ixSKU
    , S.mPriceLevel1 'InventoryPLvl1'  --
    , CD.mPriceLevel1 'WEB.17PLvl1'
    , DATEADD(dd,0,DATEDIFF(dd,0,getdate())) 'dtDate'
from tblSKU S
    left join tblCatalogDetail CD on S.ixSKU = CD.ixSKU and CD.ixCatalog = 'WEB.17' 
    left join vwGarageSaleSKUs GS on S.ixSKU = GS.ixSKU
WHERE S.flgDeletedFromSOP = 0
    and S.flgActive = 1               --259,386
    and S.flgIntangible = 0           --259,322
   -- and S.mPriceLevel1 > 0          --242,580
    and GS.ixSKU is NULL -- excludes Garage Sale SKUs
    and ABS(S.mPriceLevel1-CD.mPriceLevel1) > 0) -- has a Delta        
ORDER BY ABS(S.mPriceLevel1-CD.mPriceLevel1) DESC




SELECT PLD.*
    ,(CASE WHEN TNG.ixSOPSKU IS NOT NULL then 'Y'
      ELSE 'N'
      END) as 'AvailableOnTheWeb' 
FROM [SMITemp].dbo.PJC_SMIHD9152_SKUsWPL1Deltas PLD
    left join (-- available on the Web
              SELECT TNG.ixSOPSKU
               FROM openquery([TNGREADREPLICA], '
                            select s.ixSOPSKU 
                            from tblskubase AS b
                                inner JOIN tblskuvariant s ON b.ixSKUBase = s.ixSKUBase
                                inner JOIN tblproductpageskubase ppsb ON b.ixSKUBase = ppsb.ixSKUBase
                                inner JOIN tblproductpage AS pp ON ppsb.ixProductPage = pp.ixProductPage
                            WHERE b.flgWebPublish = 1
                                AND s.flgPublish = 1
                                AND pp.flgActive = 1
                                AND fn_isProductSaleable(s.flgFactoryShip, s.flgDiscontinued, s.flgBackorderable, s.iTotalQAV, s.flgMTO) = 1
                             '
                            ) TNG 
               ) TNG on PLD.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = TNG.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS   
WHERE PV NOT IN ('3706','2095','1142','1018')               
ORDER BY PLD.PV



SELECT PLD.ixSKU, S.dtDateLastSOPUpdate
FROM [SMITemp].dbo.PJC_SMIHD9152_SKUsWPL1Deltas PLD
    join tblSKU S on S.ixSKU = PLD.ixSKU
WHERE PV NOT IN ('3706','2095','1142','1018')     
ORDER BY S.dtDateLastSOPUpdate     