select sEmailAddress, ixCustomer, dtAccountCreateDate, sCustomerLastName, sMailToZip
from tblCustomer
where sEmailAddress in (
                        select sEmailAddress --, count(ixCustomer) CustCount -- 4,196 unique sEmailAddress
                        from tblCustomer
                        where sEmailAddress is NOT NULL
                          and dtAccountCreateDate >= '01/01/2010'
                        group by sEmailAddress
                        having count(ixCustomer) > 1
                        ) 
order by sEmailAddress      