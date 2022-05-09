/*
select * from tblSKU
where upper(sDescription) like '%GIFT%'
ORDER BY mPriceLevel1
*/

/*** BRONX ORDERS 
SELECT distinct OL.ixOrder, O.sShipToCity
from tblOrderLine OL
    join tblOrder O on OL.ixOrder = O.ixOrder
    join tblSKU SKU on SKU.ixSKU = OL.ixSKU
where O.sOrderStatus = 'Shipped'
and O.dtShippedDate >= '01/01/2011'    
and O.sShipToState = 'NY'
and O.sShipToCity = 'BRONX'
and (
     upper(SKU.sDescription) like '%GIFT%CARD%'
     OR SKU.sDescription = 'EGIFT'
     )
*/


select OL.ixOrder      'Order#',
       OL.ixCustomer   'Cust#',
       C.sCustomerFirstName 'FirstName',
       C.sCustomerLastName  'LastName',
       OL.ixSKU        'SKU',
       OL.iQuantity    'Qty',
       OL.mUnitPrice   'UnitPrice', 
       OL.dtShippedDate 'DateShipped'
from tblOrderLine OL
    join tblOrder O on OL.ixOrder = O.ixOrder
    join tblCustomer C on C.ixCustomer = O.ixCustomer
where O.ixOrder in ('4571241','4823348','4438247','4806540','4106241','4287942')
order by O.dtShippedDate

