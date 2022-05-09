-- SMIHD-16169 - Correct Period start and end dates for 2022 through 2025 in tblDate

-- DROP TABLE [SMITemp].dbo.PJC_SMIHD16169_tblDateCorrected

select * 
into [SMITemp].dbo.PJC_SMIHD16169_tblDateCorrected
from tblDate
where dtDate between '01/01/2025' and '01/02/2026'
order by ixDate



SELECT * FROM [SMITemp].dbo.PJC_SMIHD16169_tblDateCorrected

DELETE FROM [SMITemp].dbo.PJC_SMIHD16169_tblDateCorrected
WHERE dtDate < '01/01/2022'




-- DROP table [SMIArchive].dbo.BU_tblDate_20200624
select *
into [SMIArchive].dbo.BU_tblDate_20200626
from tblDate



BEGIN TRAN

update A 
set iPeriod = B.iPeriod,
   iDayOfFiscalPeriod = B.iDayOfFiscalPeriod
from tblDate A
 join [SMITemp].dbo.PJC_SMIHD16169_tblDateCorrected B on A.ixDate = B.ixDate
where -- B.iPeriodYear = 2023
    B.ixDate between 20821   and 21187

ROLLBACK TRAN

    
-- First and Last Days of each period for specified year

DECLARE @PeriodYear int
SELECT @PeriodYear = 2019

SELECT  D.iPeriod, D.iPeriodYear,
    CONVERT(VARCHAR, D.dtDate, 101) AS 'StartDate',
    CONVERT(VARCHAR, D2.dtDate, 101) AS 'EndDate',
    D.ixDate 'ixPeriodStart',
    PE.PeriodEnd    
from tblDate D
    join (select iPeriod, MAX(ixDate) 'PeriodEnd'
          from tblDate
          where iPeriodYear = @PeriodYear
          group by iPeriod) PE on D.iPeriod = PE.iPeriod
    join tblDate D2 on  D2.ixDate = PE.PeriodEnd         
where D.iPeriodYear = @PeriodYear
    and D.iDayOfFiscalPeriod = 1
order by D.iPeriod

select * from tblDate
where iPeriodYear = 2023
order by ixDate 



SELECT ixDate, dtDate, iPeriod, iYear, iPeriodYear, iDayOfFiscalYear, iDayOfFiscalPeriod 
FROM tblDate
where ixDate between 21186 and 21187


UPDATE tblDate set iPeriodYear = 2025 where ixDate = 21187


