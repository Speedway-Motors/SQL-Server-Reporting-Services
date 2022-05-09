-- Case 24447 - Data for customers with a WA Mailing address

select ixCustomer 'Customer'
    , sCustomerFirstName 'FirstName'
    , sCustomerLastName 'LastName'
    , sMailToState 'MailToState' 
    , flgTaxable 'Taxable'
    , ixCustomerType 'CustFlag'
    , sCustomerType 'CustType' 
from tblCustomer
where sMailToState = @State -- 44,346
    and flgTaxable = 0 -- 31
    and flgDeletedFromSOP = 0
    

    
    
select distinct sOrderStatus from tblOrder   

-- drop-down for @State
select ixState from tblStates
where flgContiguous = 1
    or flgNonContiguous = 1
order by ixState


