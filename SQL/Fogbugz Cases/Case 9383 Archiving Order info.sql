/*
insert into tblOrderArchive -- 4,039,197 rows   11 mins
select *
from tblOrder

insert into tblOrderLineArchive -- 16,032,229 rows   24 mins
select *
from tblOrderLine
*/

delete from tblOrder where dtOrderDate < '01/01/1991' -- 10K orders 1.44 mins
delete from tblOrder where dtOrderDate < '01/01/1992' -- 70K orders 11 mins      with feeds ON  =  6K/min
delete from tblOrder where dtOrderDate < '01/01/1993' -- 85K orders 6.75 mins    with feeds OFF = 13K/min
delete from tblOrder where dtOrderDate < '01/01/1996' -- 353K orders 18 mins     with feeds OFF = 20K/min
delete from tblOrder where dtOrderDate < '01/01/1997' -- 128K orders 37 mins     with feeds OFF =  3K/min
delete from tblOrder where dtOrderDate < '01/01/1998' -- 138K orders 7.5 mins    with feeds ON  = 18K/min
delete from tblOrder where dtOrderDate < '01/01/1999' -- 140K orders 5.3 mins    with feeds ON  = 26K/min
delete from tblOrder where dtOrderDate < '01/01/2000' -- 148K orders 5.3 mins    with feeds ON  = 28K/min
delete from tblOrder where dtOrderDate < '01/01/2001' -- 159K orders 6.1 mins    with feeds ON  = 26K/min
delete from tblOrder where dtOrderDate < '01/01/2002' -- 148K orders 8.0 mins    with feeds ON  = 18K/min
delete from tblOrder where dtOrderDate < '01/01/2003' -- 173K orders 9.5 mins    with feeds ON  = 18K/min
delete from tblOrder where dtOrderDate < '01/01/2004' -- 193K orders 12 mins     with feeds ON  = 16K/min
delete from tblOrder where dtOrderDate < '01/01/2005' -- 206K orders 16 mins     with feeds ON  = 13K/min
delete from tblOrder where dtOrderDate < '01/01/2006' -- 223K orders 17 mins    with feeds ON  = ##K/min

delete from tblOrder where dtOrderDate < '01/01/2007' -- 243K orders 17 mins    with feeds ON  = ##K/min
delete from tblOrder where dtOrderDate < '01/01/2008' -- 282K orders ### mins    with feeds ON  = ##K/min


select ixOrder 
into PJC_ArchivedOrders -- should be about 2.7m orders
from tblOrder
where ixOrder in (select ixOrder from tblOrderArchive where dtOrderDate < '01/01/2008')
order by ixOrder

select datepart(yyyy,dtOrderDate), count(*) 
from tblOrder
group by datepart(yyyy,dtOrderDate)
order by datepart(yyyy,dtOrderDate)
/*
2001	159417
2002	172741
2003	191315
2004	205577
2005	223130
2006	242931
2007	281677

2008	324274
2009	347859
2010	385022
2011	285650
*/
30 mins + 6:10-9:30 

delete from tblOrder where dtOrderDate is NULL

select datepart(yyyy,dtOrderDate), count(*) 
from tblOrderArchive
group by datepart(yyyy,dtOrderDate)
order by datepart(yyyy,dtOrderDate)


select * from tblOrder where dtOrderDate is NULL


select * 
into PJC_ArchivedOrders
from tblOrderArchive
where dtOrderDate < '01/01/2008'

set rowcount 2000000 -- 158 mins    25.3K/min  1.5m/hour
delete from tblOrderLine
where ixOrder collate SQL_Latin1_General_CP1_CS_AS in (select ixOrder from PJC_ArchivedOrders)

set rowcount 0


select count(*) from tblOrderLineArchive


/*** DELETE from tblOrdline Loop ***/
declare @runcount int
set @runcount = 0
   set rowcount 1000
WHILE @runcount < 291000
  BEGIN
   delete from tblOrderLine -- 100K/25    100K/10    60K/11  3.5K/1  
   where dtOrderDate < '01/01/1993'
set @runcount = @runcount + 1
  END
   set rowcount 0 

