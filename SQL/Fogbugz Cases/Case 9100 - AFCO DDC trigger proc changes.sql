    update tblOrder
    set sOptimalShipOrigination = (case when (dbo.BestBoonvilleTNT(sShipToZip) > dbo.BestLincolnTNT(sShipToZip)) then '68' -- Lincoln
             else '99' --  Booneville
             end
             )
    where dtShippedDate between '07/15/2011' and '08/04/2011'  --ixOrder = '658276'
    --  and sOptimalShipOrigination is NULL


select count(*) QTY, sOptimalShipOrigination
from tblOrder
where dtShippedDate between '01/01/2010' and '12/31/2011'
  and ixCustomer NOT in ('12410','15242','11571','11572','11573','11574','10511') --,'10511') 
group by sOptimalShipOrigination


QTY	sOptimalShipOrigination
12949	68
29454	99



update tblOrder
 set sOptimalShipOrigination = '99'
where  sOptimalShipOrigination = 'Lincoln'
and dtShippedDate >= '01/01/2010'--'11/24/2010'
and dtShippedDate < '01/01/2011'
*/

  


select ixOrder, sOptimalShipOrigination 
from tblOrder 
where dtShippedDate > '04/01/2011'
and sShipToState = 'NE'
order by sOptimalShipOrigination


select * from tblTrailer


select sOptimalShipOrigination, count(ixOrder)
from tblOrder
where dtShippedDate > '01/01/2011'
group by sOptimalShipOrigination

insert into  tblTrailerZipTNT
select * 

from [SMI Reporting].dbo.tblTrailerZipTNT

select * from tblTrailerZipTNT