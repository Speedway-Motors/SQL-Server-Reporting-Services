-- SMIHD-4880 - Customer Mailing information for customers who have ordered specific SKUs since 1-1-2014

SELECT C.ixCustomer, C.dtAccountCreateDate, C.ixCustomerType, C.sCustomerFirstName, C.sCustomerLastName, 
 C.sMailToStreetAddress1, C.sMailToStreetAddress2, C.sMailToCOLine, C.sMailToCity, C.sMailToState, C.sMailToZip, C.sMailToCountry
from tblCustomer C
where C.flgDeletedFromSOP = 0
and C.ixCustomer in (
                     select distinct O.ixCustomer 
                     from tblOrderLine OL
                        join tblOrder O on OL.ixOrder = O.ixOrder
                     where ixSKU in ('12119258602','12119318604','1218602','1218604','35519258602','35519318604','91019258602','91019318604','91619258602','91619318604') -- 286
                     and flgLineStatus in ('Shipped','Dropshipped') 
                     and O.ixOrderDate >= 16803
                     and O.ixOrder NOT LIKE 'Q%'
                     and O.ixOrder NOT LIKE 'P%'
                     and O.sOrderStatus = 'Shipped'
                     and mExtendedPrice > 0
                     )



SELECT DISTINCT flgLineStatus from tblOrderLine

