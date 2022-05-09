-- SMIHD-5701 - Dropship Summary by Month and Channel

SELECT Distinct sOrderChannel
from tblOrder
where dtOrderDate >= '1/1/16'


select O.sOrderChannel, COUNT(*)
from tblDropship DS
join tblOrder O on DS.ixOrder = O.ixOrder
WHERE O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '01/01/2016' and '12/31/2016'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
GROUP BY sOrderChannel    



select O.sOrderChannel, O.ixOrder
from tblDropship DS
join tblOrder O on DS.ixOrder = O.ixOrder
WHERE O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '01/01/2016' and '12/31/2016'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and sOrderChannel = 'COUNTER'
    
    
SELECT * from tblOrder where ixOrder in ('6680461','6051772')
SELECT * from tblOrderLine where ixOrder in ('6680461','6051772')
SELECT * from tblDropship where ixOrder in ('6680461','6051772')

SELECT * from tblOrder where ixOrder in ('6275494')
SELECT * from tblOrderLine where ixOrder in ('6275494')
SELECT * from tblDropship where ixOrder in ('6275494')



select * from tblDropship
where iQty > 5 
and ixActualShipDate >= 17807
/*
Order	Qty	SKU	        Description	                Price   ExtPrice
6275494	8	10610753	AFCO STL BIG BODY 7" SHOCK	83.98   671.84
*/

/*
	January		
Channels	Qty	Retail $	% Sales/Month
Catalog	50	$5,500	50.0%
Digital	30	$3,500	30.0%
Email	20	$2,000	20.0%

*/

-- To populate "SMIHD-5701 - Dropship Summary by Month and Channel.xlsx":
select D.iMonth, D.sMonth 'Month',
        (CASE WHEN O.sOrderChannel IN ('FAX','MAIL','PHONE') THEN 'Catalog'
             WHEN O.sOrderChannel IN ('AMAZON','AUCTION','WEB') THEN 'Digital'
             WHEN O.sOrderChannel = 'COUNTER' THEN 'Counter'
             ELSE O.sOrderChannel
             END
        ) OrderChannel, 
        SUM(OL.iQuantity) 'QTY',
        SUM(OL.mExtendedPrice) 'OLExtPrice'
from tblDropship DS
    join tblOrder O on DS.ixOrder = O.ixOrder
    join tblDate D on D.ixDate = O.ixOrderDate
    join tblOrderLine OL on DS.ixOrder = OL.ixOrder and DS.ixSKU = OL.ixSKU
WHERE O.sOrderStatus = 'Shipped'
    and O.dtOrderDate between '01/01/2016' and '12/31/2016'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and OL.flgLineStatus = 'Dropshipped'
    and O.sOrderChannel <> 'INTERNAL'
GROUP BY D.iMonth, D.sMonth, 
        (CASE WHEN O.sOrderChannel IN ('FAX','MAIL','PHONE') THEN 'Catalog'
             WHEN O.sOrderChannel IN ('AMAZON','AUCTION','WEB') THEN 'Digital'
             WHEN O.sOrderChannel = 'COUNTER' THEN 'Counter'
             ELSE O.sOrderChannel
             END) 
ORDER BY  D.iMonth,
        (CASE WHEN O.sOrderChannel IN ('FAX','MAIL','PHONE') THEN 'Catalog'
             WHEN O.sOrderChannel IN ('AMAZON','AUCTION','WEB') THEN 'Digital'
             WHEN O.sOrderChannel = 'COUNTER' THEN 'Counter'
             ELSE O.sOrderChannel
             END) 




select ixOrder, COUNT(*)
from tblDropship 
group by ixOrder
order by COUNT(*) desc

SELECT * FROM tblOrderLine where ixOrder = '4713251'

SELECT * FROM tblDropship where ixOrder = '6133564'      

