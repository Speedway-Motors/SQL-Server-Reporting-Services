-- Users that can issue POs
SELECT distinct POM.ixIssuer  COLLATE SQL_Latin1_General_CP1_CI_AS, E.sFirstname  COLLATE SQL_Latin1_General_CP1_CI_AS, E.sLastname  COLLATE SQL_Latin1_General_CP1_CI_AS, E.flgCurrentEmployee
from tblPOMaster POM
    left join tblEmployee E on POM.ixIssuer  COLLATE SQL_Latin1_General_CP1_CI_AS = E.ixEmployee COLLATE SQL_Latin1_General_CP1_CI_AS
where ixPODate >= 17533 -- '01/01/2016'
AND E.flgCurrentEmployee = 1

UNION

SELECT distinct POM.ixIssuer  COLLATE SQL_Latin1_General_CP1_CI_AS, E.sFirstname  COLLATE SQL_Latin1_General_CP1_CI_AS, E.sLastname  COLLATE SQL_Latin1_General_CP1_CI_AS, E.flgCurrentEmployee
from [AFCOReporting].dbo.tblPOMaster POM
    left join [AFCOReporting].dbo.tblEmployee E on POM.ixIssuer COLLATE SQL_Latin1_General_CP1_CI_AS = E.ixEmployee COLLATE SQL_Latin1_General_CP1_CI_AS
where ixPODate >= 17533 -- '01/01/2016'
AND E.flgCurrentEmployee = 1

ORDER BY POM.ixIssuer COLLATE SQL_Latin1_General_CP1_CI_AS