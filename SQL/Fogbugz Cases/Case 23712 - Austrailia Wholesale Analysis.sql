-- Case 23712 - Austrailia Wholesale Analysis

select SKU.sSEMACategory,
    SUM(OL.mExtendedPrice) Sales,
    SUM(OL.mExtendedCost) Cost    
from tblCustomer C
    left join tblOrder O on C.ixCustomer = O.ixCustomer
    left join tblDate D on O.ixShippedDate = D.ixDate
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblSKU SKU on SKU.ixSKU = OL.ixSKU
where C.ixCustomer in ('345385','144629','293762','1027179','1250066','299695','1879120','462840','778313','1546678')
and O.sOrderStatus = 'Shipped'
and O.dtShippedDate between '05/01/2012' and '08/27/2014'
and OL.flgLineStatus = 'Shipped'
group by SKU.sSEMACategory
order by  SUM(OL.mExtendedPrice) desc





select --C.ixCustomer, 
--D.iYearMonth, 
D.iYear,
SUM(O.mMerchandise) Sales
from tblCustomer C
    left join tblOrder O on C.ixCustomer = O.ixCustomer
    left join tblDate D on O.ixShippedDate = D.ixDate
where C.ixCustomer in ('345385','144629','293762','1027179','1250066','299695','1879120','462840','778313','1546678')
and O.sOrderStatus = 'Shipped'
and O.dtShippedDate >= '05/12/2014'
group by 
    --C.ixCustomer, 
    D.iYearMonth
order by   D.iYearMonth  

-- ??? are these customers only shipping to Austrailia?
select O.sShipToCountry, COUNT(distinct O.ixOrder) OrderCount
from tblCustomer C
    left join tblOrder O on C.ixCustomer = O.ixCustomer
    left join tblDate D on O.ixShippedDate = D.ixDate
where C.ixCustomer in ('345385','144629','293762','1027179','1250066','299695','1879120','462840','778313','1546678')
and O.sOrderStatus = 'Shipped'
and O.dtShippedDate >= '05/01/2012'
group by O.sShipToCountry
/*
sShip
ToCountry	OrderCount
AUSTRALIA	473
US	         69
*/

select O.sShipToCountry, COUNT(distinct O.ixOrder) OrderCount
from tblCustomer C
    left join tblOrder O on C.ixCustomer = O.ixCustomer
    left join tblDate D on O.ixShippedDate = D.ixDate
where O.sShipToCountry = 'AUSTRALIA'
and C.ixCustomer NOT in ('345385','144629','293762','1027179','1250066','299695','1879120','462840','778313','1546678')
and O.sOrderStatus = 'Shipped'
and O.dtShippedDate >= '05/01/2012'
group by O.sShipToCountry


select O.sShipToCountry, COUNT(distinct O.ixOrder) OrderCount
from tblCustomer C
    left join tblOrder O on C.ixCustomer = O.ixCustomer
    left join tblDate D on O.ixShippedDate = D.ixDate
where O.sShipToCountry in ( 'AUSTRALIA','CANADA')
and C.ixCustomer NOT in ('345385','144629','293762','1027179','1250066','299695','1879120','462840','778313','1546678')
and O.sOrderStatus = 'Shipped'
and O.dtShippedDate >= '05/01/2012'
group by O.sShipToCountry




-- NON-AUS previous 4 Quarters
select --C.ixCustomer, 
    D.iYearMonth,
    SUM(O.mMerchandise) Sales,
   -- SUM(O.mMerchandiseCost) Cost,
    (SUM(O.mMerchandise) - SUM(O.mMerchandiseCost)) GM, -- verified
    D.iQuarter  
from tblCustomer C
    left join tblOrder O on C.ixCustomer = O.ixCustomer
    left join tblDate D on O.ixShippedDate = D.ixDate
where C.ixCustomer in ('345385','144629','293762','1027179','1250066','299695','1879120','462840','778313','1546678')
    O.sOrderType = 'PRS'
    and O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '07/01/2013' and '06/30/2014'
group by D.iYearMonth,D.iQuarter
order by   D.iYearMonth  


-- AUS ONLY previous 4 Quarters
select --C.ixCustomer, 
    --D.iYearMonth, 
    D.iYearMonth,D.iQuarter,
    SUM(O.mMerchandise) Sales
from tblCustomer C
    left join tblOrder O on C.ixCustomer = O.ixCustomer
    left join tblDate D on O.ixShippedDate = D.ixDate
where O.sOrderType = 'PRS'
    and C.ixCustomer NOT in ('345385','144629','293762','1027179','1250066','299695','1879120','462840','778313','1546678')
    and O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '07/01/2013' and '06/30/2014'
group by D.iYearMonth,D.iQuarter
order by   D.iYearMonth  