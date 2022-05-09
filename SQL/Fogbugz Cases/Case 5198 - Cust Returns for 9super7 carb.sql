/*
CASE 5198
Excel list of customers who
returned a 9super7 carb for any reason. Please exclude any customer who
does not have an email address on file with us. I will need the
following info:

*        Order Date
*        Order Number
*        Customer First Name
*        Customer Last Name
*        Email Address

*/
-- select * from tblCreditMemoDetail where ixSKU = '91511655'

select CMM.dtCreateDate CreditMemoDate,CMM.ixCreditMemo,
    C.sCustomerFirstName FirstName,
    C.sCustomerLastName  Lastname,
    C.sEmailAddress      Email,
     CMD.sReturnType, CMD.sReasonCode, CMD.iQuantityCredited QTYCredited
    
from tblCreditMemoDetail CMD
    join tblCreditMemoMaster CMM on CMM.ixCreditMemo = CMD.ixCreditMemo
    join tblCustomer C on C.ixCustomer = CMM.ixCustomer
where ixSKU = '91511655'
    and C.sEmailAddress is not null
order by C.sCustomerLastName,C.sCustomerFirstName


