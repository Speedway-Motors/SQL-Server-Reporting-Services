-- SMIHD-13161 - Web Order Analysis for PPC Conversion Tracking

/*
Date Range: January 21, 2019 - February 19, 2019

order date, customer number, SOP order number, 
the web transaction id (ie E2375055), 
order sub total, order shipping, 
order tax, and order total.
*/

SELECT dtOrderDate 'OrderDate', ixCustomer 'Customer', 
    ixOrder 'Order', sWebOrderID 'WebOrderID',
    mMerchandise 'Merch',
    mShipping 'Shipping',
    mTax 'Tax',
    mCredits 'Credits',
    mAmountPaid 'AmountPaid',
    (mMerchandise+mShipping+mTax-mCredits) 'Merch+SH+Tax-Credits'
FROM tblOrder
WHERE dtOrderDate between '01/21/2019' and '02/19/2019'
    and sOrderType <> 'Internal'
    and sOrderStatus = 'Shipped'
    and sWebOrderID like 'E%'
    and mMerchandise > 0
--and mCredits = 0
--and (mMerchandise+mShipping+mTax-mCredits) <> mAmountPaid
--and ixOrder like '%-%'
order by mCredits desc



-- 2/20/19 to 2/26/19
SELECT dtOrderDate 'OrderDate', ixCustomer 'Customer', 
    ixOrder 'Order', sWebOrderID 'WebOrderID',
    mMerchandise 'Merch',
    mShipping 'Shipping',
    mTax 'Tax',
    mCredits 'Credits',
    mAmountPaid 'AmountPaid',
    (mMerchandise+mShipping+mTax-mCredits) 'Merch+SH+Tax-Credits',
    sOrderChannel
FROM tblOrder
WHERE dtOrderDate between '02/20/2019' and '02/26/2019'
    and sOrderType <> 'Internal'
    and sOrderStatus = 'Shipped'
    and sWebOrderID like 'E%'
    and mMerchandise > 0
--and mCredits = 0
--and (mMerchandise+mShipping+mTax-mCredits) <> mAmountPaid
--and ixOrder like '%-%'
order by sWebOrderID --  mCredits desc



-- 2/20/19 to 3/07/19
SELECT dtOrderDate 'OrderDate', ixCustomer 'Customer', 
    ixOrder 'Order', sWebOrderID 'WebOrderID',
    mMerchandise 'Merch',
    mShipping 'Shipping',
    mTax 'Tax',
    mCredits 'Credits',
    mAmountPaid 'AmountPaid',
    (mMerchandise+mShipping+mTax-mCredits) 'Merch+SH+Tax-Credits'
  --  ,sOrderChannel
FROM tblOrder
WHERE dtOrderDate between '02/20/2019' and '03/07/2019'
    and sOrderType <> 'Internal'
    and sOrderStatus = 'Shipped'
    and sWebOrderID like 'E%'
    and mMerchandise > 0
--and mCredits = 0
--and (mMerchandise+mShipping+mTax-mCredits) <> mAmountPaid
--and ixOrder like '%-%'
order by sWebOrderID --  mCredits desc


-- 12/02/2019  (single day only this time)
SELECT dtOrderDate 'OrderDate', ixCustomer 'Customer', 
    ixOrder 'Order', sWebOrderID 'WebOrderID',
    mMerchandise 'Merch',
    mShipping 'Shipping',
    mTax 'Tax',
    mCredits 'Credits',
    mAmountPaid 'AmountPaid',
    (mMerchandise+mShipping+mTax-mCredits) 'Merch+SH+Tax-Credits'
    -- , sOrderChannel
FROM tblOrder
WHERE dtOrderDate between '12/02/2019 ' and '12/02/2019'
    and sOrderType <> 'Internal'
    and sOrderStatus = 'Shipped'
    and sWebOrderID like 'E%'
    and mMerchandise > 0
--and mCredits = 0
--and (mMerchandise+mShipping+mTax-mCredits) <> mAmountPaid
--and ixOrder like '%-%'
order by sWebOrderID --  mCredits desc




-- UNUSUAL sWebOrderID values
select ixOrder, sWebOrderID, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
FROM tblOrder
where ixOrder in ('8023745','8032541') -- refed records.  They updated but values did not change
/*
ixOrder	sWebOrderID	dtDateLastSOPUpdate	ixTimeLastSOPUpdate
8023745	ETRRBAJA02	2019-02-27          47223
8032541	E	        2019-02-27          47223
*/

select * from tblTime where ixTime = 47223
