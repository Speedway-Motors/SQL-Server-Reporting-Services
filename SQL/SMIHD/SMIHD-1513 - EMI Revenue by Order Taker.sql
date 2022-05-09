-- SMIHD-1513 - EMI Revenue by Order Taker
select sOrderTaker,
D.iYear, D.iMonth,
count(ixOrder) OrderCount, 
SUM(mMerchandise) TotMerch,
SUM(mMerchandiseCost) TotMerchCost,
SUM(mShipping) TotSH,
SUM(mTax) TotTax,
SUM(mCredits) TotCredits
from vwEagleOrder O
    join tblDate D on O.ixShippedDate = D.ixDate
where sOrderStatus = 'Shipped'
and ixShippedDate between 17168 and 17348
and sOrderTaker in ('MAL','MAL1','MAL2','FWG','KAV','JTM')
group by sOrderTaker,
D.iYear, D.iMonth
ORDER BY sOrderTaker,
D.iYear, D.iMonth

select SUM(mMerchandise)
from vwEagleOrder
where sOrderStatus = 'Shipped'
and ixShippedDate between 17168 and 17348
and sOrderTaker in ('MAL','MAL1','MAL2','FWG','KAV','JTM')

SELECT * FROM tblDate where ixDate in (17168,17348)


select * from tblCustomerType