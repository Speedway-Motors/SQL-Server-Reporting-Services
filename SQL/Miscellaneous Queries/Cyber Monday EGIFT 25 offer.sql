--select * from [LNK-DW1].[SMI Reporting].dbo.tblLatestFeed

-- 283 individual orders
select O.ixOrder, O.sWebOrderID, O.ixCustomer, sSourceCodeGiven, sMatchbackSourceCode, sPromoApplied, O.mMerchandise
 --O.dtOrderDate, OL.mExtendedPrice as GiftCardPrice, count(distinct O.ixOrder) QTY
from tblOrderLine OL
    join tblOrder O on OL.ixOrder = O.ixOrder
where O.dtOrderDate = '11/28/2011'
     and O.sOrderType <> 'Internal'
     and O.sOrderChannel <> 'INTERNAL'
     and OL.ixSKU = 'EGIFT'
     and O.sOrderStatus <> 'Cancelled'
     and O.ixCustomer NOT in ('765260','783938','1194637') -- MRR & PRS customers
     --and OL.mExtendedPrice = 150
     --and O.sSourceCodeGiven = '2190'
order by sSourceCodeGiven, sPromoApplied -- sSourceCodeGiven   
--group by OL.mExtendedPrice, O.dtOrderDate   
--order by dtOrderDate, OL.mExtendedPrice 



select O.* 
from tblOrder O
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
where O.dtOrderDate = '11/28/2011'
and O.ixCustomer in ('765260','783938','1194637') -- = '833415'




