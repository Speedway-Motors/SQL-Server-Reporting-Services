SELECT -- TOP 6000
C.ixCustomer,-- dtDateLastSOPUpdate, ixTimeLastSOPUpdate, 
    C.sCustomerFirstName, C.sCustomerLastName, C.sMailToStreetAddress1,C.sMailToStreetAddress2,C.sMailToCity,C.sMailToState,C.sMailToZip,C.sMailToStreetAddress1, C.dtAccountCreateDate, C.ixSourceCode
FROM tblCustomer C
join (-- POTENTIAL DUPES
        select sCustomerFirstName, sMailToStreetAddress1, sMailToZip, COUNT (ixCustomer) PDcount
        from tblCustomer
        where flgDeletedFromSOP = 0
            and sCustomerFirstName is NOT NULL
            and sCustomerLastName NOT LIKE '%JR%'
            and sCustomerLastName NOT LIKE '%SR%'      
            and sCustomerLastName NOT LIKE '%III%' 
            and sCustomerType = 'Retail'    
            and sMailToCountry is NULL      -- 5272  excludes international addresses
        group by sCustomerFirstName, sMailToStreetAddress1, sMailToZip
        having COUNT (ixCustomer) > 1
       -- order by COUNT (ixCustomer) desc
) PD on PD.sCustomerFirstName = C.sCustomerFirstName
    and PD.sMailToStreetAddress1 = C.sMailToStreetAddress1
    and PD.sMailToZip = C.sMailToZip 
WHERE C.flgDeletedFromSOP = 0    
ORDER BY --dtDateLastSOPUpdate, C.ixTimeLastSOPUpdate

C.sMailToZip,C.sMailToStreetAddress1,C.sCustomerFirstName, C.sCustomerLastName

