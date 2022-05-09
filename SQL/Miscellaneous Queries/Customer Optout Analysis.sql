select ixSourceCode, count(*) Qty
from tblCustomerOffer
where ixSourceCode like '367%'
group by ixSourceCode

select top 10 * from tblMailingOptIn order by newid()
/*
ixCustomer	ixMarket	sOptInStatus	dtLastUpdate	        ixLastUpdateTime	sUserLastUpdated
673789	    AD	        UK	            2003-07-15 00:00:00.000	1	                SQL
730174	    SR	        UK	            2004-07-06 00:00:00.000	1	                SQL
913410	    AD	        UK	            2007-05-02 00:00:00.000	1	                SQL
645967	    R	        UK	            2003-03-04 00:00:00.000	1	                SQL
1049644	    AD	        UK	            2008-09-16 00:00:00.000	1	                SQL
664129	    AD	        UK	            2003-05-30 00:00:00.000	1	                SQL
943501	    SM	        UK	            2007-09-07 00:00:00.000	1	                SQL
1143414	    SM	        UK	            2009-04-12 00:00:00.000	1	                SQL
769904	    R	        UK	            2005-03-02 00:00:00.000	1	                SQL
1221323	    2B	        UK	            2010-03-07 00:00:00.000	1	                SQL
*/


select count(*) -- 6,645,480
from tblMailingOptIn

select count(*) -- 6,645,480
from tblMailingOptIn

select MOI.ixMarket, MOI.sOptInStatus, count(MOI.sOptInStatus) QTY
from tblMailingOptIn MOI
    join tblCustomer C on MOI.ixCustomer = C.ixCustomer
where MOI.sUserLastUpdated NOT IN ('SQL','PSG','BATCH')
  and C.dtAccountCreateDate >= '01/01/2011'
group by  MOI.ixMarket, MOI.sOptInStatus
order by  MOI.ixMarket, MOI.sOptInStatus

select sUserLastUpdated, count(*)
from tblMailingOptIn
group by sUserLastUpdated
order by count(*) desc


select * from tblEmployee where ixEmployee = 'JLH2'
select * from tblEmployee where ixEmployee = 'DJH'
select * from tblEmployee where ixEmployee = 'KKM'
select * from tblEmployee where ixEmployee = 'BJI'
select * from tblEmployee where ixEmployee = 'ADB'
select * from tblEmployee where ixEmployee = 'EEP'
select * from tblEmployee where ixEmployee = 'LDD'
select * from tblEmployee where ixEmployee = 'MRU'