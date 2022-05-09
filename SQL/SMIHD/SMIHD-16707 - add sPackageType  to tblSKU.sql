-- SMIHD-16707 - add sPackageType  to tblSKU

-- RENAME This Template using the appropriate Jira Case #

SELECT @@SPID as 'Current SPID' -- 113

/*  TABLE: tblSKU
    CHANGES TO BE MADE: add sPackageType varchar(10) (NULL ALLOWED)
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

select * into [SMIArchive].dbo.BU_tblSKU_20200207 from [SMI Reporting].dbo.tblSKU      --    476,889
select * into [SMIArchive].dbo.BU_AFCO_tblSKU_20200207 from [AFCOReporting].dbo.tblSKU --     76,656

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
    sPackageType varchar(10)
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
    sPackageType  varchar(10)
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
    sPackageType varchar(10)
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
/****** Object:  StoredProcedure [dbo].[spUpdateSKU]    Script Date: 2/7/2020 10:07:57 AM ******/
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
    @sPackageType varchar(10) NULL
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
                                     END),  -- added 1-9-19
            sPackageType = @sPackageType
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
            ixProductLifeCycleCode, sPackageType
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
            @sPackageType
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
/****** Object:  StoredProcedure [dbo].[spUpdateSKU]    Script Date: 2/7/2020 10:12:55 AM ******/
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
    @sPackageType varchar(10) NULL
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
            sPackageType = @sPackageType    -- added 2-7-20
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
            ixProductLifeCycleCode, sPackageType
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
            @sPackageType
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
        SELECT ixSKU, sPackageType ,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [SMI Reporting].dbo.tblSKU 
        where ixSKU in ('')
            -- sPackageType  is NOT NULL
        order by ixSKU, sPackageType 
                                        
        /*
*/


    --AFCO TEST DATA
        SELECT ixSKU, sPackageType ,
                    FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [AFCOReporting].dbo.tblSKU 
        where ixSKU in ('')
            -- sPackageType  is NOT NULL
        order by ixSKU, sPackageType 
/*
*/

SELECT * FROM tblTime where ixTime = 

/*************************************************************************************************************/
/******    STEP 16) verify records pushed updated as expected in SMI/AFCO Reporting                    *******/
/******    SOP                                                                                         *******/

        SELECT  ixSKU, sPackageType ,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [SMI Reporting].dbo.tblSKU 
        where --ixOrder in ( '8464588-1', '8827980')
            sPackageType  is NOT NULL
        order by ixSKU, sPackageType  desc
                                        
        /*
        ixOrder	sPackageType 	LastSOPUpdate	TimeLastSOPUpdate
        9390500	35511	2020.01.28	39575
        */


        SELECT  sPackageType, count(*) 'SKUCnt'
        from [SMI Reporting].dbo.tblSKU 
        where --ixOrder in ( '8464588-1', '8827980')
            sPackageType  is NOT NULL
        GROUP BY sPackageType
        ORDER BY sPackageType




       /*********   AFCO TEST DATA  *********/
        SELECT  ixSKU, sPackageType ,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
        from [AFCOReporting].dbo.tblSKU 
        where --ixOrder in ( '8464588-1', '8827980')
            sPackageType  is NOT NULL
        order by ixSKU, sPackageType  desc
        /*
        ixOrder	sPackageType 	LastSOPUpdate	TimeLastSOPUpdate

        */

        

        SELECT  sPackageType, count(*) 'SKUCnt'
        from [AFCOReporting].dbo.tblSKU 
        where --ixOrder in ( '8464588-1', '8827980')
            sPackageType  is NOT NULL
        GROUP BY sPackageType
        ORDER BY sPackageType

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
      and dtDate >=  DATEADD(month, -1, getdate())  -- past X months
    GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
    --HAVING count(*) > 10
    ORDER BY dtDate desc 
    /*
    DataBaseName	Date      	ErrorQty
    SMI Reporting	01-09-20	1082

*/

SELECT sPackageType , FORMAT(count(*),'###,###') 'SKUcount'
FROM tblSKU
-- WHERE sPackageType  is NOT NULL
GROUP BY sPackageType 
order by sPackageType 









SET ROWCOUNT 0

BEGIN TRAN

        UPDATE tblSKU
        SET sPackageType = 'NA'
        WHERE sPackageType is NULL
            and flgDeletedFromSOP = 0

ROLLBACK TRAN






SELECT sPackageType , FORMAT(count(*),'###,###') 'BOXcount'
FROM [SMI Reporting].dbo.tblSKU 
WHERE flgDeletedFromSOP = 0 
   -- and sPackageType  is NOT NULL
GROUP BY sPackageType 
order by sPackageType
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

select ixSKU, dtCreateDate from tblSKU
where ixSKU NOT IN (select ixSKU from tblSnapshotSKU where ixDate = 19031)
and flgDeletedFromSOP = 0
order by dtCreateDate

BEGIN TRAN

    UPDATE tblSKU
    set sPackageType = NULL
    where ixSKU between 'UP119850' and 'UP119875'


ROLLBACK TRAN


select * from tblSKU where flgDeletedFromSOP = 0 
    and sPackageType  is NULL



select ixSKU, sPackageType ,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate 'TimeLastSOPUpdate'
from tblSKU
where ixSKU in ('103A184B1SS','10620231','10620231XHD','10640015','10640017','10680100LWN','10680101NP','10680103N','10680104N','10680120N','10680144-S-NA-Y','10680184NDP','10680184NDPU','10680185NDP','10680202N','10680205','106802051','10680249N','1068026810','10680283NDP','10680404FAN','10681164-S-NA-N','1132070','1132276','113253','113345','113550','113594','113673','113679','113681','113696','113709','113856','113913','113996')

select * from tblTime where ixTime = 39738



SELECT * FROM [SMITemp].dbo.PJC_TEMP_SLAPR_SKUs SS-- 3,954    816 missing
    join tblSKU S on S.ixSKU = SS.ixSKU
where S.sPackageType is NULL


