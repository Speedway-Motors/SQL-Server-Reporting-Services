-- SMIHD-6956 - problem Gift Cards that did not get activated

--  customer #, order #, and email address 
-- for all orders shipping 3/10 & 3/11 that included gift cards

SELECT * FROM tblSKU 
where ixSKU = '9108825'


SELECT C.ixCustomer, C.sCustomerFirstName, C.sCustomerLastName, O.sShipToName, O.sShipToCOLine, O.sShipToStreetAddress1, O.sShipToStreetAddress2, O.sShipToCity, O.sShipToState, O.sShipToZip, O.sShipToCountry, OL.ixOrder, O.mMerchandise, O.dtShippedDate, C.sEmailAddress 'CustEmail', O.sShipToEmailAddress 'ShipToEmail'
from tblOrderLine OL
    join tblOrder O on O.ixOrder = OL.ixOrder
    join tblCustomer C on O.ixCustomer = C.ixCustomer
where OL.ixSKU = '9108825'
    and OL.flgLineStatus = 'Shipped'
    and (OL.dtShippedDate < '03/12/17'
        OR O.dtShippedDate < '03/12/17')
--and C.sEmailAddress <> O.sShipToEmailAddress        
order by OL.dtShippedDate -- dtOrderDate -- dtShippedDate



7416213

select * from tblGiftCardMaster
where ixOrder = '7416213'
