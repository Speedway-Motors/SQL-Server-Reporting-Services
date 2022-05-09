select C.sMailToState, COUNT(distinct C.ixCustomer) CustCnt 
from tblCustomer C
    join tblCustomerOffer CO on C.ixCustomer = CO.ixCustomer
where (CO.ixSourceCode like '339%'
    or CO.ixSourceCode like '340%')
--and C.sMailToState = 'NE'    -- 16,252
group by C.sMailToState
order by CustCnt
    




    
select distinct ixSourceCode
from tblCustomerOffer CO
where (CO.ixSourceCode like '339%'
    or CO.ixSourceCode like '340%')
order by ixSourceCode    


-- 

select count(distinct CO.ixCustomer) -- 526729
from tblCustomerOffer CO
    join tblCustomer C on CO.ixCustomer = C.ixCustomer
    join tblStates S on C.sMailToState = S.ixState
where (CO.ixSourceCode like '339%')
    --or CO.ixSourceCode like '340%')
and CO.ixSourceCode not in ('33957','33958') -- Bills Buddys & Dealers
and (S.flgNonContiguous = 1 OR S.flgContiguous = 1) -- 50 states + DC
and C.sMailToState <> 'DC'

and CO.ixSourceCode in 
     ('340708','340718','340728')

('33970','33971','33972','33973','33974')
(select ixSourceCode from PJC_339_Production_Pulls)



33957 -- 14
33958 -- 464 


select * from tblSourceCode
where ixSoureCode
 
 
 
select * from tblStates
where flgNonContiguous = 1