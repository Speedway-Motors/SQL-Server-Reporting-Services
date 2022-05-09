SELECT C.ixCustomer AS CustomerNumber
     , ISNULL(C.sCustomerFirstName, '') AS FirstName
     , ISNULL(C.sCustomerLastName, '') AS LastName
     , ISNULL(C.sMailToCity, 'No data') AS MailingCity
     , ISNULL(C.sMailToState, 'No data') AS MailingState
     , (CASE WHEN C.sMailToZip = 'F' THEN 'Foreign' 
             ELSE ISNULL(C.sMailToZip, 'No data')
        END) AS MailingZip
     , C.ixCustomerType AS CustomerFlag
     , C.iPriceLevel AS PriceLevel 
     , ISNULL(C.sDayPhone, ISNULL(C.sNightPhone, ISNULL(sCellPhone, ''))) AS PhoneNumber
     , ISNULL(C.sFax, '') AS FaxNumber
     , ISNULL(Sales.Merch,0) AS Merch
     , ISNULL(Sales.Shipping,0) AS Shipping 
     , ISNULL(Sales.Tax,0) AS Tax 
     , ISNULL(Sales.SubTotal,0) AS SubTotal 
FROM tblCustomer C
LEFT JOIN (SELECT ixCustomer 
                , SUM(mMerchandise) AS Merch
                , SUM(O.mShipping) AS Shipping
                , SUM(O.mTax) AS Tax 
                , SUM(mMerchandise) + SUM(mShipping) + SUM(mTax) AS SubTotal 
           FROM tblOrder O 
           WHERE dtShippedDate BETWEEN @StartDate AND @EndDate -- '06/01/10' AND '05/31/13' 
             AND sOrderStatus = 'Shipped'
             AND sOrderChannel <> 'INTERNAL'
             AND sOrderType <> 'Internal' 
           GROUP BY ixCustomer
          ) Sales ON Sales.ixCustomer = C.ixCustomer
WHERE C.flgTaxable = '0'
  AND C.flgDeletedFromSOP = '0'
  AND Sales.ixCustomer IS NOT NULL  