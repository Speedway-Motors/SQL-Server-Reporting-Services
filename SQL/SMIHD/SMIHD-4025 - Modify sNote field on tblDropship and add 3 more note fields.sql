-- SMIHD-4025 - Modify sNote field on tblDropship and add 3 more note fields
-- BACK-UP tables
    SELECT *
    into [SMIArchive].dbo.tblDropship_BU2016_0330      
    from [SMI Reporting].dbo.tblDropship -- 36,176

    SELECT *
    into [SMIArchive].dbo.tblDropship_AFCOReporting_BU2016_0330      
    from [AFCOreporting].dbo.tblDropship -- 1,501

/* table is updated live

        SELECT * FROM [SMI Reporting].dbo.tblDropship
        where dtDateLastSOPUpdate = '03/30/16'
        order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc

        SELECT * from tblTime where ixTime = 49478 -- 13:44:38  
*/


-- expand 1st note column and add 3 new ones
BEGIN TRAN
    ALTER TABLE [SMI Reporting].dbo.tblDropship
    ALTER COLUMN sNote VARCHAR (50)
ROLLBACK TRAN  
  
BEGIN TRAN  
    ALTER TABLE [SMI Reporting].dbo.tblDropship
    ADD sNote2 VARCHAR(50),
        sNote3 VARCHAR(50),
        sNote4 VARCHAR(50)
ROLLBACK TRAN     
      

-- expand 1st note column and add 3 new ones
BEGIN TRAN
    ALTER TABLE [AFCOReporting].dbo.tblDropship
    ALTER COLUMN sNote VARCHAR (50)
ROLLBACK TRAN  
  
BEGIN TRAN  
    ALTER TABLE [AFCOReporting].dbo.tblDropship
    ADD sNote2 VARCHAR(50),
        sNote3 VARCHAR(50),
        sNote4 VARCHAR(50)
ROLLBACK TRAN     





select ixSpecialOrder, dtDateLastSOPUpdate, ixOrder, sNote, sNote2, sNote3, sNote4
from [SMI Reporting].dbo.tblDropship -- 115, 110 unique
where sNote is NOT NULL
and len(sNote) = 30

SELECT distinct ixSpecialOrder, dtDateLastSOPUpdate
from  [SMI Reporting].dbo.tblDropship -- 115   110 distinct special orders
where sNote is NOT NULL
and len(sNote) = 30
order by dtDateLastSOPUpdate

select * from [SMI Reporting].dbo.tblDropship
where dtDateLastSOPUpdate = '02/15/16'
order by ixOrder, ixDropship

select * from [SMI Reporting].dbo.tblDropship
WHERE ixSpecialOrder = '26187'


select * --ixSpecialOrder, dtDateLastSOPUpdate, ixOrder, sNote, sNote2, sNote3, sNote4
from [SMI Reporting].dbo.tblDropship -- 115, 110 unique
order by dtDateLastSOPUpdate

select * --ixSpecialOrder, dtDateLastSOPUpdate, ixOrder, sNote, sNote2, sNote3, sNote4
from [SMI Reporting].dbo.tblDropship 
where sNote is NOT NULL
and len(sNote) = 30
order by ixActualShipDate desc

SELECT count(distinct ixSpecialOrder) from [SMI Reporting].dbo.tblDropship
where dtDateLastSOPUpdate = '03/30/16'

SELECT distinct ixSpecialOrder from [SMI Reporting].dbo.tblDropship
WHERE --sNote is NOT NULL
    sNote2 is NOT NULL
OR sNote3 is NOT NULL
OR sNote4 is NOT NULL

select * from tblPOMaster