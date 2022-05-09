-- Case 25946 - Goodguys Gift Card Analysis

select * from tblCustomer where ixCustomer = 1299264 
/*
ixCustomer	sCustomerLastName	    ixSourceCode	ixCustomerType	sCustomerType	sMailToStreetAddress1	ixLastUpdateUser	dtAccountCreateDate
1299264	    TRADESHOWS - GOODGUY	INTERNAL	    45	            Other	         VICTORY LANE	        JJM	                2013-01-21 00:00:00.000
*/

select ixCustomer,sCustomerFirstName, sCustomerLastName, 
    ixSourceCode,ixCustomerType,sCustomerType,
    sMailToStreetAddress1,dtAccountCreateDate,
    ixLastUpdateUser,ixAccountManager
from tblCustomer 
where sCustomerFirstName like '%GOODGUY%'
or sCustomerLastName like '%GOODGUY%'


select ixCustomer, ixGiftCard,dtDateIssued, mAmountIssued, mAmountOutstanding 
from tblGiftCardMaster
where ixCustomer in (1299264,1484335,284721)
and dtDateIssued between '01/01/2014' and '12/31/2014'
order by dtDateIssued

select GCM.ixCustomer, C.sCustomerLastName, 
    ixSourceCode,ixCustomerType,--,sCustomerType,
    sMailToStreetAddress1,dtAccountCreateDate,
    ixLastUpdateUser,
    COUNT(GCM.ixGiftCard) '#of$100GCs'
from tblGiftCardMaster GCM
    left join tblCustomer C on C.ixCustomer = GCM.ixCustomer
where --ixCustomer in (1299264,1484335,284721)
--and 
GCM.dtDateIssued between '01/01/2014' and '12/31/2014'
and GCM.mAmountIssued = 100
group by C.sCustomerLastName, GCM.ixCustomer,
    ixSourceCode,ixCustomerType,--,sCustomerType,
    sMailToStreetAddress1,dtAccountCreateDate,
    ixLastUpdateUser
having COUNT(GCM.ixGiftCard) > 20
order by COUNT(GCM.ixGiftCard) desc
/*
ixCustomer	(No column name)
732941	68
1299266	42
746028	39
707952	37
1299265	28
*/

select ixCustomer,sCustomerFirstName, sCustomerLastName, 
    ixSourceCode,ixCustomerType,sCustomerType,
    sMailToStreetAddress1,dtAccountCreateDate,
    ixLastUpdateUser,ixAccountManager
from tblCustomer 
where ixCustomer in ('732941','1299266','746028','707952','1299265')
