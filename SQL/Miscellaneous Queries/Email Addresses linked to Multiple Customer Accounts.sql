-- Email Addresses linked to Multiple Customer Accounts
USE [SMITemp]

-- drop table [SMITemp].dbo.PJC_EmailsWithMultiCustAccounts
-- truncate [SMITemp].dbo.PJC_EmailsWithMultiCustAccounts
--insert into[SMITemp].dbo.PJC_EmailsWithMultiCustAccounts
select distinct sEmailAddress, count(ixCustomer) 'AcctsUsingThisAddress'
--into [SMITemp].dbo.PJC_EmailsWithMultiCustAccounts
from [SMI Reporting].dbo.tblCustomer
where flgDeletedFromSOP = 0
  and sEmailAddress is NOT NULL
group by sEmailAddress
having count(ixCustomer) > 1
order by sEmailAddress 

-- most reused accounts
select AcctsUsingThisAddress, sEmailAddress
from [SMITemp].dbo.PJC_EmailsWithMultiCustAccounts
order by AcctsUsingThisAddress desc
/* @08/15/2014
AcctsUsing
ThisAddress	sEmailAddress
68	        NONE@NONE.COM
27	        SALES@SPEEDWAYMOTORS.COM
19	        INFO@GYPSYCRUISERS.COM
18	        MAGSAPLENTY@GMAIL.COM
12	        LYLETUCKER@GMAIL.COM
11	        NONE@YAHOO.COM
11	        DYNAMICRIDES@HOTMAIL.COM
11	        ALADDIN_31@YAHOO.COM
10	        JJMALCOM@SPEEDWAYMOTORS.COM
10	        NONE@AOL.COM
9	        NONE@SPEEDWAYMOTORS.COM
8	        ESCORTMAN@WEB.DE
7	        TEST@TESTING.COM
6	        STUDE532004@YAHOO.COM
6	        NONE@HOTMAIL.COM
6	        NOEMAIL@NOEMAIL.COM
6	        JJAUTO87@AOL.COM
6	        JEREMY.ATER@GMAIL.COM
6	        INFO@SPECIALPARTS.CH
6	        ALLAMER1990@HOTMAIL.COM
6	        BIGCREEKRESTORATION@HOTMAIL.COM
5	        BLHARCROW@YAHOO.COM
5	        BHOODRACING42@YAHOO.COM
5	        BOB@AOL.COM
*/

select ixCustomer 
from [SMI Reporting].dbo.tblCustomer C
    join [SMITemp].dbo.PJC_EmailsWithMultiCustAccounts MA on C.sEmailAddress = MA.sEmailAddress -- 48311
where C.flgDeletedFromSOP = 0






select C.ixCustomer, C.sEmailAddress, MA.AcctsUsingThisAddress, C.dtDateLastSOPUpdate
from [SMI Reporting].dbo.tblCustomer C
    join [SMITemp].dbo.PJC_EmailsWithMultiCustAccounts MA on C.sEmailAddress = MA.sEmailAddress
where C.flgDeletedFromSOP = 0
order by C.sEmailAddress,  C.sCustomerFirstName, C.sCustomerLastName



