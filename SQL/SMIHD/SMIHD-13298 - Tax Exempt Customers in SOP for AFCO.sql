-- SMIHD-13298 - Tax Exempt Customers in SOP for AFCO

SELECT -- count(*)          -- 3-6-19  AFCO 1,416   SMI 2,815
    C.ixCustomer, 
    C.sEmailAddress,
    C.sCustomerFirstName,    -- 20
    C.sCustomerLastName,    -- 20
    -- Company Name
    C.sMailToCOLine,    -- 64
    C.sMailToStreetAddress1,
    C.sMailToStreetAddress2,
    --C.sMailToCity,
    C.sMailToState,
    C.sMailToZip,
    C.sMailToZipFour,
    C.sMailToCountry,
   -- C.flgTaxable, 
    -- C.dtDateLastSOPUpdate -- 3,278
    LO.LastOrder,
    OC.OrderCount12Mo,
    C.sCustomerType 'CustType',
    C.ixCustomerType 'AltCustType',
    CT.sDescription 'AltCustTypeDescription'
FROM tblCustomer C
    LEFT JOIN tblCustomerType CT on CT.ixCustomerType = C.ixCustomerType
    LEFT JOIN (-- Last Order
               SELECT ixCustomer, max(dtOrderDate) 'LastOrder'
               FROM tblOrder O
               WHERE O.sOrderStatus = 'Shipped'
                    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                    and O.sOrderType <> 'Internal'   -- USUALLY filtered"
                    AND O.ixOrder NOT LIKE 'Q%'
                    AND O.ixOrder NOT LIKE 'P%'
                    AND O.ixOrder NOT LIKE '%-%'
               GROUP BY ixCustomer) LO on LO.ixCustomer = C.ixCustomer
    LEFT JOIN (-- 12 Mo order count
               SELECT ixCustomer, count(ixOrder) 'OrderCount12Mo'
               FROM tblOrder O
               WHERE O.sOrderStatus = 'Shipped'
                    and O.dtOrderDate between '10/08/2017' and '10/07/2018'
                    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                    and O.sOrderType <> 'Internal'   -- USUALLY filtered"
                    AND O.ixOrder NOT LIKE 'Q%'
                    AND O.ixOrder NOT LIKE 'P%'
                    AND O.ixOrder NOT LIKE '%-%'
               GROUP BY ixCustomer) OC on OC.ixCustomer = C.ixCustomer
WHERE C.flgDeletedFromSOP = 0
    and C.flgTaxable = 0
ORDER BY C.ixCustomerType,  LO.LastOrder

    --    425 3282 = 12.9%     exempt customers          
    --    11,579  2,148,371  = 0.5%   taxable customers
-- aftco 841 out of 1,844

/*
customer number, first name, last name, sMailToCOLine
for customers in the attached two lists.
*/
