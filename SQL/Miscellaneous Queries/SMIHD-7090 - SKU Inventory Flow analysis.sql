-- SMIHD-7090 - SKU Inventory Flow analysis

-- Create #TempDates
select DATEADD(dd, DATEDIFF(dd,0,getdate()), 0) 'Yesterday',
       DATEADD(dd, DATEDIFF(dd,1,getdate()), 0) 'TwoDaysAgo',
       DATEADD(mm,-12,GETDATE()) 'OneYearAgo',
       GETDATE() 'Today'
into #TempDates
/*
#TempDates.
#TempDates.
#TempDates.OneYearAgo       DATEADD(mm,-12,GETDATE())
#TempDates.Today
*/
SELECT 
       SKU.ixSKU AS SKU 
     , ISNULL(TNG.sSKUVariantName,SKU.sDescription) 'SKUDescription'
     , V.ixVendor AS PrimaryVendorNum
     , V.sName AS PrimaryVendor
     , V2.ixVendor AS SecondaryVendorNum
     , V2.sName AS SecondaryVendor     
     , SKU.mLatestCost 
     , SKU.mAverageCost        
     , SKU.mPriceLevel1 AS PriceLevel1 
     , ISNULL(TMS.QtySold,0) 'TMQtySold'
     , ISNULL(BOM.TotalQty,0) 'TMBOMConsumption'
     , ISNULL(TMS.KCQtySold,0) AS 'TMKitConsumption' 
     , ISNULL(TMS.QtySold,0) + ISNULL(BOM.TotalQty,0) + ISNULL(TMS.KCQtySold,0) 'TMCombinedUsageQty'
     , ISNULL(SKU.iQAV,0) AS 'QAV'
     , ISNULL(TMS.Sales,0) AS 'TMSales'
     , FIFO.TotFIFOCost 'CurrentFIFOCost'
     , SKU.ixProductLine 'ProductLine'
     , B.ixBrand AS 'Brand'
     , B.sBrandDescription AS 'BrandDescription'     
     , SKU.sSEMACategory AS Category
     , SKU.sSEMASubCategory AS SubCategory
     , SKU.sSEMAPart AS PartTerminology     
INTO [SMI Reporting].dbo.[tblSKUInventoryFlow_Rollup] -- [SMITemp].dbo.[PJC_TEMP]   75,084 40 minutes!
-- DROP TABLE [SMITemp].dbo.[PJC_SMIHD7090_SKUInventoryFlow] 
-- DROP TABLE [SMI Reporting].dbo.[tblSKUInventoryFlow_Rollup]  
FROM vwSKULocalLocation SKU
    LEFT JOIN (SELECT * FROM openquery([TNGREADREPLICA], '
                SELECT s.ixSOPSKU, s.sSKUVariantName
                FROM tblskuvariant s')
                ) TNG on TNG.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
    LEFT JOIN tblVendorSKU VSKU on VSKU.ixSKU = SKU.ixSKU and VSKU.iOrdinality = 1 
    LEFT JOIN tblVendorSKU VSKU2 on VSKU2.ixSKU = SKU.ixSKU and VSKU2.iOrdinality = 2    
    LEFT JOIN tblVendor V on V.ixVendor = VSKU.ixVendor
    LEFT JOIN tblVendor V2 on V2.ixVendor = VSKU2.ixVendor    
    LEFT JOIN tblBrand B on SKU.ixBrand = B.ixBrand
    LEFT JOIN (--Twelve Month Sales                                                             61,615 @5:46
               SELECT OL.ixSKU AS SKU 
				    , Qty.QtySold AS QtySold
				    , SUM(ISNULL(OL.mExtendedPrice,0)) AS Sales 
				    , Qty.KCQtySold
				--	, SUM(ISNULL(OL.mExtendedPrice,0)) - SUM(ISNULL(OL.mExtendedCost,0)) AS GP 
			   FROM tblOrderLine OL  
		       LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
			   LEFT JOIN (SELECT OL.ixSKU AS SKU    -- Sub-Query alone returns 61,457 @1:56  -- 3 SECONDS
							   , SUM(ISNULL(OL.iQuantity,0)) AS QtySold 
							   , SUM(CASE WHEN OL.flgKitComponent = '0' THEN 0 
                                 ELSE OL.iQuantity
                                END) AS KCQtySold  
						  FROM tblOrderLine OL
						  LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder  
						  WHERE O.dtOrderDate BETWEEN DATEADD(mm,-12,GETDATE()) and GETDATE() --  
						    AND O.sOrderStatus = 'Shipped' 
							AND O.sOrderType <> 'Internal' 
							AND O.mMerchandise > 0 
							AND O.ixOrder NOT LIKE '%-%' 
-- AND O.ixOrder = '7229411'  								
						  GROUP BY OL.ixSKU 
			           ) Qty ON Qty.SKU = OL.ixSKU 
			   WHERE O.dtOrderDate BETWEEN DATEADD(mm,-12,GETDATE()) and GETDATE() -- #TempDates.OneYearAgo  AND #TempDates.Today
				 AND O.sOrderStatus = 'Shipped' 
				 AND O.sOrderType <> 'Internal' 
				 AND O.mMerchandise > 0 
			   GROUP BY OL.ixSKU
					  , Qty.QtySold
					  , Qty.KCQtySold
		  
              ) TMS ON TMS.SKU = SKU.ixSKU  
    LEFT JOIN (-- FIFO
                select ixSKU, SUM(iFIFOQuantity) FIFOQty , SUM(iFIFOQuantity*mFIFOCost) TotFIFOCost
                from tblFIFODetail
                where ixLocation = 99
                    and ixDate = (SELECT ixDate-1 from tblDate where dtDate = CONVERT(VARCHAR, GETDATE(), 101))
                group by ixSKU 
                ) FIFO on FIFO.ixSKU = SKU.ixSKU  
    LEFT JOIN(SELECT ST.ixSKU AS ixSKU, ISNULL(SUM(ST.iQty),0) * -1 AS TotalQty 
		      FROM tblSKUTransaction ST 
		      LEFT JOIN tblDate D ON D.ixDate = ST.ixDate 
		      WHERE D.dtDate BETWEEN DATEADD(mm,-12,GETDATE()) and GETDATE() -- #TempDates.OneYearAgo  AND #TempDates.Today
		        AND ST.sTransactionType = 'BOM' 
			    AND ST.iQty < 0
	          GROUP BY ST.ixSKU) BOM ON BOM.ixSKU  = SKU.ixSKU                               
WHERE SKU.flgDeletedFromSOP = 0
    and SKU.flgIntangible = 0
    and SKU.sSEMAPart <> 'Catalogs'
    and V.ixVendor NOT IN ('0003', '0113', '2309', '2600', '2747', '2825')  -- SPEEDWAY PHANTOM PARTS    BOXES BOUGHT BY JASON    PRATT INDUSTRIES         QUAD/GRAPHICS INC,      RR DONNELLEY     SMITH COLLECTION
  --  and (ISNULL(TNG.sSKUVariantName,SKU.sDescription) NOT LIKE '%CATALOG%')
        --- OR ISNULL(TNG.sSKUVariantName,SKU.sDescription) is NULL)
  --  and (ISNULL(TNG.sSKUVariantName,SKU.sDescription) NOT LIKE 'INS%')
        -- OR ISNULL(TNG.sSKUVariantName,SKU.sDescription) is NULL)
-- and SKU.ixSKU in ('91009020','60409020-PRP','1750757','1750247','910372','91032847-PRP')    
    -- and V.ixVendor = '0835' --  '3115' -- TESTING ONLY
    and (--BOMQty consumed OR KITQty consumed OR 12MSales $ OR QAV > 0 
         (ISNULL(BOM.TotalQty,0)+ISNULL(TMS.KCQtySold,0))> 0 
         OR 
          ISNULL(TMS.Sales,0) > 0
         OR  
         ISNULL(SKU.iQAV,0) > 0
         )
       
 ORDER BY
    
drop table #TempDates   






select * from tblVendor
order by LEN(ixVendor) desc


SELECT COUNT(*)  FROM [LNK-DW1].[SMITemp].dbo.PJC_SMIHD7090_SKUInventoryFlow    -- 82,722
SELECT COUNT(*)  FROM [SMI Reporting].dbo.[tblSKUInventoryFlow_Rollup]          -- 74,927

SELECT *
-- DELETE 
FROM  [LNK-DW1].[SMITemp].dbo.PJC_SMIHD7090_SKUInventoryFlow    
where SKU NOT IN (select SKU from [SMI Reporting].dbo.[tblSKUInventoryFlow_Rollup]  )
order by TMCombinedUsageQty, TMSales -- QAV, TMQtySold, TMBOMConsumption,  -- CurrentFIFOCost

select * from [SMI Reporting].dbo.[tblSKUInventoryFlow_Rollup]  

SELECT *
-- DELETE 
FROM [LNK-DW1].[SMITemp].dbo.PJC_SMIHD7090_SKUInventoryFlow 
WHERE PartTerminology = 'Catalogs'      

SELECT PrimaryVendorNum, COUNT(*) 
FROM [SMI Reporting].dbo.[tblSKUInventoryFlow_Rollup] 
WHERE PrimaryVendorNum in ('0','0001','0009','0010','0012','0013','0014','0099')
GROUP BY PrimaryVendorNum


where mAverageCost = 0
    and mLatestCost = 0
    and PriceLevel1 = 0
    and CurrentFIFOCost <= 0.009
    --and UPPER(SKUDescription) LIKE '%CATALOG%'
    and ProductLine is NULL
order by PrimaryVendorNum desc -- mAverageCost

-- DROP TABLE  [SMITemp].dbo.[PJC_TEMP] 

SELECT * FROM  [SMITemp].dbo.[PJC_TEMP]


BEGIN TRAN

    SELECT *
    -- DELETE 
    FROM [LNK-DW1].[SMITemp].dbo.PJC_SMIHD7090_SKUInventoryFlow
    where  PrimaryVendorNum =  0
-- order by  PrimaryVendorNum   
ROLLBACK TRAN
    
SELECT * FROM [LNK-DW1].[SMITemp].dbo.PJC_SMIHD7090_SKUInventoryFlow
WHERE -- SKU like 'BOX-%'
 SecondaryVendorNum =  'JUNK'

SELECT * FROM [LNK-DW1].[SMITemp].dbo.PJC_SMIHD7090_SKUInventoryFlow
WHERE PartTerminology = 'Catalogs'



    SELECT *
    -- DELETE 
    FROM [LNK-DW1].[SMITemp].dbo.PJC_SMIHD7090_SKUInventoryFlow
    where PrimaryVendorNum IN (0003) -- (0113, 2600, 2747)  -- SPEEDWAY PHANTOM PARTS       BOXES BOUGHT BY JASON     QUAD/GRAPHICS INC,      RR DONNELLEY
    
/*
Summary of the rules for a SKU to make it into the results:

    flgDeletedFromSOP = 0
AND flgIntangible = 0
AND (
     12M Sales > 0
     OR
     12M BOMConsumption > 0
     OR
     12M KITConsumption > 0 
     OR
     Quantity Available > 0
     )
*/    




/*
select ixSKU, SUM(mFIFOCost) 
from tblFIFODetail
where ixLocation = 99
    and ixDate = (SELECT ixDate-1 from tblDate where dtDate = CONVERT(VARCHAR, GETDATE(), 101))
    --and ixSKU in ('26113270-BLK','26113270-PLN','70174-100')
group by ixSKU 

26113270-BLK	394.90
26113270-PLN	352.76
70174-100	220.50

*/
/* 

  /* 
  
       --, VSKU.mCost AS PrimaryVendorCost  
    --    left join tblPGC PGC on PGC.ixPGC = SKU.ixPGC
     --   left join tblMarket M on M.ixMarket = PGC.ixMarket
     --   left join vwSKUQuantityOutstanding vwQO on vwQO.ixSKU = SKU.ixSKU  
     left join (--Twelve Month Returns 
                    SELECT ixSKU AS SKU 
						, SUM(ISNULL(iQuantityReturned,0)) AS Qty
						, SUM(ISNULL(mExtendedPrice,0)) AS Sales
						, SUM(ISNULL(mExtendedCost,0)) AS Cost 
						, SUM(ISNULL(mExtendedPrice,0)) - SUM(ISNULL(mExtendedCost,0)) AS GP 
				   FROM tblCreditMemoDetail CMD 
				   LEFT JOIN tblCreditMemoMaster CMM ON CMM.ixCreditMemo = CMD.ixCreditMemo 
				   WHERE CMM.flgCanceled = '0'
					 and CMM.dtCreateDate BETWEEN DATEADD(mm,-12,GETDATE()) AND GETDATE()
				   GROUP BY ixSKU            
                  ) TMR ON TMR.SKU = SKU.ixSKU   
*/    
   --  , ISNULL(vwQO.QTYOutstanding,0) AS OPOQty -- add both together on report side for "INV OH+OPO QTY" field
  --   , (ISNULL(TMS.Qty,0) - ISNULL(TMR.Qty,0)) AS TMQtySold


     , M.ixMarket AS MarketCode
     , M.sDescription AS MarketDescription
    
     , SKU.flgUnitOfMeasure AS SellUM
    , (CASE WHEN flgActive = 1 THEN 'Y'
             WHEN flgActive = 0 then 'N'
             ELSE '?'
        END
       ) AS Active
         , (CASE WHEN SKU.flgEndUserSKU = 1 THEN 'Y'
             WHEN SKU.flgEndUserSKU = 0 then 'N'
             ELSE NULL
        END
       ) AS EndUserSKU 
       
     , SKU.dtDiscontinuedDate AS DiscontinuedDate
     , SKU.dtCreateDate AS ItemCreationDate
     , SKU.ixCreator AS CreatedBy
*/  

SELECT * FROM [SMITemp].dbo.[PJC_TEMP]


SELECT * FROM [LNK-DW1].[SMITemp].dbo.PJC_SMIHD7090_SKUInventoryFlow
where PrimaryVendor = 