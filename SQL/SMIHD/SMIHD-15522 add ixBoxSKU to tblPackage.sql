-- SMIHD-15522 add ixBoxSKU to tblPackage

-- RENAME This Template using the appropriate Jira Case #

SELECT @@SPID as 'Current SPID' -- 127

/*  TABLE: tblPackage
    CHANGES TO BE MADE: add ixBoxSKU (NULL ALLOWED)
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

select * into [SMIArchive].dbo.BU_tblPackage_20191025 from [SMI Reporting].dbo.tblPackage      --    6,770,472
select * into [SMIArchive].dbo.BU_AFCO_tblPackage_20191025 from [AFCOReporting].dbo.tblPackage --      395,656

-- DROP TABLE [SMIArchive].dbo.BU_tblPackage_20191025
-- DROP TABLE [SMIArchive].dbo.BU_AFCO_tblPackage_20191025


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
    ixBoxSKU varchar(30) NULL
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
    ixBoxSKU varchar(30) NULL
GO
ALTER TABLE [SMI Reporting].dbo.tblPackage SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
-- ROLLBACK TRAN

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
    ixBoxSKU varchar(30) NULL
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
/****** Object:  StoredProcedure [dbo].[spUpdatePackage]    Script Date: 10/23/2019 1:08:07 PM ******/
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
    @ixBoxSKU varchar(30)
    
	
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
            ixBoxSKU = @ixBoxSKU
            -- mSMIEstScaleShippingCost = NULL
		    WHERE sTrackingNumber = @sTrackingNumber and ixOrder = @ixOrder
		END TRY
	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='sTrackingNumber',@Value1=@sTrackingNumber, 
                @Field2='ixOrder',        @Value2=@ixOrder,
                @Field3='dActualWeight',  @Value3=@dActualWeight,
                @Field4='dDimWeight',     @Value4=@dDimWeight, 
                @Field5='ixBoxSKU',      @Value5=@ixBoxSKU 
        END CATCH       	
    END
ELSE
    BEGIN
        BEGIN TRY
        insert tblPackage 
            (sTrackingNumber, ixOrder, ixVerificationDate, ixVerificationTime, ixShipDate, ixShipTime, ixPacker, ixVerifier, ixShipper, dBillingWeight, dActualWeight, 
	         ixTrailer, mPublishedFreight, mShippingCost, ixVerificationIP, ixShippingIP,
	         dtDateLastSOPUpdate, ixTimeLastSOPUpdate, ixShipTNT, flgMetals, flgCanceled, flgReplaced,
	         dLength, dWidth, dHeight, ixPackageDeliveredLocal,dtPackageDeliveredLocal, dDimWeight, mSMIEstScaleShippingCost, dBoxWeight, ixBoxSKU)
        values
	        (@sTrackingNumber, @ixOrder, @ixVerificationDate, @ixVerificationTime, @ixShipDate, @ixShipTime, @ixPacker, @ixVerifier, @ixShipper, @dBillingWeight, @dActualWeight, 
	         @ixTrailer, @mPublishedFreight, @mShippingCost, @ixVerificationIP, @ixShippingIP,
	         DATEADD(dd,0,DATEDIFF(dd,0,GETDATE())), dbo.GetCurrentixTime(), @ixShipTNT, @flgMetals, @flgCanceled, @flgReplaced,
	         @dLength, @dWidth, @dHeight, @ixPackageDeliveredLocal, @dtPackageDeliveredLocal, @dDimWeight, @mSMIEstScaleShippingCost, @dBoxWeight, @ixBoxSKU)
	         
        END TRY
	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='sTrackingNumber',@Value1=@sTrackingNumber, 
                @Field2='ixOrder',        @Value2=@ixOrder,
                @Field3='dActualWeight',  @Value3=@dActualWeight,
                @Field4='dDimWeight',     @Value4=@dDimWeight,
                @Field5='ixBoxSKU',      @Value5=@ixBoxSKU  
        END CATCH           	         
    END








USE [AFCOReporting]
GO
/****** Object:  StoredProcedure [dbo].[spUpdatePackage]    Script Date: 10/23/2019 1:11:09 PM ******/
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
    @ixBoxSKU varchar(30)
	
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
            ixBoxSKU = @ixBoxSKU
            -- mSMIEstScaleShippingCost = NULL
		    WHERE sTrackingNumber = @sTrackingNumber and ixOrder = @ixOrder
		END TRY
	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='sTrackingNumber',@Value1=@sTrackingNumber, 
                @Field2='ixOrder',        @Value2=@ixOrder,
                @Field3='dActualWeight',  @Value3=@dActualWeight,
                @Field4='dDimWeight',     @Value4=@dDimWeight, 
                @Field5='ixBoxSKU',      @Value5=@ixBoxSKU 
        END CATCH       	
    END
ELSE
    BEGIN
        BEGIN TRY
        insert tblPackage 
            (sTrackingNumber, ixOrder, ixVerificationDate, ixVerificationTime, ixShipDate, ixShipTime, ixPacker, ixVerifier, ixShipper, dBillingWeight, dActualWeight, 
	         ixTrailer, mPublishedFreight, mShippingCost, ixVerificationIP, ixShippingIP,
	         dtDateLastSOPUpdate, ixTimeLastSOPUpdate, ixShipTNT, flgMetals, flgCanceled, flgReplaced,
	         dLength, dWidth, dHeight, ixPackageDeliveredLocal,dtPackageDeliveredLocal, dDimWeight, mSMIEstScaleShippingCost, dBoxWeight, ixBoxSKU)
        values
	        (@sTrackingNumber, @ixOrder, @ixVerificationDate, @ixVerificationTime, @ixShipDate, @ixShipTime, @ixPacker, @ixVerifier, @ixShipper, @dBillingWeight, @dActualWeight, 
	         @ixTrailer, @mPublishedFreight, @mShippingCost, @ixVerificationIP, @ixShippingIP,
	         DATEADD(dd,0,DATEDIFF(dd,0,GETDATE())), dbo.GetCurrentixTime(), @ixShipTNT, @flgMetals, @flgCanceled, @flgReplaced,
	         @dLength, @dWidth, @dHeight, @ixPackageDeliveredLocal, @dtPackageDeliveredLocal, @dDimWeight, @mSMIEstScaleShippingCost, @dBoxWeight, @ixBoxSKU)
	         
        END TRY
	    BEGIN CATCH
            EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                @Field1='sTrackingNumber',@Value1=@sTrackingNumber, 
                @Field2='ixOrder',        @Value2=@ixOrder,
                @Field3='dActualWeight',  @Value3=@dActualWeight,
                @Field4='dDimWeight',     @Value4=@dDimWeight,
                @Field5='ixBoxSKU',      @Value5=@ixBoxSKU  
        END CATCH           	         
    END


/*************************************************************************************************************/
/******    STEP 15) manually push records to test feeds                                                *******/
/******    SOP                                                                                         *******/

    --SMI TEST DATA
        SELECT sTrackingNumber, ixOrder, ixBoxSKU,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [SMI Reporting].dbo.tblPackage 
        where ixOrder in ('878971', '8908284')
            -- ixBoxSKU is NOT NULL
          --  sTrackingNumber = 'XXX'
        order by ixOrder, sTrackingNumber
                                        
        /*                          ixBox   Last        TimeLast
        sTrackingNumber	    ixOrder	SKU	    SOPUpdate	SOPUpdate
        JJD0030194775008999	8908284	NULL	2019.10.25	52516
        JJD0030194775009000	8908284	NULL	2019.10.25	52516
        JJD0030194775009001	8908284	NULL	2019.10.25	52517
        JJD0030194775009002	8908284	NULL	2019.10.25	52517
        JJD0030194775009003	8908284	NULL	2019.10.25	52518
        JJD0030194775009004	8908284	NULL	2019.10.25	52519
        JJD0030194775009005	8908284	NULL	2019.10.25	52519
        JJD0030194775009006	8908284	NULL	2019.10.25	52520
        JJD0030194775009007	8908284	NULL	2019.10.25	52520
        JJD0030194775009008	8908284	NULL	2019.10.25	52520
        JJD0030194775009009	8908284	NULL	2019.10.25	52520
        JJD0030194775009010	8908284	NULL	2019.10.25	52521
        JJD0030194775009011	8908284	NULL	2019.10.25	52521
        JJD0030194775009024	8908284	NULL	2019.10.25	52521
        JJD0030194775009025	8908284	CUSTOM	2019.10.25	52521
        JJD0030194775009026	8908284	CUSTOM	2019.10.25	52522
        JJD0030194775009027	8908284	BOX-107	2019.10.25	52522
        JJD0030194775009028	8908284	CUSTOM	2019.10.25	52522
        JJD0030194775009029	8908284	BOX-151	2019.10.25	52522
        JJD0030194775009030	8908284	BOX-151	2019.10.25	52522
        JJD0030194775009031	8908284	BOX-151	2019.10.25	52523
        JJD0030194775009032	8908284	BOX-107	2019.10.25	52523
        JJD0030194775009033	8908284	BOX-151	2019.10.25	52523
        JJD0030194775009034	8908284	BOX-151	2019.10.25	52523
        JJD0030194775009035	8908284	BOX-123	2019.10.25	52523
        JJD0030194775009036	8908284	91050036	2019.10.25	52524
*/


    --AFCO TEST DATA
        SELECT sTrackingNumber, ixOrder, ixBoxSKU,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [AFCOReporting].dbo.tblPackage 
        where ixOrder in ('878971', '8908284')
            -- ixBoxSKU is NOT NULL
          --  sTrackingNumber = 'XXX'
        order by ixOrder, sTrackingNumber
/*
sTrackingNumber	    ixOrder	ixBoxSKU	LastSOPUpdate	TimeLastSOPUpdate
1Z4315530302222822	878971	760-46410	2019.10.25	    52828
*/
SELECT * FROM tblTime where ixTime = 50715

/*************************************************************************************************************/
/******    STEP 16) verify records pushed updated as expected in SMI/AFCO Reporting                    *******/
/******    SOP                                                                                         *******/

        SELECT sTrackingNumber, ixOrder, ixBoxSKU,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [SMI Reporting].dbo.tblPackage 
        where --ixOrder in ( '8464588-1', '8827980')
            ixBoxSKU is NOT NULL
          --  sTrackingNumber = 'XXX'
        order by ixOrder, sTrackingNumber
                                        
        /*

        */

    --AFCO TEST DATA
        SELECT sTrackingNumber, ixOrder, ixBoxSKU,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [AFCOReporting].dbo.tblPackage 
        where-- ixOrder in ( '8464588-1', '8827980')
            ixBoxSKU is NOT NULL
          --  sTrackingNumber = 'XXX'
        order by ixOrder, sTrackingNumber


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
    --  1149	Failure to update tblPackage

    -- ERROR CODE feeds are DELAYED
    -- CHECK FOR THE CODES DIRECTLY IN SOP !!!!!!!


    -- ERROR COUNTS by Day
    SELECT DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
        ,count(*) AS 'ErrorQty'
    FROM tblErrorLogMaster
    WHERE ixErrorCode = '1149'
      and dtDate >=  DATEADD(month, -8, getdate())  -- past X months
    GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
    --HAVING count(*) > 10
    ORDER BY dtDate desc 
    /*
    DataBaseName	Date      	ErrorQty
    SMI Reporting	03-27-19	197





/*************************************************************************************************************/
/**********************         Run all code below on DW.SPEEDWAY2.COM          ******************************/
/**********************                     steps 3-6,19,20                     ******************************/
/*************************************************************************************************************/

/*************************************************************************************************************/
/******    STEP 2) DISABLE SSA job "JobAwsImportData"       ON dw.speedway2.com                        *******/
/******                                                                                                *******/

    exec [msdb].dbo.sp_update_job @job_name = 'JobAwsImportData', @enabled = 0



/*************************************************************************************************************/
/******    STEP 4)	Script & drop any affected indexes in SMiReportingRawData    ON dw.speedway2.com   *******/

            N/A



/*************************************************************************************************************/
/******    STEP 5) Add/alter corresponding table in SMiReportingRawData        ON dw.speedway2.com     *******/
/******           (Schema is Transfer)                                                                 *******/


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
ALTER TABLE [SMiReportingRawData].[Transfer].tblPackage ADD
    ixBoxSKU [decimal](10, 3) NULL

GO
ALTER TABLE [SMiReportingRawData].[Transfer].tblPackage SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



/*************************************************************************************************************/
/******    STEP 6) Rebuild any affected indexes in in SMiReportingRawData       ON dw.speedway2.com    *******/

       N/A

/*************************************************************************************************************/
/******    19) RE-ENABLE SSA job "JobAwsImportData"                                                    *******/
/******    dw.speedway2.com                                                                            *******/
    exec [msdb].dbo.sp_update_job @job_name = 'JobAwsImportData', @enabled = 1


/*************************************************************************************************************/
/******    STEP 20)	verify updates in SMI Reporting are making their way to corresponding AWS tables   *******/
/******    dw.speedway2.com                                                                            *******/
                                                                         
        --SMI TEST DATA

        SELECT ixPackage, ixBoxSKU,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [SMiReportingRawData].[Transfer].tblPackage 
        where ixBoxSKU is NOT NULL
*/


0.0154324

SELECT ixBoxSKU,FORMAT(count(*),'###,###') 'BOXcount'
FROM tblPackage
WHERE ixBoxSKU is NOT NULL
and ixShipDate >= 18924 -- '10/24/2019'
GROUP by ixBoxSKU
order by ixBoxSKU

SELECT ixBoxSKU, ixOrder, FORMAT(count(*),'###,###') 'BOXcount'
FROM tblPackage
WHERE ixBoxSKU is NOT NULL
GROUP BY ixBoxSKU, ixOrder
order by ixBoxSKU


select sTrackingNumber 
from tblPackage
where ixBoxSKU in ('0.001','0.009')


 

SELECT D.iYear, FORMAT(count(*),'###,###') 'CMcount'
--ixCreditMemo, ixCreateDate, mMerchandiseCost , mMerchandiseReturnedCost, ixBusinessUnit, flgCounter,
--        FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
from tblPackage P
    left join tblDate D on P.ixShipDate = D.ixDate
where ixBoxSKU is NOT NULL -- 428,165
group by D.iYear
order by D.iYear desc
/*
iYear	CMcount
2016	91
2006	131      
*/










select top 10 ixOrder, ixOrderTime
from tblOrder
where ixOrderDate = 18926
order by ixOrderTime desc



SELECT * FROM tblPackage where ixShipDate >= 18902

select P.ixBoxSKU, S.ixSKU, S.iLength, S.iWidth, S.iHeight, S.dWeight, count(P.sTrackingNumber) 'PKGcount'
FROM tblPackage P 
    left join tblSKU S on P.ixBoxSKU = S.ixSKU
where ixShipDate >= 18902
    and ixBoxSKU NOT LIKE 'BOX-%'
    and ixBoxSKU NOT LIKE 'PS%'
    and ixBoxSKU NOT LIKE 'FCM%'
and S.ixSKU is NULL

group by  P.ixBoxSKU, S.ixSKU,  S.iLength, S.iWidth, S.iHeight, S.dWeight
order by count(P.sTrackingNumber) desc

SELECT count(*) FROM dbo.tblPackage P 
WHERE ixBoxSKU is NOT NULL




select * from tblSKU where ixSKU in ('910-13824-1','917-347-31','917-347-28','917-347-22','910-13832-2')
