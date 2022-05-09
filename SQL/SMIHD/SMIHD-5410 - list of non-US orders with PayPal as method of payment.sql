-- SMIHD-5410 - list of non-US orders with PayPal as method of payment
/*
Can you provide a report that lists the order #, merchandise dollar amount and total order dollar amount for 
 orders taken Mar 1- Aug 31, 2016 
    MOP = PayPal 
    NON-US Billing OR Shipping Address
    
*/

-- to populate the speadsheet sent to Ken
SELECT O.ixOrder, O.dtOrderDate, O.sShipToCountry 'ShippedTo', C.sMailToCountry 'CustomerMailingAddressCountry', O.mMerchandise, O.mShipping, O.mTax, (O.mMerchandise + O.mShipping + O.mTax) 'OrderTotal', SM.sDescription 'Ship Method', O.iShipMethod
FROM tblOrder O
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
    left join tblShipMethod SM on O.iShipMethod = SM.ixShipMethod
WHERE O.sOrderStatus = 'Shipped'
    and O.dtOrderDate between '03/01/2016' and '08/31/2016'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and O.sMethodOfPayment = 'PAYPAL' -- 41,707
    and (
        (O.sShipToCountry is NOT NULL  and O.sShipToCountry <> 'US')
        OR C.sMailToCountry is NOT NULL
        -- OR O.iShipMethod in (15,18)
         )
ORDER BY    O.iShipMethod 



/*


SELECT C.sMailToCountry, COUNT(*)
FROM tblCustomer C
where flgDeletedFromSOP = 0
group by     C.sMailToCountry
order by  C.sMailToCountry   
    
    
select * from tblMethodOfPayment    

*/



