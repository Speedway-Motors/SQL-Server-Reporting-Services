

/* Case 11270 */ 

SELECT OL.dtOrderDate as 'Order Date',
       C.sCustomerFirstName as 'First Name',
       C.sCustomerLastName as 'Last Name',
       isnull (C.sEmailAddress, '') as 'Email Address',
       OL.ixOrder as 'Order Number'
       
FROM tblOrderLine OL

JOIN tblCustomer C ON C.ixCustomer = OL.ixCustomer

JOIN tblOrder O ON O.ixOrder = OL.ixOrder

WHERE OL.ixSKU = '5605174'
                 and O.sOrderStatus = 'Shipped'
                 and O.sOrderType <> 'Internal'
                 and O.sOrderChannel <> 'INTERNAL'
                 --and O.mMerchandise > 0


ORDER BY OL.dtOrderDate,
         C.sCustomerFirstName