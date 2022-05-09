-- SMIHD-18829 - Order ready for pickup email being sent too soon

--Counter invoiced orders 
SELECT O.ixOrder AS OrderNum
     , O.dtOrderDate + SUBSTRING(T1.chTime,1,5) AS DateTimeEntered
     , FS.FirstScan
   --  , (DATEDIFF(mi,GETDATE(),(ISNULL((OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)),(D3.dtDate + SUBSTRING(T4.chTime,1,5)))))*-1) AS WaitTime 													                    
     , O.sSourceCodeGiven
       -- Max values for time scanned and verified have already been taken into account in subselect below      
     , OS2.dtScanDate + SUBSTRING(T3.chTime,1,5) AS DateTimeScanned
     , D3.dtDate + SUBSTRING(T4.chTime,1,5) AS DateTimeVerified       
     , SCE.ShipConfirmationEmailSentCST
FROM tblOrder O
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
LEFT JOIN tblOrderRouting ORT ON ORT.ixOrder = O.ixOrder
LEFT JOIN tblCustomer C on O.ixCustomer = C.ixCustomer
--To get the number of order lines with tangible SKUs 
LEFT JOIN (SELECT DISTINCT ixOrder 
                , COUNT(DISTINCT OL.ixSKU) AS SkuCnt 
           FROM tblOrderLine OL 
           LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
           WHERE S.flgIntangible = '0'
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
           WHERE IP.sGroup = 'Counter'  
           GROUP BY OS.ixOrder
           ) OS2 ON OS2.ixOrder = O.ixOrder  
LEFT JOIN tblTime T3 ON T3.ixTime = OS2.ixScanTime  
LEFT JOIN tblDate D3 ON D3.ixDate = ORT.ixVerifyDate
LEFT JOIN tblTime T4 ON T4.ixTime = ORT.ixVerifyTime 
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
     LEFT JOIN (-- Ship Confirmation emails
                select O.ixOrder, 
                FORMAT((ES.dtEmailSentUTC AT TIME ZONE 'UTC'  AT TIME ZONE 'Central Standard Time'),'M/d/yyyy HH:mm') 'ShipConfirmationEmailSentCST'
                from tblOrder O 
                    left join tblHackOrderID h on h.ixOrder = O.ixOrder -- special table to preven COLLATION from breaking all the indexes
                    left join tng.tblOrder tngO on h.ixOrder_CI = tngO.ixSopOrderNumber
                    left join tng.tblemail_sent ES ON tngO.ixOrder = ES.ixOrder
                                                   and ES. ixEmailType = 1	-- ixEmailType 1 is "Shipping confirmation for orders that have been shipped.ShipConfirm"
               ) SCE on SCE.ixOrder = O.ixOrder 
    LEFT JOIN (-- FIRST SCAN
                select CS.ixOrder, MIN(FORMAT ((CS.dtScanDate + T.chTime),'yyyy-MM-dd hh:mm'))'FirstScan'
                from tblCounterOrderScans CS
                    left join tblTime T on T.ixTime = CS.ixScanTime
                group by CS.ixOrder
                ) FS on FS.ixOrder = O.ixOrder
                                             
WHERE O.dtOrderDate > '10/02/2020'
    AND O.sOrderStatus = 'Shipped' 
    AND O.iShipMethod = '1' -- Counter orders only  		
    AND BO.ixOrder IS NULL
    AND O.sOrderChannel <> 'COUNTER' /* this results from orders being created that started as pick tickets therefore 
                                       the parts are already at the counter and bypass the carousel phase */
    AND O.ixPrimaryShipLocation = '99'      
    AND O.ixOrder NOT LIKE 'PC%' -- exclude Pick Tickets per SMIHD-11759                                 
    AND (O.dtHoldUntilDate is NULL    
          OR                           -- hide held orders until hold until date is today (or in the past)
         O.dtHoldUntilDate <= getdate())
    AND O.sSourceCodeGiven NOT IN ('EMI','EMP-EMI','EMI300','PRS-EMI','EMI340') -- exclude per Jeff
GROUP BY O.ixOrder
       , O.dtOrderDate + SUBSTRING(T1.chTime,1,5)  
 --      , (DATEDIFF(mi,GETDATE(),(ISNULL((OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)),(D3.dtDate + SUBSTRING(T4.chTime,1,5)))))*-1)                           
     , O.sSourceCodeGiven
       , OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)  
            , FS.FirstScan
       , D3.dtDate + SUBSTRING(T4.chTime,1,5)
       , SCE.ShipConfirmationEmailSentCST   
--HAVING   SCE.ShipConfirmationEmailSentCST  < OS2.dtScanDate + SUBSTRING(T3.chTime,1,5)
ORDER BY WaitTime DESC
    --   , TimeSinceCreated DESC







(
select CS.ixOrder, FORMAT ((CS.dtScanDate + T.chTime),'yyyy-MM-dd hh:mm') 'ScanTime', CS.ixEmployee
from tblCounterOrderScans CS
    left join tblTime T on T.ixTime = CS.ixScanTime
where CS.ixOrder = '9956066'
 --= '9600967'
 order by ixOrder, T.chTime

(-- FIRST SCAN
select CS.ixOrder, MIN(FORMAT ((CS.dtScanDate + T.chTime),'yyyy-MM-dd hh:mm'))'FirstScan'
from tblCounterOrderScans CS
    left join tblTime T on T.ixTime = CS.ixScanTime
where ixOrder in ('9702469','9701469','9786364','9614963','9682863','9683861','9681868','9604864','9617465','9683363','9615469','9616369','9610365','9698267','9687262','9676268','9670266','9637264','9630268','9614260','9612265','9684064','9647066','9630062')
 --= '9600967'
group by CS.ixOrder
) FS on FS.ixOrder = .ixOrder

select * from tblSKU where sDescription like 'PO#%'
