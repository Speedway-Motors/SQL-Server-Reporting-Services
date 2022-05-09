-- Query for 10700 and 10701 
-- QTY sold by SKU 
-- # of orders that the SKU was on 
-- total revenue for 07-01-11 to 06-30-12 


SELECT OL.ixSKU AS SKU
     , S.sDescription AS Description
     , SUM(OL.iQuantity) AS TotalQtySold
     , COUNT (OL.ixOrder) AS TotalOrders
     , SUM(OL.mExtendedPrice) AS TotalRevenue
FROM tblOrderLine OL 
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
WHERE OL.ixCustomer = '10701' --If wanting to combine the results then replace with > OL.ixCustomer IN ('10700', '10701')
  AND O.dtShippedDate BETWEEN '07/01/11' AND '06/30/12' 
  AND O.sOrderStatus = 'Shipped' 
  AND OL.flgLineStatus = 'Shipped'
  AND O.sOrderType <> 'Internal' 
  AND O.sOrderChannel <> 'INTERNAL' --?? 
GROUP BY OL.ixSKU 
       , S.sDescription  
--ORDER BY  


SELECT *
FROM tblOrder 
WHERE ixCustomer = '10700'
and sOrderType <> 'Retail' 