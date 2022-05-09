-- Case 18351 - preliminary analysis for new Dropship Detail report



select C.ixCustomer, C.sCustomerFirstName, C.sCustomerLastName, C.sCustomerType,
    O.ixOrder, 
    O.sOrderType,
    O.sOrderChannel,
    O.dtOrderDate, O.sOrderTaker, 
    O.mMerchandise, 
    DSC.DropshipCharge,
    O.mMerchandiseCost, 
    (Case when O.mMerchandise = 0 then -99999 -- HACK FOR DIV/ZERO ERROR... replace these values with "ERROR" on spreadsheet output
     else     ((O.mMerchandise - O.mMerchandiseCost)/O.mMerchandise) 
     end
     )as GPcalc,   
--    ((O.mMerchandise - O.mMerchandiseCost)/O.mMerchandise) as GP,
    O.mShipping, O.mTax,
    (O.mMerchandise+O.mShipping+O.mTax) as Total
    
from tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
    join -- only orders with DROPSHIP SKU
        (select distinct ixOrder
         from tblOrderLine
         where ixSKU = 'DROPSHIP'
         and flgLineStatus in ('Shipped','DropShipped')
         ) DSO on O.ixOrder = DSO.ixOrder
     left join(select ixOrder, sum(OL.mExtendedPrice) DropshipCharge
          from tblOrderLine OL
          where ixSKU = 'DROPSHIP'
            and flgLineStatus in ('Shipped','DropShipped')
          group by ixOrder
          ) DSC on O.ixOrder = DSC.ixOrder
where O.sOrderStatus = 'Shipped'
    and O.dtOrderDate
    between '01/01/2011' and '12/31/2011' 
   -- between '01/01/2012' and '12/31/2012' 
   -- between '01/01/2013' and '12/31/2013'
--and O.mMerchandise = 0    
group by C.ixCustomer, C.sCustomerFirstName, C.sCustomerLastName, C.sCustomerType,
    O.ixOrder,     
    O.sOrderType,
    O.sOrderChannel,
    O.dtOrderDate, O.sOrderTaker, 
    O.mMerchandise, O.mMerchandiseCost,
    DSC.DropshipCharge, O.mShipping, O.mTax  
order by GPcalc         
            




