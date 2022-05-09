SELECT SKU.ixSKU AS SKU -- Our Part Number
     , VSKU.sVendorSKU AS PrimaryVendorSKU -- Their Part Number 
     , V.ixVendor AS PrimaryVendorNumber
     , V.sName AS PrimaryVendor
     , SKU.sDescription AS ProductDescription
     --SEMA 
     , RTRIM(SKU.sSEMACategory) AS Category
     , RTRIM(SKU.sSEMASubCategory) AS SubCategory
     , RTRIM(SKU.sSEMAPart) AS PartTerminology
     , SKU.flgUnitOfMeasure AS SellUM
     , SKU.mPriceLevel1 AS Retail -- Current price
     , VSKU.mCost AS PrimaryVendorCost
     , SKU.mLatestCost     
     , (CASE WHEN flgActive = 1 THEN 'Y'
             WHEN flgActive = 0 then 'N'
             ELSE '?'
        END
       ) AS Active
     , SKU.dtDiscontinuedDate AS DiscontinuedDate
     , SKU.dtCreateDate AS ItemCreationDate
     , SKU.ixCreator AS CreatedBy
     , M.ixMarket AS MarketCode
     , M.sDescription AS MarketDescription
     , SKU.ixPGC AS PGC
     , PGC.sDescription AS PGCDescription
     , SKU.iQOS AS OH
     , ISNULL(vwQO.QTYOutstanding,0) AS OPOQty -- add both together on report side for "INV OH+OPO QTY" field
     , SKU.iQOS / NULLIF(((ISNULL(TMS.Qty,0) - ISNULL(TMR.Qty,0))/52.00), 0) AS WeeksOH     
     , (ISNULL(TMS.Qty,0) - ISNULL(TMR.Qty,0)) AS TMQtySold
     , (ISNULL(TMS.Sales,0) - ISNULL(TMR.Sales,0)) AS TMSales 
     , (ISNULL(TMS.GP,0) - ISNULL(TMR.GP,0)) AS TMGP
     , (ISNULL(TFMS.Qty,0) - ISNULL(TFMR.Qty,0)) AS TFMQtySold
     , (ISNULL(TFMS.Sales,0) - ISNULL(TFMR.Sales,0)) AS TFMSales 
     , (ISNULL(TFMS.GP,0) - ISNULL(TFMR.GP,0)) AS TFMGP     
   --  , NULLIF((TMS.Qty/52.00), 0) AS Calc     
FROM vwSKULocalLocation SKU
        left join tblVendorSKU VSKU on VSKU.ixSKU = SKU.ixSKU 
        left join tblVendor V on V.ixVendor = VSKU.ixVendor
        left join tblPGC PGC on PGC.ixPGC = SKU.ixPGC
        left join tblMarket M on M.ixMarket = PGC.ixMarket
        left join vwSKUQuantityOutstanding vwQO on vwQO.ixSKU = SKU.ixSKU
        left join (SELECT OL.ixSKU AS SKU 
					    , Qty.Qty AS Qty
					    , SUM(ISNULL(OL.mExtendedPrice,0)) AS Sales 
						, SUM(ISNULL(OL.mExtendedPrice,0)) - SUM(ISNULL(OL.mExtendedCost,0)) AS GP 
				   FROM tblOrderLine OL  
			       LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
				   LEFT JOIN (SELECT OL.ixSKU AS SKU
								   , SUM(ISNULL(OL.iQuantity,0)) AS Qty 
							  FROM tblOrderLine OL
							  LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder  
							  WHERE O.dtOrderDate BETWEEN @CPStart AND @CPEnd -- DATEADD(mm,-12,GETDATE()) AND GETDATE() 
							    AND O.sOrderStatus = 'Shipped' 
								AND O.sOrderType <> 'Internal' 
								AND O.sOrderChannel <> 'INTERNAL' 
								AND O.mMerchandise > 0 
								AND O.ixOrder NOT LIKE '%-%' 
							  GROUP BY OL.ixSKU 
					         ) Qty ON Qty.SKU = OL.ixSKU 
				   WHERE O.dtOrderDate BETWEEN @CPStart AND @CPEnd -- DATEADD(mm,-12,GETDATE()) AND GETDATE() 
					 AND O.sOrderStatus = 'Shipped' 
					 AND O.sOrderType <> 'Internal' 
					 AND O.sOrderChannel <> 'INTERNAL' 
					 AND O.mMerchandise > 0 
				   GROUP BY OL.ixSKU
						  , Qty.Qty
                  ) TMS ON TMS.SKU = SKU.ixSKU  --Twelve Month Sales  
        left join (SELECT ixSKU AS SKU 
						, SUM(ISNULL(iQuantityReturned,0)) AS Qty
						, SUM(ISNULL(mExtendedPrice,0)) AS Sales
						, SUM(ISNULL(mExtendedCost,0)) AS Cost 
						, SUM(ISNULL(mExtendedPrice,0)) - SUM(ISNULL(mExtendedCost,0)) AS GP 
				   FROM tblCreditMemoDetail CMD 
				   LEFT JOIN tblCreditMemoMaster CMM ON CMM.ixCreditMemo = CMD.ixCreditMemo 
				   WHERE CMM.flgCanceled = '0'
					 and CMM.dtCreateDate BETWEEN @CPStart AND @CPEnd -- DATEADD(mm,-12,GETDATE()) AND GETDATE()
					 --and CMD.sReturnType = 'Refund'      
				   GROUP BY ixSKU            
                  ) TMR ON TMR.SKU = SKU.ixSKU --Twelve Month Returns    
        left join (SELECT OL.ixSKU AS SKU 
					    , Qty.Qty AS Qty
					    , SUM(ISNULL(OL.mExtendedPrice,0)) AS Sales 
						, SUM(ISNULL(OL.mExtendedPrice,0)) - SUM(ISNULL(OL.mExtendedCost,0)) AS GP 
				   FROM tblOrderLine OL  
			       LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
				   LEFT JOIN (SELECT OL.ixSKU AS SKU
								   , SUM(ISNULL(OL.iQuantity,0)) AS Qty 
							  FROM tblOrderLine OL
							  LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder  
							  WHERE O.dtOrderDate BETWEEN @PPStart AND @PPEnd -- DATEADD(mm,-24,GETDATE()) AND DATEADD(mm,-13,GETDATE()) 
							    AND O.sOrderStatus = 'Shipped' 
								AND O.sOrderType <> 'Internal' 
								AND O.sOrderChannel <> 'INTERNAL' 
								AND O.mMerchandise > 0 
								AND O.ixOrder NOT LIKE '%-%' 
							  GROUP BY OL.ixSKU 
					         ) Qty ON Qty.SKU = OL.ixSKU 
				   WHERE O.dtOrderDate BETWEEN @PPStart AND @PPEnd -- DATEADD(mm,-24,GETDATE()) AND DATEADD(mm,-13,GETDATE()) 
					 AND O.sOrderStatus = 'Shipped' 
					 AND O.sOrderType <> 'Internal' 
					 AND O.sOrderChannel <> 'INTERNAL' 
					 AND O.mMerchandise > 0 
				   GROUP BY OL.ixSKU
						  , Qty.Qty
                  ) TFMS ON TFMS.SKU = SKU.ixSKU  --13-24 (TF= Twenty-Four) Month Sales  
        left join (SELECT ixSKU AS SKU 
						, SUM(ISNULL(iQuantityReturned,0)) AS Qty
						, SUM(ISNULL(mExtendedPrice,0)) AS Sales
						, SUM(ISNULL(mExtendedCost,0)) AS Cost 
						, SUM(ISNULL(mExtendedPrice,0)) - SUM(ISNULL(mExtendedCost,0)) AS GP 
				   FROM tblCreditMemoDetail CMD 
				   LEFT JOIN tblCreditMemoMaster CMM ON CMM.ixCreditMemo = CMD.ixCreditMemo 
				   WHERE CMM.flgCanceled = '0'
					 and CMM.dtCreateDate BETWEEN @PPStart AND @PPEnd -- DATEADD(mm,-24,GETDATE()) AND DATEADD(mm,-13,GETDATE())
					 --and CMD.sReturnType = 'Refund'      
				   GROUP BY ixSKU            
                  ) TFMR ON TFMR.SKU = SKU.ixSKU --13-24 (TF= Twenty-Four) Month Returns                                    
WHERE VSKU.iOrdinality = 1
  and  V.ixVendor not in ('0494','2921','JUNK')
  --and  V.ixVendor >= @VendorStart
  --and  V.ixVendor <= @VendorEnd
  and SKU.flgDeletedFromSOP = '0' 
  --and SKU.ixSKU = '7219100'
ORDER BY V.ixVendor, SKU 