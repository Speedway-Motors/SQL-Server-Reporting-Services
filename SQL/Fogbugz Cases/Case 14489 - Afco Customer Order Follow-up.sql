 
SELECT DISTINCT O.ixCustomer AS CustomerNumber
     , ISNULL(C.sCustomerFirstName, ' ') + ' ' + ISNULL(C.sCustomerLastName, ' ') AS Name
	 , O.sPhone AS ContactPhoneonOrder
	 --, C.sDayPhone AS DayPhone
	 --, C.sNightPhone AS NightPhone
	 --, C.sCellPhone AS CellPhone
	 , O.ixOrder AS OrderNumber
	 , OL.ixSKU AS SKU
	 , S.sDescription AS Description
	 , OL.iQuantity AS Quantity
	 , O.sShipToCity + ' , ' + O.sShipToState + ' ' + O.sShipToZip AS ShipTo
	 , O.ixAccountManager AS AcctMgr
	 , O.sOrderTaker AS OEO
	 , O.iShipMethod AS ShipMethod 
	 --, (CASE WHEN O.dtShippedDate = (SELECT dbo.CustFirstOrderShippedDate (O.ixCustomer)
	 --                          ) THEN 'NEW'
	 --        ELSE 'OLD'
	 --   END
	 --  ) AS CustomerStatus
	  , O.dtShippedDate
FROM tblOrder O 	 
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
WHERE C.iPriceLevel <> '1' 
 -- AND O.dtShippedDate = DATEADD(dd,-5,DATEDIFF(dd,0,getdate())) --Change to 7 but 7 days ago today was 4th of July
  AND O.dtShippedDate BETWEEN @StartDate AND @EndDate -- '07/01/12' AND GETDATE() 
  AND sOrderStatus = 'Shipped' 
  AND flgIsBackorder = '0' 
 -- AND O.ixCustomer = '31438'
  AND O.dtShippedDate = dbo.CustFirstOrderShippedDate (O.ixCustomer) -- ('31438')
ORDER BY CustomerNumber


