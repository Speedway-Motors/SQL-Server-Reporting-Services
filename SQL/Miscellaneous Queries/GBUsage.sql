SELECT * from PJC_GBUsage

-- summary by date
SELECT U.dtDate, 
    D.sDayOfWeek 'Day', 
    SUM(GB) 'GB'
FROM PJC_GBUsage U
    join [SMI Reporting].dbo.tblDate D on U.dtDate = D.dtDate
GROUP BY U.dtDate, D.sDayOfWeek
ORDER BY SUM(GB) desc

-- summary by day of week
SELECT D.sDayOfWeek 'Day', 
    SUM(GB) 'GB'
FROM PJC_GBUsage U
    join [SMI Reporting].dbo.tblDate D on U.dtDate = D.dtDate
GROUP BY D.sDayOfWeek
ORDER BY SUM(GB) desc