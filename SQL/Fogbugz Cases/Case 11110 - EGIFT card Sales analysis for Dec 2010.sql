/*
select * from tblSKU
where upper(sDescription) like '%GIFT%'
*/



select O.dtShippedDate, OL.mExtendedPrice as GiftCardPrice, count(*) QTY
from tblOrderLine OL
    join tblOrder O on OL.ixOrder = O.ixOrder
where O.dtShippedDate between '12/01/2010' and '12/31/2010'
     and O.sOrderStatus = 'Shipped'
     and O.sOrderType <> 'Internal'
     and O.sOrderChannel <> 'INTERNAL'
     and O.mMerchandise > 0 
     and OL.ixSKU = 'EGIFT'
group by OL.mExtendedPrice, O.dtShippedDate   
order by dtShippedDate, OL.mExtendedPrice  
     
         
select O.dtShippedDate, sum(OL.mExtendedPrice) as TotGiftCardSales, count(*) QTY
from tblOrderLine OL
    join tblOrder O on OL.ixOrder = O.ixOrder
where O.dtShippedDate between '12/01/2010' and '12/31/2010'
     and O.sOrderStatus = 'Shipped'
     and O.sOrderType <> 'Internal'
     and O.sOrderChannel <> 'INTERNAL'
     and O.mMerchandise > 0 
     and OL.ixSKU = 'EGIFT'
group by O.dtShippedDate   
order by dtShippedDate, OL.mExtendedPrice  


select OL.mExtendedPrice as GiftCardPrice, count(*) QTY
from tblOrderLine OL
    join tblOrder O on OL.ixOrder = O.ixOrder
where O.dtShippedDate between '12/01/2010' and '12/31/2010'
     and O.sOrderStatus = 'Shipped'
     and O.sOrderType <> 'Internal'
     and O.sOrderChannel <> 'INTERNAL'
     and O.mMerchandise > 0 
     and OL.ixSKU = 'EGIFT'
group by OL.mExtendedPrice  
order by OL.mExtendedPrice  
              
  