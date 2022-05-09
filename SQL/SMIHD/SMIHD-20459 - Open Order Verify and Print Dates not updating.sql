-- SMIHD-20459 - Open Order Verify and Print Dates not updating

-- OPEN COUNTER for SMI
SELECT O.ixOrder AS OrderNum
--    , (C.sCustomerFirstName + ' ' + C.sCustomerLastName) 'Customer'
     /*, O.sShipToStreetAddress1 -- being populated with Pick Up Date and Time for counter orders
     , O.sShippingInstructions
     , Lines.SkuCnt AS OrderLines
   --  , ISNULL(BP.NonBPcount,0) AS NonBPCnt
       -- orders where this returns 'Y' will want to be excluded from the historical report 
     --, (CASE WHEN Shock.ShockSkuCnt > 0 THEN 'Y' 
     --        ELSE 'N'
     --    END) AS ShockParts
     , O.dtOrderDate AS DateEntered  -- KEEP for cond. formatting
     , SUBSTRING(T1.chTime,1,5) AS TimeEntered -- KEEP for cond. formatting
     , O.dtOrderDate + SUBSTRING(T1.chTime,1,5) AS DateTimeEntered
     , O.dtHoldUntilDate
       -- Time since created = [Current time - authorization time or IF NULL then printed time]    
     , (CASE WHEN T2.chTime IS NULL THEN ((DATEDIFF(mi,GETDATE(),(dbo.GetLatestOrderTimePrinted (O.ixOrder)))*-1))
             ELSE ((DATEDIFF(mi,GETDATE(),(D2.dtDate + SUBSTRING(T2.chTime,1,5)))*-1)) 
         END) AS TimeSinceCreated 
       -- Wait time = [Current time - most recent scan/verify time from carousel OR big pack]            
     --, (DATEDIFF(mi,GETDATE(),(ISNULL((OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)),(D3.dtDate + SUBSTRING(T4.chTime,1,5)))))*-1) AS WaitTime 													                    
     , O.ixAuthorizationStatus AS AuthStatus
     , O.sMethodOfPayment
     , O.mAmountPaid
     , D2.dtDate AS DateAuthorized -- KEEP for cond. formatting
     , SUBSTRING(T2.chTime,1,5) AS TimeAuthorized -- KEEP for cond. formatting           
     , D2.dtDate + SUBSTRING(T2.chTime,1,5) AS DateTimeAuthorized  
     , (dbo.GetLatestOrderTimePrinted (O.ixOrder)) AS dtTimePrinted
       -- Max values for time scanned and verified have already been taken into account in subselect below      
   --  , OS2.dtScanDate + SUBSTRING(T3.chTime,1,5) AS DateTimeScanned
   */
     --, D3.dtDate + SUBSTRING(T4.chTime,1,5) AS DateTimeVerified       
FROM tblOrder O
LEFT JOIN tblCustomer C on O.ixCustomer = C.ixCustomer
LEFT JOIN tblOrderRouting ORT ON ORT.ixOrder = O.ixOrder
--To get the number of order lines with tangible SKUs 
LEFT JOIN (SELECT DISTINCT ixOrder 
                , COUNT(DISTINCT OL.ixSKU) AS SkuCnt 
           FROM tblOrderLine OL 
           LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
           WHERE --OL.dtOrderDate >=  DATEADD(dd, -2, GETDATE())
             --AND 
S.flgIntangible = '0'
           GROUP BY ixOrder) Lines ON Lines.ixOrder = O.ixOrder 
LEFT JOIN tblTime T1 ON T1.ixTime = O.ixOrderTime
LEFT JOIN tblDate D2 ON D2.ixDate = O.ixAuthorizationDate
LEFT JOIN tblTime T2 ON T2.ixTime = O.ixAuthorizationTime
LEFT JOIN tblDate D3 ON D3.ixDate = ORT.ixVerifyDate
LEFT JOIN tblTime T4 ON T4.ixTime = ORT.ixVerifyTime 
where O.sOrderStatus = 'Open'
and iShipMethod = 1
--and O.ixPrimaryShipLocation = 85

UNION ALL

-- UNVERIFIED COUNTER ORDERS for SMI
SELECT O.ixOrder AS OrderNum
 /*    , Lines.SkuCnt AS OrderLines
     , ISNULL(BP.NonBPcount,0) AS NonBPCnt
     , (CASE WHEN Shock.ShockSkuCnt > 0 THEN 'Y' 
             ELSE 'N'
         END) AS ShockParts     
     , O.dtOrderDate AS DateEntered  -- KEEP for cond. formatting
     , SUBSTRING(T1.chTime,1,5) AS TimeEntered -- KEEP for cond. formatting
     , O.dtOrderDate + SUBSTRING(T1.chTime,1,5) AS DateTimeEntered
     -- Wait time = [Current time - authorization time or IF NULL then printed time]    
     , (CASE WHEN T2.chTime IS NULL THEN ((DATEDIFF(mi,GETDATE(),(dbo.GetLatestOrderTimePrinted (O.ixOrder)))*-1))
             ELSE ((DATEDIFF(mi,GETDATE(),(D2.dtDate + SUBSTRING(T2.chTime,1,5)))*-1)) 
         END) AS WaitTime 
     , O.ixAuthorizationStatus AS AuthStatus
     , D2.dtDate AS DateAuthorized -- KEEP for cond. formatting
     , SUBSTRING(T2.chTime,1,5) AS TimeAuthorized -- KEEP for cond. formatting           
     , D2.dtDate + SUBSTRING(T2.chTime,1,5) AS DateTimeAuthorized  
     , (dbo.GetLatestOrderTimePrinted (O.ixOrder)) AS dtTimePrinted
    -- ,O.ixPrimaryShipLocation
*/
FROM tblOrder O
--LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
LEFT JOIN tblOrderRouting ORT ON ORT.ixOrder = O.ixOrder
--To get the number of order lines with tangible SKUs 
LEFT JOIN (SELECT DISTINCT ixOrder 
                , COUNT(DISTINCT OL.ixSKU) AS SkuCnt 
           FROM tblOrderLine OL 
           LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
           WHERE OL.dtOrderDate >= DATEADD(dd, -2, GETDATE()) -- '05/27/13'
             AND S.flgIntangible = '0'
             AND OL.flgLineStatus NOT IN ('Cancelled', 'fail', 'Lost')
           GROUP BY ixOrder) Lines ON Lines.ixOrder = O.ixOrder 
LEFT JOIN tblTime T1 ON T1.ixTime = O.ixOrderTime
LEFT JOIN tblDate D2 ON D2.ixDate = O.ixAuthorizationDate
LEFT JOIN tblTime T2 ON T2.ixTime = O.ixAuthorizationTime
LEFT JOIN tblCounterOrderScans OS ON OS.ixOrder = O.ixOrder 
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
             AND OL.flgLineStatus NOT IN ('Cancelled', 'fail', 'Lost')         
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
              AND OL.flgLineStatus NOT IN ('Cancelled', 'fail', 'Lost')          
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
		   WHERE OL.flgLineStatus NOT IN ('Cancelled', 'fail', 'Lost')			 
		   GROUP BY OL.ixOrder  
				  , BO.BOCnt 
				  , OL.dtOrderDate 	
		   HAVING COUNT(DISTINCT OL.iOrdinality) = BO.BOCnt
		 ) BO ON BO.ixOrder = O.ixOrder                      
WHERE O.sOrderStatus = 'Open' 
  AND O.dtOrderDate >= DATEADD(dd, -2, GETDATE()) -- '05/27/13' --@OrderDate -- This would be a hidden parameter 	
  AND O.iShipMethod = '1' -- Counter orders only  		
  -- order either hasn't been scanned at all or has been scanned but not by carousel (i.e. scanned by counter) 
  AND ORT.ixVerifyDate IS NULL
  /********************************************************************************************
   THIS ENTIRE SECTION COMMENTED OUT 1-30-18 (see SMIHD-9279)
	 per Jason Korth orders should always appear as long as they have NOT BEEN VERIFIED. (that check is handled by line immediately above this comment section)
   ********************************************************************************************
  AND (OS.ixOrder IS NULL       
		OR (OS.ixOrder IS NOT NULL  AND   
						 -- sub select = orders scanned by carousel          
			OS.ixOrder NOT IN (SELECT DISTINCT ixOrder 
			     		       FROM tblCounterOrderScans OS
							   LEFT JOIN tblIPAddress IP ON IP.ixIP = OS.ixIP
							   WHERE IP.sGroup IN ('Carousel', 'Big Pack')
							   ) 
 			)
	    ) 
   */
  AND O.sOrderChannel <> 'COUNTER'
  AND BO.ixOrder IS NULL
 -- AND dbo.OrdersBigPackOnly(O.ixOrder) = 'N'
 -- AND ISNULL(BP.NonBPcount,0) > 0 
 AND (ISNULL(BP.NonBPcount,0) > 0 
       OR (ISNULL(BP.NonBPcount,0) = 0 
           AND (Lines.SkuCnt is NULL OR Lines.SkuCnt = 0)
           )
       )   
    AND O.ixPrimaryShipLocation = 99 -- SMI ONLY      
--AND O.ixOrder = '7606968'	   
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
       , O.ixAuthorizationStatus  
       , D2.dtDate          
       , SUBSTRING(T2.chTime,1,5) 
       , D2.dtDate + SUBSTRING(T2.chTime,1,5)           
       , (dbo.GetLatestOrderTimePrinted (O.ixOrder)) 
       --,O.ixPrimaryShipLocation       
--ORDER BY DateTimeEntered DESC
      -- , TimeEntered DESC	
ORDER BY O.ixOrder -- 64 @3:00
 
 




 elect ORT.* 
from tblOrderRouting  ORT
where ixOrder = '10790204'





SELECT ORT.ixOrder,
    --O.sOderStatus, O.iShipMethod, 
    O.dtOrderDate 'OrderDate', T4.chTime 'OrderTime',
   --.dtHoldUntilDate,
    D.dtDate 'VerifyDate', T.chTime 'VerifyTime', 
    D2.dtDate 'PrintDate', T3.chTime 'PrintTime',
    O.flgPrinted 'tblOrderflgPrinted',
    ORT.dtDateLastSOPUpdate 'LastSOPUpdateDate', T2.chTime 'LastSOPUpdateTime'
FROM tblOrderRouting ORT
    left join tblDate D on D.ixDate = ORT.ixVerifyDate
    left join tblDate D2 on D2.ixDate = ORT.ixPrintDate
    left join tblTime T on T.ixTime = ORT.ixVerifyTime
    left join tblTime T2 on T2.ixTime = ORT.ixTimeLastSOPUpdate
    left join tblTime T3 on T3.ixTime = ORT.ixPrintTime
    left join tblOrder O on ORT.ixOrder = O.ixOrder
    left join tblTime T4 on T4.ixTime = O.ixOrderTime
WHERE O.sOrderStatus = 'Open'
    and O.iShipMethod = 1
    and O.flgPrinted = 1 -- 51 printed in tblOrder but not date/time in ORT
ORDER BY D.dtDate



-- tblOrder.flgPrinted = 1 but ORT.ixPrintDate is NULL
select ORT.ixOrder, ORT.ixPrintDate, O.flgPrinted
from tblOrderRouting ORT
    left join tblOrder O on ORT.ixOrder = O.ixOrder
where ixPrintDate is NULL
    and O.sOrderStatus = 'Open'
    and O.flgPrinted = 1 
    and O.iShipMethod = 1
order by ixPrintDate desc


