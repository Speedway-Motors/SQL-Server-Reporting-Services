-- SMIHD-18235 - add 4 SDS fields to tblSKU

-- RENAME This Template using the appropriate Jira Case #

SELECT @@SPID as 'Current SPID' -- 109

/*  TABLE: tblSKU
    CHANGES TO BE MADE: add 4 SDS fields to tblSKU
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

select * into [SMIArchive].dbo.BU_tblSKU_20200730 from [SMI Reporting].dbo.tblSKU      --    497,852
select * into [SMIArchive].dbo.BU_AFCO_tblSKU_20200730 from [AFCOReporting].dbo.tblSKU --     77,947

-- DROP TABLE [SMIArchive].dbo.BU_tblSKU_20200207
-- DROP TABLE [SMIArchive].dbo.BU_AFCO_tblSKU_20200207


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
ALTER TABLE [ChangeLog_smiReportingRawData].dbo.tblSKU ADD
    sBattery varchar(10),
    sLiquid varchar(10),
    sLimitedQuantity varchar(10),
    sSDS varchar(10)
GO
ALTER TABLE [ChangeLog_smiReportingRawData].dbo.tblSKU SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE [SMI Reporting].dbo.tblSKU ADD
    sBattery varchar(10),
    sLiquid varchar(10),
    sLimitedQuantity varchar(10),
    sSDS varchar(10)
GO
ALTER TABLE [SMI Reporting].dbo.tblSKU SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
 --ROLLBACK TRAN

-- SELECT TOP 1 * FROM dbo.tblSKU

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
ALTER TABLE [AFCOReporting].dbo.tblSKU ADD
    sBattery varchar(10),
    sLiquid varchar(10),
    sLimitedQuantity varchar(10),
    sSDS varchar(10)
GO
ALTER TABLE [AFCOReporting].dbo.tblSKU SET (LOCK_ESCALATION = TABLE)
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
/****** Object:  StoredProcedure [dbo].[spUpdateSKU]    Script Date: 7/29/2020 1:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spUpdateSKU] 
    @ixSKU varchar(30),
	@mPriceLevel1 varchar(10),
	@mPriceLevel2 varchar(10),
	@mPriceLevel3 varchar(10),
	@mPriceLevel4 varchar(10),
	@mPriceLevel5 varchar(10),
	@mLatestCost varchar(10),
	@mAverageCost varchar(10),
	@ixPGC varchar(5),
	@sDescription varchar(65),
	@flgUnitOfMeasure varchar(5),
	@flgTaxable tinyint,
	--@iQAV int,    -- deleted because field is now stored in tblSKULocation
	--@iQOS int,    -- deleted because field is now stored in tblSKULocation
	@ixCreateDate smallint,
	@dtCreateDate datetime,
	@ixRoyaltyVendor varchar(10),
	@ixDiscontinuedDate smallint,
	@dtDiscontinuedDate datetime,
	@flgActive tinyint,
	@sBaseIndex varchar(30),
	@dWeight decimal(10,3),
	@sOriginalSource varchar(30),
	@flgAdditionalHandling tinyint,
	@ixBrand varchar(5),
	@ixOriginalPart varchar(30),
	@ixHarmonizedTariffCode varchar(20),
	@flgIsKit tinyint,
	@iLength [decimal](7,1),
	@iWidth [decimal](7,1),
	@iHeight [decimal](7,1),
	@iMaxQOS int,
	@iRestockPoint int,
	--@iCartonQuantity int,  --deleted because field is now stored in tblSKULocation
	@flgShipAloneStatus tinyint,
	@flgIntangible tinyint,
	@ixCreator varchar(10),
	@iLeadTime smallint,
	@flgMadeToOrder int,
	@ixForecastingSKU varchar(30),
	@flgDeletedFromSOP tinyint,
	@iMinOrderQuantity int,
	@sCountryOfOrigin varchar(30),
	@sAlternateItem1 varchar(30), 
	@sAlternateItem2 varchar(30),
	@sAlternateItem3 varchar(30),
	@flgBackorderAccepted tinyint,
	@dtDateLastSOPUpdate datetime,
	@ixTimeLastSOPUpdate int,
	@ixReasonCode varchar(5),
	@sHandlingCode varchar(2),
	@ixProductLine varchar(10),
	@sWebUrl varchar(500),
	@sWebDescription varchar(500),
	@mMSRP varchar(10),
	@iDropshipLeadTime smallint,
	@ixCAHTC varchar(20),
	@flgORMD tinyint,
	@dDimWeight decimal(10,3),
	@mZone4Rate money,
	@flgMSDS tinyint,
	@sCycleCode varchar(7),
	@flgEndUserSKU bit,
	@mMAP money,
	@ixProposer varchar(10) NULL,
	@ixAnalyst varchar(10) NULL,
	@ixMerchant varchar(10) NULL,
	@ixBuyer varchar(10) NULL,
    @flgProp65 tinyint NULL,
    @flgCARB tinyint NULL,
    @ixABCCode varchar(5) NULL,
    @sProductLifeCycleCode varchar(12) NULL,
    @sPackageType varchar(10) NULL,
    @sBattery varchar(10) NULL,
    @sLiquid varchar(10) NULL,
    @sLimitedQuantity varchar(10) NULL,
    @sSDS varchar(10) NULL

AS
    --EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
    --    @Field1='ixSKU',      @Value1=@ixSKU, 
    --    @Field2='sBattery',	@Value2=@sBattery,
    --    @Field3='sLiquid',	@Value3=@sLiquid,
    --    @Field4='sLimitedQuantity', @Value4=@sLimitedQuantity, 
    --    @Field5='sSDS',    @Value5=@sSDS  
 -- SET DEADLOCK_PRIORITY LOW -- switched to low 7-10-17 to see if it will  help with that Tableau refresh transaction deadlock errors
if exists (select * from tblSKU where ixSKU = @ixSKU)
    BEGIN
    BEGIN TRY
	    -- SET NOCOUNT ON added to prevent extra result sets from
	    -- interfering with SELECT statements.
	--     SET NOCOUNT ON; -- added 6-30-14 by PJC to see if there was any impact on SOP feed performance
	    update tblSKU set
		    mPriceLevel1 = @mPriceLevel1,
		    mPriceLevel2 = @mPriceLevel2,
		    mPriceLevel3 = @mPriceLevel3,
		    mPriceLevel4 = @mPriceLevel4,
		    mPriceLevel5 = @mPriceLevel5,
		    mLatestCost = @mLatestCost,
		    mAverageCost = @mAverageCost,
		    ixPGC = @ixPGC,
		    sDescription = @sDescription,
		    flgUnitOfMeasure = @flgUnitOfMeasure,
		    flgTaxable = @flgTaxable,
		    --iQAV = @iQAV,
		    --iQOS = @iQOS,
		    ixCreateDate = @ixCreateDate,
		    dtCreateDate = @dtCreateDate,
		    ixRoyaltyVendor = @ixRoyaltyVendor,
		    ixDiscontinuedDate = @ixDiscontinuedDate,
		    dtDiscontinuedDate = @dtDiscontinuedDate,
		    flgActive = @flgActive,
		    sBaseIndex = @sBaseIndex,
		    dWeight = @dWeight,
		    sOriginalSource = @sOriginalSource,
		    flgAdditionalHandling = @flgAdditionalHandling,
		    --ixBrand = @ixBrand,
		    ixOriginalPart = @ixOriginalPart,
		    ixHarmonizedTariffCode = @ixHarmonizedTariffCode,
		    flgIsKit = @flgIsKit,
		    iLength = @iLength,
		    iWidth = @iWidth,
		    iHeight = @iHeight,
		    iMaxQOS = @iMaxQOS,
		    iRestockPoint = @iRestockPoint,
		    --iCartonQuantity = @iCartonQuantity,
		    flgShipAloneStatus = @flgShipAloneStatus,
		    flgIntangible = @flgIntangible,
		    ixCreator = @ixCreator,
		    iLeadTime = @iLeadTime,
		    flgMadeToOrder = @flgMadeToOrder,
		    ixForecastingSKU = @ixForecastingSKU,
            flgDeletedFromSOP = @flgDeletedFromSOP,
            iMinOrderQuantity = @iMinOrderQuantity,
            sCountryOfOrigin = @sCountryOfOrigin,
            sAlternateItem1 = @sAlternateItem1, 
            sAlternateItem2 = @sAlternateItem2,
            sAlternateItem3 = @sAlternateItem3,
            flgBackorderAccepted = @flgBackorderAccepted,
            dtDateLastSOPUpdate = @dtDateLastSOPUpdate,
            ixTimeLastSOPUpdate = @ixTimeLastSOPUpdate,
            ixReasonCode = @ixReasonCode,
            sHandlingCode = @sHandlingCode,
--		        ixProductLine = @ixProductLine,
		    sWebUrl = @sWebUrl,
		    --sWebDescription = @sWebDescription,
		    mMSRP = @mMSRP,
		    iDropshipLeadTime = @iDropshipLeadTime,
		    ixCAHTC = @ixCAHTC,
		    flgORMD = @flgORMD,
		    dDimWeight = @dDimWeight,
		    mZone4Rate = @mZone4Rate,
		    flgMSDS = @flgMSDS,
		    sCycleCode = @sCycleCode,
		    flgEndUserSKU = @flgEndUserSKU,
		    mMAP = @mMAP,
			ixProposer = @ixProposer,   -- added 2-13-18
			ixAnalyst = @ixAnalyst,		-- added 2-13-18
			ixMerchant = @ixMerchant,	-- added 2-13-18
			ixBuyer = @ixBuyer,			-- added 2-13-18
            flgProp65 = @flgProp65,     -- added 6-28-18
            flgCARB = @flgCARB,          -- added 10-17-18
            ixABCCode = @ixABCCode,      -- added 04-23-19
            ixProductLifeCycleCode = (CASE WHEN @sProductLifeCycleCode IS NULL THEN NULL
                                      ELSE COALESCE((Select ixProductLifeCycleCode
                                        From tblProductLifeCycle
                                        where sProductLifeCycleCode = @sProductLifeCycleCode)
                                      ,999)
                                     END),  -- added 1-9-19
            sPackageType = @sPackageType,
            sBattery = @sBattery,                   -- added 07-30-20
            sLiquid = @sLiquid,                     -- added 07-30-20
            sLimitedQuantity = @sLimitedQuantity,   -- added 07-30-20
            sSDS = @sSDS                            -- added 07-30-20
		    where ixSKU = @ixSKU
        -- Insert statements for procedure here
	    --SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	END TRY    
	    
	BEGIN CATCH
        EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
            @Field1='ixSKU',		@Value1=@ixSKU, 
            @Field2='ixABCCode',	@Value2=@ixABCCode,
            @Field3='ixAnalyst',	@Value3=@ixAnalyst,
            @Field4='sPackageType',      @Value4=@sPackageType, 
            @Field5='sProductLifeCycleCode',	@Value5=@sProductLifeCycleCode  
    --RAISERROR('You tried to divide by 0.', 0, 1)
    END CATCH
	END
else
	BEGIN
	BEGIN TRY
		insert 
			tblSKU (ixSKU, mPriceLevel1, mPriceLevel2, mPriceLevel3, mPriceLevel4, mPriceLevel5, 
			mLatestCost, mAverageCost, ixPGC, 
			sDescription, flgUnitOfMeasure, flgTaxable, 
			--iQAV, iQOS, 
			ixCreateDate, dtCreateDate, ixRoyaltyVendor, ixDiscontinuedDate, dtDiscontinuedDate, flgActive, sBaseIndex, 
			dWeight, sOriginalSource, flgAdditionalHandling, 
			--ixBrand, 
			ixOriginalPart, ixHarmonizedTariffCode, 
			flgIsKit, iLength, iWidth, iHeight, iMaxQOS, iRestockPoint, 
			--iCartonQuantity, 
			flgShipAloneStatus, flgIntangible, ixCreator, iLeadTime,
			flgMadeToOrder,ixForecastingSKU,flgDeletedFromSOP,iMinOrderQuantity,
			sCountryOfOrigin, sAlternateItem1, sAlternateItem2, sAlternateItem3, flgBackorderAccepted,
			dtDateLastSOPUpdate,ixTimeLastSOPUpdate,
			ixReasonCode, sHandlingCode, 
			--ixProductLine, 
			sWebUrl, 
			--sWebDescription, 
			mMSRP, iDropshipLeadTime, ixCAHTC,
			flgORMD, dDimWeight, mZone4Rate, flgMSDS, sCycleCode, flgEndUserSKU,
			mMAP, ixProposer, ixAnalyst, ixMerchant, ixBuyer, flgProp65, flgCARB, ixABCCode,
            ixProductLifeCycleCode, sPackageType, sBattery, sLiquid, sLimitedQuantity, sSDS
			)
		values
			(@ixSKU, @mPriceLevel1, @mPriceLevel2, @mPriceLevel3, @mPriceLevel4, @mPriceLevel5, 
			@mLatestCost, @mAverageCost, @ixPGC, 
			@sDescription, @flgUnitOfMeasure, @flgTaxable, 
			--@iQAV, @iQOS, 
			@ixCreateDate, @dtCreateDate, @ixRoyaltyVendor, @ixDiscontinuedDate, @dtDiscontinuedDate, @flgActive, @sBaseIndex, 
			@dWeight, @sOriginalSource, @flgAdditionalHandling, 
			--@ixBrand, 
			@ixOriginalPart, @ixHarmonizedTariffCode, 
			@flgIsKit, @iLength, @iWidth, @iHeight, @iMaxQOS, @iRestockPoint, 
			--@iCartonQuantity, 
			@flgShipAloneStatus, @flgIntangible, @ixCreator, @iLeadTime,
			@flgMadeToOrder,@ixForecastingSKU, @flgDeletedFromSOP,@iMinOrderQuantity,
			@sCountryOfOrigin, @sAlternateItem1, @sAlternateItem2, @sAlternateItem3, @flgBackorderAccepted,
			@dtDateLastSOPUpdate, @ixTimeLastSOPUpdate,
			@ixReasonCode, @sHandlingCode, 
			-- @ixProductLine, 
			@sWebUrl, 
			--@sWebDescription, 
			@mMSRP, @iDropshipLeadTime, @ixCAHTC,
			@flgORMD, @dDimWeight, @mZone4Rate, @flgMSDS, @sCycleCode, @flgEndUserSKU,
			@mMAP, @ixProposer, @ixAnalyst, @ixMerchant, @ixBuyer, @flgProp65, @flgCARB, @ixABCCode,
            (CASE WHEN @sProductLifeCycleCode IS NULL THEN NULL
                ELSE COALESCE((Select ixProductLifeCycleCode
                                From tblProductLifeCycle
                                where sProductLifeCycleCode = @sProductLifeCycleCode)
                                ,999)
             END),
            @sPackageType, @sBattery, @sLiquid, @sLimitedQuantity, @sSDS
			)
	END TRY
	BEGIN CATCH
        EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
            @Field1='ixSKU',		@Value1=@ixSKU, 
            @Field2='ixABCCode',	@Value2=@ixABCCode,
            @Field3='ixAnalyst',	@Value3=@ixAnalyst,
            @Field4='sPackageType',      @Value4=@sPackageType, 
            @Field5='sProductLifeCycleCode',	@Value5=@sProductLifeCycleCode       
    END CATCH			    
	END








USE [AFCOReporting]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateSKU]    Script Date: 7/29/2020 1:37:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spUpdateSKU] 
    @ixSKU varchar(30),
	@mPriceLevel1 varchar(10),
	@mPriceLevel2 varchar(10),
	@mPriceLevel3 varchar(10),
	@mPriceLevel4 varchar(10),
	@mPriceLevel5 varchar(10),
	@mLatestCost varchar(10),
	@mAverageCost varchar(10),
	@ixPGC varchar(5),
	@sDescription varchar(65),
	@flgUnitOfMeasure varchar(5),
	@flgTaxable tinyint,
	--@iQAV int,    -- deleted because field is now stored in tblSKULocation
	--@iQOS int,    -- deleted because field is now stored in tblSKULocation
	@ixCreateDate smallint,
	@dtCreateDate datetime,
	@ixRoyaltyVendor varchar(10),
	@ixDiscontinuedDate smallint,
	@dtDiscontinuedDate datetime,
	@flgActive tinyint,
	@sBaseIndex varchar(30),
	@dWeight decimal(10,3),
	@sOriginalSource varchar(30),
	@flgAdditionalHandling tinyint,
	@ixBrand varchar(5),
	@ixOriginalPart varchar(30),
	@ixHarmonizedTariffCode varchar(20),
	@flgIsKit tinyint,
	@iLength [decimal](7,1),
	@iWidth [decimal](7,1),
	@iHeight [decimal](7,1),
	@iMaxQOS int,
	@iRestockPoint int,
	--@iCartonQuantity int,  --deleted because field is now stored in tblSKULocation
	@flgShipAloneStatus tinyint,
	@flgIntangible tinyint,
	@ixCreator varchar(10),
	@iLeadTime smallint,
	@flgMadeToOrder int,
	@ixForecastingSKU varchar(30),
	@flgDeletedFromSOP tinyint,
	@iMinOrderQuantity int,
	@sCountryOfOrigin varchar(30),
	@sAlternateItem1 varchar(30), 
	@sAlternateItem2 varchar(30),
	@sAlternateItem3 varchar(30),
	@flgBackorderAccepted tinyint,
	@dtDateLastSOPUpdate datetime,
	@ixTimeLastSOPUpdate int,
	@ixReasonCode varchar(5),
	@sHandlingCode varchar(2),
	@ixProductLine varchar(10),
	@sWebUrl varchar(500),
	@sWebDescription varchar(500),
	@mMSRP varchar(10),
	@iDropshipLeadTime smallint,
	@ixCAHTC varchar(20),
	@flgORMD tinyint,
	@dDimWeight decimal(10,3),
	@mZone4Rate money,
	@flgMSDS tinyint,
	@sCycleCode varchar(7),
	@flgEndUserSKU bit,
	@mMAP money,
	@ixProposer varchar(10) NULL,
	@ixAnalyst varchar(10) NULL,
	@ixMerchant varchar(10) NULL,
	@ixBuyer varchar(10) NULL,
    @flgProp65 tinyint NULL,
    @flgCARB tinyint NULL,
    @ixABCCode varchar(5) NULL,
    @sProductLifeCycleCode varchar(12) NULL,
    @sPackageType varchar(10) NULL,
    @sBattery varchar(10) NULL,
    @sLiquid varchar(10) NULL,
    @sLimitedQuantity varchar(10) NULL,
    @sSDS varchar(10) NULL
AS

    --EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
    --    @Field1='ixSKU',      @Value1=@ixSKU, 
    --    @Field2='ixABCCode',	@Value2=@ixABCCode,
    --    @Field3='ixAnalyst',	@Value3=@ixAnalyst,
    --    @Field4='ixMerchant', @Value4=@ixMerchant, 
    --    @Field5='ixBuyer',    @Value5=@ixBuyer  
 -- SET DEADLOCK_PRIORITY LOW -- switched to low 7-10-17 to see if it will  help with that Tableau refresh transaction deadlock errors
                
if exists (select * from tblSKU where ixSKU = @ixSKU)
    BEGIN
    BEGIN TRY
	    -- SET NOCOUNT ON added to prevent extra result sets from
	    -- interfering with SELECT statements.
	--     SET NOCOUNT ON; -- added 6-30-14 by PJC to see if there was any impact on SOP feed performance
	    update tblSKU set
		    mPriceLevel1 = @mPriceLevel1,
		    mPriceLevel2 = @mPriceLevel2,
		    mPriceLevel3 = @mPriceLevel3,
		    mPriceLevel4 = @mPriceLevel4,
		    mPriceLevel5 = @mPriceLevel5,
		    mLatestCost = @mLatestCost,
		    mAverageCost = @mAverageCost,
		    ixPGC = @ixPGC,
		    sDescription = @sDescription,
		    flgUnitOfMeasure = @flgUnitOfMeasure,
		    flgTaxable = @flgTaxable,
		    --iQAV = @iQAV,
		    --iQOS = @iQOS,
		    ixCreateDate = @ixCreateDate,
		    dtCreateDate = @dtCreateDate,
		    ixRoyaltyVendor = @ixRoyaltyVendor,
		    ixDiscontinuedDate = @ixDiscontinuedDate,
		    dtDiscontinuedDate = @dtDiscontinuedDate,
		    flgActive = @flgActive,
		    sBaseIndex = @sBaseIndex,
		    dWeight = @dWeight,
		    sOriginalSource = @sOriginalSource,
		    flgAdditionalHandling = @flgAdditionalHandling,
		    --ixBrand = @ixBrand,
		    ixOriginalPart = @ixOriginalPart,
		    ixHarmonizedTariffCode = @ixHarmonizedTariffCode,
		    flgIsKit = @flgIsKit,
		    iLength = @iLength,
		    iWidth = @iWidth,
		    iHeight = @iHeight,
		    iMaxQOS = @iMaxQOS,
		    iRestockPoint = @iRestockPoint,
		    --iCartonQuantity = @iCartonQuantity,
		    flgShipAloneStatus = @flgShipAloneStatus,
		    flgIntangible = @flgIntangible,
		    ixCreator = @ixCreator,
		    iLeadTime = @iLeadTime,
		    flgMadeToOrder = @flgMadeToOrder,
		    ixForecastingSKU = @ixForecastingSKU,
            flgDeletedFromSOP = @flgDeletedFromSOP,
            iMinOrderQuantity = @iMinOrderQuantity,
            sCountryOfOrigin = @sCountryOfOrigin,
            sAlternateItem1 = @sAlternateItem1, 
            sAlternateItem2 = @sAlternateItem2,
            sAlternateItem3 = @sAlternateItem3,
            flgBackorderAccepted = @flgBackorderAccepted,
            dtDateLastSOPUpdate = @dtDateLastSOPUpdate,
            ixTimeLastSOPUpdate = @ixTimeLastSOPUpdate,
            ixReasonCode = @ixReasonCode,
            sHandlingCode = @sHandlingCode,
--		        ixProductLine = @ixProductLine,
		    sWebUrl = @sWebUrl,
		    --sWebDescription = @sWebDescription,
		    mMSRP = @mMSRP,
		    iDropshipLeadTime = @iDropshipLeadTime,
		    ixCAHTC = @ixCAHTC,
		    flgORMD = @flgORMD,
		    dDimWeight = @dDimWeight,
		    mZone4Rate = @mZone4Rate,
		    flgMSDS = @flgMSDS,
		    sCycleCode = @sCycleCode,
		    flgEndUserSKU = @flgEndUserSKU,
		    mMAP = @mMAP,
			ixProposer = @ixProposer,   -- added 2-13-18
			ixAnalyst = @ixAnalyst,		-- added 2-13-18
			ixMerchant = @ixMerchant,	-- added 2-13-18
			ixBuyer = @ixBuyer,			-- added 2-13-18
            flgProp65 = @flgProp65,     -- added 6-28-18
            flgCARB = @flgCARB,          -- added 10-17-18
            ixABCCode = @ixABCCode,      -- added 04-23-19
            ixProductLifeCycleCode = (CASE WHEN @sProductLifeCycleCode IS NULL THEN NULL
                                      ELSE COALESCE((Select ixProductLifeCycleCode
                                        From tblProductLifeCycle
                                        where sProductLifeCycleCode = @sProductLifeCycleCode)
                                      ,999)
                                     END),  -- added 1-9-20
            sPackageType = @sPackageType,   -- added 2-7-20
            sBattery = @sBattery,                   -- added 07-30-20
            sLiquid = @sLiquid,                     -- added 07-30-20
            sLimitedQuantity = @sLimitedQuantity,   -- added 07-30-20
            sSDS = @sSDS                            -- added 07-30-20
		    where ixSKU = @ixSKU
        -- Insert statements for procedure here
	    --SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	END TRY    
	    
	BEGIN CATCH
        EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
            @Field1='ixSKU',		@Value1=@ixSKU, 
            @Field2='ixABCCode',	@Value2=@ixABCCode,
            @Field3='ixAnalyst',	@Value3=@ixAnalyst,
            @Field4='sPackageType',      @Value4=@sPackageType, 
            @Field5='sProductLifeCycleCode',	@Value5=@sProductLifeCycleCode  
    --RAISERROR('You tried to divide by 0.', 0, 1)
    END CATCH
	END
else
	BEGIN
	BEGIN TRY
		insert 
			tblSKU (ixSKU, mPriceLevel1, mPriceLevel2, mPriceLevel3, mPriceLevel4, mPriceLevel5, 
			mLatestCost, mAverageCost, ixPGC, 
			sDescription, flgUnitOfMeasure, flgTaxable, 
			--iQAV, iQOS, 
			ixCreateDate, dtCreateDate, ixRoyaltyVendor, ixDiscontinuedDate, dtDiscontinuedDate, flgActive, sBaseIndex, 
			dWeight, sOriginalSource, flgAdditionalHandling, 
			--ixBrand, 
			ixOriginalPart, ixHarmonizedTariffCode, 
			flgIsKit, iLength, iWidth, iHeight, iMaxQOS, iRestockPoint, 
			--iCartonQuantity, 
			flgShipAloneStatus, flgIntangible, ixCreator, iLeadTime,
			flgMadeToOrder,ixForecastingSKU,flgDeletedFromSOP,iMinOrderQuantity,
			sCountryOfOrigin, sAlternateItem1, sAlternateItem2, sAlternateItem3, flgBackorderAccepted,
			dtDateLastSOPUpdate,ixTimeLastSOPUpdate,
			ixReasonCode, sHandlingCode, 
			--ixProductLine, 
			sWebUrl, 
			--sWebDescription, 
			mMSRP, iDropshipLeadTime, ixCAHTC,
			flgORMD, dDimWeight, mZone4Rate, flgMSDS, sCycleCode, flgEndUserSKU,
			mMAP, ixProposer, ixAnalyst, ixMerchant, ixBuyer, flgProp65, flgCARB, ixABCCode,
            ixProductLifeCycleCode, sPackageType, sBattery, sLiquid, sLimitedQuantity, sSDS
			)
		values
			(@ixSKU, @mPriceLevel1, @mPriceLevel2, @mPriceLevel3, @mPriceLevel4, @mPriceLevel5, 
			@mLatestCost, @mAverageCost, @ixPGC, 
			@sDescription, @flgUnitOfMeasure, @flgTaxable, 
			--@iQAV, @iQOS, 
			@ixCreateDate, @dtCreateDate, @ixRoyaltyVendor, @ixDiscontinuedDate, @dtDiscontinuedDate, @flgActive, @sBaseIndex, 
			@dWeight, @sOriginalSource, @flgAdditionalHandling, 
			--@ixBrand, 
			@ixOriginalPart, @ixHarmonizedTariffCode, 
			@flgIsKit, @iLength, @iWidth, @iHeight, @iMaxQOS, @iRestockPoint, 
			--@iCartonQuantity, 
			@flgShipAloneStatus, @flgIntangible, @ixCreator, @iLeadTime,
			@flgMadeToOrder,@ixForecastingSKU, @flgDeletedFromSOP,@iMinOrderQuantity,
			@sCountryOfOrigin, @sAlternateItem1, @sAlternateItem2, @sAlternateItem3, @flgBackorderAccepted,
			@dtDateLastSOPUpdate, @ixTimeLastSOPUpdate,
			@ixReasonCode, @sHandlingCode, 
			-- @ixProductLine, 
			@sWebUrl, 
			--@sWebDescription, 
			@mMSRP, @iDropshipLeadTime, @ixCAHTC,
			@flgORMD, @dDimWeight, @mZone4Rate, @flgMSDS, @sCycleCode, @flgEndUserSKU,
			@mMAP, @ixProposer, @ixAnalyst, @ixMerchant, @ixBuyer, @flgProp65, @flgCARB, @ixABCCode,
            (CASE WHEN @sProductLifeCycleCode IS NULL THEN NULL
                ELSE COALESCE((Select ixProductLifeCycleCode
                                From tblProductLifeCycle
                                where sProductLifeCycleCode = @sProductLifeCycleCode)
                                ,999)
             END),
            @sPackageType, @sBattery, @sLiquid, @sLimitedQuantity, @sSDS
			)
	END TRY
		
	BEGIN CATCH
        EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
            @Field1='ixSKU',		@Value1=@ixSKU, 
            @Field2='ixABCCode',	@Value2=@ixABCCode,
            @Field3='ixAnalyst',	@Value3=@ixAnalyst,
            @Field4='sPackageType',      @Value4=@sPackageType, 
            @Field5='flgProp65',	@Value5=@flgProp65 
    END CATCH			    
        
	END
	    








/*************************************************************************************************************/
/******    STEP 15) manually push records to test feeds                                                *******/
/******    SOP                                                                                         *******/

    --SMI TEST DATA


    --AFCO TEST DATA



/*************************************************************************************************************/
/******    STEP 16) verify records pushed updated as expected in SMI/AFCO Reporting                    *******/
/******    SOP                                                                                         *******/

       SELECT ixSKU, sBattery, sLiquid, sLimitedQuantity, sSDS,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [SMI Reporting].dbo.tblSKU 
        where  sBattery is NOT NULL
            or sLiquid  is NOT NULL
            or sLimitedQuantity is NOT NULL
            or sSDS is NOT NULL
        order by ixSKU
         


        SELECT sBattery,count(ixSKU) 'SKU'
                --    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [SMI Reporting].dbo.tblSKU 
        where sBattery is NOT NULL
        group by sBattery
        --having count(ixSKU) > 20
        order by sBattery

        SELECT sLiquid,count(ixSKU) 'SKU'
                --    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [SMI Reporting].dbo.tblSKU 
        where sLiquid is NOT NULL
        group by sLiquid
        --having count(ixSKU) > 20
        order by sLiquid

        SELECT sLimitedQuantity,count(ixSKU) 'SKU'
                --    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [SMI Reporting].dbo.tblSKU 
        where sLimitedQuantity is NOT NULL
        group by sLimitedQuantity
        --having count(ixSKU) > 20
        order by sLimitedQuantity

        SELECT sSDS,count(ixSKU) 'SKU'
                --    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [SMI Reporting].dbo.tblSKU 
        where sSDS is NOT NULL
        group by sSDS
        --having count(ixSKU) > 20
        order by sSDS

-- SELECT * FROM tblTime where ixTime = 




       /*********   AFCO TEST DATA  *********/
        SELECT ixSKU, sBattery, sLiquid, sLimitedQuantity, sSDS,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [AFCOReporting].dbo.tblSKU 
        where  sBattery is NOT NULL
            or sLiquid  is NOT NULL
            or sLimitedQuantity is NOT NULL
            or sSDS is NOT NULL
        order by ixSKU



        SELECT sBattery, FORMAT(count(ixSKU),'###,###' 'SKU'
                --    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [AFCOReporting].dbo.tblSKU 
        where sBattery is NOT NULL
        group by sBattery
        --having count(ixSKU) > 20
        order by sBattery

        SELECT sLiquid,count(ixSKU) 'SKU'
                --    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [AFCOReporting].dbo.tblSKU 
        where sLiquid is NOT NULL
        group by sLiquid
        --having count(ixSKU) > 20
        order by sLiquid

        SELECT sLimitedQuantity,count(ixSKU) 'SKU'
                --    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [AFCOReporting].dbo.tblSKU 
        where sLimitedQuantity is NOT NULL
        group by sLimitedQuantity
        --having count(ixSKU) > 20
        order by sLimitedQuantity

        SELECT sSDS,count(ixSKU) 'SKU'
                --    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [AFCOReporting].dbo.tblSKU 
        where sSDS is NOT NULL
        group by sSDS
        --having count(ixSKU) > 20
        order by sSDS

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
    select * from tblErrorCode where sDescription like '%tblSKU%'
    --  1163	Failure to update tblSKU.

    -- ERROR CODE feeds are DELAYED
    -- CHECK FOR THE CODES DIRECTLY IN SOP !!!!!!!


    -- ERROR COUNTS by Day
    SELECT DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
        ,count(*) AS 'ErrorQty'
    FROM tblErrorLogMaster
    WHERE ixErrorCode = '1163'
      and dtDate >=  DATEADD(month, -11, getdate())  -- past X months
    GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
    --HAVING count(*) > 10
    ORDER BY dtDate desc 
    /*
    DataBaseName	Date      	ErrorQty
    SMI Reporting	01-09-20	1082
    SMI Reporting	10-08-19	2009

*/






SELECT * FROM [SMITemp].dbo.PJC_SMIHD18235_SDSValues_AFCO T -- 76,431
 join [AFCOReporting].dbo.tblSKU S on T.ixSKU = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS

 BEGIN TRAN

 UPDATE S
 SET sBattery = T.sBattery,
    sLiquid = T.sLiquid,
    sLimitedQuantity = T.sLimitedQuantity,
    sSDS = T.sSDS
  FROM [SMITemp].dbo.PJC_SMIHD18235_SDSValues_AFCO T
 join [AFCOReporting].dbo.tblSKU S on T.ixSKU = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS

 ROLLBACK TRAN

 SELECT * FROM [AFCOReporting].dbo.tblSKU
where flgDeletedFromSOP = 0 
    and( sBattery is NULL
    or sLiquid  is NULL
    or sLimitedQuantity is NULL
    or sSDS is NULL)
order by ixSKU
/*
UPDATE [AFCOReporting].dbo.tblSKU
SET flgDeletedFromSOP = 0
WHERE ixSKU = 'ACF1-5-6-810'
*/



-- SMI
SELECT * FROM [SMITemp].dbo.PJC_SMIHD18235_SDSValues_SMI T -- 486,187
 join [SMI Reporting].dbo.tblSKU S on T.ixSKU = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS

 SET ROWCOUNT 50000
 BEGIN TRAN

 UPDATE S
 SET sBattery = T.sBattery,
    sLiquid = T.sLiquid,
    sLimitedQuantity = T.sLimitedQuantity,
    sSDS = T.sSDS
  FROM [SMITemp].dbo.PJC_SMIHD18235_SDSValues_SMI T
 join [SMI Reporting].dbo.tblSKU S on T.ixSKU = S.ixSKU --COLLATE SQL_Latin1_General_CP1_CI_AS
  WHERE S.sBattery is NULL

 ROLLBACK TRAN

 SELECT * FROM [SMI Reporting].dbo.tblSKU
where flgDeletedFromSOP = 0 
    and( sBattery is NULL
    or sLiquid  is NULL
    or sLimitedQuantity is NULL
    or sSDS is NULL)
order by ixSKU
