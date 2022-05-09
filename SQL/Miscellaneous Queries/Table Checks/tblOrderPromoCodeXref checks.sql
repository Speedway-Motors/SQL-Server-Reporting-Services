-- tblOrderPromoCodeXref checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblOrderPromoCodeXref%'
--  ixErrorCode	sDescription
--  1218	Failure to update tblOrderPromoCodeXref

-- ERROR COUNTS by Day
SELECT dtDate
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1218'
-- and dtDate >=  DATEADD(month, -1, getdate())  -- past X months
GROUP BY dtDate
--HAVING count(*) > 10
ORDER BY dtDate Desc
/*
                dtDate	    ErrorQty
SMIRepoting     2015-03-18 	26,913      <-- Fixed.  We added a new field and SOP wasn't feeding the correct # of fields.  


*/



/*****************  TABLE GROWTH  *************************************/
exec spGetTableGrowth tblOrderPromoCodeXref
/*
DB          	Rows   	Date
SMI Reporting	tblOrderPromoCodeXref	52347	04-01-15
SMI Reporting	tblOrderPromoCodeXref	46643	01-01-15
SMI Reporting	tblOrderPromoCodeXref	34793	10-01-14
SMI Reporting	tblOrderPromoCodeXref	32961	07-01-14
SMI Reporting	tblOrderPromoCodeXref	29409	04-01-14
SMI Reporting	tblOrderPromoCodeXref	22632	01-01-14
SMI Reporting	tblOrderPromoCodeXref	13085	10-01-13
SMI Reporting	tblOrderPromoCodeXref	12045	08-01-13
SMI Reporting	tblOrderPromoCodeXref	0	    04-01-13


*/

select * from tblTime where chTime like '14:25%'


select * from tblErrorLogMaster
where ixErrorCode = '1218'
order by ixTime desc

select * from tblTime where ixTime = 48277


-- CHECK PROC LOG
select * from [ErrorLogging].dbo.ProcedureLog
where ProcedureName LIKE '%OrderPromoCodeXref%'

order by LogDate desc


-- RESOLVED PROC LOG
select * from [ErrorLogging].dbo.ProcedureLog_Resolved
where ProcedureName LIKE '%OrderPromoCodeXref%'



-- most recent records that updated
select * from tblOrderPromoCodeXref
order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc

6010016	738	2015-04-23 00:00:00.000	8664	OTUNEWFREE99
6021212	740	2015-04-23 00:00:00.000	8664	OTU503FLAT99
6036610	157	2015-04-23 00:00:00.000	8664	No Promo Code

select * from tblTime where ixTime = '8664' -- 02:24:24  

-- TEST RECORDS THAT ARE WORKING NORMALLY
6010016
6021212
6036610





-- 33 problem records that are NOT updating
select X.ixOrder, X.ixPromoId, X.ixPromoCode, X.dtDateLastSOPUpdate, 
    O.sOrderStatus, O.dtOrderDate, O.dtShippedDate
--INTO [SMITemp].dbo.PJC_33OrderPromoCodeXrefProblemRecords
-- DELETE
from tblOrderPromoCodeXref
where dtDateLastSOPUpdate < '04/21/15'
order by X.dtDateLastSOPUpdate desc

select *
from tblOrderPromoCodeXref
where dtDateLastSOPUpdate = '04/28/15'
and ixTimeLastSOPUpdate >= 50400
order by ixOrder

select * from tblTime where chTime like '14:0%'


SELECT distinct ixOrder,ixPromoId,ixPromoCode
FROM [SMITemp].dbo.PJC_OrderPromoCodeXref_MissingRecords
order by ixOrder,ixPromoId,ixPromoCode


5179791	671	CYBER14OTU
5179791	672	CYBER14OTU
5196796	671	CYBER14OTU
5196796	672	CYBER14OTU
5245191	671	CYBER14OTU
5245191	676	CYBER14OTU
5245191	677	CYBER14OTU
5296190	671	CYBER14OTU
5296190	676	CYBER14OTU
5296190	677	CYBER14OTU
5540789	616	GS15
5575593	645	NEWYEAR15
5810614	271	MD13H


select distinct X.ixOrder,X.ixPromoId,X.ixPromoCode
from [SMITemp].dbo.PJC_OrderPromoCodeXref_MissingRecords M
    left join tblOrderPromoCodeXref X on M.ixOrder= X.ixOrder
                            and M.ixPromoId = X.ixPromoId
                            and M.ixPromoCode = X.ixPromoCode
-- 13 records were passed.... they ARE in the Xref table, but since part 
-- of their composite PK values changed, new records were created instead
-- of the original values getting updated                            