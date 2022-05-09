-- Case 23606 - Sales Analysis for SKU 91027001

select * from tblSKU where ixSKU = '91027001'


-- get totals infor since 1/1/13
select SUM(OL.mExtendedPrice) 'Sales', 
       SUM(OL.iQuantity) 'QtySold'
from tblOrderLine OL
where OL.ixSKU = '91027001'
    and OL.dtShippedDate >= '01/01/2013'
    and OL.flgLineStatus = 'Shipped'
/*
Sales	    QtySold
118,816     471
*/



-- adding State
select O.sShipToState, 
       SUM(OL.mExtendedPrice) 'Sales', 
       SUM(OL.iQuantity) 'QtySold'
from tblOrderLine OL
    join tblOrder O on OL.ixOrder = O.ixOrder
where OL.ixSKU = '91027001'
    and OL.dtShippedDate > '01/01/2013' -- The first one shipped was in Dec 2013
    and OL.flgLineStatus = 'Shipped'
group by O.sShipToState    





-- Oldest Shipped Date
select min(dtShippedDate)
from tblOrderLine OL
where OL.ixSKU = '91027001' -- 2013-12-10 00:00:00.000




-- 0.00 shipped order to AZ
select *
from tblOrderLine OL
    join tblOrder O on OL.ixOrder = O.ixOrder
where OL.ixSKU = '91027001'
    and OL.dtShippedDate > '01/01/2013' -- The first one shipped was in Dec 2013
    and OL.flgLineStatus = 'Shipped'
    and O.sShipToState = 'AZ'