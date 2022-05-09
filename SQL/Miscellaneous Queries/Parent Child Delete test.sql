-- Parent Child Delete test



select max (ixDate) from tblTimeClockDetail
where ixDate = 16705 -- 09/25/2013	WEDNESDAY

-- truncate table [SMITemp].dbo.tblTimeClockTemp
insert into [SMITemp].dbo.tblTimeClockTemp -- 194 records
select *
from [SMI Reporting].dbo.tblTimeClock
where ixDate in (16704,16705)

-- drop table [SMITemp].dbo.tblTimeClockDetailTemp
-- truncate table [SMITemp].dbo.tblTimeClockDetailTemp
insert [SMITemp].dbo.tblTimeClockDetailTemp -- 326 records
select *
from [SMI Reporting].dbo.tblTimeClockDetail
where ixDate  in (16704,16705)



select * from [SMITemp].dbo.tblTimeClockTemp where ixDate = 16705
select * from [SMITemp].dbo.tblTimeClockDetailTemp where ixDate = 16705

select ixEmployee, count(*) from tblTimeClockDetailTemp
group by ixEmployee
order by count(*) desc
-- KRB	3


select * from [SMITemp].dbo.tblTimeClockTemp where ixEmployee = 'KRB'
select * from [SMITemp].dbo.tblTimeClockDetailTemp where ixEmployee = 'KRB'

/*
ixDate	ixEmployee	ixTime	dtDate	    sComment
16705	KRB	        32760	2013-09-25  NULL
16704	KRB	        27953	2013-09-24  NULL

ixEmployee	ixDate	dtDate      ixTimeIn	ixTimeOut	iSecondsLogged	dtDateLastSOPUpdate	ixTimeLastSOPUpdate
KRB	        16705	2013-09-25  39945	    64743	    24798	        2013-09-27          44945
KRB	        16705	2013-09-25  67582	    75358	    7776	        2013-09-27          44945
KRB	        16705	2013-09-25  75365	    75490	    125	            2013-09-27          44945
KRB	        16704	2013-09-24  47723	    75676	    27953	        2013-09-27          44945



OBJECTIVE: Delete the single record from tblTimeClock for KRB on ixDate 16705
           that should then cause all 3 records for KRB on ixDate 16705 to be deleted from tblTimeClockDetail
*/

select count(*) from [SMITemp].dbo.tblTimeClockTemp                                 --  394 expected after delete test: 393 result:
select count(*) from [SMITemp].dbo.tblTimeClockDetailTemp                           --  662 expected after delete test: 659 result:
select count(*) from [SMITemp].dbo.tblTimeClockTemp where ixEmployee = 'KRB'        --  2   expected after delete test: 1   result:
select count(*) from [SMITemp].dbo.tblTimeClockDetailTemp where ixEmployee = 'KRB'  --  4   expected after delete test: 1   result:


select max (ixDate) from tblTimeClockDetail
where ixDate = 16705 -- 09/25/2013	WEDNESDAY


select *( from 
