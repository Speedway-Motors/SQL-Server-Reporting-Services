-- Case 22867 - Analyze Country data for Canadian Email lists
select COUNT(*) from [SMITemp].dbo.PJC_CA_Race                              -- 672 in file, 587 matches in tblCustomer
select count(distinct sEmailAddress) from [SMITemp].dbo.PJC_CA_Race         -- 672
select count(distinct UPPER(sEmailAddress)) from [SMITemp].dbo.PJC_CA_Race  -- 672

select C.sMailToCountry, CAR.sEmailAddress
from [SMITemp].dbo.PJC_CA_Race CAR
join tblCustomer C on UPPER(CAR.sEmailAddress) = UPPER(C.sEmailAddress)


select count(distinct CAR.sEmailAddress) Qty,  C.sMailToCountry
from [SMITemp].dbo.PJC_CA_Race CAR
left join tblCustomer C on UPPER(CAR.sEmailAddress) = UPPER(C.sEmailAddress)
where C.flgDeletedFromSOP = 0
group by C.sMailToCountry
--
/* 672 in file
Qty	sMailToCountry
156 NOT IN Data Warehouse
44	NULL
300	CANADA
207	USA
*/



select COUNT(*) from [SMITemp].dbo.PJC_CA_Street                              -- 1891 in file, 587 matches in tblCustomer
select count(distinct sEmailAddress) from [SMITemp].dbo.PJC_CA_Street         -- 1891
select count(distinct UPPER(sEmailAddress)) from [SMITemp].dbo.PJC_CA_Street  -- 1891

select C.sMailToCountry, CAR.sEmailAddress
from [SMITemp].dbo.PJC_CA_Street CAR
join tblCustomer C on UPPER(CAR.sEmailAddress) = UPPER(C.sEmailAddress)


select count(CAR.sEmailAddress) Qty,  C.sMailToCountry
from [SMITemp].dbo.PJC_CA_Street CAR
left join tblCustomer C on UPPER(CAR.sEmailAddress) = UPPER(C.sEmailAddress)
where C.flgDeletedFromSOP = 0
group by C.sMailToCountry
/* 1,981 in Street file
Qty	sMailToCountry
50	NULL
3	CA
1247	CANADA
220	USA
*/



select COUNT(*) from [SMITemp].dbo.PJC_CA_Race 
where sEmailAddress in (select sEmailAddress from tblCustomer where flgDeletedFromSOP = 0)


select * from [SMITemp].dbo.PJC_CA_Race 
where sEmailAddress NOT in (select sEmailAddress from tblCustomer where flgDeletedFromSOP = 0)


/**** FOLLOW-UP
    Leslie asked for ixCustomer, sMailToCity,sMailToState,sMailToZip,sMailToCountry,flgMarketingEmailSubscription,sEmailAddress,sCustomerType,ixSourceCode 'Orig Source Code', ixCustomerType, dtAccountCreateDate
    for all of the matching email addresses that have the sMailToCountry = 'USA' to see if maybe the geo logic used by Bronto is incorrectly counting some US IP's as Canada.
****/
    
    
    
select 'FromRaceFile', ixCustomer, sMailToCity,sMailToState,sMailToZip,sMailToCountry,
    C.sEmailAddress, ixSourceCode 'Orig Source Code', dtAccountCreateDate
from [SMITemp].dbo.PJC_CA_Race CAR
join tblCustomer C on UPPER(CAR.sEmailAddress) = UPPER(C.sEmailAddress)
where C.flgDeletedFromSOP = 0
and C.sMailToCountry = 'USA'
order by sMailToState

select 'FromStreetFile', ixCustomer, sMailToCity,sMailToState,sMailToZip,sMailToCountry,
    C.sEmailAddress, ixSourceCode 'Orig Source Code', dtAccountCreateDate
from [SMITemp].dbo.PJC_CA_Street CAR
join tblCustomer C on UPPER(CAR.sEmailAddress) = UPPER(C.sEmailAddress)
where C.flgDeletedFromSOP = 0
and C.sMailToCountry = 'USA'
order by sMailToState




select * from [SMITemp].dbo.PJC_CA_Street A -- 363 of the email addresses are in BOTH files
join [SMITemp].dbo.PJC_CA_Race B on A.sEmailAddress = B.sEmailAddress