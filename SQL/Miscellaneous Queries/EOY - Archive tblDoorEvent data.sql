-- EOY - Archive tblDoorEvent data
select * from tblDoorEventArchive where iEventTimeDate > 1420070401 -- Unix TimeStamp for 1/1/2015 12:00:01AM

select * from tblDoorEvent
where select * from tblDoorEventArchive where iEventTimeDate < 1420070401 


-- Archive current years data
select *    -- 147322 rows
-- DROP TABLE [SMIArchive].dbo.BU_tblDoorEvent_12312015
into [SMIArchive].dbo.BU_tblDoorEvent_12312015
from tblDoorEvent
where iEventTimeDate < 1420070401 -- Unix TimeStamp for 1/1/2015 12:00:01AM

select *    -- 201219 rows
-- DROP TABLE [SMIArchive].dbo.BU_tblDoorEventArchive_12312015
into [SMIArchive].dbo.BU_tblDoorEventArchive_12312015
from tblDoorEventArchive
where iEventTimeDate < 1420070401 -- Unix TimeStamp for 1/1/2015 12:00:01AM
                                        -- BEFORE New Year Switch
select count(*) from tblCard            --     954
select count(*) from tblCardUser        -- 102,153
select count(*) from tblDoorEvent       -- 147,341
select count(*) from tblDoorEventArchive-- 201,219

SELECT count(*) from  [SMIArchive].dbo.BU_tblDoorEventArchive_12312015

select *    -- 1143 rows
into [SMIArchive].dbo.BU_tblCard_12312015
from tblCard


select *    -- 225916 rows
into [SMIArchive].dbo.BU_tblCardUser_12312015
from tblCardUser

select *    -- 954 rows
--into [SMIArchive].dbo.BU_tblDoorEvent_12312015
from tblDoorEvent


select
ixEventId, ixCardScanNum, dtEventTimeDate, sAction, iEventTimeDate
from tblDoorEvent
order by iEventTimeDate


select * from tblDoorEvent                      -- range 2014-04-14 09:38:12.000 to 2014-12-31 22:13:48.000     NEWEST
order by dtEventTimeDate

select * into tblDoorEventArchive041514to123114
from tblDoorEvent

select * from tblDoorEventArchive010114to041414 -- 2014-01-01 09:32:34.000 to 2014-04-14 09:34:53.000   
order by dtEventTimeDate

select * from tblDoorEventArchive                -- range 2013-01-01 19:17:21.000 to 2013-12-31 20:05:13.000    OLDEST
into tblDoorEventArchive2014
order by dtEventTimeDate



SELECT * FROM vwDoorEvent
ORDER BY dtEventTimeDate


SET ROWCOUNT 10000

BEGIN TRAN
DELETE from [SMI Reporting].dbo.tblDoorEventArchive 
--order by dtEventTimeDate
COMMIT TRAN

SELECT COUNT(*) 
from tblDoorEventArchive     -- 191,219


DROP table [SMIArchive].dbo.tblDoorEventArchive2015

select * from tblDoorEventArchive

SELECT * FROM [SMIArchive].dbo.tblDoorEventArchive2015

ixEventId	ixCardScanNum	dtEventTimeDate	sAction	iEventTimeDate
2	909562299	2015-01-01 10:17:37.000	Entry	1420129057


set rowcount 0


--if you want to insert the identify column you have to turn the identify field on.
SET IDENTITY_INSERT tblDoorEventArchive ON
GO

INSERT INTO [SMI Reporting].dbo.tblDoorEventArchive 
    SELECT ixEventId, ixCardScanNum, dtEventTimeDate, sAction, iEventTimeDate
    FROM [SMI Reporting].dbo.tblDoorEvent
GO
--Then back off when done
SET IDENTITY_INSERT tblDoorEventArchive OFF

/*Or alter the table to not be an identify field
Note, you may also have to change it to use a list of column
*/


select top 10 * FROM [SMI Reporting].dbo.tblDoorEvent

SET IDENTITY_INSERT tblDoorEvent ON
SET IDENTITY_INSERT tblDoorEvent OFF

*/

/*
tblDoorEventArchive
tblDoorEvent
tblDoorEventArchive010114to041414
tblDoorEventArchive041514to123114


SELECT MIN(dtEventTimeDate) OLDEST, MAX(dtEventTimeDate) NEWEST
FROM tblDoorEvent
OLDEST	                NEWEST
2015-01-01 10:17:37.000	2015-12-31 23:14:53.000

SELECT MIN(dtEventTimeDate) OLDEST, MAX(dtEventTimeDate) NEWEST
FROM tblDoorEventArchive
OLDEST	NEWEST
2013-01-01 19:17:21.000	2013-12-31 20:05:13.000

SELECT MIN(dtEventTimeDate) OLDEST, MAX(dtEventTimeDate) NEWEST
FROM tblDoorEventArchive010114to041414
2014-01-01 09:32:34.000	2014-04-14 09:34:53.000

SELECT MIN(dtEventTimeDate) OLDEST, MAX(dtEventTimeDate) NEWEST
FROM tblDoorEventArchive041514to123114
2014-04-14 09:38:12.000	2014-12-31 22:13:48.000





*/