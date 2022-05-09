-- Case 21959 - Create Nightly SSA Job to Populate New Fields in tblOrder

select ixOrder, count(*) as iTotalOrderLines  -- @33sec 2,912,959 rows    TOTALS  12,187,664 
from tblOrderLine
where flgLineStatus in ('Shipped','Dropshipped')
group by ixOrder
ORDER BY count(*)

select count(*) -- 12,187,665    should equal the sum of the above query
from tblOrderLine
where flgLineStatus in ('Shipped','Dropshipped')



select distinct flgLineStatus from tblOrderLine
/*
Backordered
Cancelled
Dropshipped
fail
Lost
Open
Shipped
unknown
*/

select OL.ixOrder, count(OL.iOrdinality) iTotalTangibleLines  -- @39 seconds 2,876,763 Line items   <-- NEED TO POPULATE ZEROS
    left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
where OL.flgLineStatus = 'Shipped' 
    and SKU.flgIntangible = 0
group by ixOrder



SELECT O.ixOrder, count(P.sTrackingNumber) 'iTotalShippedPackages'
from tblOrder O
    left join tblPackage P on O.ixOrder = P.ixOrder
where O.sOrderStatus = 'Shipped'   
  and P.ixShipDate is NOT NULL 
group by O.ixOrder  
order by count(P.sTrackingNumber)

select min(ixShipDate) from tblPackage -- 14695

select * from tblDate where ixDate = 14695

select distinct sOrderStatus from tblOrder
/*
Backordered
Cancelled
Open
Pick Ticket
Shipped
*/




DELETE FROM [ErrorLogging].dbo.ProcedureLog
where Field5 = 'TEST'

