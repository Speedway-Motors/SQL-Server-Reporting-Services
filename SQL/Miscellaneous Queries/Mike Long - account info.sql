-- Mike Long Eagle Motor Sports account info

select top 10 * from tblCustomer


select * from tblCustomer where ixCustomer in ('1073350','1155856')


select * from tblCustomer
where sEmailAddress like '%EAGLEMOTORSPORT%'


-- PHONE CHECKS
select ixCustomer, sCustomerType, ixCustomerType, iPriceLevel, 
    sCustomerFirstName, sCustomerLastName, sMailToCity, sMailToState,
    sEmailAddress, ixAccountManager, dtAccountCreateDate,
    sMapTermsLongDescription, sMailingStatus, flgDeletedFromSOP, flgTaxable
    ,sDayPhone, sCellPhone, sFax
from tblCustomer
where
     (
        sDayPhone in ('217.361.5443','217.414.2967','217.525.1884','217.525.1941','251.680.9357','402.438.0390','402.438.0392','402.438.0394','620.629.3853','855.525.1941')  
     OR sCellPhone in ('217.361.5443','217.414.2967','217.525.1884','217.525.1941','251.680.9357','402.438.0390','402.438.0392','402.438.0394','620.629.3853','855.525.1941')  
     OR sFax in ('217.361.5443','217.414.2967','217.525.1884','217.525.1941','251.680.9357','402.438.0390','402.438.0392','402.438.0394','620.629.3853','855.525.1941')
     )
AND ixCustomer NOT in ('1073350','1155856','1226052','1242462','1919438','393437','709611',
'1582019','386534','1546678','1751628','1595577','1596572','1596578','1597570')

-- MIKE LONG in Nebraska
select ixCustomer, sCustomerType, ixCustomerType, iPriceLevel, 
    sCustomerFirstName, sCustomerLastName, sMailToCity, sMailToState,
    sEmailAddress, ixAccountManager, dtAccountCreateDate,
    sMapTermsLongDescription, sMailingStatus, flgDeletedFromSOP, flgTaxable
    ,sDayPhone, sCellPhone, sFax
from tblCustomer
where sCustomerLastName = 'LONG'
and sCustomerFirstName LIKE '%MIKE%'
and sMailToState LIKE 'NE'
AND ixCustomer NOT in ('1073350','1155856','1226052','1242462','1919438','393437','709611',
'1582019','386534','1546678','1751628','1595577','1596572','1596578','1597570')


-- ALL potential matches
select C.ixCustomer
    ,CONVERT(VARCHAR, C.dtAccountCreateDate, 101) AS 'AcctCreateDate'
    ,sum(O.mMerchandise) 'SalesSince2007'
    ,C.sCustomerType, C.ixCustomerType
    ,C.iPriceLevel
    ,C.sCustomerFirstName, C.sCustomerLastName
    ,C.sMailToCity, C.sMailToState
    ,C.sEmailAddress, C.ixAccountManager
    ,C.sMapTermsLongDescription, C.sMailingStatus, C.flgTaxable
    ,C.sDayPhone, C.sCellPhone, C.sFax, C.flgDeletedFromSOP
from tblCustomer C
    left join tblOrder O on C.ixCustomer = O.ixCustomer
WHERE C.ixCustomer  in ('1073350','1155856','1226052','1242462','1919438','393437','709611',
'1582019','386534','1546678','1751628','1595577','1596572','1596578','1597570','1803935','886193', '1367852')
--AND O.dtOrderDate >= '01/01/2013'
GROUP BY C.ixCustomer
    ,C.dtAccountCreateDate
    ,C.sCustomerType, C.ixCustomerType
    ,C.iPriceLevel
    ,C.sCustomerFirstName, C.sCustomerLastName
    ,C.sMailToCity, C.sMailToState
    ,C.sEmailAddress, C.ixAccountManager
    ,C.sMapTermsLongDescription, C.sMailingStatus, C.flgTaxable
    ,C.sDayPhone, C.sCellPhone, C.sFax, C.flgDeletedFromSOP
ORDER BY 'SalesSince2007' desc
--C.dtAccountCreateDate desc


-- ORDERS from the two main accounts that DO NOT have EAGLE as the SourceCodeGiven
select sum(mMerchandise)
from tblOrder
where sSourceCodeGiven = 'EAGLE'
AND ixCustomer NOT in ('1073350','1155856')

select ixOrder, ixCustomer, mMerchandise, dtOrderDate, sOrderTaker, sSourceCodeGiven, sOrderStatus
from tblOrder
where sSourceCodeGiven <> 'EAGLE'
AND ixCustomer in ('1073350','1155856')
and sOrderStatus = 'Shipped'
order by dtOrderDate desc




select * from tblCustomer
where ixCustomerType = '31'