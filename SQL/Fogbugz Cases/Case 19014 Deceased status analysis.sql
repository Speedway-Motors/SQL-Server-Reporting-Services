-- Case 19014 Deceased status analysis
USE [SMITemp]



-- flagged deceased by RRD AND Dingley
select * from PJC_19014_Confirmed_Deceased  -- 251

-- flagged deceased by RRD but NOT Dingley  3,778 originally... 253 exempt... leaves 3,525
select * from PJC_19014_Potential_Deceased  

select PD.ixCustomer, C.sMailingStatus
from PJC_19014_Potential_Deceased PD
left join [SMI Reporting].dbo.tblCustomer C on PD.ixCustomer = C.ixCustomer
order by C.sMailingStatus

-- remove customers already unflagged and now "deceased exempt"
DELETE FROM PJC_19014_Potential_Deceased
WHERE ixCustomer in (select PD.ixCustomer
from PJC_19014_Potential_Deceased PD
left join [SMI Reporting].dbo.tblCustomer C on PD.ixCustomer = C.ixCustomer
where C.sMailingStatus = 0)


-- remove customers delted from SOP     -2
DELETE FROM PJC_19014_Potential_Deceased
WHERE ixCustomer in (select PD.ixCustomer
from PJC_19014_Potential_Deceased PD
left join [SMI Reporting].dbo.tblCustomer C on PD.ixCustomer = C.ixCustomer
where C.flgDeletedFromSOP = 1)

-- 3,523 remaining
-- 1,810 have placed an order in the past 4 years and qualify to be in the CST starting pool

select PD.ixCustomer, C.sMailingStatus, C.flgDeletedFromSOP
from PJC_19014_Potential_Deceased PD
left join [SMI Reporting].dbo.tblCustomer C on PD.ixCustomer = C.ixCustomer
order by C.flgDeletedFromSOP,C.sMailingStatus

/* PER PHILIP - REMOVE deceased flag from the 3,523 customers */

-- List of customers that we changed the sMailingStatus from 8 to 0 on 6-27-13
select * from PJC_19014_CustsDeceasedFlgCleared




 
 

