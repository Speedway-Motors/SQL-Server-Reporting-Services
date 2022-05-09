select sMethodOfPayment, count(*) OrdCount, SUM(O.mAmountPaid)
from tblOrder O
    where O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
--    and O.sOrderChannel <> 'INTERNAL'
	and O.sOrderChannel = 'WEB'
    and O.mMerchandise > 0 
    and O.dtShippedDate between '01/01/2011' and '12/31/2011'
group by sMethodOfPayment     
order by sMethodOfPayment    
/*
OrdCount sMethodOfPayment
2738	ACCTS RCVBL
12508	AMEX
10166	CASH
2826	CHECK
6076	COD
17100	DISCOVER
89733	MASTERCARD
1782	MONEY ORDER
25425	PAYPAL
15622	PP-AUCTION
205960	VISA
*/

select count(*) OrdCount,
    sum(mMerchandise) Merchandise,
    sum(mShipping)    Shipping,
    sum(mTax)         Tax,
    sum(mCredits)     Credits
from tblOrder O
    where O.sMethodOfPayment = 'PAYPAL'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
 --   and O.sOrderChannel <> 'INTERNAL'
	and O.sOrderChannel = 'WEB'
    and O.mMerchandise > 0 
    and O.dtShippedDate between '01/01/2011' and '12/31/2011'
    and O.sOrderChannel <> 'AUCTION' -- Excluding Ebay Orders
   -- and O.sOrderTaker = 'WEB'

    -- run above query and add next line to get Number of Orders that shipped more than 72 hours after the order was placed
    and DATEDIFF (d,dtOrderDate,dtShippedDate) > 3  -- 30 orders 

/*
OrdCount	Merchandise	Shipping	Tax	        Credits
25425	    3156395.58	331405.44	10366.22	8933.82
*/
