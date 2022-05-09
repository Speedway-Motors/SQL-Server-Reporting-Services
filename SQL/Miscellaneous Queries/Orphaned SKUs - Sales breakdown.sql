-- Orphaned SKUs - Sales breakdown



-- Sales History
select ixSKU 'SKU', D.iYear 'Year', sum(mExtendedPrice) 'Sales'
from tblOrderLine OL
    join tblDate D on OL.ixOrderDate = D.ixDate
where ixSKU = '91082156'
group by ixSKU, D.iYear
order by ixSKU, D.iYear desc 
/*          
SKU         Year	Sales
94610006	2017	46200.00
94610006	2016	42000.00
94610006	2015	23100.00
*/

91085802
425350020ERL
91082156
91036038

-- who deleted the SKUs
select ST.sUser, E.sFirstname, E.sLastname, ST.*
from tblSKUTransaction ST
    left join tblEmployee E on ST.sUser = E.ixEmployee
where ST.sTransactionType = 'DELETE'
   -- and ixSKU = '94610006'
    and ST.ixDate >= 17867 -- 11/30/2016
    and sLocation = 99
order by ixSKU, ixDate desc

-- Delete SKU count by employee
select ST.sUser 'User  ', E.sFirstname 'Firstname', E.sLastname 'Lastname', count(distinct ST.ixSKU) 'SKUCnt'
    , CONVERT(VARCHAR, GETDATE(), 102)  AS  'As Of'
from tblSKUTransaction ST
    join tblDate D on ST.ixDate = D.ixDate
    left join tblEmployee E on ST.sUser = E.ixEmployee
where ST.sTransactionType = 'DELETE'
   -- and ixSKU = '94610006'
    and D.dtDate >= '11/29/2016'
    and sLocation = 99
group by ST.sUser, E.sFirstname, E.sLastname   
order by count(distinct ST.ixSKU) desc
/*      First       Last        SKU
User    name        name	    Cnt	As Of
======  =========   =========== === ==========
JTM	    JASON	    MARTIN	    50	2017.11.29
JOS	    JOSH	    SULLIVAN	36	2017.11.29
JMC1	JESSE	    COWLES	    35	2017.11.29
CGN	    GREG	    NICOL	    27	2017.11.29
JAK	    JEFFREY	    KARLS	    23	2017.11.29
AJBIII	ANDREW	    BENTON	    18	2017.11.29
NJS	    NICHOLAS	SOMMERFELD	14	2017.11.29
KDL	    KEVIN	    LARKINS	    8	2017.11.29
DMW	    DEAN	    WINDLE	    5	2017.11.29
DAS	    DUSTIN	    SMALL	    4	2017.11.29
JDS	    JASON	    SMITH	    4	2017.11.29
JMM	    JOHN	    MOSS	    4	2017.11.29
PSG 	PHOENIX     SYSTEMS		1	2017.11.29

*/