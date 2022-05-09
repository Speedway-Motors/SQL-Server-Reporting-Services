/* 
this query will return every customer and their sales for each PGC.
The results are sorted by PGC, then by Customers with the highest sales first.
It may be quicker to just copay and paste the results into Excel and then
copy and paste the top 3 customers from each PGC.  (espicially if you want
to disregard specific customer accounts such as SPEEDWAY)
*/   
select -- 8564 ROWS
    C.ixCustomer, 
    C.sCustomerFirstName, 
    C.sCustomerLastName,
    SKU.ixPGC,
    sum(OL.mExtendedPrice) Sales   
FROM tblOrderLine OL
    join tblOrder O on OL.ixOrder = O.ixOrder
    join tblSKU SKU on SKU.ixSKU = OL.ixSKU
    join tblCustomer C on C.ixCustomer = O.ixCustomer
WHERE O.dtShippedDate >= '01/01/2011'            
   and O.sOrderStatus = 'Shipped'
   and O.sOrderType <> 'Internal'
   and O.sOrderChannel <> 'INTERNAL'
GROUP BY C.ixCustomer, 
    C.sCustomerFirstName, 
    C.sCustomerLastName,
    SKU.ixPGC
HAVING sum(OL.mExtendedPrice) > 0    
ORDER BY ixPGC, Sales desc    



-- Julie, run this query if you want to return a specific PGC
select top 3
    C.ixCustomer, 
    C.sCustomerFirstName, 
    C.sCustomerLastName,
    SKU.ixPGC,
    sum(OL.mExtendedPrice) Sales   
FROM tblOrderLine OL
    join tblOrder O on OL.ixOrder = O.ixOrder
    join tblSKU SKU on SKU.ixSKU = OL.ixSKU
    join tblCustomer C on C.ixCustomer = O.ixCustomer
WHERE O.dtShippedDate >= '01/01/2011'            
   and O.sOrderStatus = 'Shipped'
   and O.sOrderType <> 'Internal'
   and O.sOrderChannel <> 'INTERNAL'
   AND SKU.ixPGC = 'ZS' -- here is where you enter whichever PGC you want to see results for
GROUP BY C.ixCustomer, 
    C.sCustomerFirstName, 
    C.sCustomerLastName,
    SKU.ixPGC
HAVING sum(OL.mExtendedPrice) > 0        
ORDER BY ixPGC, Sales desc    



