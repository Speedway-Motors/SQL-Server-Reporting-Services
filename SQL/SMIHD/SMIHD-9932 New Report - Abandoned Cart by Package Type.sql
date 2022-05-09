-- SMIHD-9932 New Report - Abandoned Cart by Package Type

/* DATA STOPPED COLLECTING 8/26/2019
per Ron "ok, I know why.  Just need to figure out the proper way to fix it.

We stopped recording the SOP web order number on tblcheckout_transaction and instead record it on tblcheckout_transaction_shipment.
But just joining over to that may give inflated numbers, so I need to check that out"


UPDATE: 2-26-20 Ron got the proc to pull from both tables.  He ran a 5 year range that finished in about 5 mins.  Currently the proc is running very slowly (about 5 mins for a 6 day range)

*/

exec [dw.speedway2.com].DW.dbo.sp_AbandonedCheckoutPackageInfo '02/01/2020','01/01/2020'


exec [dw.speedway2.com].DW.dbo.sp_AbandonedCheckoutPackageInfo '01/27/2018','01/20/2018' -- both Saturdays

CREATE TABLE #AbandonedCheckoutPackageInfo (--CreateDate  datetime, 
                                            PackageType varchar(15), CountOrdersCompleted int, AbortedCheckOut int)

INSERT INTO #AbandonedCheckoutPackageInfo 
exec dbo.sp_AbandonedCheckoutPackageInfo '01/31/2020','01/01/2020'

SELECT PackageType, SUM(CountOrdersCompleted), SUM(AbortedCheckOut)
FROM #AbandonedCheckoutPackageInfo
GROUP BY PackageType

DROP TABLE #AbandonedCheckoutPackageInfo
/*
FirstDayOf	Package CountOrders Aborted
Week		Type	Completed	Checkout
==========	========================
2018-01-13	AH		129			56
2018-01-13	LPS		16			2
2018-01-13	Normal	408			79
2018-01-13	TF		14			5

2018-01-20	AH		1193		438
2018-01-20	LPS		193			84
2018-01-20	Normal	3457		832
2018-01-20	TF		85			86
==========	========================

*/

SELECT min(dtCheckOut) FROM tblAbandonedCheckoutPackageInfo
WHERE dtCheckout between @StartDate and @EndDate
/*
DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '01/20/2020',    @EndDate = '01/26/2020' 
*/
SELECT PackageType, SUM(CountOrdersCompleted) 'OrdersCompleted', SUM(AbortedCheckout) 'AbortedCheckout'
FROM tblAbandonedCheckoutPackageInfo
WHERE dtCheckout between @StartDate and @EndDate
GROUP BY PackageType

 

exec [dw.speedway2.com].DW.dbo.sp_AbandonedCheckoutPackageInfo @EndDate,@StartDate

-- exact matches above





select distinct    dateadd(day, datepart(dw,dtDate) * -1, cast(dtDate as Date)) as FirstDayOfWeek
from tblDate
where
    dtDate > dateadd(year,-1,getdate())




    /* [2/28 5:31 PM] Matthew L. Stubblefield
   You'd want to look for 
   ship confirm emails in the tblemail_sent table 
   for orders that have the counter shipping method.
*/

select * from tblemail_sent

select ES.* 
from tng.tblemail_sent ES
    left join tng.tblOrder tngO on tngO.ixOrder = ES.ixOrder
    left join tblOrder O on O.ixOrder = tngO.ixOrder
where  O.ixOrder in ('9665900','9903105','9846804','9927401','9944506','9912605','9926602','9981507','9916707','9988702','9975703','9942800','9924701','9968806','9028113','9022210','9097117','9989709','9087116','9062117')
order by ixEmailSent desc

select O.ixOrder, 
    ES.dtEmailSentUTC,
   -- ES.dtEmailSentUTC AT TIME ZONE 'UTC'  AT TIME ZONE 'Central Standard Time' AS 'ShipConfirmationEmailSentCST',
  --FORMAT((ES.dtEmailSentUTC AT TIME ZONE 'UTC'  AT TIME ZONE 'Central Standard Time'),'yyyy-MM-dd hh:MM:ss') 'ShipConfirmationEmailSentCST'
    FORMAT((ES.dtEmailSentUTC AT TIME ZONE 'UTC'  AT TIME ZONE 'Central Standard Time'),'M/d/yyyy HH:mm') 'ShipConfirmationEmailSentCST'
from tblOrder O 
    left join tblHackOrderID h on h.ixOrder = O.ixOrder -- special table to preven COLLATION from breaking all the indexes
    left join tng.tblOrder tngO on h.ixOrder_CI = tngO.ixSopOrderNumber
    left join tng.tblemail_sent ES ON tngO.ixOrder = ES.ixOrder
                                   and ES. ixEmailType = 1	-- ixEmailType 1 is "Shipping confirmation for orders that have been shipped.ShipConfirm"
where O.ixOrder in ('9665900','9903105','9846804','9927401','9944506','9912605','9926602','9981507','9916707','9988702','9975703','9942800','9924701','9968806','9028113','9022210','9097117','9989709','9087116','9062117')
--

SELECT ES.dtEmailSentUTC, ES.dtEmailSentUTC AT TIME ZONE 'UTC'  AT TIME ZONE 'Central Standard Time'
SELECT FORMAT((GETDATE() AT TIME ZONE 'UTC'  AT TIME ZONE 'Central Standard Time'),'yyyy.MM.dd HH:MM tt') CST




order by ixEmailSent desc




select , sWebOrderID
from tblOrder
where ixOrder in ('9665900','9903105','9846804','9927401','9944506','9912605','9926602','9981507','9916707','9988702','9975703','9942800','9924701','9968806','9028113','9022210','9097117','9989709','9087116','9062117')
