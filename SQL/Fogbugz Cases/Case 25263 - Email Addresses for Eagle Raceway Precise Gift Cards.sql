-- Case 25263 - Email Addresses for Eagle Raceway Precise Gift Cards

select count(*) from [SMITemp].dbo.PJC_25263_EagleRacewayPreciseGCs                     -- 112
select count(distinct ixCustomer) from [SMITemp].dbo.PJC_25263_EagleRacewayPreciseGCs   -- 112

select ER.ixCustomer,
   sCustomerFirstName,
   sCustomerLastName,
   sEmailAddress,
   flgMarketingEmailSubscription,
   sMailToCity,
   sMailToState
from [SMITemp].dbo.PJC_25263_EagleRacewayPreciseGCs ER 
    left join tblCustomer C on C.ixCustomer = ER.ixCustomer

UPDATE ER
SET FirstName = C.sCustomerFirstName,
    LastName = C.sCustomerLastName,
    EmailAddress = C.sEmailAddress,
    MailToCity = C.sMailToCity,
    MailToState = C.sMailToState
FROM [SMITemp].dbo.PJC_25263_EagleRacewayPreciseGCs ER 
    left join tblCustomer C on C.ixCustomer = ER.ixCustomer
WHERE ER.ixCustomer = C.ixCustomer        
    

select * from   [SMITemp].dbo.PJC_25263_EagleRacewayPreciseGCs
order by LastName, FirstName 


SELECT * FROM tblCustomer
where sCustomerLastName like '%123'
or sCustomerFirstName like '%123'
and flgDeletedFromSOP = 0



select * from tblSourceCode where ixSourceCode = '347500'

