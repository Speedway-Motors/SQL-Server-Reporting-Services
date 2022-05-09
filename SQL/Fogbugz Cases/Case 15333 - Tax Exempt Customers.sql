
SELECT C.ixCustomer AS CustomerNumber
     , ISNULL(C.sCustomerFirstName, '') AS FirstName
     , ISNULL(C.sCustomerLastName, '') AS LastName
     , ISNULL(C.sMailToCity, 'No data') AS MailingCity
     , ISNULL(C.sMailToState, 'No data') AS MailingState
     , (CASE WHEN C.sMailToZip = 'F' THEN 'Foreign' 
             ELSE ISNULL(C.sMailToZip, 'No data')
        END) AS MailingZip
     , C.ixCustomerType AS CustomerFlag
     , C.iPriceLevel AS PriceLevel 
     , ISNULL(C.sDayPhone, ISNULL(C.sNightPhone, ISNULL(sCellPhone, ''))) AS PhoneNumber
     , ISNULL(C.sFax, '') AS FaxNumber
FROM tblCustomer C
WHERE C.flgTaxable = '0'
  AND C.flgDeletedFromSOP = '0'