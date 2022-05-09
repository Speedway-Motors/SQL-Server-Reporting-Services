-- SMIHD-19508 - how many SKUs ship as slapper
/*
how many slapper SKUs ship by themselves as the only item on the order (ignore intangible and inserts)?
how does this compare to the number of skus that we're currently pulling out of the main print to go into the slapper print?

count orders with 1 tangibleSKU orderline where the SKU is a SLAPR
*/

--DECLARE @ShippedDate datetime
--SELECT @ShippedDate = '12/02/2020'

SELECT D.iYear ,D.iISOWeek
    ,count(distinct OL.ixOrder) 'Orders' 
FROM tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblSKU S on OL.ixSKU = S.ixSKU
    left join tblDate D on O.ixShippedDate = D.ixDate
WHERE O.dtShippedDate between '11/30/2019' and '11/29/2020' 
    and O.sOrderStatus = 'Shipped'
    and OL.flgLineStatus = 'Shipped'
    and S.sPackageType = 'SLAPR'  -- comment out for ALL
    and O.iShipMethod NOT IN (1,8)
    and O.iTotalTangibleLines > 1  -- =1, >1, or comment out for ALL
group by D.iYear ,D.iISOWeek
order by D.iYear desc ,D.iISOWeek desc --, count(distinct OL.ixOrder) desc


/*
Bin location
Packaging Flag
Does item ship is cardboard?
*/