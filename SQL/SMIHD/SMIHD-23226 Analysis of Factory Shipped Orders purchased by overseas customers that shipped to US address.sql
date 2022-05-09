-- SMIHD-23226 Analysis of Factory Shipped Orders purchased by overseas customers that shipped to US address

/*
 determine the frequency of an issue that has occurred.

1) Orders placed 05/15/2021 through 11/15/2021

2) Customer has an overseas primary address.
    OR
   Order has an overseas address as the billing address.

3) Order has a US shipping address.

4) Order has at least one Factory Shipped item on it that has actually shipped


We recently had an international customer ship Factory Shipped items to a Freight Forwarding company 
and there was a lack of correct paperwork for the Factory Shipped items to be shipped to the international customer. 
The resolution of this issue required a good amount of additional work/coordination on our part. 
The final shipping of the order to the customer was also greatly delayed.

I need to know how often this situation has come up over the last 6 months to find out if this is a 1 out of 100 issue or a 1 out of 5 issue.
*/

-- orders with at least 1 dropshipped item
SELECT distinct O.ixOrder -- 82
into #DSOrders
from tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
        left join tblCustomer C on O.ixCustomer = C.ixCustomer
where O.dtOrderDate between '05/15/2021' and '11/15/2021'
    and O.sOrderStatus = 'Shipped'  -- 493,065
    and O.sShipToCountry = 'US' -- 486,225
    and C.sMailToCountry is NOT NULL -- 3,802
    and OL.flgLineStatus = 'Dropshipped'

SELECT count(distinct O.ixOrder) 'Orders'
    , C.sMailToCountry 'CustomerMailToCountry'
from tblOrder O
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
    left join #DSOrders DS on DS.ixOrder = O.ixOrder
where dtOrderDate between '05/15/2021' and '11/15/2021'
    and O.sOrderStatus = 'Shipped'  -- 493,065
    and O.sShipToCountry = 'US' -- 486,225
    and C.sMailToCountry is NOT NULL -- 3,802
    and DS.ixOrder is NOT NULL -- contains at least 1 DS item   82
Group by C.sMailToCountry






/*

select --sMailToCountry, 
    COUNT(*)
from tblCustomer
WHERE flgDeletedFromSOP = 0
    and sMailToCountry IS not null -- 88,097 non-US customers
GROUP BY sMailToCountry
ORDER BY sMailToCountry


SELECT distinct flgLineStatus
from tblOrderLine
where ixOrderDate >= 19525
*/
