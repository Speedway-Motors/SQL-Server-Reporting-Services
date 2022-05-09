-- tblBOMTransferMaster checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblBOMTransfer%'
--  ixErrorCode	sDescription
--  1160	    Failure to update tblBOMTransferMaster.

-- ERROR COUNTS by Day
SELECT  DB_NAME() AS 'DB          '
    ,CONVERT(VARCHAR(10), dtDate, 101) AS 'Date    '
    ,count(*) AS 'ErrorQty',
    dtDate
FROM tblErrorLogMaster
WHERE ixErrorCode = '1160'
  and dtDate >=  DATEADD(month, -1, getdate())  -- past X months
GROUP BY dtDate,CONVERT(VARCHAR(10), dtDate, 101)   
--HAVING count(*) > 10
ORDER BY dtDate desc
/*
DB          	Date    	ErrorQty
SMI Reporting	08/30/2017	1402
SMI Reporting	08/29/2017	2026
SMI Reporting	02/19/2015	1507\
SMI Reporting	02/18/2015	2917 \
SMI Reporting	02/17/2015	2970  \
SMI Reporting	02/16/2015	3000   \ CRAP DATA
SMI Reporting	02/15/2015	3001   / ALL caused by ixTransferNumber '50869-1' having a screwed up (way too high a value) ixDate!
SMI Reporting	02/14/2015	2978  /
SMI Reporting	02/13/2015	2934 /
SMI Reporting	02/12/2015	1680/

AFCOReporting	06/01/2017	1
AFCOReporting	12/01/2016	1
AFCOReporting	10/17/2016	4
AFCOReporting	09/16/2016	15
AFCOReporting	03/03/2016	1
AFCOReporting	11/04/2015	1
AFCOReporting	10/15/2015	32
AFCOReporting	09/16/2015	1420
AFCOReporting	09/15/2015	2426
AFCOReporting	08/03/2015	888
AFCOReporting	08/02/2015	2449
AFCOReporting	08/01/2015	2455
AFCOReporting	07/31/2015	2455
AFCOReporting	07/30/2015	1809
AFCOReporting	06/19/2015	2
AFCOReporting	06/05/2015	1
AFCOReporting	06/03/2015	1099
AFCOReporting	06/02/2015	2425
AFCOReporting	06/01/2015	1111
AFCOReporting	05/29/2015	1
AFCOReporting	05/11/2015	6
AFCOReporting	03/17/2015	1
AFCOReporting	01/19/2015	2
AFCOReporting	01/02/2015	576
AFCOReporting	01/01/2015	2470
AFCOReporting	12/31/2014	2455
AFCOReporting	12/30/2014	2463
AFCOReporting	12/29/2014	2459
AFCOReporting	12/28/2014	2464
AFCOReporting	12/27/2014	2466
AFCOReporting	12/26/2014	2453
AFCOReporting	12/25/2014	2458
AFCOReporting	12/24/2014	1924

AFCOReporting	12/08/2014	846     \
AFCOReporting	12/07/2014	2471     \
AFCOReporting	12/06/2014	2453      \
AFCOReporting	12/05/2014	2448       \ CRAP DATA
AFCOReporting	12/04/2014	2457       / ALL caused by ixTransferNumber '147941-1' having a screwed up iQuantity value (huge negative number)
AFCOReporting	12/03/2014	2450      /
AFCOReporting	12/02/2014	2463     /
AFCOReporting	12/01/2014	1404    /
AFCOReporting	11/26/2014	1
AFCOReporting	11/10/2014	1
AFCOReporting	11/05/2014	2
AFCOReporting	10/09/2014	1
AFCOReporting	10/08/2014	7
AFCOReporting	10/06/2014	4
AFCOReporting	09/30/2014	778     \
AFCOReporting	09/29/2014	2465     \        
AFCOReporting	09/28/2014	2464      \  CRAP DATA
AFCOReporting	09/27/2014	2467       > ALL caused by ixTransferNumber '143106-1' having a screwed up (way too high a value) ixDate!
AFCOReporting	09/26/2014	2459      /
AFCOReporting	09/25/2014	2453     /
AFCOReporting	09/24/2014	1756    /
AFCOReporting	08/22/2014	2
AFCOReporting	08/11/2014	10
AFCOReporting	07/15/2014	1
AFCOReporting	07/01/2014	17
AFCOReporting	06/24/2014	773
AFCOReporting	06/23/2014	2460
AFCOReporting	06/22/2014	2466
AFCOReporting	06/21/2014	2458
AFCOReporting	06/20/2014	2461
AFCOReporting	06/19/2014	2446
AFCOReporting	06/18/2014	2450
AFCOReporting	06/17/2014	1627

*/


/************************************************************************/
SELECT  distinct sError
FROM tblErrorLogMaster
WHERE ixErrorCode = '1160'
  and dtDate >= '08/29/2017'
order by sError  
    
-- Distinct list of BOM Transfers with erros
-- may want to append a list of the Order #'s from the BOMTransferDetail error code also (EC 1159)

-- DROP TABLE [SMITemp].dbo.PJC_BOMTransfers_toRefeed  
-- TRUNCATE table [SMITemp].dbo.PJC_BOMTransfers_toRefeed   
INSERT INTO [SMITemp].dbo.PJC_BOMTransfers_toRefeed
select count(*) ErrorCnt,  -- 31,477
    SUBSTRING(sError,32,8) 'ixTransferNumber'
        ,sError
from tblErrorLogMaster
where ixErrorCode = '1160'
  and dtDate >= '08/16/2017'
group by   sError, 
    SUBSTRING(sError,32,8)
--order by sError  
/*
ixTransferNumber	sError
4717-1          	Failure to update BOM transfer 4717-1 [U2][SQL Client][ODBC][Microsoft][ODBC SQL Server Driver]Numeric value out of range
*/
SELECT * FROM tblBOMTransferMaster
WHERE ixTransferNumber in ('108828-1','156126-1','123236-1','94460-1','165602-1','86997-1','160957-1','149019-1','162762-1','97782-1','120070-1','161646-1','164045-1','170445-1','172652-1','169687-1','49107-1')
ORDER BY dtDateLastSOPUpdate, ixTimeLastSOPUpdate




-- latest updates of problem records
SELECT BOMRF.ixTransferNumber, ixCreateDate, dtDateLastSOPUpdate, ixTimeLastSOPUpdate-- '666351'
from [SMITemp].dbo.PJC_BOMTransfers_toRefeed BOMRF
    left join tblBOMTransferMaster BTM on BOMRF.ixTransferNumber = BTM.ixTransferNumber
order by  dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc 

DELETE FROM [SMITemp].dbo.PJC_BOMTransfers_toRefeed
WHERE ixTransferNumber in ('39640-1','40199-1','40328-1','40335-1','41486-1',
'41488-1','41489-1','41491-1','41674-1','41682-1',
'39206-1','39466-1','39593-1')





-- sub - Open BOM Transfers.rdl
-- STATUS BEFORE REFEEDING ALL BOM TRANSFERS
SELECT
   BTM.ixFinishedSKU                                  ixSKU,
   BTM.ixTransferNumber,
   BTM.iQuantity                                      QtyRequested,
   BTM.iCompletedQuantity                             QtyCompleted,
   (BTM.iQuantity-isnull(BTM.iCompletedQuantity,0))   QtyRemaining,
   (D.dtDate)                                         DeliveryDate
into #OpenBOMTransfersBeforeRefeed
from tblBOMTransferMaster BTM
   left join tblDate D on D.ixDate = BTM.ixDueDate
where --BTM.ixFinishedSKU = '41811010'--@SKU
    BTM.flgReverseBOM = 0
   and BTM.flgClosed = 0
   and BTM.dtCanceledDate is NULL
   and (ISNULL(BTM.iCompletedQuantity,0) < BTM.iQuantity 
                    OR iOpenQuantity > 0) 
ORDER BY DeliveryDate -- 1,232

SELECT * FROM #OpenBOMTransfersBeforeRefeed


-- sub - Open BOM Transfers.rdl
-- STATUS AFTER REFEEDING ALL BOM TRANSFERS
SELECT
   BTM.ixFinishedSKU                                  ixSKU,
   BTM.ixTransferNumber,
   BTM.iQuantity                                      QtyRequested,
   BTM.iCompletedQuantity                             QtyCompleted,
   (BTM.iQuantity-isnull(BTM.iCompletedQuantity,0))   QtyRemaining,
   (D.dtDate)                                         DeliveryDate
into #OpenBOMTransfersAfterRefeed
from tblBOMTransferMaster BTM
   left join tblDate D on D.ixDate = BTM.ixDueDate
where --BTM.ixFinishedSKU = '41811010'--@SKU
    BTM.flgReverseBOM = 0
   and BTM.flgClosed = 0
   and BTM.dtCanceledDate is NULL
   and (ISNULL(BTM.iCompletedQuantity,0) < BTM.iQuantity 
                    OR iOpenQuantity > 0) 
ORDER BY DeliveryDate -- 1,234


-- WHAT CHANGED?
select * from #OpenBOMTransfersBeforeRefeed
where ixTransferNumber NOT IN 
        (SELECT ixTransferNumber from #OpenBOMTransfersAfterRefeed) -- 1 records updated and dropped out of original result set!



SELECT * FROM tblSKUTransaction
where ixSKU = '41811010'
--and iQty in (30,-30)
order by ixDate desc



SELECT D.iYear 'YrCreated', COUNT(*) 'QTYofBOMXfers'
FROM [SMIArchive].dbo.BU_tblBOMTransferMaster_20170725 TM
left join tblDate D on TM.ixCreateDate = D.ixDate
GROUP BY D.iYear
ORDER BY D.iYear




select * from tblBOMTransferMaster where ixTransferNumber = '143106-1'

select * FROM tblErrorLogMaster
WHERE ixErrorCode = '1160' 
order by dtDate desc


select count(*) from tblErrorLogMaster where sError = 'Failure to update BOM transfer 162762-1 [U2][SQL Client][ODBC][Microsoft][ODBC SQL Server Driver]Numeric value out of range' -- 4425

