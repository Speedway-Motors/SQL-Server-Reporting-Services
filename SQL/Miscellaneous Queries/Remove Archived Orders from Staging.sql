set rowcount 10
delete 
from tblOrder
  where dtOrderDate < '01/01/2006'
and ixOrder COLLATE Latin1_General_CS_AS in (select ixOrder COLLATE Latin1_General_CS_AS from [SMIArchive].dbo.tblOrderArchive)
    
    
select count(*) from tblOrder -- 3,037,125

select count(*) from tblOrderLine -- 12,799,027


-- Delete archived orders from tblOrderLine

-- Delete archived orders from tblOrder
set rowcount 0
--DELETE
select count(*)
from tblOrder
  where dtOrderDate < '01/01/2008'
and ixOrder COLLATE Latin1_General_CS_AS in (select ixOrder COLLATE Latin1_General_CS_AS from [SMIArchive].dbo.tblOrderArchive)



/* Archived Orders recently updated */
select COUNT(*) from tblOrderLine
where dtOrderDate < '01/01/2008'

dtDateLastSOPUpdate >= '02/20/2013' 
and dtOrderDate < '01/01/2006'



select count(*)
from tblOrder
  where dtOrderDate < '01/01/2006'
  
  

select ixOrder, dtOrderDate, dtDateLastSOPUpdate
from tblOrder
  where dtOrderDate < '01/01/2006'  
order by dtOrderDate desc  


select ixOrder from [SMIArchive].dbo.tblOrderArchive

2231407,2231076




select ixOrder, count(*) from tblPackage 
where ixVerificationDate = 16489
group by ixOrder
having count(*) > 1
order by 
order by ixOrder


select ixOrder
from tblPackage 
where ixVerificationDate = 16489

select ixOrder
from tblPackage 
where ixShipDate = 16489


select *
from tblPackage 
where ixVerificationDate is NULL
order by ixShipDate desc


select sOrderStatus, count(*)
from tblOrder
group by sOrderStatus

set rowcount 0

select ORT.* from tblOrderRouting ORT
where ixOrder in 
(select ixOrder from tblOrder where iShipMethod = 1)

 AND ixOrderDate >= '16482')

select ixOrder from tblOrder where iShipMethod = '1'

select rowcount 0

ixCounterVerifiedDate
ixCounterVerifiedTime
ixCounterVerifiedUser

select count(*) from tblOrderLine where ixOrderDate between 14611 and 14977

