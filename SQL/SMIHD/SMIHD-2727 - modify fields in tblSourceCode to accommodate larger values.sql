-- SMIHD-2727 - modify fields in tblSourceCode to accommodate larger values

SELECT * 
FROM [SMI Reporting].dbo.tblSourceCode -- 10,820
WHERE dtDateLastSOPUpdate = '04/05/2016'
    and ixTimeLastSOPUpdate > 39300
order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate Desc

SELECT * 
FROM [AFCOReporting].dbo.tblSourceCode -- 10,820
--WHERE dtDateLastSOPUpdate = '04/05/2016'
--    and ixTimeLastSOPUpdate > 39300
order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate Desc


SELECT * 
FROM [AFCOReporting].dbo.tblSourceCode -- 82
WHERE dtDateLastSOPUpdate < '04/05/2016'
order by dtDateLastSOPUpdate desc

order by dtDateLastSOPUpdate desc

select max(dExpectedAverageOrderSize) from [SMI Reporting].dbo.tblSourceCode -- 600.00
select max(dExpectedAverageMargin) from [SMI Reporting].dbo.tblSourceCode    -- 458.00

select max(dExpectedAverageOrderSize) from [AFCOReporting].dbo.tblSourceCode -- 999.99
select max(dExpectedAverageMargin) from [AFCOReporting].dbo.tblSourceCode -- 50.00

select max(len(sDescription)) from [SMI Reporting].dbo.tblSourceCode -- where len(sDescription) < 45
select max(len(sDescription)) from [AFCOReporting].dbo.tblSourceCode -- 38

select (len(sDescription)), count(*) from [SMI Reporting].dbo.tblSourceCode 
group by len(sDescription)
order by len(sDescription) desc


SELECT * 
INTO [SMIArchive].dbo.BU_tblSourceCode2016_0405
from [SMI Reporting].dbo.tblSourceCode 

SELECT * 
INTO [SMIArchive].dbo.BU_tblSourceCode2016_0405_AFCO
from [AFCOReporting].dbo.tblSourceCode 


BEGIN TRAN

ALTER TABLE tblSourceCode
    ALTER COLUMN sDescription varchar(60)

ROLLBACK TRAN


BEGIN TRAN

ALTER TABLE tblSourceCode
    ALTER COLUMN dExpectedAverageOrderSize decimal(8, 2) -- origianl  decimal(5, 2) 

ROLLBACK TRAN


BEGIN TRAN

ALTER TABLE tblSourceCode
    ALTER COLUMN dExpectedAverageMargin decimal(8, 2) 

ROLLBACK TRAN


