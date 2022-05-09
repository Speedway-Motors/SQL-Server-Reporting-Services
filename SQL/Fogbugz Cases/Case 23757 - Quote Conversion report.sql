-- Case 23757 - Quote Conversion report

DECLARE
    @StartDate datetime,
    @EndDate datetime

SELECT
    @StartDate = '10/30/14',
    @EndDate = '11/2/14'  

SELECT O.ixOrder 'Quote',  -- runtime 1 min  107 rows
    O.sOrderTaker 'QuoteGiver',
    O.dtOrderDate 'QuoteGiven',
    O.mMerchandise 'QuoteMerch',
    O.mShipping 'QuoteShipping',
    (case when O.sOrderStatus = 'Cancelled Quote' 
                and ixConvertedOrder is NOT NULL then 'Converted' -- Converted Order could still be cancelled
        else O.sOrderStatus
     end
     ) as 'QuoteStatus',
     O.ixConvertedOrder,
     CQ.*

FROM tblOrder O
     LEFT JOIN (-- converted quote data
                 SELECT ixOrder 'Order',
                    sOrderTaker 'OrderTaker',
                    dtOrderDate 'OrderDate',
                    mMerchandise 'OrderMerch',
                    mShipping 'OrderShipping',
                    sOrderStatus 'OrderStatus',
                    ixQuote
                 FROM tblOrder O
                 WHERE dtOrderDate >= @StartDate 
                    and O.ixQuote is NOT NULL
                 ) CQ on O.ixOrder = CQ.ixQuote
WHERE O.dtOrderDate > '11/01/2014' -- the start of tracking converted orders
    and O.dtOrderDate between @StartDate and @EndDate
    and O.ixOrder like 'Q%'     
    
    
/*    
    
select dtOrderDate, COUNT(*)
from tblOrder
where ixOrder like 'Q%'
group by dtOrderDate
order by dtOrderDate
    
    
    
select * from tblOrder
where ixOrder like 'Q%'    
and dtOrderDate < '10/01/2014'
order by dtOrderDate

*/