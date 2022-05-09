-- Case 23601 - find missing Bronto customer numbers

select * from PJC_23601_Bronto_MissingCustNumbers
order by ixCustomer

select count(*) from PJC_23601_Bronto_MissingCustNumbers                        -- 4,627
select count(distinct sEmailAddress) from PJC_23601_Bronto_MissingCustNumbers   -- 4,627

-- still missing ixCustomer
select count(*)
from PJC_23601_Bronto_MissingCustNumbers   -- 651
where ixCustomer is NULL



"""STEVE.BRANNAN@GMAIL.COM"


select * from PJC_23601_Bronto_MissingCustNumbers -- 219
where sEmailAddress like '%"%'


select sEmailAddress, REPLACE(sEmailAddress,'"','')
from PJC_23601_Bronto_MissingCustNumbers -- 219
where sEmailAddress like '%"%'

update PJC_23601_Bronto_MissingCustNumbers
set sEmailAddress = REPLACE(sEmailAddress,'"','')
where sEmailAddress like '%"%'

select B.*, C.ixCustomer, C.sEmailAddress
from PJC_23601_Bronto_MissingCustNumbers B
   left join [SMI Reporting].dbo.tblCustomer C on C.sEmailAddress = B.sEmailAddress
where B.ixCustomer is NULL
order by B.ixCustomer

update A 
set ixCustomer = B.ixCustomer
from PJC_23601_Bronto_MissingCustNumbers A
 join [SMI Reporting].dbo.tblCustomer B on A.sEmailAddress = B.sEmailAddress


select * 
from PJC_23601_Bronto_MissingCustNumbers   -- 651
where ixCustomer is NOT NULL