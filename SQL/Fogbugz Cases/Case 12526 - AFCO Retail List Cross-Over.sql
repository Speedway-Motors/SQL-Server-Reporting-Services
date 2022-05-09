select top 10 * from tblCustomerOffer
select top 10 * from tblSourceCode

/*
Codes 32810 thru 32814
Vs.
Codes 33010 thru 33016
*/


-- OVERALL
select count(distinct ixCustomer) -- 83,201        -- 15,264
from tblCustomerOffer CO
where ixSourceCode between '32810' and '32814'
   AND ixCustomer in 
                     (
                     select distinct ixCustomer -- 50,586
                     from tblCustomerOffer CO
                     where ixSourceCode between '33010' and '33016'
                     )


-- BY SOURCE CODE
select ixSourceCode, count(distinct ixCustomer) QtyOverlap -- 7352
from tblCustomerOffer CO
where ixSourceCode between '33010' and '33016'
   AND ixCustomer in 
                     (
                     select distinct ixCustomer 
                     from tblCustomerOffer CO
                     where ixSourceCode between '32810' and '32814'
                     )
Group by ixSourceCode
order by ixSourceCode



-- BY SOURCE CODE
select ixSourceCode, count(distinct ixCustomer) -- 7352

from tblCustomerOffer CO
where ixSourceCode = '33010'
   AND ixCustomer in 
                     (
                     select distinct ixCustomer 
                     from tblCustomerOffer CO
                     where ixSourceCode between '32810' and '32814'
                     )

-- BY SOURCE CODE
select count(distinct ixCustomer) -- 7352

from tblCustomerOffer CO
where ixSourceCode = '33010'
   AND ixCustomer in 
                     (
                     select distinct ixCustomer 
                     from tblCustomerOffer CO
                     where ixSourceCode between '32810' and '32814'
                     )

-- BY SOURCE CODE
select count(distinct ixCustomer) -- 7352

from tblCustomerOffer CO
where ixSourceCode = '33010'
   AND ixCustomer in 
                     (
                     select distinct ixCustomer 
                     from tblCustomerOffer CO
                     where ixSourceCode between '32810' and '32814'
                     )

-- BY SOURCE CODE
select count(distinct ixCustomer) -- 7352

from tblCustomerOffer CO
where ixSourceCode = '33010'
   AND ixCustomer in 
                     (
                     select distinct ixCustomer 
                     from tblCustomerOffer CO
                     where ixSourceCode between '32810' and '32814'
                     )

-- BY SOURCE CODE
select count(distinct ixCustomer) -- 7352

from tblCustomerOffer CO
where ixSourceCode = '33010'
   AND ixCustomer in 
                     (
                     select distinct ixCustomer 
                     from tblCustomerOffer CO
                     where ixSourceCode between '32810' and '32814'
                     )

-- BY SOURCE CODE
select count(distinct ixCustomer) -- 7352

from tblCustomerOffer CO
where ixSourceCode = '33010'
   AND ixCustomer in 
                     (
                     select distinct ixCustomer 
                     from tblCustomerOffer CO
                     where ixSourceCode between '32810' and '32814'
                     )
select * from tblSourceCode where ixSourceCode between '32810' and '32814'
select * from tblSourceCode where ixSourceCode between '33010' and '33016'





