-- SMIHD-16509 - Stock-Out Date for Discontinued SKUs

/*
select ixSKU, max (D.dtDate) LastInStock
from tblSnapshotSKU SS
    left join tblDate D on SS.ixDate = D.ixDate
where SS.ixDate between 18653 and 19016 --1/24/19 and 1/23/20
    and iFIFOQuantity > 0
GROUP BY ixSKU

select count(*) from tblSnapshotSKU where ixDate = 18653
*/


select S.ixSKU, S.dtDiscontinuedDate
into #DiscontinuedSKUs
-- DROP TABLE #DiscontinuedSKUs
from tblSKU S
    left join tblSKULocation SL on SL.ixSKU = S.ixSKU and SL.ixLocation = 99
where dtDiscontinuedDate  < '01/24/2020'  -- between '01/20/2019' and '01/20/2020'
    and flgDeletedFromSOP = 0 
    and SL.iQAV = 0  -- 227,081

select DS.ixSKU, DS.dtDiscontinuedDate, max (D.dtDate) 'LastInStock'
from #DiscontinuedSKUs DS
    left join tblSnapshotSKU SS on DS.ixSKU = SS.ixSKU
    left join tblDate D on SS.ixDate = D.ixDate
where SS.ixDate between 18649and 19013 --1/20/19 and 1/20/20       18653
    and SS.iFIFOQuantity > 0
GROUP BY DS.ixSKU, DS.dtDiscontinuedDate





