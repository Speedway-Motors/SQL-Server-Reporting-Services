SELECT O.sOrderType
     , SUM(OL.iQuantity) AS TotalQty
     , COUNT(DISTINCT O.ixOrder) AS DistinctOrders 
     , COUNT(DISTINCT O.ixCustomer) AS DistinctCustomers
FROM tblOrder O 
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
WHERE ixSKU = '91031303' 
  AND O.sOrderStatus = 'Shipped' 
  AND OL.flgLineStatus NOT IN ('Cancelled', 'Lost', 'Backordered') 
  AND O.sOrderType = 'Retail'
GROUP BY O.sOrderType
  
SELECT O.ixOrder --2187 orders , 2373 quantity . 2041 customers 
     , O.ixCustomer
     , C.sCustomerFirstName
     , C.sCustomerLastName
     , O.sShipToCity
     , O.sShipToState
     , O.sShipToZip     
     , O.sShipToCountry
     , O.flgIsResidentialAddress
     , SUM(OL.iQuantity) AS TotalQty     
FROM tblOrder O 
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
LEFT JOIN  tblCustomer C ON C.ixCustomer = O.ixCustomer
WHERE ixSKU = '91031303' 
  AND O.sOrderStatus = 'Shipped' 
  AND OL.flgLineStatus NOT IN ('Cancelled', 'Lost', 'Backordered', 'fail') 
  AND O.sOrderType IN ('Retail')
GROUP BY O.ixOrder
       , O.ixCustomer
       , C.sCustomerFirstName
       , C.sCustomerLastName       
       , O.sShipToCity
       , O.sShipToState
       , O.sShipToZip     
       , O.sShipToCountry     
       , O.flgIsResidentialAddress             
ORDER BY O.ixCustomer       


SELECT *
FROM tblVendorSKU
WHERE ixSKU = '91031304'

SELECT *
FROM tblBOMTemplateDetail
WHERE ixFinishedSKU = '91031304'
