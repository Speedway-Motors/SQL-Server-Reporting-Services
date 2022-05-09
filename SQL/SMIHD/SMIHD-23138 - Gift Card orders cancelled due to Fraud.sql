-- SMIHD-23138 - Gift Card orders cancelled due to Fraud

/*
can you provide me with a list of orders for part # GIFT (with any index choice) and part # EGIFT 
that were canceled from Nov 1, 2020, through Oct 31, 2021, and what the reason code was for each canceled order, 
I could then probably substantiate the request; 
assuming the report shows there are not many orders that were canceled with reason code 106) Fraud
*/


select ixSKU, SUM(iQuantity) 'QtyOrdered'
from tblOrderLine
where dtOrderDate between '11/01/2020' and '10/31/2021'
    and ixOrder NOT like 'PC%'
    and ixOrder NOT LIKE 'Q%'
    and ixSKU like '%GIFT%'
group by ixSKU
order by ixSKU
/*          
    ixSKU	    Ordered
    EGIFT	    1902
    GIFT-RACE	295
    GIFT-SMI	725
    GIFT-SPRINT	181
    GIFT-SR	    813
*/

-- Orders containing gift cards
select distinct ixOrder
into #GiftCardOrders -- DROP TABLE #GiftCardOrders   -- 3,810
from tblOrderLine
where dtOrderDate between '11/01/2020' and '10/31/2021'
    and ixOrder NOT like 'PC%'
    and ixOrder NOT LIKE 'Q%'
    and ixSKU like '%GIFT%'


SELECT O.ixCancellationReasonCode,RC.sCancellationReasonCode, count(O.ixOrder) 'OrderCnt'
FROM tblOrder O
    left join tblOrderCancellationReasonCode RC on O.ixCancellationReasonCode = RC.ixCancellationReasonCode
    LEFT JOIN #GiftCardOrders GCO on O.ixOrder = GCO.ixOrder
where O.dtOrderDate between '11/01/2020' and '10/31/2021'
    and O.ixOrder NOT like 'PC%'
    and O.ixOrder NOT LIKE 'Q%'
    and O.sOrderStatus = 'Cancelled' -- 40,606
    and GCO.ixOrder is NOT NULL -- order contains a gift card
group by O.ixCancellationReasonCode,RC.sCancellationReasonCode
/*
ReasonCode	        OrderCnt
NULL	NULL	    4
100	Auth Issues	    34
101	Cancel/Re-enter	14
103	Changed Mind	1
105	Duplicate Order	1
106	Fraud	        11
107	International	5
112	Long BO Wait	4
108	Mis-ordered	    7
999	Other-Specify	14
*/

SELECT O.ixCancellationReasonCode,O.ixOrder, O.mMerchandise
FROM tblOrder O
    left join tblOrderCancellationReasonCode RC on O.ixCancellationReasonCode = RC.ixCancellationReasonCode
    LEFT JOIN #GiftCardOrders GCO on O.ixOrder = GCO.ixOrder
where O.dtOrderDate between '11/01/2020' and '10/31/2021'
    and O.ixOrder NOT like 'PC%'
    and O.ixOrder NOT LIKE 'Q%'
    and O.sOrderStatus = 'Cancelled' -- 40,606
    and GCO.ixOrder is NOT NULL -- order contains a gift card
    and O.ixCancellationReasonCode = 106
order by O.ixOrder

select distinct ixOrder
into #GiftCardOrders -- DROP TABLE #GiftCardOrders   -- 3,810
from tblOrderLine
where dtOrderDate between '11/01/2020' and '10/31/2021'
    and ixOrder NOT like 'PC%'
    and ixOrder NOT LIKE 'Q%'
    and ixSKU like '%GIFT%'

    SELECT ixSKU
    from tblSKU
    where ixSKU like '%GIFT%'


    select distinct ixSKU
--into #GiftCardOrders -- DROP TABLE #GiftCardOrders   -- 3,810
from tblOrderLine
where dtOrderDate between '11/01/2020' and '10/31/2021'
    and ixOrder NOT like 'PC%'
    and ixOrder NOT LIKE 'Q%'
    and ixSKU like '%GIFT%'

