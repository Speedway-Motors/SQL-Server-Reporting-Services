/*********** LNK-DW1 **************/
select count(*) from tblOrder -- 1,527,294   524,608

select count(*) from tblOrderArchive --   524,608
where dtOrderDate >= '01/01/2007'




/*********** DOMINO **************/
select * -- 1,527,390
into PJC_tblOrderBackup
from tblOrder


select * -- 6,458,618   
into PJC_tblOrderLineBackup
from tblOrderLine


insert into tblOrder -- 2 mins
select *
from [SMIArchive].dbo.tblOrderArchive
where dtOrderDate >= '01/01/2006'
and ixOrder not in (select ixOrder COLLATE Latin1_General_CS_AS from tblOrder)



exec spSOPFeedLog


select * from tblOrder
where dtOrderDate < '01/01/2005'
and ixOrder NOT in (Select ixOrder COLLATE Latin1_General_CS_AS from [SMIArchive].dbo.tblOrderArchive)



-- list of 2007 orders not already in tblOrderLine
select distinct ixOrder 
into PJC_2007OLtoLoad -- 281443
from tblOrderLineArchive
where ixOrderDate >= 14246 -- '01/01/2007'
 and ixOrder COLLATE Latin1_General_CS_AS not in (select distinct ixOrder  from [SMI Reporting].dbo.tblOrderLine)

insert into [SMI Reporting].dbo.tblOrderLine -- 2 mins
select *
--into PJC_OL2007test -- 1,308,499
from tblOrderLineArchive
where dtOrderDate >= '01/01/2007'
and ixOrder in (select ixOrder from PJC_2007OLtoLoad)

insert into [SMI Reporting].dbo.tblOrderLine -- 2 mins
select *
from PJC_OL2007test

select * from tblDate where dtDate = '01/01/2007' -- 14246
select * from tblDate where dtDate = '01/01/2006' -- 13881

-- 2006 OL data to load
-- drop table PJC_2006OLtoLoad
select *
into PJC_2006OLtoLoad -- 1,088,981
from tblOrderLineArchive
where ixOrderDate between 13881 and 14245
 and ixOrder COLLATE Latin1_General_CS_AS not in (select distinct ixOrder  from [SMI Reporting].dbo.tblOrderLine)



select ixOrder, count(iOrdinality)
from PJC_2006OLtoLoad
where iOrdinality = 1
  --and flgLineStatus = 'Shipped'
group by ixOrder
having count(iOrdinality) > 10


/************************
CAN POSIBLY RESET THE ORDINALIIES MANUALLY
BASED ON CREATING A UNIQUE ID IN A TEMP TABLE
THE UPDATING IORDINALITY IN TBLORDERLINEARCHIVE
WITH THOSE VALUES...
   WAITING FOR CHRIS TO ASNWER A COUPLE OF QUESTIONS
   BEFORE WRITING THE CODE
***************************/


-- TEST TABLE
-- drop table PJC_tblOrderLine_UpdateTest
select * into PJC_tblOrderLine_UpdateTest   -- 597    9,827 rows
from tblOrderLineArchive
where ixOrder in ('2484122')
order by newid()


select * from PJC_tblOrderLine_UpdateTest




select * from PJC_2006OLtoLoad
where ixOrder = '2284878'



insert into [SMI Reporting].dbo.tblOrderLine -- 2 mins
select *
from PJC_2006OLtoLoad


