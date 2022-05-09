-- Case 23984 - Analysis of new customer accounts with no orders AND not in tblRequestor

-- Data Set = accounts created 2014 Q2
SELECT COUNT(distinct C.ixCustomer) -- 32,886
FROM tblCustomer C
WHERE C.dtAccountCreateDate between '04/01/2014' and '06/30/2014'
    and C.flgDeletedFromSOP = 0

-- Data Set = accounts 
--            created 2014 Q2
--            no orders
--            not in tblRequester
SELECT COUNT(distinct C.ixCustomer)         -- 32,886 total Cust records
FROM tblCustomer C
    left join tblOrder O on O.ixCustomer = C.ixCustomer
    left join tblCatalogRequest CR on C.ixCustomer = CR.ixCustomer
WHERE C.dtAccountCreateDate between '04/01/2014' and '06/30/2014'
    and C.flgDeletedFromSOP = 0
    and O.ixCustomer is NULL                -- 10,820 haven't placed an order
    and CR.ixCustomer is NULL                --   990 also not in tblRequestor   <-- 3% of the customers created in that time period
    


-- putting data set into temp table to speed up additional queries
SELECT distinct C.ixCustomer -- 32,886 total Cust records
into [SMITemp].dbo.PJC_23894_ExcludedNewCustAccounts_2014Q2
FROM tblCustomer C
    left join tblOrder O on O.ixCustomer = C.ixCustomer
    left join tblCatalogRequest CR on C.ixCustomer = CR.ixCustomer
WHERE C.dtAccountCreateDate between '04/01/2014' and '06/30/2014'
    and C.flgDeletedFromSOP = 088
    and O.ixCustomer is NULL        -- haven't placed an order
    and CR.ixCustomer is NULL       -- and not in tblRequestor 990   <-- 
    

-- 0  NONE of them are in CST starting pool or CANADIAN CST starting pool
SELECT EX.ixCustomer, CST.*
FROM [SMITemp].dbo.PJC_23894_ExcludedNewCustAccounts_2014Q2 EX  
    join vwCSTStartingPool CST on EX.ixCustomer = CST.ixCustomer
    
-- 0  NONE of them are in CST starting REQUESTOR pool either
SELECT EX.ixCustomer, CST.*
FROM [SMITemp].dbo.PJC_23894_ExcludedNewCustAccounts_2014Q2 EX  
    join vwCSTStartingPoolRequestors CST on EX.ixCustomer = CST.ixCustomer    
    
-- generic detail... check country, orig SC, email address, shiptoAddress etc.    
SELECT EX.ixCustomer, C.*
FROM [SMITemp].dbo.PJC_23894_ExcludedNewCustAccounts_2014Q2 EX 
    left join tblCustomer C on EX.ixCustomer = C.ixCustomer
   
-- aprox 87% have valid looking US Mailing address data
SELECT count(EX.ixCustomer) Qty,
C.sMailToCountry, --C.sMailToZip,
FROM [SMITemp].dbo.PJC_23894_ExcludedNewCustAccounts_2014Q2 EX 
    left join tblCustomer C on EX.ixCustomer = C.ixCustomer    
--where  C.sMailToCountry is NULL   
GROUP BY  C.sMailToCountry--, C.sMailToZip
ORDER BY count(EX.ixCustomer) desc   
/*
sMailToCountry	Qty
NULL	        796 <-- 99+% have valid looking zips
USA	            87
CANADA	        54
.
.
misc            53 <-- 21 other countries
*/

SELECT count(EX.ixCustomer) Qty,
    C.ixSourceCode, SC.sDescription--C.sMailToZip,
from [SMITemp].dbo.PJC_23894_ExcludedNewCustAccounts_2014Q2 EX 
    left join tblCustomer C on EX.ixCustomer = C.ixCustomer 
    left join tblSourceCode SC on C.ixSourceCode = SC.ixSourceCode   
--where  C.sMailToCountry is NULL   
group by  C.ixSourceCode, SC.sDescription--, C.sMailToZip
order by count(EX.ixCustomer) desc  
/*
Qty	ixSourceCode	sDescription
255	UK	            STRT72MM1
195	NET	            DirectInternet
154	BUDY	        BUDY'S CATALOG
58	WCR7	        WebCatReqAFCOCT
55	2190	        INTERNET-DIRECT
53	EC	            EXISTING CUST
32	WCR3	        WebCatReqstSTRT
26	EMP	            EMPLOYEE PURCHASES
24	EBAY	        EBAY
13	375021	        BACK TO THE 50'S ST PAUL, MN
12	CTR	            COUNTER SALES
12	373012	        GOODGUYS ALL AMERICAN NATIONALS
.
.
. remaining 12SCs <10 rec ea
*/


SELECT C.*
from [SMITemp].dbo.PJC_23894_ExcludedNewCustAccounts_2014Q2 EX 
    left join tblCustomer C on EX.ixCustomer = C.ixCustomer 
    left join tblSourceCode SC on C.ixSourceCode = SC.ixSourceCode   
where  C.sMailToCountry is NULL  
    and C.ixSourceCode = 'NET' 
group by  C.ixSourceCode, SC.sDescription--, C.sMailToZip
order by count(EX.ixCustomer) desc  

select * from tblSourceCode where ixSourceCode in ('2190', 'NET')

select * from tblSourceCode
order by dtDateLastSOPUpdate



select distinct CO.ixCustomer 
from tblCustomerOffer CO
join [SMITemp].dbo.PJC_23894_ExcludedNewCustAccounts_2014Q2 EX on CO.ixCustomer = EX.ixCustomer