-- CCC SKU analysis

SELECT SKU.ixSKU AS SKU 
     , ISNULL(TNG.sSKUVariantName,SKU.sDescription) 'SKUDescription'
     , V.ixVendor AS PrimaryVendorNum
     , V.sName AS PrimaryVendor
     , V2.ixVendor AS SecondaryVendorNum
     , V2.sName AS SecondaryVendor     
     -- Alternate Vend#	Alternatve Vend Name
     , SKU.mLatestCost 
     , SKU.mAverageCost        
     , SKU.mPriceLevel1 AS PriceLevel1 
    , ISNULL(BOM.TotalQty,0) 'TMBOMConsumption'
    , ISNULL(TMS.KCQtySold,0) AS 'TMKitConsumption' 
     , ISNULL(SKU.iQAV,0) AS 'QAV'
     , ISNULL(TMS.Sales,0) AS 'TMSales'
     , FIFO.TotFIFOCost 'CurrentFIFOCost'
     , SKU.ixProductLine 'ProductLine'
     , B.ixBrand AS 'Brand'
     , B.sBrandDescription AS 'BrandDescription'     
     , SKU.sSEMACategory AS Category
     , SKU.sSEMASubCategory AS SubCategory
     , SKU.sSEMAPart AS PartTerminology     
INTO [SMITemp].dbo.[PJC_12MoSKUAnalysis]     
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
    LEFT JOIN (--Twelve Month Sales 
               SELECT OL.ixSKU AS SKU 
				    , Qty.Qty AS Qty
				    , SUM(ISNULL(OL.mExtendedPrice,0)) AS Sales 
				    , Qty.KCQtySold
				--	, SUM(ISNULL(OL.mExtendedPrice,0)) - SUM(ISNULL(OL.mExtendedCost,0)) AS GP 
			   FROM tblOrderLine OL  
		       LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
			   LEFT JOIN (SELECT OL.ixSKU AS SKU
							   , SUM(ISNULL(OL.iQuantity,0)) AS Qty 
							   , SUM(CASE WHEN OL.flgKitComponent = '0' THEN 0 
                                 ELSE OL.iQuantity
                                END) AS KCQtySold  
						  FROM tblOrderLine OL
						  LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder  
						  WHERE O.dtOrderDate BETWEEN DATEADD(mm,-12,GETDATE()) AND GETDATE() 
						    AND O.sOrderStatus = 'Shipped' 
							AND O.sOrderType <> 'Internal' 
							AND O.mMerchandise > 0 
							AND O.ixOrder NOT LIKE '%-%' 
						  GROUP BY OL.ixSKU 
				         ) Qty ON Qty.SKU = OL.ixSKU 
			   WHERE O.dtOrderDate BETWEEN DATEADD(mm,-12,GETDATE()) AND GETDATE() 
				 AND O.sOrderStatus = 'Shipped' 
				 AND O.sOrderType <> 'Internal' 
				 AND O.mMerchandise > 0 
			   GROUP BY OL.ixSKU
					  , Qty.Qty
					  , Qty.KCQtySold
              ) TMS ON TMS.SKU = SKU.ixSKU  
    LEFT JOIN (-- FIFO
                select ixSKU, SUM(iFIFOQuantity) FIFOQty , SUM(mFIFOCost) TotFIFOCost
                from tblFIFODetail
                where ixLocation = 99
                    and ixDate = (SELECT ixDate-1 from tblDate where dtDate = CONVERT(VARCHAR, GETDATE(), 101))
                group by ixSKU 
                ) FIFO on FIFO.ixSKU = SKU.ixSKU  
    LEFT JOIN(SELECT ST.ixSKU AS ixSKU, ISNULL(SUM(ST.iQty),0) * -1 AS TotalQty 
		      FROM tblSKUTransaction ST 
		      LEFT JOIN tblDate D ON D.ixDate = ST.ixDate 
		      WHERE D.dtDate BETWEEN DATEADD(yy, -1, GETDATE()) AND GETDATE()
		        AND ST.sTransactionType = 'BOM' 
			    AND ST.iQty < 0
	          GROUP BY ST.ixSKU) BOM ON BOM.ixSKU  = SKU.ixSKU                               
WHERE SKU.flgDeletedFromSOP = 0
    and SKU.flgIntangible = 0
    -- and V.ixVendor = '0835' --  '3115' -- TESTING ONLY
    -- and  V.ixVendor not in ('0494','2921','JUNK')
    and (--BOMQty consumed OR KITQty consumed OR 12MSales $
         (ISNULL(BOM.TotalQty,0)+ISNULL(TMS.KCQtySold,0))> 0 
         OR 
          ISNULL(TMS.Sales,0) > 0
         OR  
         ISNULL(SKU.iQAV,0) > 0
         )
ORDER BY V.ixVendor, SKU 
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