SELECT C.ixCustomer 
     , sCustomerFirstName
     , sCustomerLastName
     , sEmailAddress
     , sDayPhone 
     , sCustomerType 
     , ixCustomerType
     , iPriceLevel
     , sMailToZip 
     , sMailToState 
     , Orders.Merch
     , Orders.GM
     , Orders.Freight
FROM tblCustomer C 
LEFT JOIN (SELECT O.ixCustomer 
                , SUM(O.mMerchandise) AS Merch
                , SUM(O.mMerchandiseCost) AS Cost
                , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GM
                , SUM(O.mShipping) AS Freight
           FROM tblOrder O 
           WHERE dtShippedDate BETWEEN DATEADD(day,-365,GETDATE()) AND GETDATE() 
             AND sOrderStatus = 'Shipped' 
           GROUP BY O.ixCustomer  
          ) Orders ON Orders.ixCustomer = C.ixCustomer 
WHERE ixCustomerType    IN ('30', '40') --  <> '1' --
  AND flgDeletedFromSOP = 0 
 -- AND sCustomerType <> 'Retail'     
 ORDER BY Merch DESC