-- Sales and Order counts by Year and Period    
select D.iPeriodYear, D.iPeriod, SUM(O.mMerchandise) Sales, COUNT(ixOrder) 'OrderCount' -- 38,310
from tblOrder O
join tblDate D on O.ixOrderDate = D.ixDate
-- join tblDate D2 on O.ixShippedDate = D2.ixDate
where  D.iPeriodYear between 2010 and 2016 
    and O.sOrderStatus = 'Shipped'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    --and D.iPeriod = D2.iPeriod
GROUP BY D.iPeriodYear, D.iPeriod   
ORDER BY D.iPeriodYear, D.iPeriod         








