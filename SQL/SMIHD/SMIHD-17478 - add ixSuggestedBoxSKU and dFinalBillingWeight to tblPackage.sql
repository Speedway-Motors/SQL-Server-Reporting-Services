-- SMIHD-17478 - add ixSuggestedBoxSKU and dFinalBillingWeight to tblPackage

-- RENAME This Template using the appropriate Jira Case #

SELECT @@SPID as 'Current SPID' -- 58

/*  TABLE: tblPackage
    CHANGES TO BE MADE: add ixSuggestedBoxSKU  varchar(30), (NULL ALLOWED)
                            dFinalBillingWeight (decimal(10,3), (NULL ALLOWED)
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

select * into [SMIArchive].dbo.BU_tblPackage_20200423 from [SMI Reporting].dbo.tblPackage      --    7,216,522
select * into [SMIArchive].dbo.BU_AFCO_tblPackage_20200423 from [AFCOReporting].dbo.tblPackage --      414,820

-- DROP TABLE [SMIArchive].dbo.BU_tblPackage_20200207
-- DROP TABLE [SMIArchive].dbo.BU_AFCO_tblPackage_20200207


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
ALTER TABLE [ChangeLog_smiReportingRawData].dbo.tblPackage ADD
    ixSuggestedBoxSKU  varchar(30),
    dFinalBillingWeight decimal(10,3)
GO
ALTER TABLE [ChangeLog_smiReportingRawData].dbo.tblPackage SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE [SMI Reporting].dbo.tblPackage ADD
    ixSuggestedBoxSKU  varchar(30),
    dFinalBillingWeight decimal(10,3)
GO
ALTER TABLE [SMI Reporting].dbo.tblPackage SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
 --ROLLBACK TRAN

-- SELECT TOP 1 * FROM dbo.tblPackage

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
ALTER TABLE [AFCOReporting].dbo.tblPackage ADD
    ixSuggestedBoxSKU  varchar(30),
    dFinalBillingWeight decimal(10,3)
GO
ALTER TABLE [AFCOReporting].dbo.tblPackage SET (LOCK_ESCALATION = TABLE)
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

/****** Object:  StoredProcedure [dbo].[spUpdatePackage]    Script Date: 4/23/2020 9:41:23 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[spUpdatePackage]
	@sTrackingNumber varchar(30),
	@ixOrder varchar(10),
	@ixVerificationDate smallint,
	@ixVerificationTime int,
	@ixShipDate smallint,
	@ixShipTime int,
	@ixPacker varchar(10),
	@ixVerifier varchar(10),
	@ixShipper varchar(10),
	@dBillingWeight decimal(10,3),
	@dActualWeight decimal(10,3),
	@ixTrailer varchar(10),
	@mPublishedFreight money,
	@mShippingCost money,
	@ixVerificationIP varchar(15),
	@ixShippingIP varchar(15),
	@ixShipTNT tinyint,
	@flgMetals tinyint,
	@flgCanceled tinyint,
	@flgReplaced tinyint,
	@dLength decimal(6,1),
    @dWidth decimal(6,1),
    @dHeight decimal(6,1),
    @ixPackageDeliveredLocal int,
    @dtPackageDeliveredLocal datetime,
    @dDimWeight decimal(10, 3),
    @mSMIEstScaleShippingCost money,
    @dBoxWeight decimal(10, 3),
    @ixBoxSKU varchar(30),
    @ixSuggestedBoxSKU  varchar(30),
    @dFinalBillingWeight decimal(10,3)
    	
AS
if exists (select * from tblPackage where sTrackingNumber = @sTrackingNumber and ixOrder = @ixOrder)
    BEGIN
        BEGIN TRY
	    update tblPackage set
		    ixVerificationDate = @ixVerificationDate,
		    ixVerificationTime = @ixVerificationTime,
		    ixShipDate = @ixShipDate,
		    ixShipTime = @ixShipTime,
		    ixPacker = @ixPacker,
		    ixVerifier = @ixVerifier,
		    ixShipper = @ixShipper, 
		    dBillingWeight = @dBillingWeight,
		    dActualWeight = @dActualWeight,
		    ixTrailer = @ixTrailer,
	        mPublishedFreight = @mPublishedFreight,
            mShippingCost = @mShippingCost,
            ixVerificationIP = @ixVerificationIP,
	        ixShippingIP = @ixShippingIP,
	        dtDateLastSOPUpdate = DATEADD(dd,0,DATEDIFF(dd,0,GETDATE())),
	        ixTimeLastSOPUpdate = dbo.GetCurrentixTime(),
	        ixShipTNT = @ixShipTNT,
	        flgMetals = @flgMetals,
	        flgCanceled = @flgCanceled,
	        flgReplaced = @flgReplaced,
	        dLength = @dLength,
            dWidth = @dWidth,
            dHeight = @dHeight,
            ixPackageDeliveredLocal = @ixPackageDeliveredLocal,
            dtPackageDeliveredLocal = @dtPackageDeliveredLocal,
            dDimWeight = @dDimWeight,
            mSMIEstScaleShippingCost = @mSMIEstScaleShippingCost,
            dBoxWeight = @dBoxWeight,
            ixBoxSKU = @ixBoxSKU,
            ixSuggestedBoxSKU = @ixSuggestedBoxSKU,
            dFinalBillingWeight = @dFinalBillingWeight
            -- mSMIEstScaleShippingCost = NULL
		    WHERE sTrackingNumber = @sTrackingNumber and ixOrder = @ixOrder
		END TRY
	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='sTrackingNumber',@Value1=@sTrackingNumber, 
                @Field2='ixOrder',        @Value2=@ixOrder,
                @Field3='dActualWeight',  @Value3=@dActualWeight,
                @Field4='ixSuggestedBoxSKU',    @Value4=@ixSuggestedBoxSKU, 
                @Field5='dFinalBillingWeight',  @Value5=@dFinalBillingWeight 
        END CATCH       	
    END
ELSE
    BEGIN
        BEGIN TRY
        insert tblPackage 
            (sTrackingNumber, ixOrder, ixVerificationDate, ixVerificationTime, ixShipDate, ixShipTime, ixPacker, ixVerifier, ixShipper, dBillingWeight, -- 10
             dActualWeight, ixTrailer, mPublishedFreight, mShippingCost, ixVerificationIP, ixShippingIP, dtDateLastSOPUpdate, ixTimeLastSOPUpdate, ixShipTNT, flgMetals, --20
             flgCanceled, flgReplaced, dLength, dWidth, dHeight, ixPackageDeliveredLocal,dtPackageDeliveredLocal, dDimWeight, mSMIEstScaleShippingCost, dBoxWeight,  -- 30
             ixBoxSKU, ixSuggestedBoxSKU,dFinalBillingWeight)
        values
	        (@sTrackingNumber, @ixOrder, @ixVerificationDate, @ixVerificationTime, @ixShipDate, @ixShipTime, @ixPacker, @ixVerifier, @ixShipper, @dBillingWeight, 
             @dActualWeight, @ixTrailer, @mPublishedFreight, @mShippingCost, @ixVerificationIP, @ixShippingIP,
             DATEADD(dd,0,DATEDIFF(dd,0,GETDATE())), dbo.GetCurrentixTime(), @ixShipTNT, @flgMetals, 
             @flgCanceled, @flgReplaced,@dLength, @dWidth, @dHeight, @ixPackageDeliveredLocal, @dtPackageDeliveredLocal, @dDimWeight, @mSMIEstScaleShippingCost, @dBoxWeight, 
             @ixBoxSKU, @ixSuggestedBoxSKU, @dFinalBillingWeight)
        END TRY
	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='sTrackingNumber',@Value1=@sTrackingNumber, 
                @Field2='ixOrder',        @Value2=@ixOrder,
                @Field3='dActualWeight',  @Value3=@dActualWeight,
                @Field4='ixSuggestedBoxSKU',    @Value4=@ixSuggestedBoxSKU, 
                @Field5='dFinalBillingWeight',  @Value5=@dFinalBillingWeight 
        END CATCH           	         
    END

GO








USE [AFCOReporting]
GO

/****** Object:  StoredProcedure [dbo].[spUpdatePackage]    Script Date: 4/23/2020 10:02:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[spUpdatePackage]
	@sTrackingNumber varchar(30),
	@ixOrder varchar(10),
	@ixVerificationDate smallint,
	@ixVerificationTime int,
	@ixShipDate smallint,
	@ixShipTime int,
	@ixPacker varchar(10),
	@ixVerifier varchar(10),
	@ixShipper varchar(10),
	@dBillingWeight decimal(10,3),
	@dActualWeight decimal(10,3),
	@ixTrailer varchar(10),
	@mPublishedFreight money,
	@mShippingCost money,
	@ixVerificationIP varchar(15),
	@ixShippingIP varchar(15),
	@ixShipTNT tinyint,
	@flgMetals tinyint,
	@flgCanceled tinyint,
	@flgReplaced tinyint,
	@dLength decimal(6,1),
    @dWidth decimal(6,1),
    @dHeight decimal(6,1),
    @ixPackageDeliveredLocal int,
    @dtPackageDeliveredLocal datetime,
    @dDimWeight decimal(10, 3),
    @mSMIEstScaleShippingCost money,
    @dBoxWeight decimal(10, 3),
    @ixBoxSKU varchar(30),
    @ixSuggestedBoxSKU  varchar(30),
    @dFinalBillingWeight decimal(10,3)

AS
if exists (select * from tblPackage where sTrackingNumber = @sTrackingNumber and ixOrder = @ixOrder)
    BEGIN
        BEGIN TRY
	    update tblPackage set
		    ixVerificationDate = @ixVerificationDate,
		    ixVerificationTime = @ixVerificationTime,
		    ixShipDate = @ixShipDate,
		    ixShipTime = @ixShipTime,
		    ixPacker = @ixPacker,
		    ixVerifier = @ixVerifier,
		    ixShipper = @ixShipper, 
		    dBillingWeight = @dBillingWeight,
		    dActualWeight = @dActualWeight,
		    ixTrailer = @ixTrailer,
	        mPublishedFreight = @mPublishedFreight,
            mShippingCost = @mShippingCost,
            ixVerificationIP = @ixVerificationIP,
	        ixShippingIP = @ixShippingIP,
	        dtDateLastSOPUpdate = DATEADD(dd,0,DATEDIFF(dd,0,GETDATE())),
	        ixTimeLastSOPUpdate = dbo.GetCurrentixTime(),
	        ixShipTNT = @ixShipTNT,
	        flgMetals = @flgMetals,
	        flgCanceled = @flgCanceled,
	        flgReplaced = @flgReplaced,
	        dLength = @dLength,
            dWidth = @dWidth,
            dHeight = @dHeight,
            ixPackageDeliveredLocal = @ixPackageDeliveredLocal,
            dtPackageDeliveredLocal = @dtPackageDeliveredLocal,
            dDimWeight = @dDimWeight,
            mSMIEstScaleShippingCost = @mSMIEstScaleShippingCost,
            dBoxWeight = @dBoxWeight,
            ixBoxSKU = @ixBoxSKU,
            ixSuggestedBoxSKU = @ixSuggestedBoxSKU,
            dFinalBillingWeight = @dFinalBillingWeight
            -- mSMIEstScaleShippingCost = NULL
		    WHERE sTrackingNumber = @sTrackingNumber and ixOrder = @ixOrder
		END TRY
	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='sTrackingNumber',@Value1=@sTrackingNumber, 
                @Field2='ixOrder',        @Value2=@ixOrder,
                @Field3='dActualWeight',  @Value3=@dActualWeight,
                @Field4='ixSuggestedBoxSKU',    @Value4=@ixSuggestedBoxSKU, 
                @Field5='dFinalBillingWeight',  @Value5=@dFinalBillingWeight 
        END CATCH       	
    END
ELSE
    BEGIN
        BEGIN TRY
        insert tblPackage 
            (sTrackingNumber, ixOrder, ixVerificationDate, ixVerificationTime, ixShipDate, ixShipTime, ixPacker, ixVerifier, ixShipper, dBillingWeight, -- 10
             dActualWeight, ixTrailer, mPublishedFreight, mShippingCost, ixVerificationIP, ixShippingIP, dtDateLastSOPUpdate, ixTimeLastSOPUpdate, ixShipTNT, flgMetals, --20
             flgCanceled, flgReplaced, dLength, dWidth, dHeight, ixPackageDeliveredLocal,dtPackageDeliveredLocal, dDimWeight, mSMIEstScaleShippingCost, dBoxWeight,  -- 30
             ixBoxSKU, ixSuggestedBoxSKU,dFinalBillingWeight)
        values
	        (@sTrackingNumber, @ixOrder, @ixVerificationDate, @ixVerificationTime, @ixShipDate, @ixShipTime, @ixPacker, @ixVerifier, @ixShipper, @dBillingWeight, 
             @dActualWeight, @ixTrailer, @mPublishedFreight, @mShippingCost, @ixVerificationIP, @ixShippingIP,
             DATEADD(dd,0,DATEDIFF(dd,0,GETDATE())), dbo.GetCurrentixTime(), @ixShipTNT, @flgMetals, 
             @flgCanceled, @flgReplaced,@dLength, @dWidth, @dHeight, @ixPackageDeliveredLocal, @dtPackageDeliveredLocal, @dDimWeight, @mSMIEstScaleShippingCost, @dBoxWeight, 
             @ixBoxSKU, @ixSuggestedBoxSKU, @dFinalBillingWeight)
        END TRY
	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='sTrackingNumber',@Value1=@sTrackingNumber, 
                @Field2='ixOrder',        @Value2=@ixOrder,
                @Field3='dActualWeight',  @Value3=@dActualWeight,
                @Field4='ixSuggestedBoxSKU',    @Value4=@ixSuggestedBoxSKU, 
                @Field5='dFinalBillingWeight',  @Value5=@dFinalBillingWeight 
        END CATCH           	         
    END

GO






/*************************************************************************************************************/
/******    STEP 15) manually push records to test feeds                                                *******/
/******    SOP                                                                                         *******/

    --SMI TEST DATA
        SELECT sTrackingNumber, ixOrder, ixBoxSKU,  ixSuggestedBoxSKU, dFinalBillingWeight, ixShipDate, flgReplaced, flgCanceled,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [SMI Reporting].dbo.tblPackage 
        where --ixOrder in ('')
             ixSuggestedBoxSKU  is NOT NULL
             or dFinalBillingWeight is NOT NULL
        order by sTrackingNumber, ixOrder 

        
select ixBoxSKU, count(*) PkgCount
from tblPackage
where ixShipDate >=      19101  
    and flgCanceled = 0
    and flgReplaced = 0
group by ixBoxSKU
order by count(*) desc
                                         


    --AFCO TEST DATA
        SELECT sTrackingNumber, ixOrder, ixBoxSKU,  ixSuggestedBoxSKU, dFinalBillingWeight, ixShipDate, flgReplaced, flgCanceled,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [AFCOReporting].dbo.tblPackage 
        where --ixOrder in ('')
             ixSuggestedBoxSKU  is NOT NULL
             or dFinalBillingWeight is NOT NULL
        order by sTrackingNumber, ixOrder 

/*
select * from tblEmployee where ixEmployee = 'JJM'

*/

SELECT * FROM tblTime where ixTime = 

/*************************************************************************************************************/
/******    STEP 16) verify records pushed updated as expected in SMI/AFCO Reporting                    *******/
/******    SOP                                                                                         *******/

        SELECT  ixSuggestedBoxSKU, count(*) 'PkgCnt'
        from [SMI Reporting].dbo.tblPackage 
        where --sTrackingNumber in ( '8464588-1', '8827980')
            ixSuggestedBoxSKU  is NOT NULL
        GROUP BY ixSuggestedBoxSKU
        ORDER BY ixSuggestedBoxSKU

        SELECT  dFinalBillingWeight, count(*) 'PkgCnt'
        from [SMI Reporting].dbo.tblPackage 
        where --sTrackingNumber in ( '8464588-1', '8827980')
            dFinalBillingWeight  is NOT NULL
        GROUP BY dFinalBillingWeight
        ORDER BY dFinalBillingWeight


       /*********   AFCO TEST DATA  *********/
        SELECT  ixSuggestedBoxSKU, count(*) 'PkgCnt'
        from [SMI Reporting].dbo.tblPackage 
        where --sTrackingNumber in ( '8464588-1', '8827980')
            ixSuggestedBoxSKU  is NOT NULL
        GROUP BY ixSuggestedBoxSKU
        ORDER BY ixSuggestedBoxSKU

        SELECT  dFinalBillingWeight, count(*) 'PkgCnt'
        from [AFCOReporting].dbo.tblPackage 
        where --sTrackingNumber in ( '8464588-1', '8827980')
            dFinalBillingWeight  is NOT NULL
        GROUP BY dFinalBillingWeight
        ORDER BY dFinalBillingWeight





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
    select * from tblErrorCode where sDescription like '%tblPackage%'
    --  1141	Failure to update tblPackage.

    -- ERROR CODE feeds are DELAYED
    -- CHECK FOR THE CODES DIRECTLY IN SOP !!!!!!!


    -- ERROR COUNTS by Day
    SELECT DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
        ,count(*) AS 'ErrorQty'
    FROM tblErrorLogMaster
    WHERE ixErrorCode = '1141'
      and dtDate >=  DATEADD(month, -11, getdate())  -- past X months
    GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
    --HAVING count(*) > 10
    ORDER BY dtDate desc 
    /*
    DataBaseName	Date      	ErrorQty
    SMI Reporting	01-28-20	3

*/

SELECT sShippingInstructions , FORMAT(count(*),'###,###') 'ORDERcount'
FROM tblPackage
-- WHERE sShippingInstructions  is NOT NULL
GROUP BY sShippingInstructions 
order by sShippingInstructions 












SELECT sShippingInstructions , FORMAT(count(*),'###,###') 'BOXcount'
FROM [SMI Reporting].dbo.tblPackage 
WHERE flgDeletedFromSOP = 0 
   -- and sShippingInstructions  is NOT NULL
GROUP BY sShippingInstructions 
order by sShippingInstructions
/*
sPackage
Type	SKUcount    @1:26
NULL	11,170
BOX	    218
ENV	    7
NA	    461,596
NEW	    2
SLAPR	3,955
*/

select ixOrder, dtCreateDate from tblPackage
where ixOrder NOT IN (select ixOrder from tblSnapshotSKU where ixDate = 19031)
and flgDeletedFromSOP = 0
order by dtCreateDate

BEGIN TRAN

    UPDATE tblPackage
    set sShippingInstructions = NULL
    where ixOrder between 'UP119850' and 'UP119875'


ROLLBACK TRAN


select * from tblPackage where flgDeletedFromSOP = 0 
    and sShippingInstructions  is NULL



select ixOrder, sShippingInstructions ,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
from tblPackage
where ixOrder in ('103A184B1SS','10620231','10620231XHD','10640015','10640017','10680100LWN','10680101NP','10680103N','10680104N','10680120N','10680144-S-NA-Y','10680184NDP','10680184NDPU','10680185NDP','10680202N','10680205','106802051','10680249N','1068026810','10680283NDP','10680404FAN','10681164-S-NA-N','1132070','1132276','113253','113345','113550','113594','113673','113679','113681','113696','113709','113856','113913','113996')

select * from tblTime where ixTime = 48421






select top 100 ixOrder, ixOrderTime
from tblOrder
where ixOrderDate = 19107
and ixOrderTime >= 48000
order by ixOrderTime desc

select count(*) 
from dbo.tblOrder
where ixOrderDate = 19107
