--Counter invoiced orders 
SELECT O.ixOrder AS OrderNum
     , Lines.SkuCnt AS OrderLines
     , ISNULL(BP.NonBPcount,0) AS NonBPCnt
       -- orders where this returns 'Y' will want to be excluded from the historical report 
     , (CASE WHEN Shock.ShockSkuCnt > 0 THEN 'Y' 
             ELSE 'N'
         END) AS ShockParts
     , O.dtOrderDate AS DateEntered  -- KEEP for cond. formatting
     , SUBSTRING(T1.chTime,1,5) AS TimeEntered -- KEEP for cond. formatting
     , O.dtOrderDate + SUBSTRING(T1.chTime,1,5) AS DateTimeEntered
       -- Time since created = [Current time - authorization time or IF NULL then printed time]    
     , (CASE WHEN T2.chTime IS NULL THEN ((DATEDIFF(mi,GETDATE(),(dbo.GetLatestOrderTimePrinted (O.ixOrder)))*-1))
             ELSE ((DATEDIFF(mi,GETDATE(),(D2.dtDate + SUBSTRING(T2.chTime,1,5)))*-1)) 
         END) AS TimeSinceCreated 
       -- Wait time = [Current time - most recent scan/verify time from carousel OR if all items are big pack time since created]            
     , (CASE WHEN ISNULL(BP.NonBPcount,0) = 0 THEN (CASE WHEN T2.chTime IS NULL THEN ((DATEDIFF(mi,GETDATE(),(dbo.GetLatestOrderTimePrinted (O.ixOrder)))*-1))
														 ELSE ((DATEDIFF(mi,GETDATE(),(D2.dtDate + SUBSTRING(T2.chTime,1,5)))*-1)) 
													 END) 
             ELSE (DATEDIFF(mi,GETDATE(),(ISNULL((OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)),(D3.dtDate + SUBSTRING(T4.chTime,1,5)))))*-1)
        END) AS WaitTime 													                    
     , O.ixAuthorizationStatus AS AuthStatus
     , D2.dtDate AS DateAuthorized -- KEEP for cond. formatting
     , SUBSTRING(T2.chTime,1,5) AS TimeAuthorized -- KEEP for cond. formatting           
     , D2.dtDate + SUBSTRING(T2.chTime,1,5) AS DateTimeAuthorized  
     , (dbo.GetLatestOrderTimePrinted (O.ixOrder)) AS dtTimePrinted
       -- Max values for time scanned and verified have already been taken into account in subselect below      
     , OS2.dtScanDate + SUBSTRING(T3.chTime,1,5) AS DateTimeScanned
     , D3.dtDate + SUBSTRING(T4.chTime,1,5) AS DateTimeVerified       
FROM tblOrder O
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
LEFT JOIN tblOrderRouting ORT ON ORT.ixOrder = O.ixOrder
--To get the number of order lines with tangible SKUs 
LEFT JOIN (SELECT DISTINCT ixOrder 
                , COUNT(DISTINCT OL.ixSKU) AS SkuCnt 
           FROM tblOrderLine OL 
           LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
           WHERE OL.dtOrderDate >= '05/30/13'
             AND S.flgIntangible = '0'
           GROUP BY ixOrder) Lines ON Lines.ixOrder = O.ixOrder 
LEFT JOIN tblTime T1 ON T1.ixTime = O.ixOrderTime
LEFT JOIN tblDate D2 ON D2.ixDate = O.ixAuthorizationDate
LEFT JOIN tblTime T2 ON T2.ixTime = O.ixAuthorizationTime
LEFT JOIN tblCounterOrderScans OS ON OS.ixOrder = O.ixOrder 
  -- this query determines the most recent time the caraousel scanned/verified an order to base the counter wait time off of 
LEFT JOIN (SELECT DISTINCT OS.ixOrder 
                , MAX(OS.dtScanDate) AS dtScanDate 
                , MAX(OS.ixScanTime) AS ixScanTime  
           FROM tblCounterOrderScans OS 
           LEFT JOIN tblIPAddress IP ON IP.ixIP = OS.ixIP 
           WHERE IP.sGroup = 'Carousel'  
           GROUP BY OS.ixOrder
           ) OS2 ON OS2.ixOrder = O.ixOrder  
LEFT JOIN tblTime T3 ON T3.ixTime = OS2.ixScanTime  
LEFT JOIN tblDate D3 ON D3.ixDate = ORT.ixVerifyDate
LEFT JOIN tblTime T4 ON T4.ixTime = ORT.ixVerifyTime 
          -- count of SKUs that aren't in BigPack, if null(0) then counter guys should retrieve immediately on their own          
LEFT JOIN (SELECT OL.ixOrder
                , COUNT(DISTINCT OL.ixSKU) AS NonBPcount
           FROM tblOrderLine OL
           LEFT JOIN tblBinSku BS on BS.ixSKU = OL.ixSKU
                             and BS.ixLocation = 99
           LEFT JOIN tblSKU S on S.ixSKU = OL.ixSKU
           WHERE S.flgIntangible = 0 
             AND BS.sPickingBin NOT LIKE 'B%'
             AND BS.sPickingBin <> 'A KIT'             
           GROUP BY OL.ixOrder
          ) BP on BP.ixOrder = O.ixOrder
          -- determine whether an order has customer/rebuild shock components; these take additional time and should be excluded from historical data        
LEFT JOIN (SELECT OL.ixOrder
                , COUNT(DISTINCT OL.ixSKU) AS ShockSkuCnt
           FROM tblOrderLine OL
           LEFT JOIN tblBinSku BS on BS.ixSKU = OL.ixSKU
                             AND BS.ixLocation = 99
           WHERE BS.sPickingBin LIKE 'SHOCK%'             
           GROUP BY OL.ixOrder
          ) Shock on Shock.ixOrder = O.ixOrder    
          -- determine orders that all items are backordered but have not yet switched from the 'open' status state 
LEFT JOIN (SELECT OL.ixOrder 
				, COUNT(DISTINCT OL.iOrdinality) AS Tot    
				, BO.BOCnt 
				, OL.dtOrderDate
		   FROM tblOrderLine OL
		   LEFT JOIN (SELECT OL.ixOrder
					   	   , COUNT(DISTINCT OL.iOrdinality) AS BOCnt
					  FROM tblOrderLine OL
					  LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
					  WHERE O.ixOrder NOT LIKE '%-%'
						AND O.sOrderStatus IN ('Open')--,'Shipped') 
						AND flgLineStatus = 'Backordered'
					  GROUP BY OL.ixOrder 
					 ) BO ON BO.ixOrder = OL.ixOrder 
		   GROUP BY OL.ixOrder  
				  , BO.BOCnt 
				  , OL.dtOrderDate 	
		   HAVING COUNT(DISTINCT OL.ixSKU) = BO.BOCnt
		 ) BO ON BO.ixOrder = O.ixOrder                        
WHERE O.sOrderStatus = 'Open' 
  AND 
      O.dtOrderDate >= '05/30/13' --@OrderDate -- This would be a hidden parameter 	
  AND O.iShipMethod = '1' -- Counter orders only  		
  -- order either hasn't been scanned at all or has been scanned but not by counter (i.e. scanned by carousel) 
  AND ORT.ixVerifyDate IS NULL
  AND BO.ixOrder IS NULL
  AND (OS.ixOrder IS NULL       
		OR (OS.ixOrder IS NOT NULL AND   
						 -- sub select = orders scanned by counter          
			OS.ixOrder NOT IN (SELECT DISTINCT ixOrder 
			     		       FROM tblCounterOrderScans OS
							   LEFT JOIN tblIPAddress IP ON IP.ixIP = OS.ixIP
							   WHERE IP.sGroup = 'Counter') 
 			)
	    ) 
  AND O.sOrderChannel <> 'COUNTER' /* this results from orders being created that started as pick tickets therefore 
                                       the parts are already at the counter and bypass the carousel phase */
GROUP BY O.ixOrder
       , Lines.SkuCnt    
       , ISNULL(BP.NonBPcount,0) 
       , (CASE WHEN Shock.ShockSkuCnt > 0 THEN 'Y' 
               ELSE 'N'
           END)          
	   , O.dtOrderDate
       , SUBSTRING(T1.chTime,1,5)
       , O.dtOrderDate + SUBSTRING(T1.chTime,1,5)     
       , (CASE WHEN T2.chTime IS NULL THEN ((DATEDIFF(mi,GETDATE(),(dbo.GetLatestOrderTimePrinted (O.ixOrder)))*-1))
               ELSE ((DATEDIFF(mi,GETDATE(),(D2.dtDate + SUBSTRING(T2.chTime,1,5)))*-1)) 
           END)     
       , (CASE WHEN ISNULL(BP.NonBPcount,0) = 0 THEN (CASE WHEN T2.chTime IS NULL THEN ((DATEDIFF(mi,GETDATE(),(dbo.GetLatestOrderTimePrinted (O.ixOrder)))*-1))
				  										   ELSE ((DATEDIFF(mi,GETDATE(),(D2.dtDate + SUBSTRING(T2.chTime,1,5)))*-1)) 
													   END) 
               ELSE (DATEDIFF(mi,GETDATE(),(ISNULL((OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)),(D3.dtDate + SUBSTRING(T4.chTime,1,5)))))*-1)
          END)                            
       , O.ixAuthorizationStatus  
       , D2.dtDate          
       , SUBSTRING(T2.chTime,1,5) 
       , D2.dtDate + SUBSTRING(T2.chTime,1,5)           
       , (dbo.GetLatestOrderTimePrinted (O.ixOrder)) 
       , OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)  
       , D3.dtDate + SUBSTRING(T4.chTime,1,5)             
ORDER BY WaitTime DESC
       , TimeSinceCreated DESC
      
  

--Pick tickets
SELECT O.ixOrder AS OrderNum
     , Lines.SkuCnt AS OrderLines
     , ISNULL(BP.NonBPcount,0) AS NonBPCnt  
       -- orders where this returns 'Y' will want to be excluded from the historical report      
     , (CASE WHEN Shock.ShockSkuCnt > 0 THEN 'Y' 
             ELSE 'N'
         END) AS ShockParts        
     , O.dtOrderDate AS DateEntered  -- KEEP for cond. formatting
     , SUBSTRING(T1.chTime,1,5) AS TimeEntered -- KEEP for cond. formatting
     , O.dtOrderDate + SUBSTRING(T1.chTime,1,5) AS DateTimeEntered
       -- Time since created = [Current time - date/time entered (pick tickets do not get auth/printed times)]  
     , (DATEDIFF(mi,GETDATE(),(O.dtOrderDate + SUBSTRING(T1.chTime,1,5)))*-1) AS TimeSinceCreated  
       -- Wait time = [Current time - most recent scan/verify time from carousel OR if all items are big pack time since created]     
     , (CASE WHEN ISNULL(BP.NonBPcount,0) = 0 THEN (DATEDIFF(mi,GETDATE(),(O.dtOrderDate + SUBSTRING(T1.chTime,1,5)))*-1) 
             ELSE (DATEDIFF(mi,GETDATE(),(ISNULL((OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)),(D3.dtDate + SUBSTRING(T4.chTime,1,5)))))*-1)
        END) AS WaitTime 
     , O.ixAuthorizationStatus AS AuthStatus
     , D2.dtDate AS DateAuthorized -- KEEP for cond. formatting
     , SUBSTRING(T2.chTime,1,5) AS TimeAuthorized -- KEEP for cond. formatting           
     , D2.dtDate + SUBSTRING(T2.chTime,1,5) AS DateTimeAuthorized  
     , (dbo.GetLatestOrderTimePrinted (O.ixOrder)) AS dtTimePrinted
     , OS2.dtScanDate + SUBSTRING(T3.chTime,1,5) AS DateTimeScanned    
     , D3.dtDate + SUBSTRING(T4.chTime,1,5) AS DateTimeVerified        
FROM tblOrder O
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
--To get the number of order lines with tangible SKUs 
LEFT JOIN (SELECT DISTINCT ixOrder 
                , COUNT(DISTINCT OL.ixSKU) AS SkuCnt 
           FROM tblOrderLine OL 
           LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
           WHERE OL.dtOrderDate >= '05/30/13'
             AND S.flgIntangible = '0'
           GROUP BY ixOrder) Lines ON Lines.ixOrder = O.ixOrder 
LEFT JOIN tblTime T1 ON T1.ixTime = O.ixOrderTime
LEFT JOIN tblDate D2 ON D2.ixDate = O.ixAuthorizationDate
LEFT JOIN tblTime T2 ON T2.ixTime = O.ixAuthorizationTime
LEFT JOIN tblCounterOrderScans OS ON OS.ixOrder = O.ixOrder 
LEFT JOIN (SELECT DISTINCT OS.ixOrder 
                , MAX(OS.dtScanDate) AS dtScanDate 
                , MAX(OS.ixScanTime) AS ixScanTime  
           FROM tblCounterOrderScans OS 
           LEFT JOIN tblIPAddress IP ON IP.ixIP = OS.ixIP 
           WHERE IP.sGroup = 'Carousel'  
           GROUP BY OS.ixOrder
           ) OS2 ON OS2.ixOrder = O.ixOrder  
LEFT JOIN tblTime T3 ON T3.ixTime = OS2.ixScanTime
LEFT JOIN tblOrderRouting ORT ON ORT.ixOrder = O.ixOrder
LEFT JOIN tblDate D3 ON D3.ixDate = ORT.ixVerifyDate
LEFT JOIN tblTime T4 ON T4.ixTime = ORT.ixVerifyTime   
          -- count of SKUs that aren't in BigPack  
LEFT JOIN (SELECT OL.ixOrder
                , COUNT(DISTINCT OL.ixSKU) AS NonBPcount
           FROM tblOrderLine OL
           LEFT JOIN tblBinSku BS on BS.ixSKU = OL.ixSKU
           LEFT JOIN tblSKU S on S.ixSKU = OL.ixSKU
           WHERE S.flgIntangible = 0 
             AND BS.ixLocation = 99
             AND BS.sPickingBin NOT LIKE 'B%'
             AND BS.sPickingBin <> 'A KIT'             
           GROUP BY OL.ixOrder
          ) BP on BP.ixOrder = O.ixOrder
          -- determine whether an order has customer/rebuild shock components         
LEFT JOIN (SELECT OL.ixOrder
                , COUNT(DISTINCT OL.ixSKU) AS ShockSkuCnt
           FROM tblOrderLine OL
           LEFT JOIN tblBinSku BS on BS.ixSKU = OL.ixSKU
                             AND BS.ixLocation = 99
           WHERE BS.sPickingBin LIKE 'SHOCK%'             
           GROUP BY OL.ixOrder
          ) Shock on Shock.ixOrder = O.ixOrder           
WHERE O.sOrderStatus = 'Pick Ticket' 
  AND O.dtOrderDate >= '05/30/13' --@OrderDate -- This would be a hidden parameter 	
  AND O.iShipMethod = '1' -- Counter orders only  		
  -- order either hasn't been scanned at all or has been scanned but not by carousel (i.e. scanned by counter) 
  AND (OS.ixOrder IS NULL       
		OR (OS.ixOrder IS NOT NULL AND   
						 -- sub select = orders scanned by carousel          
			OS.ixOrder NOT IN (SELECT DISTINCT ixOrder 
			     		       FROM tblCounterOrderScans OS
							   LEFT JOIN tblIPAddress IP ON IP.ixIP = OS.ixIP
							   WHERE IP.sGroup = 'Counter') 
			)
	    ) 			
--  AND dbo.OrdersBigPackOnly(O.ixOrder) = 'N'		
--  AND ISNULL(BP.NonBPcount,0) > 0 															   
GROUP BY O.ixOrder
       , Lines.SkuCnt    
       , ISNULL(BP.NonBPcount,0)  
       , (CASE WHEN Shock.ShockSkuCnt > 0 THEN 'Y' 
               ELSE 'N'
           END)                     
	   , O.dtOrderDate
       , SUBSTRING(T1.chTime,1,5)
       , O.dtOrderDate + SUBSTRING(T1.chTime,1,5)     
       , (DATEDIFF(mi,GETDATE(),(O.dtOrderDate + SUBSTRING(T1.chTime,1,5)))*-1)          
       , (CASE WHEN ISNULL(BP.NonBPcount,0) = 0 THEN (DATEDIFF(mi,GETDATE(),(O.dtOrderDate + SUBSTRING(T1.chTime,1,5)))*-1) 
               ELSE (DATEDIFF(mi,GETDATE(),(ISNULL((OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)),(D3.dtDate + SUBSTRING(T4.chTime,1,5)))))*-1)
          END)  
       , O.ixAuthorizationStatus  
       , D2.dtDate          
       , SUBSTRING(T2.chTime,1,5) 
       , D2.dtDate + SUBSTRING(T2.chTime,1,5)           
       , (dbo.GetLatestOrderTimePrinted (O.ixOrder))  
       , OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)
       , D3.dtDate + SUBSTRING(T4.chTime,1,5)       
ORDER BY WaitTime DESC
       , TimeSinceCreated DESC 

               