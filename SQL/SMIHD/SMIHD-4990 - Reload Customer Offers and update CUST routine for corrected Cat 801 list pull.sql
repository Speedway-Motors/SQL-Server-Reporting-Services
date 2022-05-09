-- SMIHD-4990 - Reload Customer Offers and update CUST routine for corrected Cat 801 list pull

-- currently marked incorrect customers
select ixSourceCode, count(*) RecCount, getdate() 'As of'
from tblCustomerOffer where ixSourceCode like '801%'
group by ixSourceCode
/*
Source  Rec
Code	Count   As of
======  ======= ================
80150	237	2016-07-19 13:34:17.757
*/


-- After all customers above have had their customer offers removed, load the final list provided by Alaina



