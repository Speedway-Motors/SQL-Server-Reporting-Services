-- SMIHD-8155 - Unmark sets of customers from 80441 & 80440 Source Codes and Mark Addtiional Sets

-- BEFORE UNMARK
SELECT ixSourceCode, COUNT(*) Qty
from tblCustomerOffer
where ixSourceCode in ('80441','80440')
group by ixSourceCode
/*
ixSource
Code	Qty
80440	2024
80441	2024
*/

-- AFTER UNMARK
SELECT ixSourceCode, COUNT(*) Qty
from tblCustomerOffer
where ixSourceCode in ('80441','80440')
group by ixSourceCode
/*
ixSource
Code	Qty

*/


-- AFTER MARKING ADDITIONAL CUSTOMERS
SELECT ixSourceCode, COUNT(*) Qty
from tblCustomerOffer
where ixSourceCode in ('80441','80440')
group by ixSourceCode
/*
ixSource
Code	Qty

*/
