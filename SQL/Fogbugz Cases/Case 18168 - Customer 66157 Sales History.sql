-- Case 18168 - Customer 66157 Sales History
select datepart("yyyy",O.dtOrderDate)  , 
SUM(mMerchandise) + SUM(mShipping) + SUM(mTax) as 'MerchSales',
--    SUM(mMerchandise) Merchandise, 
--    SUM(mShipping) Shipping, 
--    SUM(mTax) Tax--, 
    SUM(mCredits) MerchCredits
from tblOrder O
where O.ixCustomer = 66157
    and O.sOrderStatus = 'Shipped'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtOrderDate >= '01/01/2008'
group by datepart("yyyy",O.dtOrderDate)  
order by     datepart("yyyy",O.dtOrderDate)  


select datepart("yyyy",dtCreateDate),
    SUM(mMerchandise) MerchCredits
from tblCreditMemoMaster
where ixCustomer = 66157
    and dtCreateDate >= '01/01/2008'
        and sMemoType = 'Refund'
    and flgCanceled = 0
group by datepart("yyyy",dtCreateDate)


select *
from tblCreditMemoMaster
where ixCustomer = 66157
    and dtCreateDate >= '01/01/2008'
   -- and sMemoType = 'Refund'
--group by datepart("yyyy",dtCreateDate)


select sOrderType,sOrderChannel, ixOrder, mMerchandise, mAmountPaid, mShipping, mTax, mCredits from tblOrder
where dtShippedDate >= '01/01/2013'
and mShipping > 0 
and mTax > 0
and mCredits > 0 



select sOrderStatus, dtShippedDate,sMethodOfPayment, ixOrder, mMerchandise, mAmountPaid, mShipping, mTax, mCredits from tblOrder
where dtShippedDate >= '01/01/2013'
 and ixCustomer = 66157


