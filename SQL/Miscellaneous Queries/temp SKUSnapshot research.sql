  select dtAccountCreateDate, count(*)
   from tblCustomer
   where dtAccountCreateDate > '02/06/2013'
   group by dtAccountCreateDate
      
  select ixCreateDate, count(*)
   from tblCustomerOffer
   where ixCreateDate > 16474
   group by ixCreateDate     
   
   
   
   select * from tblSKU where flgActive = 1 and flgDeletedFromSOP = 0
   and dtDateLastSOPUpdate < '03/01/2013'
   
   
   
   
   
  select count(*) from  tblSKUTransaction
 
DELETE from tblSKUTransaction
where ixDate < 16030

402-559-8700


select min(ixDate) Oldest,
       max(ixDate) Newest
from tblSKUTransaction -- 15707 = 01/01/2011

SELECT D.dtDate, count(ST.ixDate|ST.ixTime|ST.iSeq)
from tblSKUTransaction ST
    join tblDate D on ST.ixDate = D.ixDate
where ST.ixDate >= 16490--between 16000 and 16072
  and ST.sTransactionType NOT like 'SNAP%'
group by D.dtDate
order by D.dtDate




select * from tblDate where dtDate between '09/01/2011'
and '01/01/2012'



select count(*) from tblBinSku -- 248,021
select count(*) from tblSKU -- 152,586

select count(*)
from tblBinSku
where dtDateLastSOPUpdate = '03/07/2013' -- 52319


select ixDate, count(*) from tblSnapshotSKU
where ixDate >= 16497 -- '03/01/13'    
group by ixDate
order by ixDate



select ixDate, count(*)
from tblSKUTransaction
where ixDate >= 16504
group by ixDate

16504	27400 -- 45478 




select count(*)
from tblSKU
where dtDateLastSOPUpdate = '03/07/2013' -- 
and ixTimeLastSOPUpdate >= 56240 -- 3:47 PM     37

430 processed in first 4 mins   -- rowcount = 466
715 new start 1.3 records/second

select * from tblTime
where chTime between '15:44:00' and '16:00:00'


select getDate()

6:40 to do 470 records

87-139



