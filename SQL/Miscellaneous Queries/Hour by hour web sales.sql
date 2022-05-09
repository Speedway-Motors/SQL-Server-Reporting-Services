-- Hour by hour web sales

SELECT TOP 10 *
FROM [DW.SPEEDWAY2.COM].[dbo].[vwTABWebSalesFlashHourly] 

SELECT TOP 20 *
 from [DW.SPEEDWAY2.COM].SmiReportingRawData.Transfer.tblOrder


SELECT TOP 24 -- Hour by hour web sales
LastYearDate, LastMerchandiseTotalPrice,  NextYearDate, ThisMerchandiseTotalPrice
, ThisDateHour, DiffOrderCountFromPreviousYear, DiffMerchandiseTotalPriceFromPreviousYear
FROM [DW.SPEEDWAY2.COM].DW.dbo.[vwTABWebSalesFlashHourly]
WHERE NextYearDate = '2018-04-06'
    and ThisDateHour is NOT NULL
ORDER BY LastDateHour desc


SELECT MAX(ThisDateHour)-5 'ThroughCSTHour' 
    , NextYearDate 'TodaysDate'
    , LastYearDate 'LYDate'
    , FORMAT(SUM(ThisMerchandiseTotalPrice), ('$###,###,###')) 'TodaysWebSales'
    , FORMAT(SUM(LastMerchandiseTotalPrice), ('$###,###,###')) 'LYWebSales'
    , FORMAT((((SUM(LastMerchandiseTotalPrice)-SUM(ThisMerchandiseTotalPrice))/SUM(LastMerchandiseTotalPrice))*-1), ('###,###.0%')) 'WebSalesChangeSoFarToday'
FROM [DW.SPEEDWAY2.COM].DW.dbo.[vwTABWebSalesFlashHourly]
WHERE NextYearDate >= CONVERT(VARCHAR,GETDATE(), 23)-- Today's date
    and ThisDateHour is NOT NULL
GROUP BY LastYearDate,NextYearDate

/*
Through                         Todays      LY          WebSalesChange
CSTHour	TodaysDate	LYDate	    WebSales	WebSales	SoFarToday
======= ==========  ==========  ========    ========    ==============
15	    2018-04-06	2017-04-07	$145,510	$146,631	-.8%
*/


SELECT * FROM [DW.SPEEDWAY2.COM].DW.dbo.[vwTABWebSalesFlashHourly]





