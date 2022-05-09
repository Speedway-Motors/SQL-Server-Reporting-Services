-- SMIHD-4649 - Provide Mailing data for Responsys file



USE [SMITemp]
GO
/****** Object:  Table [dbo].[PJC_SMIHD4649_ResponsysCustMailingInfo]    Script Date: 06/01/2016 17:10:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJC_SMIHD4649_ResponsysCustMailingInfo](
	[RIID] [varchar](50) NULL,
	[ixCustomer] [varchar](50) NULL,
	[RI_EMAIL] [varchar](50) NULL,
	[sMailToCity] [varchar](25) NULL,
	[sMailToState] [varchar](20) NULL,
	[sMailToZip] [varchar](15) NULL,
	[sMailToCountry] [varchar](30) NULL,
	[sCustomerFirstName] [varchar](20) NULL,
	[sCustomerLastName] [varchar](20) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO




-- DROP TABLE [SMITemp].dbo.PJC_SMIHD4649_ResponsysCustMailingInfo
SELECT COUNT(*) TotRecs, COUNT(distinct RIID) RIIDcnt
, COUNT(distinct ixCustomer) DistinctCust
FROM [SMITemp].dbo.PJC_SMIHD4649_ResponsysCustMailingInfo
/*
TotRecs	RIIDcnt	DistinctCust
139,873	139,873	138,441
*/


select ixCustomer, COUNT(*)
from [SMITemp].dbo.PJC_SMIHD4649_ResponsysCustMailingInfo
GROUP BY ixCustomer
having COUNT(*) > 1
order by COUNT(*) desc




SELECT * FROM [SMITemp].dbo.PJC_SMIHD4649_ResponsysCustMailingInfo
WHERE ixCustomer in ('1917950','1629948','290667','1069216','355867','571262','1160335','456231','1048313','1832547')
ORDER BY ixCustomer, RI_EMAIL



RIID	ixCustomer	RI_EMAIL	sMailToCity	sMailToState	sMailToZip	sMailToCountry	sCustomerFirstName	sCustomerLastName
10070902	1048313	bob@americhem.biz	NULL	NULL	NULL	NULL	NULL	NULL


update A 
set COLUMN = B.COLUMN,
   NEXTCOLUMN = B.NEXTCOLUMN
from FIRSTTABLE A
 join SECONDTABLE B on A.XXX = B.XXX


BEGIN TRAN

update RCMI 
set sMailToCity = C.sMailToCity,
   sMailToState = C.sMailToState,
   sMailToZip = C.sMailToZip,
   sMailToCountry = C.sMailToCountry,
   sCustomerFirstName = C.sCustomerFirstName,
   sCustomerLastName = C.sCustomerLastName,
   flgDeletedFromSOP = C.flgDeletedFromSOP,
   sCurrentEmail = C.sEmailAddress
from [SMITemp].dbo.PJC_SMIHD4649_ResponsysCustMailingInfo RCMI
 join tblCustomer C on RCMI.ixCustomer = C.ixCustomer
 
ROLLBACK TRAN


select * from [SMITemp].dbo.PJC_SMIHD4649_ResponsysCustMailingInfo
order by sMailToCountry

-- HOW MANY Responsys Cust #s have been deleted from SOP
select C.dtDateLastSOPUpdate
from tblCustomer C
    join [SMITemp].dbo.PJC_SMIHD4649_ResponsysCustMailingInfo RCMI on RCMI.ixCustomer = C.ixCustomer -- 741
where C.flgDeletedFromSOP = 1
order by C.dtDateLastSOPUpdate

-- how long since non-deleted accounts have been updated?
select C.ixCustomer, C.dtDateLastSOPUpdate
from tblCustomer C
    join [SMITemp].dbo.PJC_SMIHD4649_ResponsysCustMailingInfo RCMI on RCMI.ixCustomer = C.ixCustomer -- 11,186
where C.flgDeletedFromSOP = 0
and C.dtDateLastSOPUpdate < '12/30/2015'
order by C.dtDateLastSOPUpdate


select C.*
from tblMergedCustomers C
left join [SMITemp].dbo.PJC_SMIHD4649_ResponsysCustMailingInfo RCMI on RCMI.ixCustomer = C.ixCustomerOriginal
where C.flgDeletedFromSOP = 1



BEGIN TRAN

update RCMI 
set ixCustomerMergedTo = MC.ixCustomerMergedTo
from [SMITemp].dbo.PJC_SMIHD4649_ResponsysCustMailingInfo RCMI
 join tblMergedCustomers MC on RCMI.ixCustomer = MC.ixCustomerOriginal
 
ROLLBACK TRAN


UPDATE [SMITemp].dbo.PJC_SMIHD4649_ResponsysCustMailingInfo
set sMailToCountry = 'US'
where sMailToCountry is NULL


select sMailToCountry, COUNT(*) RECcount
from [SMITemp].dbo.PJC_SMIHD4649_ResponsysCustMailingInfo
group by sMailToCountry
order by COUNT(*)

SELECT * FROM  [SMITemp].dbo.PJC_SMIHD4649_ResponsysCustMailingInfo
WHERE UPPER(RI_EMAIL) <> sCurrentEmail

UPDATE [SMITemp].dbo.PJC_SMIHD4649_ResponsysCustMailingInfo
set flgEmailChange = 'Y'
WHERE UPPER(RI_EMAIL) <> sCurrentEmail


SELECT * FROM [SMITemp].dbo.PJC_SMIHD4649_ResponsysCustMailingInfo