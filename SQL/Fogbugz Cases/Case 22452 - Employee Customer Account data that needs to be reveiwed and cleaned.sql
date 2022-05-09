-- Case 22452 - Employee Customer Account data that needs to be reveiwed and cleaned

-- List of ixType 44 (Employee) but NOT in tblEmployee
select -- 34
ixCustomer,sCustomerFirstName,sCustomerLastName,
ixCustomerType,sCustomerType,dtAccountCreateDate,
sMailingStatus,sMailToCity,sMailToState,
iPriceLevel,dtDateLastSOPUpdate
--,flgDeletedFromSOP
from tblCustomer
where ixCustomerType = '44'
and flgDeletedFromSOP = 0
and ixCustomer NOT in (Select ixCustomer from tblEmployee where flgCurrentEmployee = 1)

UNION ALL

-- Customer accounts in tblEmployee
-- but not listed with ixCustomerType = 44
select -- 10
ixCustomer,sCustomerFirstName,sCustomerLastName,
ixCustomerType,sCustomerType,dtAccountCreateDate,
sMailingStatus,sMailToCity,sMailToState,
iPriceLevel,dtDateLastSOPUpdate
--,flgDeletedFromSOP
from tblCustomer C
where (ixCustomerType <> '44'
    or ixCustomerType is NULL)
and flgDeletedFromSOP = 0
and ixCustomer in (Select ixCustomer from tblEmployee where flgCurrentEmployee = 1)

UNION ALL

-- EX-EMPLOYEES not listed as ixCustomerType <> 6
select -- 45
ixCustomer,sCustomerFirstName,sCustomerLastName,
ixCustomerType,sCustomerType,dtAccountCreateDate,
sMailingStatus,sMailToCity,sMailToState,
iPriceLevel,dtDateLastSOPUpdate
--,flgDeletedFromSOP
from tblCustomer
where ixCustomer in (Select ixCustomer from tblEmployee where flgCurrentEmployee = 0)
and flgDeletedFromSOP = 0
and (ixCustomerType is NULL
    or ixCustomerType <> 6)
order by dtDateLastSOPUpdate, ixCustomerType



select * from tblTimeClock
where ixEmployee like '%47'



