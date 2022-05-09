-- AFCO - SKU county by ABC Code
SELECT  ixABCCode
    , FORMAT(count(*),'###,###') SKUCnt
    , FORMAT(GETDATE(),'yyyy.MM.dd')  'AsOf'

FROM tblSKU
WHERE flgDeletedFromSOP = 0
    and flgActive = 1
GROUP BY ixABCCode
order by ixABCCode
/*
ixABC           % of 
Code	SKUCnt  all     As Of
====    ======  =====   ==========  
NULL	32,824  72      2019.06.07
A	       834   2
B	     1,871   4
C	    10,164  22 
*/

