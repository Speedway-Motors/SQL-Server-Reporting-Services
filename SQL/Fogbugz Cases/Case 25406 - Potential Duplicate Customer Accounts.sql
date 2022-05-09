-- Case 25406 - Potential Duplicate Customer Accounts


SELECT ixCustomer, sCustomerFirstName, sCustomerLastName, ixCustomerType, sMailToCOLine,sMailToStreetAddress1, sMailToStreetAddress2, sMailToCity, sMailToState, sMailToZip, sMailToCountry, dtDateLastSOPUpdate
from tblCustomer
where isNULL(sCustomerFirstName,'NONE')+isNULL(sCustomerLastName,'NONE')+isNULL(sMailToStreetAddress1,'NONE')+isNULL(sMailToStreetAddress2,'NONE')+isNULL(sMailToCity,'NONE')+isNULL(sMailToState,'NONE')+isNULL(sMailToZip,'NONE') in(
                                                                                            select isNULL(sCustomerFirstName,'NONE')+isNULL(sCustomerLastName,'NONE')+isNULL(sMailToStreetAddress1,'NONE')+isNULL(sMailToStreetAddress2,'NONE')+isNULL(sMailToCity,'NONE')+isNULL(sMailToState,'NONE')+isNULL(sMailToZip,'NONE')
                                                                                            from tblCustomer
                                                                                            where flgDeletedFromSOP = 0
                                                                                                and sCustomerType = 'Retail'
                                                                                                and ixCustomerType = '1' 
                                                                                                and ixCustomer in (select ixCustomer from vwCSTStartingPool)  
                                                                                            group by isNULL(sCustomerFirstName,'NONE')+isNULL(sCustomerLastName,'NONE')+isNULL(sMailToStreetAddress1,'NONE')+isNULL(sMailToStreetAddress2,'NONE')+isNULL(sMailToCity,'NONE')+isNULL(sMailToState,'NONE')+isNULL(sMailToZip,'NONE')
                                                                                            HAVING COUNT(*) > 1
                                                                                            )
    and sCustomerType = 'Retail'  
    and ixCustomerType = '1'  
    and ixCustomer in (select ixCustomer from vwCSTStartingPool)                                                                                        
order by isNULL(sCustomerFirstName,'NONE')+isNULL(sCustomerLastName,'NONE')+isNULL(sMailToStreetAddress1,'NONE')+isNULL(sMailToStreetAddress2,'NONE')+isNULL(sMailToCity,'NONE')+isNULL(sMailToState,'NONE')+isNULL(sMailToZip,'NONE')                                                                                           
-- 541 rows returned @2-5-2015











select * from tblCustomerType where ixCustomerType = '82.1'
