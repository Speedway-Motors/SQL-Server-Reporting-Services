-- SMIHD-8040 New Report - Bulk Catalog Requests by Market

SELECT TOP 10 * from tblCatalogRequest order by ixRequestDate desc


ixCatalogMarket


SELECT D.iYear, D.iISOWeek, CR.ixCatalogMarket 'Market', COUNT(ixGUID) 'Requests'
from tblCatalogRequest CR
join tblDate D on CR.ixRequestDate = D.ixDate
WHERE iYear = 2017 and iISOWeek =14
GROUP BY D.iYear, D.iISOWeek, CR.ixCatalogMarket 
ORDER BY D.iYear, D.iISOWeek, CR.ixCatalogMarket
/*
iYear	iISOWeek	Market	Requests
2017	14	        AD	    1
2017	14	        CR	    1
2017	14	        CT	    6
2017	14	        MC	    239
2017	14	        R	    147
2017	14	        SM	    60
2017	14	        SR	    568
*/


SELECT TOP 10 * FROM tblDate
where iYear = 2017 and iISOWeek = 1
and 



SELECT * FROM vwDailyCatRequestByMarket 
where iYear = 2017  and iISOWeek = 14

SELECT * 
FROM vwDailyCatRequestByMarket 
where RequestDate between '04/01/2017' and '04/30/2017'
--iYear = 2017  and iISOWeek = 14


SR	R	SM	AD	TB	MC

SELECT DISTINCT(ixCatalogMarket)
FROM tblCatalogRequest



SELECT *
  --  SUM(SR) 'StreetQty' 
FROM vwDailyCatRequestByMarket 
where RequestDate between '03/31/2017' and '04/17/2017'
k

-- SPOT CHECK 2 OR 3 WEEKS VS THE SAMPLE SPREADSHEET 
SELECT iYear, iISOWeek, 
    COUNT(RequestDate) 'DaysInISOWeekSelected',
    MIN(RequestDate) 'WeekOf', -- IF DaysInISOWeekSelected < 7 conditionally format this date field to highlight YELLOW with a note saying a full ISO week was not selected
    SUM(SR) 'Street',
    SUM(R) 'Race',
    SUM(MC) 'Muscle',
    SUM(SM) 'Sprint',
    SUM(TB) 'T-Bucket',
    SUM(AD) 'AFCO',
    SUM(CT) 'CAStreet',        
    SUM(CR) 'CARace',
    (SUM(SR)+SUM(R)+SUM(MC)+SUM(SM)+SUM(TB)+SUM(AD)+SUM(CT)+SUM(CR)) 'TotalCatalogs'
FROM vwDailyCatRequestByMarket 
where RequestDate between '04/17/2017' and '05/07/2017' -- 2 full Iso weeks and 2 partial
group by iYear, iISOWeek
order by  iYear, iISOWeek

select top 1 * from tblDate