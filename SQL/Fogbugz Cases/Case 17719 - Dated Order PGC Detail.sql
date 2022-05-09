SELECT ISNULL(O.ixAccountManager,'Unassigned') AS ActMgr
     , O.ixOrder AS OrderNum
     , O.mMerchandise AS Merch
     , O.ixCustomer AS CustNum
     , (ISNULL(C.sCustomerFirstName, '') + ' ' + ISNULL(C.sCustomerLastName, '')) AS CustName
     , O.dtOrderDate + SUBSTRING(T.chTime,1,5) AS DateTimeEntered
     , O.dtOrderDate AS DateEntered
     , SUBSTRING(T.chTime,1,5) AS TimeEntered
     , O.sOrderStatus AS OrderStatus
     , O.sOrderTaker AS OrderTaker
     , SM.sDescription AS ShipMethod
     , O.dtHoldUntilDate AS HoldUntil
     , PGC.Major AS PGC 
     , PGC.Merch AS PGCMerch 
FROM tblOrder O
LEFT JOIN tblTime T on T.ixTime = O.ixOrderTime  
LEFT JOIN tblCustomer C on C.ixCustomer = O.ixCustomer
LEFT JOIN tblShipMethod SM on SM.ixShipMethod = O.iShipMethod 
LEFT JOIN (SELECT O.ixOrder AS ixOrder 
                , SUBSTRING(S.ixPGC, 1, 1) AS Major 
				, SUM(mExtendedPrice) AS Merch 
		   FROM tblOrderLine OL   
		   LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU     
		   WHERE O.sOrderStatus = 'Open' 
			 AND O.dtHoldUntilDate > GETDATE () 
		   GROUP BY O.ixOrder 
		          , S.ixPGC 
		   ) PGC ON PGC.ixOrder = O.ixOrder 
WHERE O.sOrderStatus = 'Open'
  AND O.dtHoldUntilDate > GETDATE() 
ORDER BY sOrderStatus
       , dtOrderDate
       , O.ixOrder
       
