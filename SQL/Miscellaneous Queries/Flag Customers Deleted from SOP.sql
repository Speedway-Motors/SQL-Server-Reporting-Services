-- flag customers deleted from SOP
-- run on SMITemp

-- FIRST, verify how many records will get updated
select DEL.* 
from PJC_Customers_Deleted_From_SOP DEL
    join [SMI Reporting].dbo.tblCustomer C on DEL.ixCustomer = C.ixCustomer
    
    
-- UPDATE    
update C 
set flgDeletedFromSOP = 1
from [SMI Reporting].dbo.tblCustomer C 
 join PJC_Customers_Deleted_From_SOP DEL on C.ixCustomer = DEL.ixCustomer