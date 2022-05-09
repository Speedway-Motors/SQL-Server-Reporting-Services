/*
When an order is cancelled the dtOrderDate changes to the date it was canceled 
    (actually changes whenever ANY changes are made to the order)
*/

SELECT 
    O.sMethodOfPayment  MoP, 
    O.ixOrder           OrderNum, 
    O.ixCustomer        CustNum,
 O.dtOrderDate       OrdEntDate,
 T.chTime            OETime,
    (O.dtOrderDate+T.chTime) OrderDateTime,   
    O.ixCanceledBy      CanceledBy,
    O.sCanceledReason   CanceledReason,
    OL.ixSKU            SKU,
    SKU.sDescription    Description,
    OL.iQuantity        Qty,
    OL.mUnitPrice       UnitPrice,
    OL.mCost            UnitCost,
    O.mCredits          Credit,
    O.mTax              Tax,
    O.mMerchandise      Merchandise,
    O.mAmountPaid       AmtPaid
FROM tblOrder O
    left join tblOrderLine OL   on OL.ixOrder = O.ixOrder
    left join tblSKU SKU        on SKU.ixSKU = OL.ixSKU
    left join tblTime T         on T.ixTime = O.ixOrderTime
WHERE   O.sOrderStatus = 'Cancelled'
    and O.dtOrderDate >= '02/01/2011'
    and O.dtOrderDate < '03/01/2011'
    and O.sOrderChannel = 'COUNTER'
    and O.sMethodOfPayment in (@MoP)
ORDER BY O.dtOrderDate




select * from tblOrderLine where ixOrder = '4514807'

select * from tblOrder where ixOrder = '4688602'
select * from tblSKU where ixSKU = '91067101'




select top 10 * from tblOrder


select *
from tblOrder 
where dtOrderDate >= '02/01/2011'
and sMethodOfPayment is NULL


select * from tblReportDropDowns

drop table tblReportDropDowns



select * from tblOrder where sOrderStatus = 'Pick Ticket'
and sMethodOfPayment is NULL
order by dtOrderDate

and dtOrderDate >= '02/01/2011'
