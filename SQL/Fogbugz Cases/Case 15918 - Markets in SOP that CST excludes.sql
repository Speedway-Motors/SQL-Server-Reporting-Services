-- Case 15918 - Markets in SOP that CST excludes

select ixOrder, ixCustomer, dtOrderDate, dtShippedDate, mMerchandise, sPromoApplied, sSourceCodeGiven, sMatchbackSourceCode, sOrderType
from tblOrder
where sMatchbackSourceCode = '34515'
and sOrderStatus = 'Shipped'


select * from tblSourceCode where ixSourceCode = '34515'

select * from tblOrder
where ixCustomer = '704446'
order by dtOrderDate desc


select * 
from tblOrderLine
where ixOrder = '4754458'


select * from tblSKU where ixSKU = '9002722'

select * from tblPGC where ixPGC = 'ST' -- Street

select * from tblCustomerOffer where ixCustomer = '704446'
order by ixSourceCode desc


select O.ixCustomer, O.ixOrder, O.dtOrderDate, O.dtShippedDate, OL.ixSKU, 
    SKU.sDescription, --OL.flgLineStatus, 
    SKU.ixPGC
from tblOrder O
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
    join tblSKU SKU on SKU.ixSKU = OL.ixSKU
where O.ixCustomer   = '704446'
 and O.dtOrderDate > '10/05/2006'
 and O.sOrderStatus = 'Shipped'
 and OL.flgLineStatus = 'Shipped'

order by O.dtOrderDate desc


select * from tblMarket

select PGC.ixMarket, count(*) SKUs
from tblSKU SKU
    join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
where SKU.flgActive = 1
   and SKU.flgDeletedFromSOP = 0
   and SKU.flgIntangible = 0
group by PGC.ixMarket
order by SKUs desc


-- Active tangible SKUs who's PGC belongs to a market not currenly recoginzed by CST (therefor not qualifying them for a segment based on sales)
select PGC.ixMarket, SKU.ixPGC, SKU.ixSKU, SKU.sDescription, SKU.dtCreateDate
from tblSKU SKU
    left join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
where SKU.flgActive = 1
   and SKU.flgDeletedFromSOP = 0
   and SKU.flgIntangible = 0
   and (PGC.ixMarket is NULL
       OR PGC.ixMarket not in ('R','SR','B','SM','2B'))
ORDER BY PGC.ixMarket, SKU.dtCreateDate DESC

select distinct SKU.ixSKU, PGC.ixMarket, SKU.ixPGC, PGC.sDescription PGCDescription
from tblSKU SKU
    left join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
where SKU.flgActive = 1
   and SKU.flgDeletedFromSOP = 0
   and SKU.flgIntangible = 0
   and (PGC.ixMarket is NULL
       OR PGC.ixMarket not in ('R','SR','B','SM','2B'))
ORDER BY PGC.ixMarket, SKU.ixPGC


-- sales from the last 12 months attributed to Markets that CST ignores
select PGC.ixMarket, sum(OL.mExtendedPrice) Sales, count(distinct O.ixOrder) OrdCnt -- 406,470.066
from tblOrderLine OL
    join tblOrder O on OL.ixOrder = O.ixOrder
    join tblSKU SKU on SKU.ixSKU = OL.ixSKU
    left join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
where     O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate > '10/05/2011' -- between '01/01/2011' and '12/31/2011'
    and OL.flgLineStatus = 'Shipped'
    and OL.ixSKU in (
                select SKU.ixSKU
                    --, PGC.ixMarket, SKU.ixPGC, PGC.sDescription PGCDescription
                from tblSKU SKU
                    left join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
                where SKU.flgActive = 1
                   and SKU.flgDeletedFromSOP = 0
                   and SKU.flgIntangible = 0
                   and (PGC.ixMarket is NULL
                       OR PGC.ixMarket not in ('R','SR','B','SM','2B'))
               )
group by  PGC.ixMarket        
/*
SALES FROM THE LAST 12 months attributed to SKUs that belong to PGCs that are not in our "Standard Markets"
Market	              Sales	    OrdCnt
======              =======     ======
NULL	             27,351	      625
PC - PedalCar	    374,087	    3,303
SC - SportCompact         9	        2
TE - Tools & Equip    5,053	       86    

*/  




select sum(OL.mExtendedPrice) Sales
from tblOrderLine OL
    join tblOrder O on OL.ixOrder = O.ixOrder
    join tblSKU SKU on SKU.ixSKU = OL.ixSKU
    left join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
where     O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate > '10/05/2011' -- between '01/01/2011' and '12/31/2011'
    and OL.flgLineStatus = 'Shipped'
    
    
    

