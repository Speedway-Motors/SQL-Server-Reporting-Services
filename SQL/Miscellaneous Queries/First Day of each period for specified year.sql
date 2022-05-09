-- First and Last Days of each period for specified year

DECLARE @PeriodYear int
SELECT @PeriodYear = 2026

SELECT  D.iPeriod, D.iYear,
    CONVERT(VARCHAR, D.dtDate, 101) AS 'StartDate',
    CONVERT(VARCHAR, D2.dtDate, 101) AS 'EndDate',
    D.ixDate 'ixPeriodStart',
    PE.PeriodEnd    
FROM tblDate D
    join (select iPeriod, MAX(ixDate) 'PeriodEnd'
          from tblDate
          where iPeriodYear = @PeriodYear
          group by iPeriod) PE on D.iPeriod = PE.iPeriod
    join tblDate D2 on  D2.ixDate = PE.PeriodEnd         
WHERE D.iPeriodYear = @PeriodYear
    and D.iDayOfFiscalPeriod = 1
ORDER BY D.iPeriod




-- select top 10 * from tblDate





