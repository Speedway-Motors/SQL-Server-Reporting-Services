-- Case 23540 - AFCO ixAccountManager2

select count(ixCustomer) AcctsAssigned, ixAccountManager2
from tblCustomer
where ixCustomer in (select ixCustomer from tblOrder where dtShippedDate >= '01/01/2010')
and flgDeletedFromSOP = 0
group by ixAccountManager2
order by count(ixCustomer) desc
/* 85% of accounts that have ordered YTD
   do NOT have a 2nd Account Manager Assigned
   as of 8-26-14
   
Accts       ixAccount
Assigned	Manager2
========    =========
3095	    NULL
191	        JMR
150	        5ELF
74	        5JDW
67	        5CAS
29	        5JSM
27	        5DGW
26	        RAM
5	        MQK
1	        NLB1

*/