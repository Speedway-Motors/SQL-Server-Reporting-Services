select sPriceDevianceReason, count(ixOrder) OrderCount
FROM

(
select 
/*
O.ixOrder, O.ixCustomer, O.sOrderType, O.sOrderChannel, O.sShipToCountry, O.iShipMethod, O.sSourceCodeGiven, O.sMatchbackSourceCode, 
O.sMethodOfPayment, O.sOrderTaker, O.sPromoApplied, O.mMerchandise, O.mShipping, O.mCredits, O.sOrderStatus, O.flgIsBackorder, O.mMerchandiseCost, O.dtOrderDate, 
O.dtShippedDate, O.mPromoDiscount, O.ixAuthorizationStatus, O.ixOrderType, O.sWebOrderID,
*/
Distinct O.sOrderTaker, O.ixOrder, OL.sPriceDevianceReason, OL.ixPriceDevianceReasonCode, OL.sPriceDevianceReason,C.sCustomerType

    --O.sOrderTaker,--O.dtOrderDate,
    --OL.ixOrder,
    --OL.ixCustomer, OL.ixSKU, 
    --SKU.sDescription 'SKUDescription',
    --OL.mCost,-- OL.mExtendedCost, 
    --OL.iQuantity, OL.mUnitPrice, OL.mSystemUnitPrice,  
    --OL.mExtendedPrice,OL.mExtendedSystemPrice, 
    --(OL.mExtendedPrice-OL.mExtendedSystemPrice) as 'DELTA', 
    --OL.ixPriceDevianceReasonCode, OL.sPriceDevianceReason,C.sCustomerType,
    --SKU.flgIntangible,
    --OL.flgLineStatus, OL.dtOrderDate, OL.dtShippedDate
from tblOrder O
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
    join tblCustomer C on O.ixCustomer = C.ixCustomer
    join tblSKU SKU on OL.ixSKU = SKU.ixSKU
where 
(OL.mExtendedPrice-OL.mExtendedSystemPrice) <> 0 -- why are there 7442 = 0 ?
  and sPriceDevianceReason is not null
  and flgLineStatus in ('Shipped','Dropshipped')
--and ixPriceDevianceReasonCode = 1001
--ORDER BY sPriceDevianceReason, sCustomerType
--'DELTA'  
) A 

group by sPriceDevianceReason
order by OrderCount desc

23,811  total rows
 9,084  Orders
 5,887  Customers 



select sCustomerType, count(*) Qty
from tblCustomer 
group by sCustomerType
/*
sCustomerType	Qty
MRR	560
Other	12345
PRS	447
Retail	1266825
*/


select * from t



 mUnitPrice <> mSystemUnitPrice
    --and mSystemUnitPrice is not null
    and OL.flgLineStatus = 'Shipped'
    --and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    --and OL.mCost > 0
    and O.dtShippedDate = '08/20/2012' --between '01/01/2011' and '12/31/2011'
    
order by dtOrderDate, ixOrder 


sReason         PriceDevianceReason   

select count(distinct ixOrder)
from tblOrderLine 
where ixPriceDevianceReasonCode is not NULL


select * 
from tblOrderLine
where ixPriceDevianceReasonCode is NOT NULL and sPriceDevianceReason is NULL

select * 
from tblOrderLine
where sPriceDevianceReason  is NOT NULL and ixPriceDevianceReasonCode is NULL




select OL.ixOrder, OL.ixSKU,O.sOrderTaker,O.dtOrderDate, OL.iQuantity, mUnitPrice, mSystemUnitPrice
from tblOrderLine OL
    join tblOrder O on O.ixOrder = OL.ixOrder
where mUnitPrice <> mSystemUnitPrice
    and mSystemUnitPrice is not null
    and OL.flgLineStatus = 'Shipped'
    --and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and OL.mCost > 0
    --and O.dtShippedDate between '01/01/2011' and '12/31/2011'
    
order by dtOrderDate, ixOrder    


select OL.ixOrder, O.dtOrderDate, mUnitPrice, mSystemUnitPrice
from tblOrderLine OL
    join tblOrder O on O.ixOrder = OL.ixOrder
where O.ixOrder in 


select O.dtOrderDate, count(OL.ixSKU) CountZeroUP --OL.ixOrder, O.dtOrderDate, mUnitPrice, mSystemUnitPrice
from tblOrderLine OL
    join tblOrder O on O.ixOrder = OL.ixOrder
    join tblSKU SKU on OL.ixSKU = SKU.ixSKU
where --mUnitPrice <> mSystemUnitPrice
    --and mSystemUnitPrice is not null
    O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    --and O.mMerchandise > 0
    and SKU.flgIntangible = 0
    and mUnitPrice = 0
group by O.dtOrderDate
order by O.dtOrderDate desc    



select OL.ixOrder, OL.ixSKU,O.sOrderTaker,O.dtOrderDate, OL.iQuantity, mUnitPrice, mSystemUnitPrice, ixPriceDevianceReasonCode, sPriceDevianceReason
from tblOrderLine OL
    join tblOrder O on O.ixOrder = OL.ixOrder
where mUnitPrice <> mSystemUnitPrice
    and mSystemUnitPrice is not null
    and OL.flgLineStatus = 'Shipped'
    --and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and OL.mCost > 0
    and O.dtShippedDate = '08/20/2012' --between '01/01/2011' and '12/31/2011'
    
order by dtOrderDate, ixOrder    




