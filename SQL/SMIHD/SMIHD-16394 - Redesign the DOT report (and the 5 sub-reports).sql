-- 	SMIHD-16394	- Redesign the DOT report (and the 5 sub-reports)
USE [SMI Reporting]
GO

/****** Object:  View [dbo].[vwDailyOrdersTakenWithBU]    Script Date: 2/12/2020 11:33:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- select count (distinct dtDate) from vwDailyOrdersTaken -- 1138
-- select count (distinct dtDate) from vwDailyOrdersTakenWithBU -- 1138

   SELECT --dtDate, iPeriodYear, iPeriod, iDayOfFiscalPeriod, iDayOfFiscalYear,
          SUM (DailyNumOrds) 'TotDailyNumOrds',
          SUM (DailySales) 'TotDailySales',
          SUM (DailyShipping) 'TotDailyShipping',
          SUM (DailySalesPlusShipping) 'TotDailySalesPlusShipping',
          SUM (PkgsShipped) 'TotPkgsShipped'
    FROM vwDailyOrdersTaken
    where dtDate between '01/04/2020' and '01/31/2020'  -- 2020 P1
/*
TotDaily
NumOrds	TotDailySales	TotDailyShipping	TotDailySalesPlusShipping	TotPkgsShipped

2026123	404895801.25	14477966.92     	419373768.17	            2299378        <-- verified same results on both queries
*/

    
   SELECT SUM (DailyNumOrds) 'TotDailyNumOrds',
          SUM (DailySales) 'TotDailySales',
          --SUM (DailyCoGS) 'TotDailyCoGS',
          --SUM (DailyProductMargin) 'TotDailyProductMargin',
          SUM (DailyShipping) 'TotDailyShipping',
          SUM (DailySalesPlusShipping) 'TotDailySalesPlusShipping',
          SUM (PkgsShipped) 'TotPkgsShipped'
    FROM vwDailyOrdersTaken
    where dtDate between '01/04/2020' and '01/31/2020'  -- 2020 P1
    group by OrdChan, SortOrd, Division
    order by SortOrd


   SELECT OrdChan, SubBU, SortOrd, Division, 
          SUM (DailyNumOrds) 'TotDailyNumOrds',
          SUM (DailySales) 'TotDailySales',
          SUM (DailyCoGS) 'TotDailyCoGS',
          SUM (DailyProductMargin) 'TotDailyProductMargin',
          SUM (DailyShipping) 'TotDailyShipping',
          SUM (DailySalesPlusShipping) 'TotDailySalesPlusShipping',
          SUM (PkgsShipped) 'TotPkgsShipped'
    FROM vwDailyOrdersTakenWithBU
    where dtDate between '02/06/2020' and '02/08/2020'  -- 2020 P1
    group by OrdChan, SubBU, SortOrd, Division
    order by SortOrd


select ixOrder, dtOrderDate, sSourceCodeGiven, ixBusinessUnit
from tblOrder
where ixBusinessUnit = 101
and ixOrderDate between 18997 and 19024
order by ixOrderDate desc

SELECT TOP 10 * FROM vwDailyOrdersTakenWithBU where  



/*
TotDaily
NumOrds	TotDailySales	TotDailyShipping	TotDailySalesPlusShipping	TotPkgsShipped

2026123	404895801.25	14477966.92     	419373768.17	            2299378        <-- verified same results on both queries
*/

   SELECT SUM (DailyNumOrds) 'TotDailyNumOrds',
          SUM (DailySales) 'TotDailySales',
          SUM (DailyCoGS) 'TotDailyCoGS',
          SUM (DailyProductMargin) 'TotDailyProductMargin',
          SUM (DailyShipping) 'TotDailyShipping',
          SUM (DailySalesPlusShipping) 'TotDailySalesPlusShipping',
          SUM (PkgsShipped) 'TotPkgsShipped'
    FROM vwDailyOrdersTakenWithBU
    where dtDate between '01/04/2020' and '01/31/2020'  -- 2020 P1



SELECT TOP 10 * FROM vwDailyOrdersTaken









SELECT * FROM vwDailyOrdersTaken
WHERE dtDate = '01/15/2020'
order by SortOrd


SELECT * FROM vwDailyOrdersTakenWithBU
WHERE dtDate = '01/15/2020'
order by SortOrd




select O.flgDeviceType, count(*)
from tblOrder O
    left join tblCustomer CUST on O.ixCustomer = CUST.ixCustomer
where ixInvoiceDate between 18994 and 19024 -- Jan 2010
group by O.flgDeviceType


-- DROP VIEW [dbo].[vwDailyOrdersTakenWithBU]