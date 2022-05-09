-- tblCustomer checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblCustomer%'
--  ixErrorCode	sDescription
--  1143	Failure to update tblCustomer

-- ERROR COUNTS by Day
SELECT DB_NAME() AS 'DB          '
    ,FORMAT(dtDate,'yyyy.MM.dd') AS 'Date    '
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster    
WHERE ixErrorCode = '1143'
  and dtDate >=  DATEADD(month, -240, getdate()) -- past X months
GROUP BY dtDate
--HAVING count(*) > 10
ORDER BY dtDate Desc
/*
DB          	Date    	ErrorQty
=============   ==========  ========
SMI Reporting	2019.01.22	2

SMI Reporting	2018.11.13	1
SMI Reporting	2018.11.12	2
SMI Reporting	2018.11.09	2
SMI Reporting	2018.11.08	5
SMI Reporting	2018.11.07	4
SMI Reporting	2018.11.05	3
SMI Reporting	2018.10.31	1
SMI Reporting	2018.10.05	1
SMI Reporting	2018.10.04	1
SMI Reporting	2018.04.26	10

AFCOReporting	2015.01.19	1
AFCOReporting	2014.10.07	12
*/


/************************************************************************/
select count(*) from tblCustomer -- 1,434,876 @8-26-2013

select * from tblErrorLogMaster
where ixErrorCode = '1143'
--and dtDate >= '07/26/2013'
-- dtDateLastSOPUpdate = '07/19/2013'


select flgDeletedFromSOP, count(*) Qty 
from tblCustomer 
group by flgDeletedFromSOP
/*
DataBaseName	Date      	flgDeletedFromSOP	  QTY
SMI Reporting	04-07-14	0	                1,463,025
SMI Reporting	04-07-14	1	                   38,265
SMI Reporting	08-26-13	0                   1,409,107
SMI Reporting	08-26-13	1                      25,769
*/

/**** Recent merge history ******/
select count(ixCustomer)
from tblCustomer
where dtAccountCreateDate > = '08-26-13'

select count(ixCustomer) 
from tblCustomer
where dtAccountCreateDate > = '08-26-13' -- 30,158
and flgDeletedFromSOP = 1

--66,650 new customer accounts created since 8-26-13.
--  1,050 of those accounts have been merged since then.
--11,446 additional accounts (created prior to 8-26-13) have been merged since then. (38,265 - 25,769 - 1,050)





/************** last updates    *************************/
select ixCustomer from tblCustomer 
where dtDateLastSOPUpdate is NULL
and flgDeletedFromSOP = 0


select count(*) 
where flgDeletedFromSOP = 0
    and dtAccountCreateDate between '01/01/2012' and  '12/31/2012' -- 85,863 took about 130 mins to feed
    --and dtDateLastSOPUpdate < '08/27/2013'
    and flgDeletedFromSOP = 0
    and ixLastUpdateUser is NULL

select count(*) from tblCustomer where dtDateLastSOPUpdate < '08/27/2013'
select count(*) from tblCustomer where xLastUpdateUser is NULL

select ixLastUpdateUser, count(*)
from tblCustomer
group by ixLastUpdateUser
order by count(*) desc

select * from tblEmployee where ixEmployee in ('DJH','HJL','JRC2')

select count(C.ixCustomer) CustCount, D.iYear
from tblCustomer C
    left join tblDate D on C.ixAccountCreateDate = D.ixDate
group by   D.iYear
order by D.iYear desc  
/*
CustCount	iYear
 24855	2015
139250	2014
136548	2013
143465	2012
119295	2011
104248	2010
.
.
.
.
1157	1984
628	    1983
425	    1982
476	    1981
155 	NULL
*/



select C.ixCustomer, C.dtAccountCreateDate, C.sMailToZip, C.sMailToCountry,
    C.ixLastUpdateUser, 
    E.sFirstname, E.sLastname
from tblCustomer C
    left join tblEmployee E on C.ixLastUpdateUser = E.ixEmployee
where C.flgDeletedFromSOP = 0
    and C.dtAccountCreateDate > = '01/01/2014'
    and C.sMailToCountry = 'CANADA'
    and C.sMailToZip = 'F'
    and C.ixLastUpdateUser is NOT NULL


    
   
/*****************  TABLE GROWTH  *************************************/
exec spGetTableGrowth tblCustomer
/*
DB          	Rows   	    Date
=============   ======      ==========
SMI Reporting	2,510,402	2020.03.01

SMI Reporting	2,476,127	2020.01.01 ^220k
SMI Reporting	2,256,807	2019.01.01 ^208k
SMI Reporting	2,048,974	2018.01.01 ^153k
SMI Reporting	1,895,534	2017.01.01 ^138k
SMI Reporting	1,757,459	2016.01.01 ^146k
SMI Reporting	1,611,300	2015.01.01 ^140k
SMI Reporting	1,471,094	2014.01.01 ^138k
SMI Reporting	1,333,004	2013.01.01 ^121k
SMI Reporting	1,211,555	2012.03.01


AFCOReporting	56,261	2020.03.01

AFCOReporting	55,330	2020.01.01
AFCOReporting	49,370	2019.01.01
AFCOReporting	43,088	2018.01.01
AFCOReporting	34,352	2017.01.01
AFCOReporting	31,339	2016.01.01
AFCOReporting	28,262	2015.01.01
AFCOReporting	24,823	2014.01.01
AFCOReporting	24,164	2013.10.01
*/

/***************** DATA FRESHNESS *************************************/

select DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), getdate(), 10) AS 'Date      ' ,* 
from vwDataFreshness
where sTableName = 'tblCustomer'
/*
DataBaseName	Date      	sTableName	Records	DaysOld
SMI Reporting	03-16-15	tblCustomer	540348	   <=1
SMI Reporting	03-16-15	tblCustomer	535248	   2-7
SMI Reporting	03-16-15	tblCustomer	127949	  8-30
SMI Reporting	03-16-15	tblCustomer	389773	 31-180
SMI Reporting	03-16-15	tblCustomer	0	      181 +
*/

-- refeed "stale" customer records
-- TRUNCATE table [SMITemp].dbo.PJC_Customers_toRefeed 
-- INSERT into [SMITemp].dbo.PJC_Customers_toRefeed 
select --count(*)
 ixCustomer   -- 103,734 @9:17   ETA 9:43
from tblCustomer 
where flgDeletedFromSOP = 0
    and dtDateLastSOPUpdate < '01/24/2015'
    and ixTimeLastSOPUpdate < = 40000
    
select count(*)   -- 439,487
from tblCustomer 
where flgDeletedFromSOP = 0
    and dtDateLastSOPUpdate < '04/01/2014'
    




  
    
/**** merged customer history ******/
SELECT DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), getdate(), 10) AS 'Date      ' ,flgDeletedFromSOP, count(*) Qty
from tblCustomer
group by flgDeletedFromSOP    
/*
DataBaseName	Date      	flgDeletedFromSOP	Qty
SMI Reporting	03-16-15	0	                1,592,554
SMI Reporting	03-16-15	1	                   43,676

SMI Reporting	04-07-14	0	                1,463,025
SMI Reporting	04-07-14	1	                   38,265
*/


-- 22,653 email addresses are shared by 2 or more non-merged accounts
select sEmailAddress, count(*)
from tblCustomer
where flgDeletedFromSOP = 0
and sEmailAddress is NOT NULL
group by sEmailAddress
having count(*) > 1
order by count(*) desc

-- 9,372 email addresses are shared by 2 or more non-merged accounts
select sEmailAddress, count(*)
from tblCustomer C
    join vwCSTStartingPool SP on C.ixCustomer = SP.ixCustomer
where flgDeletedFromSOP = 0
and sEmailAddress is NOT NULL
group by sEmailAddress
having count(*) > 1
order by count(*) desc