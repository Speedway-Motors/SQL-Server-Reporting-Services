-- SMIHD-13710 - add ixABCCode to tblSKU

-- RENAME THIS TEMPLATE using the appropriate Jira Case #

/* CHANGES TO BE MADE

   add the following field to tblSKU
    ixABCCode datatype - varchar(5)

   ALLOWED VALUES:
    
    
*/

/* steps as of 9-18-2018

STEP    WHERE	        ACTION
=== ===============     =======================================================
1   LNK-SQL-LIVE-1      Back-up tables to be modified to SMIArchive
2	LNK-SQL-LIVE-1	    DISABLE SSA job "SMIJob_AwsExportData"
3	dw.speedway2.com	Script & drop any affected indexes in in SMiReportingRawData
4	dw.speedway2.com	Add/Alter the column in the corresponding table in SMiReportingRawData (Schema is Transfer)
5	dw.speedway2.com	Rebuild any affected indexes in in SMiReportingRawData
6	LNK-SQL-LIVE-1	    Script & drop any affected indexes in ChangeLog_smiReporting
7	LNK-SQL-LIVE-1	    Add the column to the corresponding table in ChangeLog_smiReporting (Schema is dbo)
8	LNK-SQL-LIVE-1	    Rebuild any affected indexes in ChangeLog_smiReporting
9	SOP	                PAUSE feeds to SMI/AFCO Reporting
10	LNK-SQL-LIVE-1	    Script & drop any affected indexes in SMI/AFCO Reporting
11	LNK-SQL-LIVE-1	    Add/Alter the column in the corresponding table in SMI/AFCO Reporting  (Schema is dbo)
12	LNK-SQL-LIVE-1	    Rebuild any affected indexes in SMI/AFCO Reporting
13	LNK-SQL-LIVE-1	    apply script changes to the appropriate stored procedure(s) (usually spUpdate<tablename>)
14	SOP	                RESUME feeds to SMI/AFCO Reporting
15	SOP	                manually push records to test feeds
16	LNK-SQL-LIVE-1	    verify records pushed updated as expected in SMI/AFCO Reporting 
17	LNK-SQL-LIVE-1	    RE-ENABLE SSA job "SMIJob_AwsExportData"
18	dw.speedway2.com	verify updates in SMI Reporting are making their way to corresponding AWS tables
*/

/*************************************************************************************************************/
/******    STEP 1) Back-up tables to be modified to SMIArchive                                         *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

select * into [SMIArchive].dbo.BU_tblSKU_20190423 from [SMI Reporting].dbo.tblSKU      --   450,322
select * into [SMIArchive].dbo.BU_AFCO_tblSKU_20190423 from [AFCOReporting].dbo.tblSKU --    74,467



/*************************************************************************************************************/
/******    STEP 2) DISABLE SSA job "SMIJob_AwsExportData"                                              *******/
/******    LNK-SQL-LIVE-1                                                                              *******/
    exec [msdb].dbo.sp_update_job @job_name = 'SMIJob_AwsExportData', @enabled = 0




/*************************************************************************************************************/
/******    STEP 3)	Script & drop any affected indexes in in SMiReportingRawData                       *******/
/******    dw.speedway2.com                                                                            *******/

            N/A



/*************************************************************************************************************/
/******    STEP 4) Add the column to the corresponding table in SMiReportingRawData                    *******/
/******           (Schema is Transfer)                                                                 *******/
/******    dw.speedway2.com                                                                            *******/

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
ALTER TABLE [SMiReportingRawData].[Transfer].tblSKU ADD
	ixABCCode varchar(5)

GO
ALTER TABLE [SMiReportingRawData].[Transfer].tblSKU SET (LOCK_ESCALATION = TABLE)
GO
COMMIT




/*************************************************************************************************************/
/******    STEP 5) Rebuild any affected indexes in in SMiReportingRawData                              *******/
/******    dw.speedway2.com                                                                            *******/

            N/A




/*************************************************************************************************************/
/******    STEP 6)	Script & drop any affected indexes in ChangeLog_smiReporting                       *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

            N/A



/*************************************************************************************************************/
/******    STEP 7)	Add the column to the corresponding table in ChangeLog_smiReportingRawData         *******/
/******            (Schema is dbo)                                                                     *******/
/******    LNK-SQL-LIVE-1                                                                              *******/


BEGIN TRANSACTION
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
	ixABCCode varchar(5)
GO
ALTER TABLE [ChangeLog_smiReportingRawData].dbo.tblSKU SET (LOCK_ESCALATION = TABLE)
GO
COMMIT




/*************************************************************************************************************/
/******    STEP 8)	Rebuild any affected indexes in ChangeLog_smiReporting                             *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

           N/A



/*************************************************************************************************************/
/******    STEP 9) PAUSE feeds to SMI/AFCO Reporting                                                   *******/
/******    SOP                                                                                         *******/



/*************************************************************************************************************/
/******    STEP 10) Script & drop any affected indexes in SMI/AFCO Reporting                            *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

           N/A




/*************************************************************************************************************/
/******    STEP 11) Add the column to the SMI/AFCO Reporting tables                                    *******/
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
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblSKU ADD
	ixABCCode varchar(5)
GO
ALTER TABLE dbo.tblSKU SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
-- ROLLBACK TRAN



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
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblSKU ADD
	ixABCCode varchar(5)
GO
ALTER TABLE dbo.tblSKU SET (LOCK_ESCALATION = TABLE)
GO
COMMIT





/*************************************************************************************************************/
/******    STEP 12) Rebuild any affected indexes in SMI/AFCO Reporting                                 *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

           N/A




/*************************************************************************************************************/
/******    STEP 13) apply script changes to the appropriate stored procedure(s)                        *******/
/******            (usually spUpdate<tablename>)                                                       *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

USE [SMI Reporting]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateSKU]    Script Date: 4/23/2019 12:08:14 PM ******/
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
	@iLength int,
	@iWidth int,
	@iHeight int,
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
    @ixABCCode varchar(5) NULL
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
            ixABCCode = @ixABCCode      -- added 04-23-19
		    where ixSKU = @ixSKU
        -- Insert statements for procedure here
	    --SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	END TRY    
	    
	BEGIN CATCH
        EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
            @Field1='ixSKU',		@Value1=@ixSKU, 
            @Field2='ixABCCode',	@Value2=@ixABCCode,
            @Field3='ixAnalyst',	@Value3=@ixAnalyst,
            @Field4='flgCARB',      @Value4=@flgCARB, 
            @Field5='flgProp65',	@Value5=@flgProp65  
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
			mMAP, ixProposer, ixAnalyst, ixMerchant, ixBuyer, flgProp65, flgCARB, ixABCCode
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
			@mMAP, @ixProposer, @ixAnalyst, @ixMerchant, @ixBuyer, @flgProp65, @flgCARB, @ixABCCode
			)
	END TRY
	BEGIN CATCH
        EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
            @Field1='ixSKU',		@Value1=@ixSKU, 
            @Field2='ixABCCode',	@Value2=@ixABCCode,
            @Field3='ixAnalyst',	@Value3=@ixAnalyst,
            @Field4='flgCARB',      @Value4=@flgCARB, 
            @Field5='flgProp65',	@Value5=@flgProp65     
    END CATCH			    
	END






USE [AFCOReporting]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateSKU]    Script Date: 4/23/2019 12:12:16 PM ******/
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
	@iLength int,
	@iWidth int,
	@iHeight int,
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
    @ixABCCode varchar(5) NULL
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
            ixABCCode = @ixABCCode      -- added 04-23-19
		    where ixSKU = @ixSKU
        -- Insert statements for procedure here
	    --SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	END TRY    
	    
	BEGIN CATCH
        EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
            @Field1='ixSKU',		@Value1=@ixSKU, 
            @Field2='ixABCCode',	@Value2=@ixABCCode,
            @Field3='ixAnalyst',	@Value3=@ixAnalyst,
            @Field4='flgCARB',      @Value4=@flgCARB, 
            @Field5='flgProp65',	@Value5=@flgProp65  
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
			mMAP, ixProposer, ixAnalyst, ixMerchant, ixBuyer, flgProp65, flgCARB, ixABCCode
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
			@mMAP, @ixProposer, @ixAnalyst, @ixMerchant, @ixBuyer, @flgProp65, @flgCARB, @ixABCCode
			)
	END TRY
		
	BEGIN CATCH
        EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
            @Field1='ixSKU',		@Value1=@ixSKU, 
            @Field2='ixABCCode',	@Value2=@ixABCCode,
            @Field3='ixAnalyst',	@Value3=@ixAnalyst,
            @Field4='flgCARB',      @Value4=@flgCARB, 
            @Field5='flgProp65',	@Value5=@flgProp65 
    END CATCH			    
        
	END
	    

/*************************************************************************************************************/
/******    STEP 14) RESUME feeds to SMI/AFCO Reporting                                                 *******/
/******    SOP                                                                                         *******/

AFTER PSG HAS APPLIED THEIR  CHANGES


/*************************************************************************************************************/
/******    STEP 15) manually push records to test feeds                                                *******/
/******    SOP                                                                                         *******/

    --SMI TEST DATA
        SELECT ixSKU, ixABCCode, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM tblSKU 
        WHERE ixABCCode is NOT null
        order by ixABCCode  --newid()


        SELECT  ixSKU, ixABCCode, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM tblSKU
        WHERE ixSKU in ('')
        order by ixABCCode  --newid()


        SELECT top 10 ixSKU, ixABCCode
        FROM tblSKU 
        WHERE ixSKU is NOT null
        --and len(ixInvoiceDate) < 4
            and ixABCCode is NOT NULL
        order by newid()

        SELECT ixABCCode, COUNT(*)
        FROM tblSKU
        group by ixABCCode
        order by ixABCCode
          

    --AFCO TEST DATA
        SELECT ixSKU, ixABCCode, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM tblSKU 
        WHERE ixABCCode is NOT null
        order by ixABCCode  --newid()

        SELECT  ixSKU, ixABCCode, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM tblSKU
        WHERE ixSKU in ('32-4239039M','KB1047','32-2-34.00R1')
        order by ixABCCode  --newid()

        SELECT top 10 ixSKU, ixABCCode
        FROM tblSKU 
        WHERE ixSKU is NOT null
        --and len(ixInvoiceDate) < 4
        order by newid()

        SELECT ixABCCode, COUNT(*)
        FROM tblSKU
        group by ixABCCode
        order by ixABCCode


select * from tblTime where ixTime = 48860

/*************************************************************************************************************/
/******    STEP 16) verify records pushed updated as expected in SMI/AFCO Reporting                    *******/
/******    SOP                                                                                         *******/

        -- get test records                                                                     
        SELECT top 10 ixSKU, ixABCCode,  dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM tblSKU
        WHERE ixABCCode is NOT null
        ORDER BY newid()


        select chTime from tblTime where ixTime = 26959





/*************************************************************************************************************/
/******    17) RE-ENABLE SSA job "SMIJob_AwsExportData"                                                *******/
/******    LNK-SQL-LIVE-1                                                                              *******/
            exec [msdb].dbo.sp_update_job @job_name = 'SMIJob_AwsExportData', @enabled = 1


/*************************************************************************************************************/
/******    STEP 18)	verify updates in SMI Reporting are making their way to corresponding AWS tables   *******/
/******    dw.speedway2.com                                                                            *******/
                                                                         
        SELECT ixABCCode, count(*)
        FROM SmiReportingRawData.Transfer.tblSKU
        where ixABCCode is NOT NULL
        GROUP BY ixABCCode



        SELECT top 10 ixABCCode dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM SmiReportingRawData.Transfer.tblSKU
        order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc

        SELECT count(*)
        FROM SmiReportingRawData.Transfer.tblSKU
        where ixABCCode is NOT NULL

      
