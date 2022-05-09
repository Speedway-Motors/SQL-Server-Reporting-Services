-- Case 19202 - Customer File Export 

-- drop table PJC_19202_CustFile
select * from PJC_19202_CustFile  


--                                                          1,376,496 in file
select count(*) from PJC_19202_CustFile                  -- 1,376,496 in table
select count(distinct ixCustomer) from PJC_19202_CustFile-- 1,376,496 in table DISTINCT

-- 9,998 customers are in tblCustomer but not the CustFile

select count(*) from PJC_19202_CustFileMissed                   -- 9,998
select count(distinct ixCustomer) from PJC_19202_CustFileMissed -- 9,998

-- inserting the missing customers
insert into PJC_19202_CustFile
select *
from PJC_19202_CustFileMissed

select count(*) from PJC_19202_CustFile                  -- 1,386,494 in Modified table
select count(distinct ixCustomer) from PJC_19202_CustFile-- 1,386,494

-- no missing remaining customers
select C.* 
from [SMI Reporting].dbo.tblCustomer C
left join PJC_19202_CustFile CF on C.ixCustomer = CF.ixCustomer
where CF.ixCustomer is NULL
and C.flgDeletedFromSOP = 0
and C.ixAccountCreateDate < 16627





-- adding the additional columns and then populating them
update A 
set sEmailAddress = B.sEmailAddress,
   sDayPhone = B.sDayPhone,
   sNightPhone = B.sNightPhone,
   sCellPhone = B.sCellPhone,
   sFax = B.sFax
from PJC_19202_CustFile A
 join [SMI Reporting].dbo.tblCustomer B on A.ixCustomer = B.ixCustomer




-- creating | delimited output
select ixCustomer+'|'+
isnull(sCustomerFirstName,'')+'|'+
isnull(sCustomerLastName,'')+'|'+
isnull(Address1,'')+'|'+
isnull(Address2,'')+'|'+
isnull(sMailToCity,'')+'|'+
isnull(sMailToState,'')+'|'+
isnull(sMailToZip,'')+'|'+
isnull(sMailToCountry,'')+'|'+
isnull(sEmailAddress,'')+'|'+
isnull(sDayPhone,'')+'|'+
isnull(sNightPhone,'')+'|'+
isnull(sCellPhone,'')+'|'+
isnull(sFax,'')
from PJC_19202_CustFile





-- FUBAR DATA that needs to get cleaned up in SOP

select max(len(ixCustomer)) MAXixCustomer
    ,max(len(sCustomerFirstName)) MAXsCustomerFirstName
    ,max(len(sCustomerLastName)) MAXsCustomerLastName
    ,max(len(Address1)) MAXAddress1
    ,max(len(Address2)) MAXAddress2
    ,max(len(sMailToCity)) MAXsMailToCity
    ,max(len(sMailToState)) MAXsMailToState
    ,max(len(sMailToZip)) MAXsMailToZip
    ,max(len(sMailToCountry)) sMailToCountry
from PJC_19202_CustFile  

/*MAXixCustomer	MAXsCustomerFirstName	MAXsCustomerLastName	MAXAddress1	MAXAddress2	MAXsMailToCity	MAXsMailToState	MAXsMailToZip	sMailToCountry
7	45	69	82	110	38	20	10	24*/


select * from PJC_19202_CustFile
where len(sCustomerFirstName) > 30


select * from PJC_19202_CustFile
where len(sCustomerLastName) > 40

select * from PJC_19202_CustFile
where len(Address1) > 50

select * from PJC_19202_CustFile
where len(Address2) > 50

select * from PJC_19202_CustFile
where len(sMailToCity) > 30

select * from PJC_19202_CustFile
where len(sMailToState) > 15

select * from PJC_19202_CustFile
where len(sMailToCountry) > 20

select sMailToCountry, count(*) Cnt
from PJC_19202_CustFile
group by sMailToCountry
order by Cnt

-- #s & special chars
ixCustomer, sCustomerFirstName, sCustomerLastName, 
Address1, Address2, 
sMailToCity, sMailToState, sMailToZip, sMailToCountry

select * from PJC_19202_CustFile
where isnumeric(sCustomerFirstName) = 1

select * from PJC_19202_CustFile
where isnumeric(sCustomerLastName) = 1

select * from PJC_19202_CustFile
where isnumeric(sMailToCity) = 1

select * from PJC_19202_CustFile
where isnumeric(sMailToState) = 1






