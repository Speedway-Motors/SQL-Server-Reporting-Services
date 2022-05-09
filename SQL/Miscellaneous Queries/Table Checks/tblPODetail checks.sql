-- tblPODetail checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblPO%'
--  ixErrorCode	sDescription
--1122	Failure to write to tblPOMaster [REPORTING.EXPORT.TBLPOMASTER.SUB]
--1145	Failure to update tblPODetail

-- ERROR COUNTS by Day
SELECT DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1145'
 --nd dtDate >=  DATEADD(month, -4, getdate())  -- past X months
GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
--HAVING count(*) > 10
ORDER BY dtDate desc 
/*
DataBaseName	Date      	ErrorQty
DataBaseName	Date      	ErrorQty
SMI Reporting	08-27-18	23
SMI Reporting	06-22-18	19
SMI Reporting	06-20-18	19
SMI Reporting	06-19-18	19
SMI Reporting	06-13-18	19
SMI Reporting	07-06-16	52
SMI Reporting	06-29-16	26
SMI Reporting	06-22-16	18
SMI Reporting	06-21-16	8
SMI Reporting	06-20-16	2
SMI Reporting	06-16-16	22
SMI Reporting	06-14-16	42
SMI Reporting	05-04-16	1
SMI Reporting	04-20-16	2
SMI Reporting	04-01-16	1
SMI Reporting	03-08-16	108
SMI Reporting	03-02-16	8
SMI Reporting	02-29-16	2
SMI Reporting	02-26-16	60
SMI Reporting	02-08-16	1
SMI Reporting	01-08-16	4
SMI Reporting	01-07-16	8
SMI Reporting	01-05-16	1
SMI Reporting	01-04-16	36
SMI Reporting	12-31-15	16
SMI Reporting	12-02-15	2
SMI Reporting	09-15-15	28
SMI Reporting	09-10-15	32
SMI Reporting	09-04-15	16
SMI Reporting	08-19-15	428         -- unknown issue. It appears multiple feeds were interrupted in a couple minute window... records seem to have refed and updated without issue.
SMI Reporting	08-17-15	2
SMI Reporting	07-28-15	2
SMI Reporting	06-04-15	132         -- all were from PO 103744.  Al Hanks said it had a goofy expected date from 2006 and that he might have accidentally messed it up.
SMI Reporting	05-01-15	1
SMI Reporting	04-03-15	3
SMI Reporting	03-02-15	1
SMI Reporting	02-24-15	1
SMI Reporting	02-23-15	56
SMI Reporting	02-16-15	8
SMI Reporting	02-04-15	20
SMI Reporting	01-30-15	4
SMI Reporting	01-28-15	58
SMI Reporting	01-28-15	36          -- refed, no new errors
SMI Reporting	01-26-15	1
SMI Reporting	01-23-15	48
SMI Reporting	12-12-14	500
SMI Reporting	12-11-14	1946
SMI Reporting	10-24-14	1
SMI Reporting	10-22-14	2
SMI Reporting	10-13-14	18
SMI Reporting	09-08-14	2
SMI Reporting	08-22-14	1
SMI Reporting	08-05-14	5
SMI Reporting	07-22-14	1
SMI Reporting	07-21-14	1
SMI Reporting	07-09-14	1
SMI Reporting	12-12-14	500
SMI Reporting	12-11-14	1946
SMI Reporting	10-24-14	1
SMI Reporting	10-22-14	2
SMI Reporting	10-13-14	18
SMI Reporting	09-08-14	2
SMI Reporting	08-22-14	1
SMI Reporting	08-05-14	5
SMI Reporting	07-22-14	1
SMI Reporting	07-21-14	1
SMI Reporting	07-09-14	1
SMI Reporting	07-02-14	130
SMI Reporting	06-19-14	1
SMI Reporting	06-05-14	8
SMI Reporting	05-30-14	4
SMI Reporting	05-14-14	1
SMI Reporting	05-06-14	36
SMI Reporting	05-01-14	1
SMI Reporting	04-28-14	2
SMI Reporting	04-03-14	2
SMI Reporting	03-24-14	1
SMI Reporting	02-25-14	1
SMI Reporting	02-20-14	2
SMI Reporting	02-17-14	2
SMI Reporting	01-29-14	36
SMI Reporting	01-10-14	9
SMI Reporting	01-08-14	8
SMI Reporting	01-02-14	243
SMI Reporting	12-26-13	36
SMI Reporting	12-19-13	1
SMI Reporting	11-11-13	76
SMI Reporting	10-21-13	1
SMI Reporting	10-04-13	1
SMI Reporting	08-22-13	69
SMI Reporting	08-21-13	101
SMI Reporting	08-20-13	39
SMI Reporting	08-19-13	20
SMI Reporting	07-23-13	40
SMI Reporting	06-17-13	2
SMI Reporting	06-11-13	1
SMI Reporting	06-03-13	8

AFCOReporting	05-08-15	1
AFCOReporting	04-01-15	1
AFCOReporting	02-19-15	1
AFCOReporting	12-03-14	18
AFCOReporting	12-01-14	4
AFCOReporting	11-26-14	12
AFCOReporting	10-13-14	3
*/

/*****************  TABLE GROWTH  *************************************/
exec spGetTableGrowth tblPODetail
/*
DB          	TABLE       Rows   	    Date
SMI Reporting	tblPODetail	1,043,393	07-01-18
SMI Reporting	tblPODetail	  991,122	01-01-18 ^89k
SMI Reporting	tblPODetail	  902,194	01-01-17 ^76k
SMI Reporting	tblPODetail	  826,115	01-01-16 ^68k
SMI Reporting	tblPODetail	  757,851	01-01-15 ^58K
SMI Reporting	tblPODetail	  699,836	01-01-14 ^56k
SMI Reporting	tblPODetail	  644,633	01-01-13
SMI Reporting	tblPODetail	  595,163	03-01-12
*/

/***************** DATA FRESHNESS *************************************/
SELECT DB_NAME() AS 'DB          '
    ,REPLACE(CONVERT(varchar, CAST(Records AS money), 1), '.00', '') 'Records'
    ,DaysOld ,CONVERT(varchar, GETDATE(), 110) AS 'DateChecked'
FROM vwDataFreshness 
WHERE sTableName = 'tblPODetail'

/*
DB          	Records	DaysOld	DateChecked
NOT IN VIEW YET
*/

-- Distinct list of POs with erros
-- may want to append a list of the Order #'s from the OrderLine error code also (EC 1142)
select -- distinct  
    count(*) Qty, -- 322 errors  12 distinct POs
    sError
    --SUBSTRING(sError,3,10) 'ixPO',
   , REPLACE(SUBSTRING(sError,4,6),' ','') 'Failed ixPO'  -- VERIFY THERE ARE NO TRAILINGS SPACES 
from tblErrorLogMaster
where ixErrorCode = '1145'
  and dtDate >='01/01/18'	
group by sError  
order by REPLACE(SUBSTRING(sError,4,6),' ','')  
/*
    Failed
Qty	ixPO	sError
8	103455	PO 103455 failed to update
1	104282	PO 104282 failed to update
8	106146	PO 106146 failed to update
28	106492	PO 106492 failed to update
48	106694	PO 106694 failed to update
20	107287	PO 107287 failed to update
2	108338	PO 108338 failed to update
28	109366	PO 109366 failed to update
168	109388	PO 109388 failed to update
2	110825	PO 110825 failed to update
8	110937	PO 110937 failed to update
1	95543	PO 95543 failed to update
*/

select * from tblPOMaster 
where ixPO in ('122280','123162','126940','127743','129121','132241','23447','92765','96325')--
order by ixPO

/*
ixPO	ixPODate	ixIssueDate	ixIssuer	ixBuyer	ixVendor	sShipToName	            sShipToAddress1	    sShipToAddress2	sShipToCSZ	sShipVia	sPaymentTerms	sFreightTerms	sNotes	flgBlanket	sBillToName	sBillToAddress1	sBillToAddress2	sBillToCSZ	sMessage1	sMessage2	sMessage3	sMessage4	sMessage5	sEmailAddress	flgIssued	flgOpen	ixVendorConfirmDate	ixVendorConfirmEmployee
94106	16846	    16846	    AHH	        AHH	    2505	    SPEEDWAY MOTORS, INC.	340 VICTORY LANE	NULL	        LINCOLN, NEBRASKA 68528	UPS GRND/LTLtrk	NET 30 DAYS	COLLECT FREIGHT: FOB	SO # 0339712	0	SPEEDWAY MOTORS	PO BOX 81906	NULL	LINCOLN, NE 68501	SHIP UPS, UNINSURED, GROUND, COLLECT FREIGHT ONLY	SHIPPER #635358 PUT OUR P.O. # IN THE UPS	REFERENCE BOX #1 SO WE CAN SEE IT ON THE UPS LABEL	NULL	NULL	AHHANKS@speedwaymotors.com	1	1	16846	AHH

96303	16936	    16936	    AHH	        AHH	    0444	    SPEEDWAY MOTORS, INC.	340 VICTORY LANE	NULL	        LINCOLN, NEBRASKA 68528	UPS GRND/LTLtrk	NET 30 DAYS	COLLECT FREIGHT: FOB	NULL	0	SPEEDWAY MOTORS	PO BOX 81906	NULL	LINCOLN, NE 68501	SHIP UPS, UNINSURED, GROUND, COLLECT FREIGHT ONLY	SHIPPER #635358 PUT OUR P.O. # IN THE UPS	REFERENCE BOX #1 SO WE CAN SEE IT ON THE UPS LABEL	NULL	NULL	AHHANKS@speedwaymotors.com	1	1	16936	AHH
96325	16937	    16937	    AHH	        JMM	    1403	    SPEEDWAY MOTORS, INC.	340 VICTORY LANE	NULL	        LINCOLN, NEBRASKA 68528	UPS	CREDIT CARD	COLLECT FREIGHT: FOB	NULL	0	SPEEDWAY MOTORS	PO BOX 81906	NULL	LINCOLN, NE 68501	SHIP UPS LTL TRUCK, COLLECT FREIGHT ONLY.	SHIPPING 80 NOW AND 80 IN 3 WEEKS.	NULL	NULL	NULL	AHHANKS@speedwaymotors.com	1	1	16937	AHH*/

select * from tblPODetail
where ixPO in ('122280','123162','126940','127743','129121','132241','23447','92765','96325')
order by ixPO


select * from tblVendor
where ixVendor in ('0444','1403')
/*
ixVendor	sName
0444	    HYPERCO
1403	    EZ WIRING & GAUGE
*/
 

select ixPO, count(*) RowCnt, max(iOrdinality) MaxOrd, 'Lines in SOP'
from tblPODetail 
where ixPO in ('103455','104282','106146','106492','106694','107287','108338','109366','109388','110825','110937','95543')--
group by ixPO
order by ixPO
/*
ixPO	RowCnt              Lines in SOP
96303	6                   6
96325   0                   1
*/

select * from tblPODetail
where  ixPO in ('106420','99920')


select ixPO, ixSKU, iQuantity, mCost, iOrdinality,
D.dtDate 'ExpectedDeliveryDate',
D2.dtDate 'FirstReceivedDate'  
, iQuantityReceivedPending, iQuantityPosted
from tblPODetail POD
    left join tblDate D on POD.ixExpectedDeliveryDate = D.ixDate
    left join tblDate D2 on POD.ixFirstReceivedDate = D2.ixDate
where ixPO in ('96303','96325')
order by ixPO, iOrdinality


