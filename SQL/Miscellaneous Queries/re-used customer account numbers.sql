-- re-used customer account numbers

-- account numbers that were merged and deleted in SOP, then later re-used for new accounts
select M.ixCustomerOriginal, 
    M.ixCustomerMergedTo, 
    M.MergedBy,    
    CONVERT(VARCHAR, M.dtDateMerged, 110) 'MergedDate', 
    C.ixCustomer, 
    CONVERT(VARCHAR, C.dtAccountCreateDate, 110) 'AccountCreateDate'
from [SMITemp].dbo.PJC_MergedCustomers M
    join tblCustomer C on M.ixCustomerOriginal = C.ixCustomer
                             where C.flgDeletedFromSOP = 0
and dtDateMerged < dtAccountCreateDate 




-- problem account # from LB
select * from [SMITemp].dbo.PJC_MergedCustomers 
where ixCustomerOriginal = 2458646

select ixCustomer, dtAccountCreateDate
from tblCustomer
where ixCustomer = 2458646




select * from [SMITemp].dbo.PJC_MergedCustomers 
where ixCustomerOriginal in (select ixCustomer from tblCustomer
                             where flgDeletedFromSOP = 0)
                             
                 



select * from tblCustomerOffer
where ixCustomer = '2458646'