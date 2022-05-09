-- ProcedureLog 

/**************   SUMMARY OF ERROR LOG HISTORY   **************/
SELECT format(count(1),'###,###,##0') 'Qty'
    ,ErrorMessage ,ProcedureName
  --  ,CONVERT(VARCHAR(10),LogDate,10) 'LogDate'
FROM [ErrorLogging].dbo.ProcedureLog
WHERE LogDate > '2021-05-03' -- >= DATEADD(dd, -1, getdate())  -- past X days
   AND ProcedureName like '%spUpdateSKUTrans%' -- '%SMI eporting%spUpdateOrderLine%' 
GROUP BY ErrorMessage ,ProcedureName
  --  ,CONVERT(VARCHAR(10),LogDate,10)
--HAVING count(*) > 30
    ORDER BY count(1) desc, ProcedureName, ErrorMessage 
/*
Qty	ProcedureName	                                    ErrorMessage
395	The INSERT statement conflicted with the FOREIGN KEY constraint "FK_ixFinishedSKU_tblBOMTransferMaster". The conflict occurred in database "SMI Reporting", table "dbo.tblSKU", column 'ixSKU'.	[SMI Reporting].[dbo].[spUpdateBOMTransferMaster]
112	The INSERT statement conflicted with the FOREIGN KEY constraint "FK_ixFinishedSKU_tblBOMTemplateDetail". The conflict occurred in database "SMI Reporting", table "dbo.tblBOMTemplateMaster", column 'ixFinishedSKU'.	[SMI Reporting].[dbo].[spUpdateBOMTemplateDetail]
48	The INSERT statement conflicted with the FOREIGN KEY constraint "FK_ixFinishedSKU_tblBOMTemplateMaster". The conflict occurred in database "SMI Reporting", table "dbo.tblSKU", column 'ixSKU'.	[SMI Reporting].[dbo].[spUpdateBOMTemplateMaster]
25	The INSERT statement conflicted with the FOREIGN KEY constraint "FK_ixReceiver_IR". The conflict occurred in database "SMI Reporting", table "dbo.tblReceiver", column 'ixReceiver'.	[SMI Reporting].[dbo].[spUpdateInventoryReceipt]
1	The INSERT statement conflicted with the FOREIGN KEY constraint "FK_ixSKU_tblInventoryReceipt". The conflict occurred in database "SMI Reporting", table "dbo.tblSKU", column 'ixSKU'.	[SMI Reporting].[dbo].[spUpdateInventoryReceipt]
*/



SELECT * FROM [ErrorLogging].dbo.ProcedureLog
WHERE ProcedureName like '%SMI Reporting%spUpdateSKUTransaction]'                      -- AFCO 1,037       SMI 547
   -- AND ErrorMessage IS NOT null
   -- AND ErrorMessage not LIKE '%smallmoney%'                                -- AFCO 1,037
   -- AND ErrorMessage NOT LIKE '%Cannot insert duplicate key in object%'     -- AFCO 0
    and LogDate > '2021-05-03' --3 13:35:36.323'
ORDER BY LogDate desc


SELECT LogDate,	Field3,	Value3,	Field4,	Value4,	Field1,	Value1,	Field2,	Value2,	ErrorMessage
FROM [ErrorLogging].dbo.ProcedureLog
WHERE ProcedureName like '%SMI Reporting%spUpdateSKUTrans%'
and LogDate > '2021-05-04'
ORDER BY LogDate desc

select top 10 * 
from [SMI Reporting].dbo.tblSKUTransaction
where ixDate = 19483
order by iSeq desc
/*
ixDate	iSeq	ixTime
19483	46960	47452
19483	46959	47452
19483	46958	47452
19483	46957	47447
19483	46956	47444
19483	46955	47444
19483	46954	47444
19483	46953	47443
19483	46952	47443
19483	46951	47443
*/



SELECT --distinct -- 395
    Value2
FROM [ErrorLogging].dbo.ProcedureLog
WHERE ProcedureName like '%SMI Reporting%spUpdateBOMTransferMaster%'
and LogDate >= '06/07/2017'
--ORDER BY LogDate desc


SELECT top 10 *
FROM [ErrorLogging].dbo.ProcedureLog
WHERE ProcedureName like '%spUpdateSKU%' -- '%SMI eporting%spUpdateOrderLine%' 
ORDER BY LogDate desc



SELECT CONVERT(VARCHAR(10),LogDate,10) 'LogDate', ProcedureName --, 'No Error. Just counting how often proc is called' as 'Notes'
 ,  count(*) Qty
  --  ,ErrorMessage ,ProcedureName
  --  ,CONVERT(VARCHAR(10),LogDate,10) 'LogDate'
FROM [ErrorLogging].dbo.ProcedureLog
WHERE ProcedureName like '%SMI Reporting%spDeleteBinSku%'  
GROUP BY   ProcedureName, 'Notes'
    ORDER BY CONVERT(VARCHAR(10),LogDate,10) 


SELECT COUNT(*) -- 148,327
 -- top 100 * --
-- DELETE
FROM [ErrorLogging].dbo.ProcedureLog
WHERE ProcedureName like '%SMI Reporting%spDeleteBinSku%'
and Value1 = 'PROC CALLED'

/****** BATCH DELETE/UPDATE  ************
     1) set ROWCOUNT to the amount to delete in each batch
     2) set @C to  # of times to loop
*/
     
-- SET ROWCOUNT 10000   SET ROWCOUNT 0 
declare @c int
set @c = 1 -- resets counter
while @c < 10 -- # of times it will loop
BEGIN
        DELETE TOP 10 *
        FROM [ErrorLogging].dbo.ProcedureLog
        WHERE ProcedureName like '%SMI Reporting%spDeleteBinSku%'
        and Value1 = 'PROC CALLED'
  set @c = @c + 1
  WAITFOR DELAY '00:00:03' -- Let the machine breath and record
END;

-- MOST RECENT error(s)
SELECT TOP 500 *
FROM [ErrorLogging].dbo.ProcedureLog
WHERE ProcedureName like '%SMI Reporting%spDeleteBinSku%'  
ORDER BY LogDate desc



SELECT 
CONVERT(VARCHAR(10),LogDate,10) 'LogDate',
	DatabaseID,ObjectID,ProcedureName,ErrorLine,ErrorMessage,Field1,Value1,Field2,Value2,Field3,Value3,Field4,Value4,Field5,Value5
INTO [ErrorLogging].dbo.PJC_DeleteBinSKU_ProcCalls
FROM [ErrorLogging].dbo.ProcedureLog
WHERE ProcedureName like '%SMI Reporting%spDeleteBinSku%' 

-- DROP TABLE [ErrorLogging].dbo.PJC_DeleteBinSKU_ProcCalls
SELECT LogDate, count(*) --    3,836,648 
FROM [ErrorLogging].dbo.PJC_DeleteBinSKU_ProcCalls
GROUP BY LogDate
order by LogDate
/*
LogDate	    QTY  
08/14/16	 63,991         <-- AVG 118K calls/day over 32 days
08/13/16	 171,091 
08/12/16	 207,713 
08/11/16	 180,379 
08/10/16	 176,442 
08/09/16	 102,972 
08/08/16	 108,049 
08/07/16	 128,103 
08/06/16	 162,891 
08/05/16	 82,272 
08/04/16	 88,379 
08/03/16	 104,015 
08/02/16	 100,270 
08/01/16	 159,387 
07/31/16	 162,463 
07/30/16	 167,025 
07/29/16	 91,676 
07/28/16	 84,728 
07/27/16	 103,686 
07/26/16	 97,741 
07/25/16	 108,061 
07/24/16	 108,586 
07/23/16	 106,756 
07/22/16	 80,750 
07/21/16	 92,228 
07/20/16	 92,030 
07/19/16	 98,281 
07/18/16	 152,308 
07/17/16	 181,500 
07/16/16	 99,215 
07/15/16	 95,049 
07/14/16	 28,250 

*/

SELECT COUNT(*)
FROM [ErrorLogging].dbo.ProcedureLog
WHERE Value1 = 'PROC CALLED'








-- [SMI Reporting].[dbo].[spUpdateBOMTemplateDetail]

SELECT * --distinct
-- LogDate, ProcedureName, ErrorMessage, 
--Field1, Value1
--, Field2, Value2, Field3, Value3, Field4, Value4--, Field5, Value5
-- DELETE 
FROM [ErrorLogging].dbo.ProcedureLog
WHERE LogDate >= '04/29/2012'
    --and Field5 like '%TEST%' 
    --ProcedureName = '[SMI Reporting].[dbo].[spUpdateSKUTransaction]'
    and ProcedureName = '[SMI Reporting].[dbo].[spUpdateBOMTemplateMaster]' 
    --and Value2 <> '98'   
    --and Value5 = 'Proc called.. temp tracking'
ORDER BY ProcedureName
    -- LogDate



-- did the refed ixFinishedSKUs update?
SELECT distinct ixFinishedSKU, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from [SMI Reporting].[dbo].tblBOMTemplateDetail
where ixFinishedSKU COLLATE Latin1_General_CS_AS in (SELECT distinct Value1 COLLATE Latin1_General_CS_AS as 'ixFinishedSKU'
                        FROM [ErrorLogging].dbo.ProcedureLog
                        WHERE ProcedureName = '[SMI Reporting].[dbo].[spUpdateBOMTemplateMaster]' 
                        )
ORDER by  dtDateLastSOPUpdate, ixTimeLastSOPUpdate                       

/******     GENERIC TEMPLATE to see latest/oldest update times  ********/
SELECT TOP 50 * FROM [SMI Reporting].dbo.tblBOMTemplateDetail ORDER BY dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc

-- 37145

SELECT min(ixTimeLastSOPUpdate), max(ixTimeLastSOPUpdate) FROM [SMI Reporting].dbo.tblBOMTemplateDetail






-- table constraint info
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS



-- most frequent
SELECT count(*) Qty,
REPLACE(ProcedureName, '].[dbo].[', '   ') ProcedureName
,ErrorMessage
--, CONVERT(VARCHAR, DATEADD(dd, DATEDIFF(dd, 0, LogDate), 0), 101) 'LogDate'
FROM [ErrorLogging].dbo.ProcedureLog
WHERE LogDate >= '06/20/2016'
GROUP BY ProcedureName,ErrorMessage--, DATEADD(dd, DATEDIFF(dd, 0, LogDate), 0)

ORDER BY count(*) desc



/*********     MOVE DATA   ********************* 
    FROM [ErrorLogging].dbo.ProcedureLog 
    TO [ErrorLogging].dbo.ProcedureLog_Resolved 
    as issues are resolved 
************************************************************/
SELECT count(*) FROM [ErrorLogging].dbo.ProcedureLog            -- 14K@4-28-16   12,424 @9-2-15       @12,923 @10-26-15
                                                                
SELECT count(*) FROM [ErrorLogging].dbo.ProcedureLog_Resolved   -- 97K@4-28-16   77,390 @9-2-15       @77,390 @10-26-15


BEGIN TRAN
INSERT INTO [ErrorLogging].dbo.ProcedureLog_Resolved
    SELECT LogDate,	DatabaseID,	ObjectID, ProcedureName,	ErrorLine,	ErrorMessage,	Field1,	Value1,	Field2,	Value2,	Field3,	Value3,	Field4,	Value4,	Field5,	Value5,
    'All SKUs now refeed succesfully.  Do not know original cause of update failure.' as 'ResolutionNotes'
 
    -- DELETE
    FROM [ErrorLogging].dbo.ProcedureLog
WHERE ProcedureName like '%SMI Reporting%spUpdateBOMTransferMaster%'
and LogDate >= '06/07/2017'
    --ErrorMessage like '%column ''ixSKU''%'
   -- Value5 = 'PROC CALLED'
  -- AND Value5 = 'TESTING - NOT an error'
-- and Value1 <> 'Q1752569'  
  --  LogDate >= '2015-12-11 15:36:03.447'
 --   AND ErrorMessage like '%smallmoney%'
    --   ErrorMessage like '%spUpdateBOMTemplateDetail%'
        -- AND LogDate >= '07/01/2010'
        -- AND Field1 = 'ixVendor'
        -- AND ErrorMessage LIKE '%deadlocked%'
    --    ProcedureName = '[SMI Reporting].[dbo].[spUpdateBOMTemplateMaster]' -- '[SMI Reporting].[dbo].[spUpdateSKU]' 
        -- AND ErrorMessage Like 'Violation of PRIMARY KEY constraint%'
        -- AND ProcedureName IN ('[AFCOReporting].[dbo].[spUpdateSKUTransaction]','[SMI Reporting].[dbo].[spUpdateSKUTransaction]','[SMI Reporting].[dbo].[spUpdateVendorSKU]')
ROLLBACK TRAN

select * from [ErrorLogging].dbo.ProcedureLog_Resolved
where ResolutionNotes = 'increased column sizes for sDescription,dExpectedAverageOrderSize,dExpectedAverageMargin '
order by LogDate desc


BEGIN TRAN

INSERT INTO [ErrorLogging].dbo.ProcedureLog
    SELECT LogDate,	DatabaseID,	ObjectID, ProcedureName,	ErrorLine,	ErrorMessage,	Field1,	Value1,	Field2,	Value2,	Field3,	Value3,	Field4,	Value4,	Field5,	Value5 
    -- DELETE
    FROM [ErrorLogging].dbo.ProcedureLog_Resolved
where ResolutionNotes = 'increased column sizes for sDescription,dExpectedAverageOrderSize,dExpectedAverageMargin '

ROLLBACK TRAN







SELECT name 'Proc', create_date, modify_date
FROM [AFCOReporting].sys.tables
WHERE name like 'tblSKUT%'


-- Procs in AFCO but not SMI
SELECT name 'Proc', create_date, modify_date
FROM [AFCOReporting].sys.procedures
WHERE name like 'spUpdate%'
and name NOT IN (SELECT name
                 FROM [SMI Reporting].sys.procedures
                 WHERE name like 'spUpdate%')

-- Procs in SMI but NOT AFCO
SELECT name 'Proc', create_date, modify_date
FROM [SMI Reporting].sys.procedures
WHERE name like 'spUpdate%'
and name NOT IN (SELECT name
                 FROM [AFCOReporting].sys.procedures
                 WHERE name like 'spUpdate%')




SELECT * FROM [ErrorLogging].dbo.ProcedureLog
WHERE ErrorMessage like  '%dbo.tblSKU%'
and LogDate between '02/01/2021' and '03/08/2021'
ORDER BY LogDate


SELECT ErrorMessage,  
    CONVERT(VARCHAR(10),LogDate,10) 'LogDate', 
    count(*)
FROM [ErrorLogging].dbo.ProcedureLog
WHERE LogDate >= '08/01/2016' -- between '09/01/2014' and '09/15/2014'
GROUP BY ErrorMessage,  
    CONVERT(VARCHAR(10),LogDate,10)
ORDER BY ErrorMessage, CONVERT(VARCHAR(10),LogDate,10)    






CONVERT(VARCHAR, DATEADD(dd, DATEDIFF(dd, 0, LogDate), 0), 101) AS 'Date'


SELECT DATEADD(dd, DATEDIFF(dd, 0, LogDate), 0)
FROM [ErrorLogging].dbo.ProcedureLog



SELECT -- *
    LogDate, ProcedureName, ErrorLine, ErrorMessage, AdditionalInfo
FROM [ErrorLogging].dbo.ProcedureLogOLD
ORDER BY ErrorMessage, LogDate



-- DELETE
-- SELECT *
FROM [ErrorLogging].dbo.ProcedureLog
WHERE ProcedureName like '%SMI Reporting%spUpdateBOMTransferMaster%'
and LogDate >= '06/07/2017'


SELECT -- *
    CONVERT(VARCHAR, LogDate, 101) AS 'Date', ProcedureName, ErrorMessage, count(*) Qty
FROM [ErrorLogging].dbo.ProcedureLog
WHERE LogDate between DATEADD(dd,-3,DATEDIFF(dd,0,getdate())) and DATEADD(dd,1,DATEDIFF(dd,0,getdate()))
GROUP BY CONVERT(VARCHAR, LogDate, 101), ProcedureName, ErrorMessage

ORDER BY 
--Value3, 
LogDate desc

[AFCOReporting].[dbo].[spUpdateSKUTransaction]


SELECT name 'Proc', create_date, modify_date
FROM [SMI Reporting].sys.procedures
WHERE (name like 'spUpdate%'
        or name like 'spDelete%')
ORDER BY name        

SELECT name 'Proc', create_date, modify_date
FROM [AFCOReporting].sys.procedures
WHERE name like 'spUpdate%'


-- Procs in AFCO but not SMI
SELECT name 'Proc', create_date, modify_date
FROM [AFCOReporting].sys.procedures
WHERE name like 'spUpdate%'
and name NOT IN (SELECT name
                 FROM [SMI Reporting].sys.procedures
                 WHERE name like 'spUpdate%')

-- Procs in SMI but NOT AFCO
SELECT name 'Proc', create_date, modify_date
FROM [SMI Reporting].sys.procedures
WHERE name like 'spUpdate%'
and name NOT IN (SELECT name
                 FROM [AFCOReporting].sys.procedures
                 WHERE name like 'spUpdate%')


-- DELETE TESTING records
BEGIN TRAN

    SELECT *
    -- DELETE
    FROM [ErrorLogging].dbo.ProcedureLog
    WHERE ProcedureName like '%spEmptyCreditMemoReasonCode%' 
    AND Field1 = 'TEST'

ROLLBACK TRAN






SELECT FORMAT(LogDate,'yyyy.MM.dd') 'LogDate', format(count(1),'###,###,##0') 'Qty'
    ,ErrorMessage ,ProcedureName
  --  ,CONVERT(VARCHAR(10),LogDate,10) 'LogDate'
FROM [ErrorLogging].dbo.ProcedureLog
WHERE LogDate > '2021-05-05' -- >= DATEADD(dd, -1, getdate())  -- past X days
   AND ProcedureName like '%spUpdateSKUTrans%' -- '%SMI eporting%spUpdateOrderLine%' 
GROUP BY FORMAT(LogDate,'yyyy.MM.dd'), ErrorMessage ,ProcedureName
--HAVING count(*) > 30
    ORDER BY FORMAT(LogDate,'yyyy.MM.dd') desc --count(1) desc, ProcedureName, ErrorMessage 

SELECT FORMAT(D.dtDate,'yyyy.MM.dd') 'Date', format(count(ST.iSeq),'###,###,##0') 'Qty'
from tblSKUTransaction ST
    left join tblDate D on ST.ixDate = D.ixDate
WHERE D.dtDate > '2021-05-05'




/*  DELETE TEST RECORDS

SET ROWCOUNT 0 -- 1000000

SELECT COUNT(1) -- 3,917,987
-- DELETE 
FROM [ErrorLogging].dbo.ProcedureLog
WHERE LogDate > '2021-05-05' -- >= DATEADD(dd, -1, getdate())  -- past X days
   AND ProcedureName like '%spUpdateSKUTrans%'
   AND ErrorMessage is NULL 


latest SKU Trans
/*
CurrentTime	SOPUpdated	TransTime	iSeq
09:12:02	09:11:35  	09:11:19  	10455
09:13:37	09:13:14  	09:12:36  	11024
09:19:24	09:19:20  	09:19:03  	12035 -- table still updates after modifying the stored proc


*/


