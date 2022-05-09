-- SMIHD-8155 - Unmark and remark customer offers for SCs 80440 and 80441


-- CURRENTLY MARKED
SELECT ixSourceCode, COUNT(*) Qty
from tblCustomerOffer 
where ixSourceCode in ('80440', '80441')
group by ixSourceCode
/*
ixSource
Code	Qty
80440	2024
80441	2024
*/

SELECT *  
INTO [SMITemp].dbo.PJC_SMIHD8155_OrigCustOffers -- 4048
from tblCustomerOffer 
where ixSourceCode in ('80440', '80441')

-- SAVE ORIGINALLY MARKED CUSTOMERS IN NEW TABLE
SELECT ixSourceCode, COUNT(*) Qty
from [SMITemp].dbo.PJC_SMIHD8155_OrigCustOffers
where ixSourceCode in ('80440', '80441')
group by ixSourceCode
/*
Source
Code	Qty
=====   =====
80440	2,024
80441	2,024
*/

/******* NEW PLAN 
         Alaia is going to provide new lists of people that were actually sent and the new customers that were added.
         I will unmark all customers for both source codes and upload the new lists. */
         
            -- CUSTOMERS TO UNMARK
            SELECT ixSourceCode, COUNT(*) Qty
            from [SMITemp].dbo.PJC_SMIHD8155_UnmarkCustomers
            where ixSourceCode in ('80440', '80441')
            group by ixSourceCode
            /*
            Source
            Code	Qty
            =====   =====
            80440	69
            80441	49
            */

            -- CUSTOMERS TO MARK
            SELECT ixSourceCode, COUNT(*) Qty
            from [SMITemp].dbo.PJC_SMIHD8155_MarkCustomers
            where ixSourceCode in ('80440', '80441')
            group by ixSourceCode
            /*
            Source
            Code	Qty
            =====   =====
            80441	210
            */



            /* 

            FINAL EXPECTED TOTALS

            Source
            Code	Qty
            =====   =====
            80440	1,955
            80441	2,185
            */



SELECT * FROM [SMITemp].dbo.PJC_SMIHD8155_FinalCustomersToMark

-- no dupe customers
SELECT COUNT(ixCustomer) Cust, 
    COUNT(distinct ixCustomer) DistCust
FROM [SMITemp].dbo.PJC_SMIHD8155_FinalCustomersToMark
/*
Cust	DistCust
3851	3851
*/

-- expected quantities match
SELECT ixSourceCode, COUNT(*) Qty
from [SMITemp].dbo.PJC_SMIHD8155_FinalCustomersToMark
group by ixSourceCode
order by ixSourceCode
/*
ixSource
Code	Qty
80440	1854
80441	1997
*/


SELECT ixSourceCode, COUNT(*) Qty
FROM [SMITemp].dbo.PJC_SMIHD8155_FinalCustomersToMark
where ixCustomer IN (Select ixCustomer
                     FROM tblCustomerOffer
                     where ixSourceCode in ('80440','80441')
                     )
group by ixSourceCode              
/*      Qty     Qty
SC      IN      NOT IN
80440	1854    
80441	1783       
*/

SELECT ixSourceCode, COUNT(*) Qty
FROM tblCustomerOffer  
 where ixSourceCode in ('80440','80441')
and ixCustomer NOT IN (Select ixCustomer
                     FROM [SMITemp].dbo.PJC_SMIHD8155_FinalCustomersToMark
                     )
group by ixSourceCode  
/*      Qty     
SC      NOT IN  
======  ======
80440	170
80441	241
*/


SELECT * FROM [SMITemp].dbo.PJC_SMIHD8155_OrigCustOffers


SELECT * FROM [SMITemp].dbo.PJC_SMIHD8155_FinalCustomersToMark