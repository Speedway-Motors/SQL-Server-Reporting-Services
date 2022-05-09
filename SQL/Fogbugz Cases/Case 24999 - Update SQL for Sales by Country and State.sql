-- Case 6858 

SELECT ISNULL(Y1.Geo, Y2.Geo) AS Geo
     , ISNULL(Y1.ShipTo, Y2.ShipTo) AS ShipTo
     , Y1.OrdCnt AS Y1OrdCnt
     , Y2.OrdCnt AS Y2OrdCnt
     , Y1.NetRev AS Y1NetRev
     , Y1.NetCost AS Y1NetCost
     , Y1.GrossProfit AS Y1GM
     , Y2.NetRev AS Y2NetRev
     , Y2.NetCost AS Y2NetCost
     , Y2.GrossProfit AS Y2GM
FROM (SELECT ISNULL(SALES.Geo, RTNS.Geo) AS Geo --to allow filtering by region
           , ISNULL(SALES.ShipTo, RTNS.ShipTo) AS ShipTo
           , SALES.Orders AS OrdCnt
           , ISNULL(SALES.Merch, 0) - ISNULL(RTNS.MerchRef, 0) AS NetRev
           , ISNULL(SALES.Cost, 0) - ISNULL(RTNS.CostRef, 0) AS NetCost
           , (ISNULL(SALES.Merch, 0) - ISNULL(RTNS.MerchRef, 0)) 
            - (ISNULL(SALES.Cost, 0) - ISNULL(RTNS.CostRef, 0)) AS GrossProfit
           --   Margin calculation to be done on report side to exclude divide by zero error
      FROM (SELECT (CASE WHEN O.ixCustomer = '16878' THEN 'NON-US'
				         WHEN O.ixCustomer = '10533' THEN 'NON-US' 
                         WHEN O.sShipToCountry IN ('US', 'USA') THEN 'US'
                         ELSE 'NON-US'
                    END) AS Geo 
                 , (CASE WHEN O.ixCustomer = '16878' THEN 'BRAZIL'
                         WHEN O.ixCustomer = '10533' THEN 'GERMANY'
                         WHEN O.sShipToCountry IN ('US', 'USA') THEN O.sShipToState
			             ELSE O.sShipToCountry
                    END) AS ShipTo
                 , COUNT (*) AS Orders 
                 , ISNULL (SUM(O.mMerchandise), 0) AS Merch
                 , ISNULL (SUM(O.mMerchandiseCost), 0) AS Cost 
            FROM tblOrder O 
            WHERE O.dtShippedDate BETWEEN @PPSalesStart AND @PPSalesEnd -- '01/01/10' AND '12/31/10'
              AND O.sOrderStatus = 'Shipped'
              AND O.mMerchandise > 0 
            GROUP BY (CASE WHEN O.ixCustomer = '16878' THEN 'NON-US'
				  		   WHEN O.ixCustomer = '10533' THEN 'NON-US' 
                           WHEN O.sShipToCountry IN ('US', 'USA') THEN 'US'
                           ELSE 'NON-US'
                      END)  
				    , (CASE WHEN O.ixCustomer = '16878' THEN 'BRAZIL'
                            WHEN O.ixCustomer = '10533' THEN 'GERMANY'
                            WHEN O.sShipToCountry IN ('US', 'USA') THEN O.sShipToState
			                ELSE O.sShipToCountry
                       END) 
           ) AS SALES 

      FULL OUTER JOIN (SELECT (CASE WHEN O.ixCustomer = '16878' THEN 'NON-US'
                                    WHEN O.ixCustomer = '10533' THEN 'NON-US' 
                                    WHEN O.sShipToCountry IN ('US', 'USA') THEN 'US'
                                    ELSE 'NON-US'
                               END) AS Geo 
                             , (CASE WHEN O.ixCustomer = '16878' THEN 'BRAZIL'
									 WHEN O.ixCustomer = '10533' THEN 'GERMANY'
									 WHEN O.sShipToCountry IN ('US', 'USA') THEN O.sShipToState
									 ELSE O.sShipToCountry
								END) AS ShipTo
						     , ISNULL(SUM(CMM.mMerchandise),0) AS MerchRef
							 , ISNULL(SUM(CMM.mMerchandiseCost),0) AS CostRef
					   FROM tblCreditMemoMaster CMM 
					   LEFT JOIN tblOrder O ON O.ixOrder = CMM.ixOrder 
					   WHERE flgCanceled = '0'
						 AND dtCreateDate BETWEEN @PPRtnStart AND @PPRtnEnd -- '01/01/10' AND '12/31/10'
						-- AND CMM.ixOrder <> 'FSCR' -- PER TED H. THESE SHOULD NOT BE EXCLUDED
						 AND CMM.mMerchandise > 0 
					   GROUP BY (CASE WHEN O.ixCustomer = '16878' THEN 'NON-US'
								      WHEN O.ixCustomer = '10533' THEN 'NON-US' 
									  WHEN O.sShipToCountry IN ('US', 'USA') THEN 'US'
									  ELSE 'NON-US'
								 END) 
							    , (CASE WHEN O.ixCustomer = '16878' THEN 'BRAZIL'
										WHEN O.ixCustomer = '10533' THEN 'GERMANY'
										WHEN O.sShipToCountry IN ('US', 'USA') THEN O.sShipToState
									    ELSE O.sShipToCountry
								   END) 
					  ) AS RTNS ON RTNS.ShipTo = SALES.ShipTo 

      GROUP BY ISNULL(SALES.Geo, RTNS.Geo)
             , ISNULL(SALES.ShipTo, RTNS.ShipTo) 
             , SALES.Orders 
             , ISNULL(SALES.Merch, 0) - ISNULL(RTNS.MerchRef, 0) 
             , ISNULL(SALES.Cost, 0) - ISNULL(RTNS.CostRef, 0) 
             , (ISNULL(SALES.Merch, 0) - ISNULL(RTNS.MerchRef, 0)) 
               - (ISNULL(SALES.Cost, 0) - ISNULL(RTNS.CostRef, 0))
     ) AS Y1     
       
FULL OUTER JOIN (SELECT ISNULL(SALES.Geo, RTNS.Geo) AS Geo --to allow filtering by region
					  , ISNULL(SALES.ShipTo, RTNS.ShipTo) AS ShipTo
					  , SALES.Orders AS OrdCnt
					  , ISNULL(SALES.Merch, 0) - ISNULL(RTNS.MerchRef, 0) AS NetRev
					  , ISNULL(SALES.Cost, 0) - ISNULL(RTNS.CostRef, 0) AS NetCost
					  , (ISNULL(SALES.Merch, 0) - ISNULL(RTNS.MerchRef, 0)) 
					   - (ISNULL(SALES.Cost, 0) - ISNULL(RTNS.CostRef, 0)) AS GrossProfit
					  --   Margin calculation to be done on report side to exclude divide by zero error
				 FROM (SELECT (CASE WHEN O.ixCustomer = '16878' THEN 'NON-US'
								    WHEN O.ixCustomer = '10533' THEN 'NON-US' 
									WHEN O.sShipToCountry IN ('US', 'USA') THEN 'US'
									ELSE 'NON-US'
							   END) AS Geo 
							, (CASE WHEN O.ixCustomer = '16878' THEN 'BRAZIL'
									WHEN O.ixCustomer = '10533' THEN 'GERMANY'
									WHEN O.sShipToCountry IN ('US', 'USA') THEN O.sShipToState
									ELSE O.sShipToCountry
							   END) AS ShipTo
							, COUNT (*) AS Orders 
							, ISNULL (SUM(O.mMerchandise), 0) AS Merch
							, ISNULL (SUM(O.mMerchandiseCost), 0) AS Cost 
					   FROM tblOrder O 
					   WHERE O.dtShippedDate BETWEEN @CPSalesStart AND @CPSalesEnd -- '01/01/11' AND '12/31/11'
						 AND O.sOrderStatus ='Shipped'
						 AND O.mMerchandise > 0 
					   GROUP BY (CASE WHEN O.ixCustomer = '16878' THEN 'NON-US'
									  WHEN O.ixCustomer = '10533' THEN 'NON-US' 
									  WHEN O.sShipToCountry IN ('US', 'USA') THEN 'US'
									  ELSE 'NON-US'
								 END)  
								,(CASE WHEN O.ixCustomer = '16878' THEN 'BRAZIL'
                                       WHEN O.ixCustomer = '10533' THEN 'GERMANY'
                                       WHEN O.sShipToCountry IN ('US', 'USA') THEN O.sShipToState
			                           ELSE O.sShipToCountry
                                  END) 
					  ) AS SALES 

				 FULL OUTER JOIN (SELECT (CASE WHEN O.ixCustomer = '16878' THEN 'NON-US'
											   WHEN O.ixCustomer = '10533' THEN 'NON-US' 
											   WHEN O.sShipToCountry IN ('US', 'USA') THEN 'US'
											   ELSE 'NON-US'
											   END) AS Geo 
										 , (CASE WHEN O.ixCustomer = '16878' THEN 'BRAZIL'
												 WHEN O.ixCustomer = '10533' THEN 'GERMANY'
											     WHEN O.sShipToCountry IN ('US', 'USA') THEN O.sShipToState
												 ELSE O.sShipToCountry
										    END) AS ShipTo
										 , ISNULL(SUM(CMM.mMerchandise),0) AS MerchRef
										 , ISNULL(SUM(CMM.mMerchandiseCost),0) AS CostRef
								  FROM tblCreditMemoMaster CMM 
								  LEFT JOIN tblOrder O ON O.ixOrder = CMM.ixOrder 
								  WHERE flgCanceled = '0'
									AND dtCreateDate BETWEEN @CPRtnStart AND @CPRtnEnd -- '01/01/11' AND '12/31/11'
									-- AND CMM.ixOrder <> 'FSCR' -- PER TED H. THESE SHOULD NOT BE EXCLUDED
									AND CMM.mMerchandise > 0 
								  GROUP BY (CASE WHEN O.ixCustomer = '16878' THEN 'NON-US'
												 WHEN O.ixCustomer = '10533' THEN 'NON-US' 
												 WHEN O.sShipToCountry IN ('US', 'USA') THEN 'US'
											     ELSE 'NON-US'
											END) 
                                           , (CASE WHEN O.ixCustomer = '16878' THEN 'BRAZIL'
												   WHEN O.ixCustomer = '10533' THEN 'GERMANY'
												   WHEN O.sShipToCountry IN ('US', 'USA') THEN O.sShipToState
												   ELSE O.sShipToCountry
											  END) 
								 ) AS RTNS ON RTNS.ShipTo = SALES.ShipTo 

				 GROUP BY ISNULL(SALES.Geo, RTNS.Geo)
					    , ISNULL(SALES.ShipTo, RTNS.ShipTo) 
						, SALES.Orders 
						, ISNULL(SALES.Merch, 0) - ISNULL(RTNS.MerchRef, 0) 
						, ISNULL(SALES.Cost, 0) - ISNULL(RTNS.CostRef, 0) 
						, (ISNULL(SALES.Merch, 0) - ISNULL(RTNS.MerchRef, 0)) 
							- (ISNULL(SALES.Cost, 0) - ISNULL(RTNS.CostRef, 0))
			    ) AS Y2 ON Y2.ShipTo = Y1.ShipTo
 
GROUP BY ISNULL(Y1.Geo, Y2.Geo)
       , ISNULL(Y1.ShipTo, Y2.ShipTo) 
	   , Y1.OrdCnt 
	   , Y2.OrdCnt 
	   , Y1.NetRev 
	   , Y1.NetCost 
	   , Y1.GrossProfit 
	   , Y2.NetRev 
	   , Y2.NetCost 
	   , Y2.GrossProfit 
		
ORDER BY Geo, ShipTo