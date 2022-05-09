-- SMIHD-12070 - Tax Exempt Customers in SOP
/*
select flgTaxable, count(*)
from tblCustomer
where flgDeletedFromSOP = 0
group by flgTaxable

0	3278
1	2142529
*/


/*
First/Last Name
Company Name
Email Address
Physical Address (if no email address)
Last Order date
Total # of orders in 12 months
*/

SELECT C.ixCustomer, 
    C.sEmailAddress,
    C.sCustomerFirstName,
    C.sCustomerLastName,
    -- Company Name
    C.sMailToCOLine,
    C.sMailToStreetAddress1,
    C.sMailToStreetAddress2,
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
    LEFT JOIN [SMI Reporting].dbo.tblCustomerType CT on CT.ixCustomerType = C.ixCustomerType
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

select * from tblCustomerType





SELECT     CT.sDescription, count(C.ixCustomer) 'CustCnt'
/* 
    C.sEmailAddress,
    C.sCustomerFirstName,
    C.sCustomerLastName,
    -- Company Name
    C.sMailToCOLine,
    C.sMailToStreetAddress1,
    C.sMailToStreetAddress2,
    C.sMailToState,
    C.sMailToZip,
    C.sMailToZipFour,
    C.sMailToCountry,
   -- C.flgTaxable, 
    -- C.dtDateLastSOPUpdate -- 3,278
    LO.LastOrder,
    OC.OrderCount12Mo,
    C.sCustomerType,
    C.ixCustomerType,
    CT.sDescription 'TypeDescription'
*/
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
GROUP BY CT.sDescription -- C.sCustomerType

ORDER BY C.ixCustomerType,  LO.LastOrder



/*
sCustomer
Type	CustCnt
MRR 	838
Other	383
PRS	    508
Retail	1552
*/



/*
run a second version of this report with the following criteria:

Customer type of 30, 40, 32 and tax code of 1

This will pick up the dealers that have not been affected by our current nexus states, but may be as the tax laws change. 
*/

SELECT C.ixCustomer, 
    C.sEmailAddress,
    C.sCustomerFirstName,
    C.sCustomerLastName,
    -- Company Name
    C.sMailToCOLine,
    C.sMailToStreetAddress1,
    C.sMailToStreetAddress2,
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
    and C.flgTaxable = 1
    and C.ixCustomerType in ('30', '40', '32')
ORDER BY C.ixCustomerType,  LO.LastOrder

