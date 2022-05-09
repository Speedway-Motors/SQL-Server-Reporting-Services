/*************************************

		Counter Invoiced Orders
		 Scanned CORRECTLY
		    
***********************************/	

SELECT O.ixOrder AS OrderNum
     , O.ixCustomer AS Customer 
     , ISNULL(Lines.SkuCnt,0) AS OrderLines
     , ISNULL(BP.NonBPcount,0) AS NonBPCnt
       -- orders where this returns 'Y' will want to be excluded from the historical report 
     , (CASE WHEN Shock.ShockSkuCnt > 0 THEN 'YES' 
             ELSE 'NO'
         END) AS ShockParts
     , O.dtOrderDate AS DateEntered  -- KEEP for cond. formatting
     , SUBSTRING(T1.chTime,1,5) AS TimeEntered -- KEEP for cond. formatting
     , O.dtOrderDate + SUBSTRING(T1.chTime,1,5) AS DateTimeEntered --(v)												                    
     , D2.dtDate AS DateAuthorized -- KEEP for cond. formatting
     , SUBSTRING(T2.chTime,1,5) AS TimeAuthorized -- KEEP for cond. formatting           
     , D2.dtDate + SUBSTRING(T2.chTime,1,5) AS DateTimeAuthorized --(w) 
     , (dbo.GetLatestOrderTimePrinted (O.ixOrder)) AS dtTimePrinted --(x)      
     , D3.dtDate + SUBSTRING(T4.chTime,1,5) AS DateTimeVerified --date/time max carousel scan OR date/time verified (y)     
     , OS2.dtScanDate + SUBSTRING(T3.chTime,1,5) AS MaxDateTimeScannedCounter --date/time max counter scan (z)           
     , (DATEDIFF(mi,(OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)),((dbo.GetLatestOrderTimePrinted (O.ixOrder))))*-1) AS TotalWaitTime --total wait time (z-x)
     , (DATEDIFF(mi,(OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)),(O.dtOrderDate + SUBSTRING(T1.chTime,1,5)))*-1) AS TotalTimeSinceEntered --total time since entered (z-v)
     , (DATEDIFF(mi,(OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)),(D2.dtDate + SUBSTRING(T2.chTime,1,5)))*-1) AS TotalTimeSinceAuthorized --total time since authorized (z-w) 
     , (DATEDIFF(mi,(D3.dtDate + SUBSTRING(T4.chTime,1,5)),((dbo.GetLatestOrderTimePrinted (O.ixOrder))))*-1) AS TotalCarouselTime --total carousel pull time (y-x) 
     , (DATEDIFF(mi,(OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)),(D3.dtDate + SUBSTRING(T4.chTime,1,5))) *-1) AS TotalCounterTime --total counter pull time (z-y) 
     -- averages of all totals calculations       
FROM tblOrder O
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
LEFT JOIN tblOrderRouting ORT ON ORT.ixOrder = O.ixOrder
--To get the number of order lines with tangible SKUs 
LEFT JOIN (SELECT DISTINCT ixOrder 
                , COUNT(DISTINCT OL.ixSKU) AS SkuCnt 
           FROM tblOrderLine OL 
           LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
           WHERE OL.dtShippedDate BETWEEN '06/17/13' AND '06/18/13' --@StartDate AND @EndDate 
             AND S.flgIntangible = '0'
           GROUP BY ixOrder) Lines ON Lines.ixOrder = O.ixOrder 
LEFT JOIN tblTime T1 ON T1.ixTime = O.ixOrderTime
LEFT JOIN tblDate D2 ON D2.ixDate = O.ixAuthorizationDate
LEFT JOIN tblTime T2 ON T2.ixTime = O.ixAuthorizationTime
  -- this query determines the max counter scan 
LEFT JOIN (SELECT DISTINCT OS.ixOrder 
                , MAX(OS.dtScanDate) AS dtScanDate 
                , MAX(OS.ixScanTime) AS ixScanTime  
           FROM tblCounterOrderScans OS 
           LEFT JOIN tblIPAddress IP ON IP.ixIP = OS.ixIP 
           WHERE IP.sGroup = 'Counter'  
           GROUP BY OS.ixOrder
           ) OS2 ON OS2.ixOrder = O.ixOrder  
LEFT JOIN tblTime T3 ON T3.ixTime = OS2.ixScanTime  
LEFT JOIN tblDate D3 ON D3.ixDate = ORT.ixVerifyDate
LEFT JOIN tblTime T4 ON T4.ixTime = ORT.ixVerifyTime 
          -- count of SKUs that aren't in BigPack          
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
              OR BS.sPickingBin LIKE 'SHOP%'          
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
WHERE O.dtShippedDate BETWEEN '06/17/13' AND '06/18/13' --@StartDate AND @EndDate 	
  AND BO.ixOrder IS NULL  
  AND O.iShipMethod = '1' -- Counter orders only  	
  AND O.sOrderStatus = 'Shipped' 	
  AND O.sOrderChannel <> 'COUNTER' /* this results from orders being created that started as pick tickets therefore 
                                       the parts are already at the counter and bypass the carousel phase */
  AND (D3.dtDate + SUBSTRING(T4.chTime,1,5) IS NOT NULL
        AND OS2.dtScanDate + SUBSTRING(T3.chTime,1,5) IS NOT NULL)                                            
GROUP BY O.ixOrder 
     , O.ixCustomer  
     , ISNULL(Lines.SkuCnt,0) 
     , ISNULL(BP.NonBPcount,0) 
     , (CASE WHEN Shock.ShockSkuCnt > 0 THEN 'YES' 
             ELSE 'NO'
         END) 
     , O.dtOrderDate   
     , SUBSTRING(T1.chTime,1,5) 
     , O.dtOrderDate + SUBSTRING(T1.chTime,1,5) 												                    
     , D2.dtDate 
     , SUBSTRING(T2.chTime,1,5)            
     , D2.dtDate + SUBSTRING(T2.chTime,1,5) 
     , (dbo.GetLatestOrderTimePrinted (O.ixOrder))       
     , D3.dtDate + SUBSTRING(T4.chTime,1,5)     
     , OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)       
     , (DATEDIFF(mi,(OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)),((dbo.GetLatestOrderTimePrinted (O.ixOrder))))*-1) 
     , (DATEDIFF(mi,(OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)),(O.dtOrderDate + SUBSTRING(T1.chTime,1,5)))*-1) 
     , (DATEDIFF(mi,(OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)),(D2.dtDate + SUBSTRING(T2.chTime,1,5)))*-1) 
     , (DATEDIFF(mi,(D3.dtDate + SUBSTRING(T4.chTime,1,5)),((dbo.GetLatestOrderTimePrinted (O.ixOrder))))*-1) 
     , (DATEDIFF(mi,(OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)),(D3.dtDate + SUBSTRING(T4.chTime,1,5))) *-1)
HAVING ISNULL(Lines.SkuCnt,0) > 0
ORDER BY OrderLines DESC     


/*************************************

		Pick Tickets Scanned
		    CORRECTLY
		    
***********************************/		    

--Pick Tickets
SELECT O.ixOrder AS PickNumber
     , O.ixCustomer AS Customer 
     , ISNULL(Lines.SkuCnt,0) AS OrderLines
     , ISNULL(BP.NonBPcount,0) AS NonBPCnt
     , O.dtOrderDate AS DateEntered  -- KEEP for cond. formatting
     , SUBSTRING(T1.chTime,1,5) AS TimeEntered -- KEEP for cond. formatting
     , O.dtOrderDate + SUBSTRING(T1.chTime,1,5) AS DateTimeEntered --(v)(x)												                        
     , OS.dtScanDate + SUBSTRING(T2.chTime,1,5)  AS MaxDateTimeScannedCarousel --date/time max carousel scan OR date/time verified (y)     
     , OS2.dtScanDate + SUBSTRING(T3.chTime,1,5) AS MaxDateTimeScannedCounter --date/time max counter scan (z)           
     , (DATEDIFF(mi,(OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)),(O.dtOrderDate + SUBSTRING(T1.chTime,1,5)))*-1) AS TotalWaitTime --total wait time (z-x)
     --, (DATEDIFF(mi,(OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)),(O.dtOrderDate + SUBSTRING(T1.chTime,1,5)))*-1) AS TotalTimeSinceEntered --total time since entered (z-v)
     , (DATEDIFF(mi,(OS.dtScanDate + SUBSTRING(T2.chTime,1,5)),(O.dtOrderDate + SUBSTRING(T1.chTime,1,5)))*-1) AS TotalCarouselTime --total carousel pull time (y-x) 
     , (CASE WHEN ISNULL(BP.NonBPcount,0) = 0 THEN (DATEDIFF(mi,(OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)),(O.dtOrderDate + SUBSTRING(T1.chTime,1,5)))*-1) 
             ELSE (DATEDIFF(mi,(OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)),(OS.dtScanDate + SUBSTRING(T2.chTime,1,5))) *-1) 
        END) AS TotalCounterTime --total counter pull time (z-y) 
     -- averages of all totals calculations 
FROM tblOrder O
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
--To get the number of order lines with tangible SKUs 
LEFT JOIN (SELECT DISTINCT ixOrder 
                , COUNT(DISTINCT OL.ixSKU) AS SkuCnt 
           FROM tblOrderLine OL 
           LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
           WHERE OL.dtOrderDate BETWEEN '06/17/13' AND '06/18/13' --@StartDate AND @EndDate 
             AND S.flgIntangible = '0'
           GROUP BY ixOrder) Lines ON Lines.ixOrder = O.ixOrder 
LEFT JOIN tblTime T1 ON T1.ixTime = O.ixOrderTime
  -- this query determines the max carousel/big pack scan 
LEFT JOIN (SELECT DISTINCT OS.ixOrder 
                , MAX(OS.dtScanDate) AS dtScanDate 
                , MAX(OS.ixScanTime) AS ixScanTime  
           FROM tblCounterOrderScans OS 
           LEFT JOIN tblIPAddress IP ON IP.ixIP = OS.ixIP 
           WHERE IP.sGroup <> 'Counter'  
           GROUP BY OS.ixOrder
           ) OS ON OS.ixOrder = O.ixOrder  
LEFT JOIN tblTime T2 ON T2.ixTime = OS.ixScanTime  
  -- this query determines the max counter scan 
LEFT JOIN (SELECT DISTINCT OS.ixOrder 
                , MAX(OS.dtScanDate) AS dtScanDate 
                , MAX(OS.ixScanTime) AS ixScanTime  
           FROM tblCounterOrderScans OS 
           LEFT JOIN tblIPAddress IP ON IP.ixIP = OS.ixIP 
           WHERE IP.sGroup = 'Counter'  
           GROUP BY OS.ixOrder
           ) OS2 ON OS2.ixOrder = O.ixOrder  
LEFT JOIN tblTime T3 ON T3.ixTime = OS2.ixScanTime  
          -- count of SKUs that aren't in BigPack          
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
          -- determine orders that all items are backordered but have not yet switched from the 'open' status state                               
WHERE O.dtOrderDate BETWEEN '06/17/13' AND '06/18/13' --@StartDate AND @EndDate 	 
  AND O.iShipMethod = '1' -- Counter orders only  	
  AND O.sOrderStatus = 'Pick Ticket'  	
  AND (
       (OS.dtScanDate + SUBSTRING(T2.chTime,1,5) IS NOT NULL
            OR ISNULL(BP.NonBPcount,0) = 0
        )
        AND OS2.dtScanDate + SUBSTRING(T3.chTime,1,5) IS NOT NULL)                                            
GROUP BY O.ixOrder 
     , O.ixCustomer  
     , ISNULL(Lines.SkuCnt,0) 
     , ISNULL(BP.NonBPcount,0) 
     , O.dtOrderDate   
     , SUBSTRING(T1.chTime,1,5) 
     , O.dtOrderDate + SUBSTRING(T1.chTime,1,5) 												                         
     , OS.dtScanDate + SUBSTRING(T2.chTime,1,5)     
     , OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)       
     , (DATEDIFF(mi,(OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)),(O.dtOrderDate + SUBSTRING(T1.chTime,1,5)))*-1)  
     --, (DATEDIFF(mi,(OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)),(O.dtOrderDate + SUBSTRING(T1.chTime,1,5)))*-1)
     , (DATEDIFF(mi,(OS.dtScanDate + SUBSTRING(T2.chTime,1,5)),(O.dtOrderDate + SUBSTRING(T1.chTime,1,5)))*-1) 
     , (CASE WHEN ISNULL(BP.NonBPcount,0) = 0 THEN (DATEDIFF(mi,(OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)),(O.dtOrderDate + SUBSTRING(T1.chTime,1,5)))*-1) 
             ELSE (DATEDIFF(mi,(OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)),(OS.dtScanDate + SUBSTRING(T2.chTime,1,5))) *-1) 
        END) 
ORDER BY OrderLines DESC    



