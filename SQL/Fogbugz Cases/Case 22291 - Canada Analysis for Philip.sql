/********************************************

 Ship Methods to Canada in the past 2 years
 
Ship		Order	Ship Method
Method		Cnt		Description
19			96		Canada Post
10			1511	UPS Worldwide Expedited
8			928		Best Way
12			621		UPS Standard
27			12		USPS Express International
1			22		Counter
11			132		UPS Worldwide Saver
26			471		USPS Priority International

********************************************/

SELECT ISNULL(LY.Province, TY.Province) AS Province
     , ISNULL(LY.Merch,0) AS LYMerch
     , ISNULL(LY.OrderCnt,0) AS LYOrderCnt
     , ISNULL(LY.GM,0) AS LYGM
     , ISNULL(LY.ShippingCharged,0) AS LYShippingCharged
     , ISNULL(LY.CanadaPostShippingCharged,0) AS LYCanadaPostShippingCharged
     , ISNULL(LY.UPSWEShippingCharged,0) AS LYUPSWEShippingCharged
     , ISNULL(LY.OtherShipShippingCharged,0) AS LYOtherShipShippingCharged
     , ISNULL(LY.ShippingCost,0) AS LYShippingCost   
     , ISNULL(LY.CanadaPostShippingCost,0) AS LYCanadaPostShippingCost
     , ISNULL(LY.UPSWEShippingCost,0) AS LYUPSWEShippingCost
     , ISNULL(LY.OtherShipShippingCost,0) AS LYOtherShipShippingCost       
     , ISNULL(LY.CanadaPostCnt,0) AS LYCanadaPostCnt
     , ISNULL(LY.UPSWECnt,0) AS LYUPSWECnt     
     , ISNULL(LY.OtherShipCnt,0) AS LYOtherShipCnt 
     , ISNULL(TY.Merch,0) AS TYMerch
     , ISNULL(TY.OrderCnt,0) AS TYOrderCnt
     , ISNULL(TY.GM,0) AS TYGM
     , ISNULL(TY.ShippingCharged,0) AS TYShippingCharged
     , ISNULL(TY.CanadaPostShippingCharged,0) AS TYCanadaPostShippingCharged
     , ISNULL(TY.UPSWEShippingCharged,0) AS TYUPSWEShippingCharged
     , ISNULL(TY.OtherShipShippingCharged,0) AS TYOtherShipShippingCharged     
     , ISNULL(TY.ShippingCost,0) AS TYShippingCost
     , ISNULL(TY.CanadaPostShippingCost,0) AS TYCanadaPostShippingCost
     , ISNULL(TY.UPSWEShippingCost,0) AS TYUPSWEShippingCost
     , ISNULL(TY.OtherShipShippingCost,0) AS TYOtherShipShippingCost       
     , ISNULL(TY.CanadaPostCnt,0) AS TYCanadaPostCnt
     , ISNULL(TY.UPSWECnt,0) AS TYUPSWECnt     
     , ISNULL(TY.OtherShipCnt,0) AS TYOtherShipCnt      
FROM (SELECT (CASE WHEN O.sShipToState IN (CP.ixProvince) THEN O.sShipToState
				   ELSE 'Other' --to show errors in order entry not being placed in correct province category
             END) AS Province 
		   , SUM(ISNULL(mMerchandise,0)) AS Merch
		   , SUM(CASE WHEN ixOrder LIKE '%-%' THEN 0
					  ELSE 1 
				END) AS OrderCnt --to avoid backorders being double counted
		   , SUM(ISNULL(mMerchandise,0)) - SUM(ISNULL(mMerchandiseCost,0)) AS GM 
		   , SUM(ISNULL(mShipping,0)) AS ShippingCharged
		   , ISNULL(CanadaPost.ShippingCharged,0) AS CanadaPostShippingCharged 
		   , ISNULL(UPSWE.ShippingCharged,0) AS UPSWEShippingCharged 		   
		   , ISNULL(OtherShip.ShippingCharged,0) AS OtherShipShippingCharged	  		   
		   , SUM(dbo.EstShippingCost(iShipMethod, mPublishedShipping)) AS ShippingCost
		   , ISNULL(CanadaPost.ShippingCost,0) AS CanadaPostShippingCost 
		   , ISNULL(UPSWE.ShippingCost,0) AS UPSWEShippingCost 		   
		   , ISNULL(OtherShip.ShippingCost,0) AS OtherShipShippingCost	  		   
		   , ISNULL(CanadaPost.Cnt,0) AS CanadaPostCnt 
		   , ISNULL(UPSWE.Cnt,0) AS UPSWECnt 		   
		   , ISNULL(OtherShip.Cnt,0) AS OtherShipCnt	              
	  FROM tblOrder O      
	  LEFT JOIN (SELECT ixProvince
			     FROM tblCanadianProvince CP 
                ) CP ON CP.ixProvince = O.sShipToState 
	  LEFT JOIN (SELECT (CASE WHEN O.sShipToState IN (CP.ixProvince) THEN O.sShipToState
							  ELSE 'Other' 
						END) AS Province 
			          , COUNT(DISTINCT ixOrder) AS Cnt
			          , SUM(ISNULL(mShipping,0)) AS ShippingCharged
		              , SUM(dbo.EstShippingCost(iShipMethod, mPublishedShipping)) AS ShippingCost
				 FROM tblOrder O
				 LEFT JOIN (SELECT ixProvince
					   	    FROM tblCanadianProvince CP 
					       ) CP ON CP.ixProvince = O.sShipToState 
				 WHERE dtShippedDate BETWEEN '01/01/13' AND '04/13/13' --DATEADD(yy, DATEDIFF(yy, 0, DATEADD(yy, -1, GETDATE())), 0) AND DATEADD(dd, -365, GETDATE()) --the first day of last year to one year prior to today's date
				   AND sOrderStatus = 'Shipped' 
				   AND sOrderChannel <> 'INTERNAL'
				   AND sOrderType <> 'Internal'
				   AND sShipToCountry = 'CANADA' 
				   AND mMerchandise >= 1 --to exclude catalog only orders 	
				   AND ixOrder NOT LIKE '%-%'
				   AND iShipMethod = '19'	
				 GROUP BY (CASE WHEN O.sShipToState IN (CP.ixProvince) THEN O.sShipToState
							    ELSE 'Other' 
						  END) 	
				) CanadaPost ON CanadaPost.Province = (CASE WHEN O.sShipToState IN (CP.ixProvince) THEN O.sShipToState
															ELSE 'Other' 
														END)
	  LEFT JOIN (SELECT (CASE WHEN O.sShipToState IN (CP.ixProvince) THEN O.sShipToState
							  ELSE 'Other' 
						END) AS Province 
			          , COUNT(DISTINCT ixOrder) AS Cnt
			          , SUM(ISNULL(mShipping,0)) AS ShippingCharged
		              , SUM(dbo.EstShippingCost(iShipMethod, mPublishedShipping)) AS ShippingCost
				 FROM tblOrder O
				 LEFT JOIN (SELECT ixProvince
					   	    FROM tblCanadianProvince CP 
					       ) CP ON CP.ixProvince = O.sShipToState 
				 WHERE dtShippedDate BETWEEN '01/01/13' AND '04/13/13' --DATEADD(yy, DATEDIFF(yy, 0, DATEADD(yy, -1, GETDATE())), 0) AND DATEADD(dd, -365, GETDATE()) --the first day of last year to one year prior to today's date
				   AND sOrderStatus = 'Shipped' 
				   AND sOrderChannel <> 'INTERNAL'
				   AND sOrderType <> 'Internal'
				   AND sShipToCountry = 'CANADA' 
				   AND mMerchandise >= 1 --to exclude catalog only orders 	
				   AND ixOrder NOT LIKE '%-%'
				   AND iShipMethod = '10'	
				 GROUP BY (CASE WHEN O.sShipToState IN (CP.ixProvince) THEN O.sShipToState
							    ELSE 'Other' 
						  END) 	
				) UPSWE ON UPSWE.Province = (CASE WHEN O.sShipToState IN (CP.ixProvince) THEN O.sShipToState
															ELSE 'Other' 
														END)														
	  LEFT JOIN (SELECT (CASE WHEN O.sShipToState IN (CP.ixProvince) THEN O.sShipToState
					          ELSE 'Other' 
					    END) AS Province 
			          , COUNT(DISTINCT ixOrder) AS Cnt
			          , SUM(ISNULL(mShipping,0)) AS ShippingCharged
		              , SUM(dbo.EstShippingCost(iShipMethod, mPublishedShipping)) AS ShippingCost
		         FROM tblOrder O
		         LEFT JOIN (SELECT ixProvince
					        FROM tblCanadianProvince CP 
					       ) CP ON CP.ixProvince = O.sShipToState 		   
		         WHERE dtShippedDate BETWEEN '01/01/13' AND '04/13/13' --DATEADD(yy, DATEDIFF(yy, 0, DATEADD(yy, -1, GETDATE())), 0) AND DATEADD(dd, -365, GETDATE())
			       AND sOrderStatus = 'Shipped' 
				   AND sOrderChannel <> 'INTERNAL'
				   AND sOrderType <> 'Internal'
				   AND sShipToCountry = 'CANADA' 
				   AND mMerchandise >= 1 --to exclude catalog only orders 	
				   AND ixOrder NOT LIKE '%-%'
				   AND iShipMethod NOT IN ('19', '10')	
				 GROUP BY (CASE WHEN O.sShipToState IN (CP.ixProvince) THEN O.sShipToState
					            ELSE 'Other' 
						  END) 	
				) OtherShip ON OtherShip.Province = (CASE WHEN O.sShipToState IN (CP.ixProvince) THEN O.sShipToState
													      ELSE 'Other' 
												    END) 		                      
	  WHERE dtShippedDate BETWEEN '01/01/13' AND '04/13/13' --DATEADD(yy, DATEDIFF(yy, 0, DATEADD(yy, -1, GETDATE())), 0) AND DATEADD(dd, -365, GETDATE())
		AND sOrderStatus = 'Shipped' 
		AND sOrderChannel <> 'INTERNAL'
		AND sOrderType <> 'Internal'
		AND sShipToCountry = 'CANADA' 
		AND mMerchandise >= 1 --to exclude catalog only orders
	  GROUP BY (CASE WHEN sShipToState IN (CP.ixProvince) THEN O.sShipToState
					 ELSE 'Other' 
			   END)
			 , ISNULL(CanadaPost.ShippingCharged,0) 
		     , ISNULL(UPSWE.ShippingCharged,0)  		   
		     , ISNULL(OtherShip.ShippingCharged,0)
		     , ISNULL(CanadaPost.ShippingCost,0)  
		     , ISNULL(UPSWE.ShippingCost,0)  		   
		     , ISNULL(OtherShip.ShippingCost,0)  
			 , ISNULL(CanadaPost.Cnt,0)
		     , ISNULL(UPSWE.Cnt,0)			   
			 , ISNULL(OtherShip.Cnt,0) 	
    ) LY --Last Year
FULL OUTER JOIN (SELECT (CASE WHEN O.sShipToState IN (CP.ixProvince) THEN O.sShipToState
							  ELSE 'Other' 
						END) AS Province 
					  , SUM(ISNULL(mMerchandise,0)) AS Merch
					  , SUM(CASE WHEN ixOrder LIKE '%-%' THEN 0
					             ELSE 1 
				           END) AS OrderCnt 
					  , SUM(ISNULL(mMerchandise,0)) - SUM(ISNULL(mMerchandiseCost,0)) AS GM 
					  , SUM(ISNULL(mShipping,0)) AS ShippingCharged
					  , ISNULL(CanadaPost.ShippingCharged,0) AS CanadaPostShippingCharged 
					  , ISNULL(UPSWE.ShippingCharged,0) AS UPSWEShippingCharged 		   
					  , ISNULL(OtherShip.ShippingCharged,0) AS OtherShipShippingCharged
		              , SUM(dbo.EstShippingCost(iShipMethod, mPublishedShipping)) AS ShippingCost	
		              , ISNULL(CanadaPost.ShippingCost,0) AS CanadaPostShippingCost 
					  , ISNULL(UPSWE.ShippingCost,0) AS UPSWEShippingCost 		   
					  , ISNULL(OtherShip.ShippingCost,0) AS OtherShipShippingCost			  
					  , ISNULL(CanadaPost.Cnt,0) AS CanadaPostCnt 
					  , ISNULL(UPSWE.Cnt,0) AS UPSWECnt 					  
					  , ISNULL(OtherShip.Cnt,0) AS OtherShipCnt	              
				 FROM tblOrder O      
			     LEFT JOIN (SELECT ixProvince
							FROM tblCanadianProvince CP 
                           ) CP ON CP.ixProvince = O.sShipToState 
				 LEFT JOIN (SELECT (CASE WHEN O.sShipToState IN (CP.ixProvince) THEN O.sShipToState
										 ELSE 'Other' 
								   END) AS Province 
			                     , COUNT(DISTINCT ixOrder) AS Cnt
			                     , SUM(ISNULL(mShipping,0)) AS ShippingCharged
		                         , SUM(dbo.EstShippingCost(iShipMethod, mPublishedShipping)) AS ShippingCost
						    FROM tblOrder O
							LEFT JOIN (SELECT ixProvince
					   				   FROM tblCanadianProvince CP 
					                 ) CP ON CP.ixProvince = O.sShipToState 
							WHERE dtShippedDate BETWEEN '01/01/14' AND '04/13/14' --DATEADD(yy, DATEDIFF(yy,0,getdate()), 0) AND GETDATE() --the first day of this year to today's date
							  AND sOrderStatus = 'Shipped' 
							  AND sOrderChannel <> 'INTERNAL'
							  AND sOrderType <> 'Internal'
							  AND sShipToCountry = 'CANADA' 
							  AND mMerchandise >= 1 --to exclude catalog only orders 	
							  AND ixOrder NOT LIKE '%-%'
							  AND iShipMethod = '19'	
							GROUP BY (CASE WHEN O.sShipToState IN (CP.ixProvince) THEN O.sShipToState
										   ELSE 'Other' 
									END) 	
						  ) CanadaPost ON CanadaPost.Province = (CASE WHEN O.sShipToState IN (CP.ixProvince) THEN O.sShipToState
																	  ELSE 'Other' 
																END)
				 LEFT JOIN (SELECT (CASE WHEN O.sShipToState IN (CP.ixProvince) THEN O.sShipToState
										 ELSE 'Other' 
								   END) AS Province 
			                     , COUNT(DISTINCT ixOrder) AS Cnt
			                     , SUM(ISNULL(mShipping,0)) AS ShippingCharged
		                         , SUM(dbo.EstShippingCost(iShipMethod, mPublishedShipping)) AS ShippingCost
						    FROM tblOrder O
							LEFT JOIN (SELECT ixProvince
					   				   FROM tblCanadianProvince CP 
					                 ) CP ON CP.ixProvince = O.sShipToState 
							WHERE dtShippedDate BETWEEN '01/01/14' AND '04/13/14' --DATEADD(yy, DATEDIFF(yy,0,getdate()), 0) AND GETDATE() --the first day of this year to today's date
							  AND sOrderStatus = 'Shipped' 
							  AND sOrderChannel <> 'INTERNAL'
							  AND sOrderType <> 'Internal'
							  AND sShipToCountry = 'CANADA' 
							  AND mMerchandise >= 1 --to exclude catalog only orders 	
							  AND ixOrder NOT LIKE '%-%'
							  AND iShipMethod = '10'	
							GROUP BY (CASE WHEN O.sShipToState IN (CP.ixProvince) THEN O.sShipToState
										   ELSE 'Other' 
									END) 	
						  ) UPSWE ON UPSWE.Province = (CASE WHEN O.sShipToState IN (CP.ixProvince) THEN O.sShipToState
																	  ELSE 'Other' 
																END)																
				 LEFT JOIN (SELECT (CASE WHEN O.sShipToState IN (CP.ixProvince) THEN O.sShipToState
										 ELSE 'Other' 
								   END) AS Province 
			                     , COUNT(DISTINCT ixOrder) AS Cnt
			                     , SUM(ISNULL(mShipping,0)) AS ShippingCharged
		                         , SUM(dbo.EstShippingCost(iShipMethod, mPublishedShipping)) AS ShippingCost
							FROM tblOrder O
							LEFT JOIN (SELECT ixProvince
									   FROM tblCanadianProvince CP 
									 ) CP ON CP.ixProvince = O.sShipToState 		   
						    WHERE dtShippedDate BETWEEN '01/01/14' AND '04/13/14' --DATEADD(yy, DATEDIFF(yy,0,getdate()), 0) AND GETDATE()
							  AND sOrderStatus = 'Shipped' 
							  AND sOrderChannel <> 'INTERNAL'
							  AND sOrderType <> 'Internal'
							  AND sShipToCountry = 'CANADA' 
							  AND mMerchandise >= 1 --to exclude catalog only orders 	
							  AND ixOrder NOT LIKE '%-%'
							  AND iShipMethod NOT IN ('19', '10')	
							GROUP BY (CASE WHEN O.sShipToState IN (CP.ixProvince) THEN O.sShipToState
										   ELSE 'Other' 
									 END) 	
						  ) OtherShip ON OtherShip.Province = (CASE WHEN O.sShipToState IN (CP.ixProvince) THEN O.sShipToState
													                ELSE 'Other' 
												              END) 		                      
				 WHERE dtShippedDate BETWEEN '01/01/14' AND '04/13/14' --DATEADD(yy, DATEDIFF(yy,0,getdate()), 0) AND GETDATE()
				   AND sOrderStatus = 'Shipped' 
				   AND sOrderChannel <> 'INTERNAL'
				   AND sOrderType <> 'Internal'
				   AND sShipToCountry = 'CANADA' 
				   AND mMerchandise >= 1 --to exclude catalog only orders
				 GROUP BY (CASE WHEN sShipToState IN (CP.ixProvince) THEN O.sShipToState
								ELSE 'Other' 
						  END)
			            , ISNULL(CanadaPost.ShippingCharged,0) 
						, ISNULL(UPSWE.ShippingCharged,0)  		   
						, ISNULL(OtherShip.ShippingCharged,0)
						, ISNULL(CanadaPost.ShippingCost,0)  
						, ISNULL(UPSWE.ShippingCost,0)  		   
						, ISNULL(OtherShip.ShippingCost,0)  
						, ISNULL(CanadaPost.Cnt,0)
						, ISNULL(UPSWE.Cnt,0)			   
						, ISNULL(OtherShip.Cnt,0)  	
               ) TY ON TY.Province = LY.Province--This Year