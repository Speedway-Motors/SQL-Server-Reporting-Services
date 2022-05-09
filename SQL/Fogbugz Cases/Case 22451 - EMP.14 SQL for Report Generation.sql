SELECT DISTINCT SKU.ixSKU AS SKU -- Our Part Number
     , V.ixVendor AS PrimaryVendorNumber
     , V.sName AS PrimaryVendor     
     --, VSKU.sVendorSKU AS PrimaryVendorSKU -- Their Part Number 
     , SKU.sDescription AS ProductDescription
     , SKU.flgUnitOfMeasure AS SellUM
     , (CASE WHEN SKU.flgIsKit = 1 THEN 'Y'
             WHEN SKU.flgIsKit = 0 THEN 'N'
             ELSE '?' 
        END) AS KitSKU
     , SKU.mPriceLevel1 AS Retail -- Current price
     , VSKU.mCost AS PrimaryVendorCost
     , SKU.mLatestCost AS LastCost 
     , ROUND((((ISNULL(TMS.Sales,0) - ISNULL(TMR.Sales,0))) - ((ISNULL(TMS.GP,0) - ISNULL(TMR.GP,0))))
                     /(NULLIF(((ISNULL(TMS.Qty,0) - ISNULL(TMR.Qty,0))),0)),2) AS AvgUnitCostFromTMSales
     , SUM(KSD.ComponentSKUExtendedCost) AS ComponentSKUsExtendedCost 
     , GPCalc.CostValueUsed
     , GPCalc.GPCalcUsed
     , ISNULL(ROUND(GPCalc.GPCalcResult,2),0) AS GPCalcResult 
     , (CASE WHEN ISNULL(ROUND(GPCalc.GPCalcResult,2),0) < .6 THEN .25 
             WHEN ISNULL(ROUND(GPCalc.GPCalcResult,2),0) BETWEEN .6001 AND .9799 THEN .28
             WHEN ISNULL(ROUND(GPCalc.GPCalcResult,2),0) >= .98 THEN .25
             ELSE .25
       END) AS PercentDiscountGiven 
     , SKU.mPriceLevel1 AS 'PriceLevel1'
     , (CASE WHEN ROUND((SKU.mPriceLevel1*.9),2) < GPCalc.CostValueUsed THEN GPCalc.CostValueUsed
             ELSE ROUND((SKU.mPriceLevel1*.9),2)
       END) AS 'PriceLevel2'
     , (CASE WHEN (CASE WHEN ISNULL(ROUND(GPCalc.GPCalcResult,2),0) < .6 THEN ROUND((SKU.mPriceLevel1*.75),2) 
					    WHEN ISNULL(ROUND(GPCalc.GPCalcResult,2),0) BETWEEN .6001 AND .9799 THEN ROUND((SKU.mPriceLevel1*.72),2) 
					    WHEN ISNULL(ROUND(GPCalc.GPCalcResult,2),0) >= .98 THEN ROUND((SKU.mPriceLevel1*.75),2) 
						ELSE ROUND((SKU.mPriceLevel1*.75),2) 
				  END) < GPCalc.CostValueUsed THEN GPCalc.CostValueUsed
		     ELSE (CASE WHEN ISNULL(ROUND(GPCalc.GPCalcResult,2),0) < .6 THEN ROUND((SKU.mPriceLevel1*.75),2) 
					    WHEN ISNULL(ROUND(GPCalc.GPCalcResult,2),0) BETWEEN .6001 AND .9799 THEN ROUND((SKU.mPriceLevel1*.72),2) 
					    WHEN ISNULL(ROUND(GPCalc.GPCalcResult,2),0) >= .98 THEN ROUND((SKU.mPriceLevel1*.75),2) 
						ELSE ROUND((SKU.mPriceLevel1*.75),2) 
				  END)
	   END) AS 'PriceLevel3'       	         
     --,price4 = price3 -.01 
     --,price5 = price4 -.01          
     , (CASE WHEN flgActive = 1 THEN 'Y'
             WHEN flgActive = 0 then 'N'
             ELSE '?'
       END) AS Active
     , SKU.iQOS AS INVOH
     , (ISNULL(TMS.Qty,0) - ISNULL(TMR.Qty,0)) AS TMQtySold
     , (ISNULL(TMS.Sales,0) - ISNULL(TMR.Sales,0)) AS TMSales 
     , ROUND((ISNULL(TMS.GP,0) - ISNULL(TMR.GP,0)),2) AS TMGP
FROM tblCatalogDetail CD 
LEFT JOIN vwSKULocalLocation SKU ON SKU.ixSKU = CD.ixSKU 
LEFT JOIN tblVendorSKU VSKU ON VSKU.ixSKU = SKU.ixSKU 
LEFT JOIN tblVendor V ON V.ixVendor = VSKU.ixVendor
LEFT JOIN vwKitSKUDetail KSD ON KSD.KitSKU = SKU.ixSKU
LEFT JOIN (SELECT OL.ixSKU AS SKU 
		        , Qty.Qty AS Qty
				, SUM(ISNULL(OL.mExtendedPrice,0)) AS Sales 
				, ROUND(SUM(ISNULL(OL.mExtendedPrice,0)) - SUM(ISNULL(OL.mExtendedCost,0)),2) AS GP 
		   FROM tblOrderLine OL  
		   LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
		   LEFT JOIN (SELECT OL.ixSKU AS SKU
						   , SUM(ISNULL(OL.iQuantity,0)) AS Qty 
					  FROM tblOrderLine OL
					  LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder  
					  WHERE O.dtOrderDate BETWEEN DATEADD(mm,-12,GETDATE()) AND GETDATE() 
						AND O.sOrderStatus = 'Shipped' 
						AND O.sOrderType <> 'Internal' 
						AND O.sOrderChannel <> 'INTERNAL' 
						AND O.mMerchandise > 0 
						AND O.ixOrder NOT LIKE '%-%' 
					  GROUP BY OL.ixSKU 
				     ) Qty ON Qty.SKU = OL.ixSKU 
			WHERE O.dtOrderDate BETWEEN DATEADD(mm,-12,GETDATE()) AND GETDATE() 
			  AND O.sOrderStatus = 'Shipped' 
			  AND O.sOrderType <> 'Internal' 
			  AND O.sOrderChannel <> 'INTERNAL' 
			  AND O.mMerchandise > 0 
			GROUP BY OL.ixSKU
				   , Qty.Qty
           ) TMS ON TMS.SKU = SKU.ixSKU  --Twelve Month Sales  
LEFT JOIN (SELECT ixSKU AS SKU 
			    , SUM(ISNULL(iQuantityReturned,0)) AS Qty
				, SUM(ISNULL(mExtendedPrice,0)) AS Sales
				, SUM(ISNULL(mExtendedCost,0)) AS Cost 
				, ROUND(SUM(ISNULL(mExtendedPrice,0)) - SUM(ISNULL(mExtendedCost,0)),2) AS GP 
		   FROM tblCreditMemoDetail CMD 
		   LEFT JOIN tblCreditMemoMaster CMM ON CMM.ixCreditMemo = CMD.ixCreditMemo 
		   WHERE CMM.flgCanceled = '0'
			 and CMM.dtCreateDate BETWEEN DATEADD(mm,-12,GETDATE()) AND GETDATE()
			 --and CMD.sReturnType = 'Refund'      
		   GROUP BY ixSKU            
          ) TMR ON TMR.SKU = SKU.ixSKU --Twelve Month Returns   
LEFT JOIN (SELECT SKU.ixSKU 
				--, SKU.mPriceLevel1
				--, VS.mCost AS PVCost 
				--, SKU.mLatestCost AS LastCost 
				--, (((ISNULL(TMS.Sales,0) - ISNULL(TMR.Sales,0))) - ((ISNULL(TMS.GP,0) - ISNULL(TMR.GP,0))))
				--               /((ISNULL(TMS.Qty,0) - ISNULL(TMR.Qty,0))) AS TMAvgUnitCost
				--, (ISNULL(SKU.mPriceLevel1,0)-ISNULL(VS.mCost,0))/(ISNULL(SKU.mPriceLevel1,0)) AS FirstGPCalc
				--, (ISNULL(SKU.mPriceLevel1,0)-ISNULL(SKU.mLatestCost,0))/(ISNULL(SKU.mPriceLevel1,0)) AS SecondGPCalc
				--, (((ISNULL(TMS.Sales,0) - ISNULL(TMR.Sales,0))) - (((ISNULL(TMS.Sales,0) - ISNULL(TMR.Sales,0))) - ((ISNULL(TMS.GP,0) - ISNULL(TMR.GP,0)))))
				--              /((ISNULL(TMS.Sales,0) - ISNULL(TMR.Sales,0))) AS ThirdGPCalc    
				--, (ISNULL(KSD.KitSKURetail,0) - ISNULL(KSD.AvgKitCost,0))/(ISNULL(KSD.KitSKURetail,0)) AS LastGPCalc  
				, (CASE WHEN VS.mCost <> 0 THEN 'PrimaryVendorCostUsed' 
						WHEN SKU.mLatestCost <> 0 THEN 'LastCostUsed'
						WHEN ROUND((((ISNULL(TMS.Sales,0) - ISNULL(TMR.Sales,0))) - ((ISNULL(TMS.GP,0) - ISNULL(TMR.GP,0))))
								/(NULLIF(((ISNULL(TMS.Qty,0) - ISNULL(TMR.Qty,0))),0)),2) <> 0 THEN 'TwelveMonthAvgUnitCostUsed'    
						WHEN KSD.AvgKitCost <> 0 THEN 'KitCalculationUsed'
						ELSE 'NoCostDataForCalculation'
				  END) AS GPCalcUsed       
				, (CASE WHEN VS.mCost <> 0 THEN VS.mCost  
						WHEN SKU.mLatestCost <> 0 THEN SKU.mLatestCost
						WHEN ROUND((((ISNULL(TMS.Sales,0) - ISNULL(TMR.Sales,0))) - ((ISNULL(TMS.GP,0) - ISNULL(TMR.GP,0))))
								/(NULLIF(((ISNULL(TMS.Qty,0) - ISNULL(TMR.Qty,0))),0)),2) <> 0 THEN (ROUND((((ISNULL(TMS.Sales,0) - ISNULL(TMR.Sales,0))) 
																									- ((ISNULL(TMS.GP,0) - ISNULL(TMR.GP,0))))/
																									(NULLIF(((ISNULL(TMS.Qty,0) - ISNULL(TMR.Qty,0))),0)),2))   
						WHEN KSD.AvgKitCost <> 0 THEN KSD.AvgKitCost
						ELSE 0
				  END) AS CostValueUsed   					
				, (CASE WHEN VS.mCost <> 0 THEN ROUND((ISNULL(SKU.mPriceLevel1,0)-ISNULL(VS.mCost,0))/(NULLIF((ISNULL(SKU.mPriceLevel1,0)),0)),2)
						WHEN SKU.mLatestCost <> 0 THEN ROUND((ISNULL(SKU.mPriceLevel1,0)-ISNULL(SKU.mLatestCost,0))/(NULLIF((ISNULL(SKU.mPriceLevel1,0)),0)),2)
						WHEN ROUND((((ISNULL(TMS.Sales,0) - ISNULL(TMR.Sales,0))) - ((ISNULL(TMS.GP,0) - ISNULL(TMR.GP,0))))
								/(NULLIF(((ISNULL(TMS.Qty,0) - ISNULL(TMR.Qty,0))),0)),2) <> 0 THEN ROUND((((ISNULL(TMS.Sales,0) - ISNULL(TMR.Sales,0))) - 
																				(((ISNULL(TMS.Sales,0) - ISNULL(TMR.Sales,0))) - 
																				((ISNULL(TMS.GP,0) - ISNULL(TMR.GP,0))))) /(NULLIF(((ISNULL(TMS.Sales,0) - ISNULL(TMR.Sales,0))),0)),2)      
						ELSE ROUND((ISNULL(KSD.KitSKURetail,0) - ISNULL(KSD.AvgKitCost,0))/NULLIF((ISNULL(KSD.KitSKURetail,0)),0),2)
				  END) AS GPCalcResult                                                                       
			FROM vwSKULocalLocation SKU 
			LEFT JOIN tblVendorSKU VS ON VS.ixSKU = SKU.ixSKU AND VS.iOrdinality = 1 
			LEFT JOIN (SELECT KitSKU 
							, ISNULL(KSD.KitSKURetail,0) AS KitSKURetail
							, SUM(ISNULL(KSD.ComponentSKUExtendedCost,0)) AS AvgKitCost
					   FROM vwKitSKUDetail KSD 
					   GROUP BY KitSKU
							  , ISNULL(KSD.KitSKURetail,0)            
					  ) KSD ON KSD.KitSKU = SKU.ixSKU
			LEFT JOIN (SELECT OL.ixSKU AS SKU 
							, Qty.Qty AS Qty
							, SUM(ISNULL(OL.mExtendedPrice,0)) AS Sales 
							, ROUND(SUM(ISNULL(OL.mExtendedPrice,0)) - SUM(ISNULL(OL.mExtendedCost,0)),2) AS GP 
					   FROM tblOrderLine OL  
					   LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
					   LEFT JOIN (SELECT OL.ixSKU AS SKU
									   , SUM(ISNULL(OL.iQuantity,0)) AS Qty 
								  FROM tblOrderLine OL
								  LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder  
								  WHERE O.dtOrderDate BETWEEN DATEADD(mm,-12,GETDATE()) AND GETDATE() 
									AND O.sOrderStatus = 'Shipped' 
									AND O.sOrderType <> 'Internal' 
									AND O.sOrderChannel <> 'INTERNAL' 
									AND O.mMerchandise > 0 
									AND O.ixOrder NOT LIKE '%-%' 
								  GROUP BY OL.ixSKU 
								 ) Qty ON Qty.SKU = OL.ixSKU 
					   WHERE O.dtOrderDate BETWEEN DATEADD(mm,-12,GETDATE()) AND GETDATE() 
						 AND O.sOrderStatus = 'Shipped' 
						 AND O.sOrderType <> 'Internal' 
						 AND O.sOrderChannel <> 'INTERNAL' 
						 AND O.mMerchandise > 0 
					   GROUP BY OL.ixSKU
							  , Qty.Qty
					) TMS ON TMS.SKU = SKU.ixSKU  --Twelve Month Sales  
			LEFT JOIN (SELECT ixSKU AS SKU 
							, SUM(ISNULL(iQuantityReturned,0)) AS Qty
							, SUM(ISNULL(mExtendedPrice,0)) AS Sales
							, SUM(ISNULL(mExtendedCost,0)) AS Cost 
							, ROUND(SUM(ISNULL(mExtendedPrice,0)) - SUM(ISNULL(mExtendedCost,0)),2) AS GP 
					   FROM tblCreditMemoDetail CMD 
					   LEFT JOIN tblCreditMemoMaster CMM ON CMM.ixCreditMemo = CMD.ixCreditMemo 
					   WHERE CMM.flgCanceled = '0'
						 and CMM.dtCreateDate BETWEEN DATEADD(mm,-12,GETDATE()) AND GETDATE()
						 --and CMD.sReturnType = 'Refund'      
					   GROUP BY ixSKU            
					  ) TMR ON TMR.SKU = SKU.ixSKU --Twelve Month Returns     
		 )GPCalc ON GPCalc.ixSKU = CD.ixSKU                           
WHERE CD.ixCatalog = 'WEB.14'
  AND VSKU.iOrdinality = 1
  AND (flgActive = 1 OR (flgActive = 0 AND iQAV > 0)) -- increased SKU count from 77,869 (lowest) to 78,172
  AND SKU.mPriceLevel1 > 0
  --AND SKU.mPriceLevel1 > VSKU.mCost --77,880
  AND SKU.mPriceLevel1 > GPCalc.CostValueUsed -- 77,869
  AND V.ixVendor NOT IN ('2840','2841','2600', '0009', '9106')
  AND SKU.flgDeletedFromSOP = '0' 
  AND CD.ixSKU <> '932001'
  AND CD.ixSKU NOT LIKE '%GS'
  AND CD.ixSKU NOT LIKE '%.GS%'
  AND CD.ixSKU NOT LIKE 'UP%'
  AND CD.ixSKU NOT LIKE 'AUP%' 
GROUP BY SKU.ixSKU 
       , V.ixVendor 
       , V.sName  
       --, VSKU.sVendorSKU 
       , SKU.sDescription 
       , SKU.flgUnitOfMeasure 
       , (CASE WHEN SKU.flgIsKit = 1 THEN 'Y'
               WHEN SKU.flgIsKit = 0 THEN 'N'
               ELSE '?' 
          END)        
       , SKU.mPriceLevel1 
       , VSKU.mCost 
       , SKU.mLatestCost 
       , ROUND((((ISNULL(TMS.Sales,0) - ISNULL(TMR.Sales,0))) - ((ISNULL(TMS.GP,0) - ISNULL(TMR.GP,0))))/(NULLIF(((ISNULL(TMS.Qty,0) - ISNULL(TMR.Qty,0))),0)),2) 
       , GPCalc.CostValueUsed
       , GPCalc.GPCalcUsed
       , ISNULL(ROUND(GPCalc.GPCalcResult,2) ,0)
       , (CASE WHEN ISNULL(ROUND(GPCalc.GPCalcResult,2),0) < .6 THEN .25 
               WHEN ISNULL(ROUND(GPCalc.GPCalcResult,2),0) BETWEEN .6001 AND .9799 THEN .28
               WHEN ISNULL(ROUND(GPCalc.GPCalcResult,2),0) >= .98 THEN .25
               ELSE .25
         END) 
       , SKU.mPriceLevel1 
       , (CASE WHEN ROUND((SKU.mPriceLevel1*.9),2) < GPCalc.CostValueUsed THEN GPCalc.CostValueUsed
               ELSE ROUND((SKU.mPriceLevel1*.9),2)
         END) 
       , (CASE WHEN (CASE WHEN ISNULL(ROUND(GPCalc.GPCalcResult,2),0) < .6 THEN ROUND((SKU.mPriceLevel1*.75),2) 
					      WHEN ISNULL(ROUND(GPCalc.GPCalcResult,2),0) BETWEEN .6001 AND .9799 THEN ROUND((SKU.mPriceLevel1*.72),2) 
					      WHEN ISNULL(ROUND(GPCalc.GPCalcResult,2),0) >= .98 THEN ROUND((SKU.mPriceLevel1*.75),2) 
						  ELSE ROUND((SKU.mPriceLevel1*.75),2) 
				    END) < GPCalc.CostValueUsed THEN GPCalc.CostValueUsed
		       ELSE (CASE WHEN ISNULL(ROUND(GPCalc.GPCalcResult,2),0) < .6 THEN ROUND((SKU.mPriceLevel1*.75),2) 
			  		      WHEN ISNULL(ROUND(GPCalc.GPCalcResult,2),0) BETWEEN .6001 AND .9799 THEN ROUND((SKU.mPriceLevel1*.72),2) 
					      WHEN ISNULL(ROUND(GPCalc.GPCalcResult,2),0) >= .98 THEN ROUND((SKU.mPriceLevel1*.75),2) 
						  ELSE ROUND((SKU.mPriceLevel1*.75),2) 
				    END)
	     END)              
       , (CASE WHEN flgActive = 1 THEN 'Y'
             WHEN flgActive = 0 then 'N'
             ELSE '?'
         END) 
       , SKU.iQOS 
       , (ISNULL(TMS.Qty,0) - ISNULL(TMR.Qty,0)) 
       , (ISNULL(TMS.Sales,0) - ISNULL(TMR.Sales,0)) 
       , ROUND((ISNULL(TMS.GP,0) - ISNULL(TMR.GP,0)),2)     
ORDER BY GPCalcResult --77,869 SKU results 
