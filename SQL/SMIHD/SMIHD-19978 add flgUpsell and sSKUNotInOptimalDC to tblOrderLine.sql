-- SMIHD-19978 add flgUpsell and sSKUNotInOptimalDC to tblOrderLine

-- RENAME This Template using the appropriate Jira Case #

SELECT @@SPID as 'Current SPID' -- 52

/*  TABLE: tblOrderLine
    CHANGES TO BE MADE: add ixCancellationReasonCode field to tblOrderLine
*/

/* steps as of 2019.09.19

STEP    WHERE	        ACTION
=== ===============     =======================================================
1	LNK-SQL-LIVE-1	    BACKUP tables to be modified to SMIArchive
2	LNK-SQL-LIVE-1	    DISABLE SSA job "SMIJob_AwsExportData"
3	dw.speedway2.com	DISABLE SSA job "JobAwsImportData"
4	dw.speedway2.com	Script & drop any affexted indexes in SMIReportingRawData
5	dw.speedway2.com	Add to/Alter the corresponding table in SMiReportingRawData (Schema is Transfer)
6	dw.speedway2.com	Rebuild any affected indexes in SMiReportingRawData
7	LNK-SQL-LIVE-1	    Script & drop any affected indexes in ChangeLog_smiReporting
8	LNK-SQL-LIVE-1	    Add to/Alter corresponding table in ChangeLog_smiReporting (Schema is dbo)
9	LNK-SQL-LIVE-1	    Rebuild any affected indexes in ChangeLog_smiReporting
10	SOP	                PAUSE feeds to SMI/AFCO Reporting
11	LNK-SQL-LIVE-1	    Script & drop any affected indexes in SMI/AFCO Reporting
12	LNK-SQL-LIVE-1	    Add/Alter the column in the corresponding table in SMI/AFCO Reporting  (Schema is dbo)
13	LNK-SQL-LIVE-1	    Rebuild any affected indexes in SMI/AFCO Reporting
14	LNK-SQL-LIVE-1	    apply script changes to the appropriate stored procedure(s) (usually spUpdate<tablename>)
15	SOP	                RESUME feeds to SMI/AFCO Reporting
16	SOP             	manually push records to test feeds (before resuming feeds if possible)
17	LNK-SQL-LIVE-1	    verify records pushed updated as expected in SMI/AFCO Reporting 
18	LNK-SQL-LIVE-1	    RE-ENABLE SSA job "SMIJob_AwsExportData"
19	dw.speedway2.com	RE-ENABLE SSA job "JobAwsImportData"
20	dw.speedway2.com	VERIFY updates in SMI Reporting are making their way to corresponding AWS tables
21	SOP	                Verify no error codes are tripping

*/


/*************************************************************************************************************/
/******    STEP 1) DISABLE SSA job "SMIJob_AwsExportData"                                              *******/
/******    LNK-SQL-LIVE-1                                                                              *******/
    exec [msdb].dbo.sp_update_job @job_name = 'SMIJob_AwsExportData', @enabled = 0

/*************************************************************************************************************/
/******   STEP 2) DISABLE SSA job "JobAwsImportData"   ON    [dw.speedway2.com].SMiReportingRawData    *******/


/*************************************************************************************************************/
/******    STEP 3) Back-up tables to be modified to SMIArchive                                         *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

select * into [SMIArchive].dbo.BU_tblOrderLine_20210204 from [SMI Reporting].dbo.tblOrderLine      --   30,163,977
select * into [SMIArchive].dbo.BU_AFCO_tblOrderLine_20210204 from [AFCOReporting].dbo.tblOrderLine --    1,981,378

-- DROP TABLE [SMIArchive].dbo.BU_tblOrderLine_20200207
-- DROP TABLE [SMIArchive].dbo.BU_AFCO_tblOrderLine_20200207


/******    Copy & Paste detailed code at end of script to a session ON [dw.speedway2.com].SMiReportingRawData
    STEP 2) DISABLE SSA job "JobAwsImportData"                           ON dw.speedway2.com
    STEP 4) Script & drop any affected indexes in SMiReportingRawData    ON dw.speedway2.com
    STEP 5) Add to/Alter corresponding table in SMiReportingRawData      ON dw.speedway2.com
    STEP 6) Rebuild any affected indexes in in SMiReportingRawData       ON dw.speedway2.com                
    STEP 19) RE-ENABLE SSA job "JobAwsImportData"
    STEP 20) VERIFY updates in SMI Reporting are making their way to corresponding AWS tables
    */


/*************************************************************************************************************/
/******    STEP 7)	Script & drop any affected indexes in ChangeLog_smiReporting                       *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

            N/A



/*************************************************************************************************************/
/******    STEP 8)	Add the column to the corresponding table in ChangeLog_smiReportingRawData         *******/
/******            (Schema is dbo)                                                                     *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

-- SMI REPORTING

BEGIN TRANSACTION   -- 37 sec
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE [ChangeLog_smiReportingRawData].dbo.tblOrderLine ADD
    flgUpsell int,
    sSKUNotInOptimalDC varchar(6)
GO  
ALTER TABLE [ChangeLog_smiReportingRawData].dbo.tblOrderLine SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

/*************************************************************************************************************/
/******    STEP 9)	Rebuild any affected indexes in ChangeLog_smiReporting                             *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

            N/A

/*************************************************************************************************************/
/******    STEP 10) PAUSE feeds to SMI/AFCO Reporting                                                   *******/
/******    SOP                                                                                         *******/



/*************************************************************************************************************/
/******    STEP 11) Script & drop any affected indexes in SMI/AFCO Reporting                            *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

           N/A



/*************************************************************************************************************/
/******    STEP 12) Add the column to the SMI/AFCO Reporting tables                                    *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

-- SMI
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION -- be sure to change the SCHEMA when copying and pasting!
GO
ALTER TABLE [SMI Reporting].dbo.tblOrderLine ADD
        flgUpsell int,
        sSKUNotInOptimalDC varchar(6)
GO
ALTER TABLE [SMI Reporting].dbo.tblOrderLine SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
 --ROLLBACK TRAN


-- SELECT TOP 1 * FROM dbo.tblOrderLineLocation

-- AFCO
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION -- be sure to change the SCHEMA when copying and pasting!
GO
ALTER TABLE [AFCOReporting].dbo.tblOrderLine ADD
        flgUpsell int,
        sSKUNotInOptimalDC varchar(6)
GO
ALTER TABLE [AFCOReporting].dbo.tblOrderLine SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


/*************************************************************************************************************/
/******    STEP 13) Rebuild any affected indexes in SMI/AFCO Reporting                                 *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

            N/A


/*************************************************************************************************************/
/******    STEP 14) apply script changes to the appropriate stored procedure(s)                        *******/
/******            (usually spUpdate<tablename>)                                                       *******/
/******    LNK-SQL-LIVE-1                                                                              *******/
USE [SMI Reporting]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateOrderLine]    Script Date: 2/4/2021 2:22:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spUpdateOrderLine]
	@ixOrder varchar(10),
	@ixCustomer varchar(10),
	@ixSKU varchar(30),
	@ixShippedDate smallint,
	@ixOrderDate smallint,
	@iQuantity smallint,
	@mUnitPrice money,
	@mExtendedPrice money,
	@flgLineStatus varchar(15),
	@dtOrderDate datetime,
	@dtShippedDate datetime,
	@mCost money,
	@mExtendedCost money,
	@flgKitComponent tinyint,
	@iOrdinality smallint,
	@iKitOrdinality smallint,
	@ixPrintedDate int,
	@ixPrintedTime int,
	@mSystemUnitPrice money,
	@mExtendedSystemPrice money,
	@ixPriceDevianceReasonCode varchar(10),
	@sPriceDevianceReason varchar(100),
	@ixPicker varchar(10),
	@sTrackingNumber varchar(30),
	@iMispullQuantity int,
	@flgOverride tinyint,
	@mWeightedKitComponentPrice money,
    @flgUpsell int,
    @sSKUNotInOptimalDC varchar(6)
AS

/* NOTE: SOP first executes spDeleteOrderLine which deletes all rows for the specied order 
    and then executes this proc to insert the values. */
SET DEADLOCK_PRIORITY LOW -- switched to low 7-10-17 to see if it will  help with that Tableau refresh transaction deadlock errors
	
begin
	BEGIN TRY
		insert
			tblOrderLine (ixOrder, ixCustomer, ixSKU, ixShippedDate, ixOrderDate, iQuantity, mUnitPrice, mExtendedPrice, flgLineStatus,          -- 9
			dtOrderDate, dtShippedDate, mCost, mExtendedCost, flgKitComponent, iOrdinality, iKitOrdinality, ixPrintedDate, ixPrintedTime,        -- 9
			mSystemUnitPrice, mExtendedSystemPrice, ixPriceDevianceReasonCode, sPriceDevianceReason, ixPicker, sTrackingNumber, iMispullQuantity,-- 7
	        dtDateLastSOPUpdate, ixTimeLastSOPUpdate, flgOverride, 	mWeightedKitComponentPrice, mExtendedWeightedKitComponentPrice,     
            flgUpsell, sSKUNotInOptimalDC)
		values                                                                                                                                  
			(@ixOrder, @ixCustomer, @ixSKU, @ixShippedDate, @ixOrderDate, @iQuantity, @mUnitPrice, @mExtendedPrice, @flgLineStatus,                         -- 9
			 @dtOrderDate, @dtShippedDate, @mCost, @mExtendedCost, @flgKitComponent, @iOrdinality, @iKitOrdinality, @ixPrintedDate, @ixPrintedTime,         -- 9
			 @mSystemUnitPrice, @mExtendedSystemPrice, @ixPriceDevianceReasonCode, @sPriceDevianceReason, @ixPicker, @sTrackingNumber, @iMispullQuantity,   -- 7
			 DATEADD(dd,0,DATEDIFF(dd,0,GETDATE())),dbo.GetCurrentixTime(), @flgOverride, @mWeightedKitComponentPrice, (@mWeightedKitComponentPrice * @iQuantity),
             @flgUpsell, @sSKUNotInOptimalDC
			 )
	END TRY
	BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='ixSKU'         ,@Value2=@ixSKU,
                @Field3='flgLineStatus' ,@Value3=@flgLineStatus,
                @Field4='flgUpsell'   ,@Value4=@flgUpsell, 
                @Field5='sSKUNotInOptimalDC' ,@Value5=@sSKUNotInOptimalDC
    END CATCH

end

-- to generate error in Log_Procedure table:
-->  execute [spUpdateOrderLine] 9,9,'PAT testing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL


/*
select flgOverride, count(*) 
from tblOrderLine
group by flgOverride


SELECT max(ixTimeLastSOPUpdate)
from tblOrderLine
where dtDateLastSOPUpdate = '05/27/2015' 
-- AFCO 35951
-- SMI  36271


SELECT dtDate
    ,DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1142'
  and dtDate >=  DATEADD(dd, -2, getdate())  -- past X months
GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
--HAVING count(*) > 10
ORDER BY dtDate Desc

dtDate	    DataBaseName	Date      	ErrorQty
2015-05-27  SMI Reporting	05-27-15	1
2015-05-26  SMI Reporting	05-26-15	5
2015-05-26   AFCOReporting	05-26-15	1
*/








USE [AFCOReporting]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateOrderLine]    Script Date: 2/4/2021 2:28:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spUpdateOrderLine]
	@ixOrder varchar(10),
	@ixCustomer varchar(10),
	@ixSKU varchar(30),
	@ixShippedDate smallint,
	@ixOrderDate smallint,
	@iQuantity smallint,
	@mUnitPrice money,
	@mExtendedPrice money,
	@flgLineStatus varchar(15),
	@dtOrderDate datetime,
	@dtShippedDate datetime,
	@mCost money,
	@mExtendedCost money,
	@flgKitComponent tinyint,
	@iOrdinality smallint,
	@iKitOrdinality smallint,
	@ixPrintedDate int,
	@ixPrintedTime int,
	@mSystemUnitPrice money,
	@mExtendedSystemPrice money,
	@ixPriceDevianceReasonCode varchar(10),
	@sPriceDevianceReason varchar(100),
	@ixPicker varchar(10),
	@sTrackingNumber varchar(30),
	@iMispullQuantity int,
	@flgOverride tinyint,
	@mWeightedKitComponentPrice money,
    @flgUpsell int,
    @sSKUNotInOptimalDC varchar(6)
AS

/* NOTE: SOP first executes spDeleteOrderLine which deletes all rows for the specied order 
    and then executes this proc to insert the values. */
	
begin
	BEGIN TRY
		insert
			tblOrderLine (ixOrder, ixCustomer, ixSKU, ixShippedDate, ixOrderDate, iQuantity, mUnitPrice, mExtendedPrice, flgLineStatus,          -- 9
			dtOrderDate, dtShippedDate, mCost, mExtendedCost, flgKitComponent, iOrdinality, iKitOrdinality, ixPrintedDate, ixPrintedTime,        -- 9
			mSystemUnitPrice, mExtendedSystemPrice, ixPriceDevianceReasonCode, sPriceDevianceReason, ixPicker, sTrackingNumber, iMispullQuantity,-- 7
	        dtDateLastSOPUpdate, ixTimeLastSOPUpdate, flgOverride, 	mWeightedKitComponentPrice, mExtendedWeightedKitComponentPrice,
            flgUpsell, sSKUNotInOptimalDC)
		values                                                                                                                                  
			(@ixOrder, @ixCustomer, @ixSKU, @ixShippedDate, @ixOrderDate, @iQuantity, @mUnitPrice, @mExtendedPrice, @flgLineStatus,                         -- 9
			 @dtOrderDate, @dtShippedDate, @mCost, @mExtendedCost, @flgKitComponent, @iOrdinality, @iKitOrdinality, @ixPrintedDate, @ixPrintedTime,         -- 9
			 @mSystemUnitPrice, @mExtendedSystemPrice, @ixPriceDevianceReasonCode, @sPriceDevianceReason, @ixPicker, @sTrackingNumber, @iMispullQuantity,   -- 7
			 DATEADD(dd,0,DATEDIFF(dd,0,GETDATE())),dbo.GetCurrentixTime(), @flgOverride, @mWeightedKitComponentPrice, (@mWeightedKitComponentPrice * @iQuantity),
             @flgUpsell, @sSKUNotInOptimalDC
			 )
	END TRY
	BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='ixOrder'       ,@Value1=@ixOrder, 
                @Field2='ixSKU'         ,@Value2=@ixSKU,
                @Field3='flgLineStatus' ,@Value3=@flgLineStatus,
                @Field4='flgUpsell'     ,@Value4=@flgUpsell, 
                @Field5='sSKUNotInOptimalDC' ,@Value5=@sSKUNotInOptimalDC
    END CATCH

end

-- to generate error in Log_Procedure table:
-->  execute [spUpdateOrderLine] 9,9,'PAT testing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL


/*
select flgOverride, count(*) 
from tblOrderLine
group by flgOverride


SELECT max(ixTimeLastSOPUpdate)
from tblOrderLine
where dtDateLastSOPUpdate = '05/27/2015' 
-- AFCO 35951
-- SMI  36271


SELECT dtDate
    ,DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1142'
  and dtDate >=  DATEADD(dd, -2, getdate())  -- past X months
GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
--HAVING count(*) > 10
ORDER BY dtDate Desc

dtDate	    DataBaseName	Date      	ErrorQty
2015-05-27  SMI Reporting	05-27-15	1
2015-05-26  SMI Reporting	05-26-15	5
2015-05-26   AFCOReporting	05-26-15	1
*/




/*************************************************************************************************************/
/******    STEP 15) manually push records to test feeds                                                *******/
/******    SOP                                                                                         *******/


    --SMI TEST DATA
        SELECT ixOrder, ixSKU, flgUpsell, sSKUNotInOptimalDC,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM tblOrderLine S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixOrder  in ('9738298', '9738096', '9776097')
        ORDER BY dtDateLastSOPUpdate, T.chTime
            
    --AFCO TEST DATA
        SELECT ixOrder, flgUpsell, sSKUNotInOptimalDC,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM [AFCOReporting].dbo.tblOrderLine S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixOrder  in ('9738298', '9738096', '9776097')
        ORDER BY dtDateLastSOPUpdate, T.chTime


/*************************************************************************************************************/
/******    STEP 16) verify records pushed updated as expected in SMI/AFCO Reporting                    *******/
/******    SOP                                                                                         *******/

        SELECT ixOrder, flgUpsell, sSKUNotInOptimalDC,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM tblOrderLine S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE sSKUNotInOptimalDC is NOT NULL
            or flgUpsell is NOT NULL
        ORDER BY dtDateLastSOPUpdate, T.chTime


       /*********   AFCO TEST DATA  *********/
        SELECT ixOrder, ixCancellationReasonCode,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM [AFCOReporting].dbo.tblOrderLine S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE sSKUNotInOptimalDC is NOT NULL
            or flgUpsell is NOT NULL
        ORDER BY dtDateLastSOPUpdate, T.chTime

/*************************************************************************************************************/
/******    STEP 17) RESUME feeds to SMI/AFCO Reporting                                                 *******/
/******    SOP                                                                                         *******/

AFTER PSG HAS APPLIED THEIR  CHANGES



/*************************************************************************************************************/
/******    18) RE-ENABLE SSA job "SMIJob_AwsExportData"                                                *******/
/******    LNK-SQL-LIVE-1                                                                              *******/
            exec [msdb].dbo.sp_update_job @job_name = 'SMIJob_AwsExportData', @enabled = 1


/*************************************************************************************************************
    STEP 19) RE-ENABLE SSA job "JobAwsImportData"                       ON dw.speedway2.com                 
    STEP 20) Verify SMI Reporting updates are making their way to AWS   ON dw.speedway2.com                 */


/*************************************************************************************************************/
/******    STEP 21)	final check on SMI Reporting to make sure no error codes are tripping              *******/
/******    LNK-SQL-LIVE-1                                                                              *******/ 

    -- ERROR CODE to check on
    select * from tblErrorCode where sDescription like '%tblOrderLine%'
    --  1142	Failure to update tblOrderLine

    -- ERROR CODE feeds are DELAYED
    -- CHECK FOR THE CODES DIRECTLY IN SOP !!!!!!!


    -- ERROR COUNTS by Day
    SELECT DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
        ,count(*) AS 'ErrorQty'
    FROM tblErrorLogMaster
    WHERE ixErrorCode = '1142'
      and dtDate >=  DATEADD(month, -1, getdate())  -- past X months
    GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
    --HAVING count(*) > 10
    ORDER BY dtDate desc 
    /*
    DataBaseName	Date      	ErrorQty
    SMI Reporting	01-09-20	1082
    SMI Reporting	10-08-19	2009

*/

