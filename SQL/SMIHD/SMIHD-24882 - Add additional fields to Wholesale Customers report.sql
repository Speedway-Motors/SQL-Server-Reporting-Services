-- SMIHD-24882 - Add additional fields to Wholesale Customers report

-- sample of all address/phone fields
SELECT ixCustomer, sCustomerFirstName,	sCustomerLastName,
	sMailToStreetAddress1	sMailToStreetAddress2, sMailToCOLine, sMailToCity,	sMailToState,sMailToZip, sMailToZipFour, sMailToCountry, sDayPhone,	sNightPhone,	sCellPhone,	sFax
FROM tblCustomer
where sCustomerType = 'PRS'
order by newid()
--ixCustomer = 284430


/* Wholesale Customers.rdl

CHANGE LOG
Version Ticket		by	Change
=======	=========== ===	=================================================
22.20.1 SMIHD-24882 PJC Add additional address and phone fields
 
DECLARE @PriceLevel INT = 3,	@CustomerType VARCHAR(5)= '30' --('30','40')
*/

 
SELECT C.ixCustomer as 'Customer#',
	convert(varchar,C.dtAccountCreateDate, 101) as 'Account Created',
	isnull(C.sCustomerFirstName,'') + ' ' + isnull(C.sCustomerLastName,'') as 'Name',
	-- Address info
	C.sCustomerFirstName 'CustFirstName',	
	C.sCustomerLastName 'CustLastName',
	C.sMailToCOLine 'COLine',
	C.sMailToStreetAddress1 'StreetAdress1', 
	C.sMailToStreetAddress2 'StreetAdress2', 
	C.sMailToCity as 'City',
	C.sMailToState as 'State',
	C.sMailToZip as 'Zip',
	RIGHT( '00000' + LTRIM( RTRIM( C.sMailToZipFour ) ), 4 ) 'ZipPlus4',
    C.sMailToCountry as 'Country',
	-- Phone info
	C.sDayPhone 'DayPhone',	
	C.sNightPhone 'NightPhone',	
	C.sCellPhone 'CellPhone',
	-- additional info
	C.iPriceLevel as 'Price Level',
    C.sCustomerType 'GeneralCustType',
    C.ixCustomerType 'CustType',
    CT.sDescription 'CustTypeDescription',
    C.ixAccountManager 'AcctMgr',
    C.sMapTerms 'MapTerms'
FROM tblCustomer C
    left join tblCustomerType CT on C.ixCustomerType = CT.ixCustomerType
WHERE C.flgDeletedFromSOP = 0
	and C.iPriceLevel in (@PriceLevel)
	and C.ixCustomerType in (@CustomerType) --('30','40')
	and C.flgDeletedFromSOP  = 0