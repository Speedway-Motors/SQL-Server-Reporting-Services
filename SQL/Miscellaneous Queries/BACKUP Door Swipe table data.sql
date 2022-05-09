-- BACKUP Door Swipe table data

/* BACKUP
    tblCard
    tblCardUser
    tblDoorEvent
    tblDoorEventArchive -- NO LONGER USED
*/

select COUNT (*) from tblCard   -- 2,762
select COUNT (*) from tblCardUser -- 3,384
select COUNT (*) from tblDoorEvent -- 165,399

select * into [SMIArchive].dbo.BU_tblCard_BU_20211231 from tblCard -- 2,762
select * into [SMIArchive].dbo.BU_tblCardUser_BU_20211231 from tblCardUser -- 3,384
select * into [SMIArchive].dbo.BU_tblDoorEvent_BU_20211231 from tblDoorEvent --  165,399

select COUNT (*) from [SMIArchive].dbo.BU_tblCard_BU_20211231         
select COUNT (*) from [SMIArchive].dbo.BU_tblCardUser_BU_20211231    
select COUNT (*) from [SMIArchive].dbo.BU_tblDoorEvent_BU_20211231   





select * from [SMIArchive].dbo.BU_tblDoorEvent_BU_20211231
order by dtEventTimeDate desc


SET IDENTITY_INSERT dbo.tblDoorEvent ON



BEGIN TRAN



    SET IDENTITY_INSERT dbo.tblDoorEvent ON  



 
    insert into dbo.tblDoorEvent (ixEventId, 	ixCardScanNum,	dtEventTimeDate,	sAction,	iEventTimeDate)
    select (ixEventId+201900000000) as 'ixEventId', 	ixCardScanNum,	dtEventTimeDate,	sAction,	iEventTimeDate
    from [SMIArchive].dbo.BU_tblDoorEvent_BU_20211231



select * from dbo.tblDoorEvent

SELECT OBJECTPROPERTY(OBJECT_ID('tblDoorEvent'), 'TableHasIdentity');



ROLLBACK TRAN




select min(ixEventId), max(ixEventId)
from [SMIArchive].dbo.BU_tblDoorEvent_BU_20211231
 from tblDoorEvent

 82243097