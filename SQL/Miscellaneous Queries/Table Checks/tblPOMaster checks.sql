-- tblPOMaster checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%POMas%'
--  ixErrorCode	sDescription
--1122	Failure to write to tblPOMaster [REPORTING.EXPORT.TBLPOMASTER.SUB]
--1145	Failure to update tblPOMaster

-- ERROR COUNTS by Day
SELECT DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1122'
  and dtDate >=  DATEADD(month, -48, getdate())  -- past X months
GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
--HAVING count(*) > 10
ORDER BY dtDate desc 
/*
DataBaseName	Date      	ErrorQty
SMI Reporting	12-12-14	4
SMI Reporting	12-11-14	14
SMI Reporting	10-07-14	1
SMI Reporting	08-25-14	1
SMI Reporting	02-27-14	1
SMI Reporting	01-08-14	2


AFCOReporting	08-26-15	1
AFCOReporting	07-08-15	1
AFCOReporting	04-01-15	1
AFCOReporting	12-03-14	18
AFCOReporting	12-01-14	4
AFCOReporting	11-26-14	6
AFCOReporting	10-13-14	2
*/

/*****************  TABLE GROWTH  *************************************/
exec spGetTableGrowth tblPOMaster
/*
DB          	TABLE       Rows   	Date
SMI Reporting	tblPOMaster	102013	12-01-14
SMI Reporting	tblPOMaster	101552	11-01-14
SMI Reporting	tblPOMaster	100976	10-01-14
SMI Reporting	tblPOMaster	98992	07-01-14
SMI Reporting	tblPOMaster	96826	04-01-14
SMI Reporting	tblPOMaster	94730	01-01-14
SMI Reporting	tblPOMaster	92799	10-01-13
SMI Reporting	tblPOMaster	91436	08-01-13
SMI Reporting	tblPOMaster	88231	04-01-13
SMI Reporting	tblPOMaster	85890	01-01-13
SMI Reporting	tblPOMaster	84100	10-01-12
SMI Reporting	tblPOMaster	79138	03-01-12

AFCOReporting	tblPOMaster	37,867	03-01-18
AFCOReporting	tblPOMaster	36,708	01-01-18

AFCOReporting	tblPOMaster	34,957	10-01-17
AFCOReporting	tblPOMaster	33,623	07-01-17
AFCOReporting	tblPOMaster	32,468	04-01-17

AFCOReporting	tblPOMaster	31,436	01-01-17
AFCOReporting	tblPOMaster	27,358	01-01-16
AFCOReporting	tblPOMaster	23,812	01-01-15
AFCOReporting	tblPOMaster	20,979	01-01-14

*/

/***************** DATA FRESHNESS *************************************/
SELECT DB_NAME() AS 'DB          '
    ,REPLACE(CONVERT(varchar, CAST(Records AS money), 1), '.00', '') 'Records'
    ,DaysOld ,CONVERT(varchar, GETDATE(), 110) AS 'DateChecked'
FROM vwDataFreshness 
WHERE sTableName = 'tblPOMaster'

/*
DB          	Records	DaysOld	DateChecked
NOT IN VIEW YET
*/

-- Distinct list of POs with erros
-- may want to append a list of the Order #'s from the OrderLine error code also (EC 1142)
select distinct 
    -- count(*) Qty,
    --  sError,
    SUBSTRING(sError,16,20) 'Failed ixPO'
    -- REPLACE(SUBSTRING(sError,1,10),'Purchase Order ','') 'Failed ixPO'  -- VERIFY THERE ARE NO TRAILINGS SPACES 
from tblErrorLogMaster
where ixErrorCode = '1122'
  and dtDate >='10/01/2014'	
--group by sError  
--order by sError  
/*
by COUNT
2	Purchase Order 100372
4	Purchase Order 100404
2	Purchase Order 32841
2	Purchase Order 6511
8	Purchase Order 99976


sError	                    Failed ixPO
PO 100372 failed to update	100372 fa
PO 100404 failed to update	100404 fa
PO 32841 failed to update	32841
PO 6511 failed to update	6511l
PO 99976 failed to update	99976
*/

select * from tblPOMaster 
where ixPO in ('94106')--
order by ixPO

/*
ixPO	ixPODate	ixIssueDate	ixIssuer	ixBuyer	ixVendor	sShipToName	            sShipToAddress1	    sShipToAddress2	sShipToCSZ	sShipVia	sPaymentTerms	sFreightTerms	sNotes	flgBlanket	sBillToName	sBillToAddress1	sBillToAddress2	sBillToCSZ	sMessage1	sMessage2	sMessage3	sMessage4	sMessage5	sEmailAddress	flgIssued	flgOpen	ixVendorConfirmDate	ixVendorConfirmEmployee
94106	16846	    16846	    AHH	        AHH	    2505	    SPEEDWAY MOTORS, INC.	340 VICTORY LANE	NULL	        LINCOLN, NEBRASKA 68528	UPS GRND/LTLtrk	NET 30 DAYS	COLLECT FREIGHT: FOB	SO # 0339712	0	SPEEDWAY MOTORS	PO BOX 81906	NULL	LINCOLN, NE 68501	SHIP UPS, UNINSURED, GROUND, COLLECT FREIGHT ONLY	SHIPPER #635358 PUT OUR P.O. # IN THE UPS	REFERENCE BOX #1 SO WE CAN SEE IT ON THE UPS LABEL	NULL	NULL	AHHANKS@speedwaymotors.com	1	1	16846	AHH

96303	16936	    16936	    AHH	        AHH	    0444	    SPEEDWAY MOTORS, INC.	340 VICTORY LANE	NULL	        LINCOLN, NEBRASKA 68528	UPS GRND/LTLtrk	NET 30 DAYS	COLLECT FREIGHT: FOB	NULL	0	SPEEDWAY MOTORS	PO BOX 81906	NULL	LINCOLN, NE 68501	SHIP UPS, UNINSURED, GROUND, COLLECT FREIGHT ONLY	SHIPPER #635358 PUT OUR P.O. # IN THE UPS	REFERENCE BOX #1 SO WE CAN SEE IT ON THE UPS LABEL	NULL	NULL	AHHANKS@speedwaymotors.com	1	1	16936	AHH
96325	16937	    16937	    AHH	        JMM	    1403	    SPEEDWAY MOTORS, INC.	340 VICTORY LANE	NULL	        LINCOLN, NEBRASKA 68528	UPS	CREDIT CARD	COLLECT FREIGHT: FOB	NULL	0	SPEEDWAY MOTORS	PO BOX 81906	NULL	LINCOLN, NE 68501	SHIP UPS LTL TRUCK, COLLECT FREIGHT ONLY.	SHIPPING 80 NOW AND 80 IN 3 WEEKS.	NULL	NULL	NULL	AHHANKS@speedwaymotors.com	1	1	16937	AHH*/

select * from tblPOMaster
where ixPO in ('94106')--
order by ixPO


select * from tblVendor
where ixVendor in ('0444','1403')
/*
ixVendor	sName
0444	    HYPERCO
1403	    EZ WIRING & GAUGE
*/
 

select ixPO, count(*) RowCnt  
from tblPOMaster 
where ixPO in ('96303','96325')
group by ixPO
order by ixPO
/*
ixPO	RowCnt              Lines in SOP
96303	6                   6
96325   0                   1
*/

select ixPO, ixSKU, iQuantity, mCost, iOrdinality,
D.dtDate 'ExpectedDeliveryDate',
D2.dtDate 'FirstReceivedDate'  
, iQuantityReceivedPending, iQuantityPosted
from tblPOMaster POD
    left join tblDate D on POD.ixExpectedDeliveryDate = D.ixDate
    left join tblDate D2 on POD.ixFirstReceivedDate = D2.ixDate
where ixPO in ('96303','96325')
order by ixPO, iOrdinality




select * from tblErrorLogMaster
where ixErrorCode in (1105,1106,1107,1108,1109,1110,1111,1112,1210,1200,1198,1197,1196) --between 1105 and 1112   (ARE being written to the error log 1145 & 1122)
and ixDate > 17139 -- 12/3/314


select ixTime, chTime from tblTime where ixTime in (32735)


select * from tblErrorCode where ixErrorCode in (1105,1106,1107,1108,1109,1110,1111,1112,1210,1200,1198,1197,1196)