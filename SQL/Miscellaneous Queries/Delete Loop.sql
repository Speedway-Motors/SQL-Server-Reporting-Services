declare @runcount int
set @runcount = 0
   set rowcount 1000
WHILE @runcount < 143
  BEGIN
   delete from tblOrderLine -- 1287791    291K/72    100K/25    100K/10    60K/11  3.5K/1  
   where dtOrderDate < '01/01/2008'
set @runcount = @runcount + 1
  END
   set rowcount 0 

select count(*) from tblOrderLine -- 5,704,406     1,346,752
where dtOrderDate < '01/01/2008' -- 142K




sp_who2




select * from tblOrder
where dtOrderDate = '08/14/2011' -- as of 12:20PM     SUN 402   MON 18
   and sOrderStatus = 'Shipped'

order by ixOrder





select max(dtOrderDate) -- 2011-08-12 00:00:00.000
from tblOrderArchive


select * from tblOrderLine -- 
select * from tblOrderLineArchive
