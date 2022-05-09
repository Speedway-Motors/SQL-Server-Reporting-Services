-- drop table PJC_OptShipOrgXRef
select ixOrder, sShipToZip, Cast (NULL as Varchar(64)) mOptimumShipOrigination
into PJC_OptShipOrgXRef
from tblOrder
where dtOrderDate >= '11/13/09' -- 384893    populated 11/21/10




set rowcount 15000
GO
update tblOrder
set sOptimalShipOrigination = (case when (dbo.BestBoonvilleTNT(sShipToZip) < dbo.BestLincolnTNT(sShipToZip)) then 'Booneville'
         else 'Lincoln'
         end
         )
where sOptimalShipOrigination is NULL
and dtShippedDate > '04/01/2009'
and dtShippedDate < '05/01/2009'
GO
set rowcount 0


select * from tblOrder where dtShippedDate > '11/25/2010'
-- 30K rows - 25 mins

select getdate() CurrentDateTimeStamp, count(*) Quant, sOptimalShipOrigination OptOrig
from tblOrder
where dtShippedDate > '03/01/2009'
and dtShippedDate < '04/01/2009'
group by sOptimalShipOrigination

/*
CurrentDateTimeStamp	Quant	OptOrig
2010-11-29 10:40:45.107	28792	NULL
2010-11-29 10:40:45.107	88	Booneville
2010-11-29 10:40:45.107	477	Lincoln
*/


select 
    ixOrder, 
    (case when (dbo.BestBoonvilleTNT(sShipToZip) < dbo.BestLincolnTNT(sShipToZip)) then 'Booneville'
         else 'Lincoln'
         end
         ) mOptimumShipOrigination -- 384886
into PJC_OptShipOrgXRef
from tblOrder
where dtOrderDate >= '11/13/10'

-- 1 minute per day of orders to update



select top 10 ixSku from tblOrderLine




select * from PJC_OptShipOrgXRef
order by ixOrder

3000060 - 3999979

select distinct sPickingBin from tblBinSku


select distinct flgAvailablePicking from tblBin


select ixSKU, count(sPickingBin) PickingBinCount
from tblBinSku
group by ixSKU
order by count(sPickingBin) desc