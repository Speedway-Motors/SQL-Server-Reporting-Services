

SELECT OL.dtOrderDate as 'Date',
       OL.ixOrder as 'Order #',
       OL.ixSKU as 'SKU',
       C.sCustomerFirstName as 'First Name',
       C.sCustomerLastName as 'Last Name',
       isnull (C.sEmailAddress, '') as 'Email Address'
      
       
FROM tblOrderLine OL

JOIN tblCustomer C ON C.ixCustomer = OL.ixCustomer

JOIN tblOrder O ON O.ixOrder = OL.ixOrder

WHERE OL.ixSKU IN ( @SKU )
                 and O.sOrderStatus = 'Shipped'
                 and O.sOrderType <> 'Internal'
                 and O.sOrderChannel <> 'INTERNAL'
                 --and O.mMerchandise > 0
                 and O.dtShippedDate >= @StartDate
                 and O.dtShippedDate < (@EndDate +1)

ORDER BY OL.ixSKU,
         OL.dtOrderDate,
         C.sCustomerFirstName
        

