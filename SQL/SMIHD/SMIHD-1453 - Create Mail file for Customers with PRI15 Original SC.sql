-- SMIHD-1453 - Create Mail file for Customers with PRI15 Original SC

-- First, Last, Address 1, Address 2, City, State, Zip1, Zip2

SELECT 
    -- ixCustomer, sCustomerType, ixAccountCreateDate, 
sCustomerFirstName 'FirstName',
sCustomerLastName 'LastName',
sMailToCOLine 'C/O', 
sMailToStreetAddress1 'Address1', 
sMailToStreetAddress2 'Adress2',
-- sMailToZipFour, -- all NULL
sMailToCity 'City', 
sMailToState 'State', 
sMailToZip 'Zip'
-- sMailToCountry,sMailingStatus
--, ixSourceCode, dtAccountCreateDate, ixAccountManager, , iPriceLevel, sEmailAddress, flgMarketingEmailSubscription, ixCustomerType, sMapTerms, sMapTermsLongDescription, 
-- sCustomerMarket, ixOriginalMarket, flgDeletedFromSOP, sDayPhone, sNightPhone, sCellPhone, flgTaxable, dtDateLastSOPUpdate, ixTimeLastSOPUpdate, sFax, 
-- dtDeceasedStatusUpdateDate, flgDeceasedMailingStatusExempt, ixDeceasedStatusSource, ixLastUpdateUser, ixAccountManager2, 
FROM tblCustomer
WHERE flgDeletedFromSOP = 0
and ixSourceCode = 'PRI15'
--and sMailToZipFour is NOT NULL
order by FirstName --len(sMailToZip) desc

