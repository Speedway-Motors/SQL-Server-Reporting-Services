-- First and Last Days of each period for specified year

SELECT D1.iPeriod,	
    D1.ixDate 'ixPeriodStart', 
    CONVERT(VARCHAR, D1.dtDate, 101) AS 'Date', 
    D1.iDayOfFiscalPeriod
from tblDate D1
where D1.iPeriodYear = 2017
    and (D1.iDayOfFiscalPeriod = 1
         OR D1.iDayOfFiscalPeriod >= 28
        )
order by D1.iPeriod, D1.iDayOfFiscalPeriod


SELECT D1.iPeriod,	
    D1.ixDate 'ixPeriodStart', 
    CONVERT(VARCHAR, D1.dtDate, 101) AS 'Date', 
    D1.iDayOfFiscalPeriod
from tblDate D1
   where D1.iPeriodYear = 2017
    and (D1.iDayOfFiscalPeriod = 1
         OR D1.iDayOfFiscalPeriod >= 28
        )
order by D1.iPeriod, D1.iDayOfFiscalPeriod


DECLARE @PeriodYear int
SELECT @PeriodYear = 2020

SELECT  D.iPeriod, 
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









