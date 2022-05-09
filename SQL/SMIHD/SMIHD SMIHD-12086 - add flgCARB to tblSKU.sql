-- SMIHD SMIHD-12086 - add flgCARB to tblSKU

-- RENAME THIS TEMPLATE using the appropriate Jira Case #

/* CHANGES TO BE MADE

   add the following field to tblSKU
   flgCARB (tinyint)

   ALLOWED VALUES:
    NULL
    N =0
    Y =1
    E =2 (evaluate Later)
    OEM=3 (original equipment manufacturer)
    NS =4 (No Sale in CA)

*/

/* steps as of 9-18-2018

STEP    WHERE	            ACTION
=== ===============         =======================================================
1	LNK-SQL-LIVE-1	    DISABLE SSA job "SMIJob_AwsExportData"
2	dw.speedway2.com	Script & drop any affected indexes in in SMiReportingRawData
3	dw.speedway2.com	Add the column to the corresponding table in SMiReportingRawData (Schema is Transfer)
4	dw.speedway2.com	Rebuild any affected indexes in in SMiReportingRawData
5	LNK-SQL-LIVE-1	    Script & drop any affected indexes in ChangeLog_smiReporting
6	LNK-SQL-LIVE-1	    Add the column to the corresponding table in ChangeLog_smiReporting (Schema is dbo)
7	LNK-SQL-LIVE-1	    Rebuild any affected indexes in ChangeLog_smiReporting
8	SOP	                PAUSE feeds to SMI/AFCO Reporting
9	LNK-SQL-LIVE-1	    Script & drop any affected indexes in SMI/AFCO Reporting
10	LNK-SQL-LIVE-1	    Add the column to the SMI/AFCO Reporting tables
11	LNK-SQL-LIVE-1	    Rebuild any affected indexes in SMI/AFCO Reporting
12	LNK-SQL-LIVE-1	    apply script changes to the appropriate stored procedure(s) (usually spUpdate<tablename>)
13	SOP	                RESUME feeds to SMI/AFCO Reporting
14	SOP	                manually push records to test feeds
15	LNK-SQL-LIVE-1	    verify records pushed updated as expected in SMI/AFCO Reporting 
16	LNK-SQL-LIVE-1	    RE-ENABLE SSA job "SMIJob_AwsExportData"
17	dw.speedway2.com	verify updates in SMI Reporting are making their way to corresponding AWS tables
*/



/*************************************************************************************************************/
/******    STEP 1) DISABLE SSA job "SMIJob_AwsExportData"                                              *******/
/******    LNK-SQL-LIVE-1                                                                              *******/
    exec [msdb].dbo.sp_update_job @job_name = 'SMIJob_AwsExportData', @enabled = 0




/*************************************************************************************************************/
/******    STEP 2)	Script & drop any affected indexes in in SMiReportingRawData                       *******/
/******    dw.speedway2.com                                                                            *******/

            N/A



/*************************************************************************************************************/
/******    STEP 3) Add the column to the corresponding table in SMiReportingRawData                    *******/
/******           (Schema is Transfer)                                                                 *******/
/******    dw.speedway2.com                                                                            *******/

ALTER TABLE  [DW.SPEEDWAY2.COM].SmiReportingRawData.Transfer.tblSKU -- HAD TO RUN IT DIRECTLY ON dw.speedway2.com  AND had to remove [DW.SPEEDWAY2.COM] from the ALTER statement
ADD flgCARB tinyint NULL
-- TRY THIS NEXT TIME           EXECUTE [DW.SPEEDWAY2.COM].SmiReportingRawData.[dbo].sp_executesql N'ALTER TABLE tblSKU Add flgCARB tinyint'


-- SELECT TOP 10 * FROM [DW.SPEEDWAY2.COM].SmiReportingRawData.Transfer.tblSKU


/*************************************************************************************************************/
/******    STEP 4) Rebuild any affected indexes in in SMiReportingRawData                              *******/
/******    dw.speedway2.com                                                                            *******/

            N/A




/*************************************************************************************************************/
/******    STEP 5)	Script & drop any affected indexes in ChangeLog_smiReporting                       *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

            N/A



/*************************************************************************************************************/
/******    STEP 6)	Add the column to the corresponding table in ChangeLog_SmiReportingRawData         *******/
/******            (Schema is dbo)                                                                     *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

ALTER TABLE [ChangeLog_SmiReportingRawData].dbo.tblSKU
ADD flgCARB tinyint NULL




/*************************************************************************************************************/
/******    STEP 7)	Rebuild any affected indexes in ChangeLog_smiReporting                             *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

           N/A



/*************************************************************************************************************/
/******    STEP 8) PAUSE feeds to SMI/AFCO Reporting                                                   *******/
/******    SOP                                                                                         *******/



/*************************************************************************************************************/
/******    STEP 9) Script & drop any affected indexes in SMI/AFCO Reporting                            *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

           N/A




/*************************************************************************************************************/
/******    STEP 10) Add the column to the SMI/AFCO Reporting tables                                    *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

-- SMI
ALTER TABLE [SMI Reporting].dbo.tblSKU
ADD flgCARB tinyint NULL



-- AFCO
ALTER TABLE [AFCOReporting].dbo.tblSKU
ADD flgCARB tinyint NULL





/*************************************************************************************************************/
/******    STEP 11) Rebuild any affected indexes in SMI/AFCO Reporting                                 *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

           N/A




/*************************************************************************************************************/
/******    STEP 12) apply script changes to the appropriate stored procedure(s)                        *******/
/******            (usually spUpdate<tablename>)                                                       *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

USE [SMI Reporting]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateSKU]    Script Date: 10/17/2018 2:34:19 PM ******/
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
    @flgCARB tinyint NULL
AS

    --EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
    --    @Field1='ixSKU',      @Value1=@ixSKU, 
    --    @Field2='ixProposer',	@Value2=@ixProposer,
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
            flgCARB = @flgCARB          -- added 10-17-18
		    where ixSKU = @ixSKU
        -- Insert statements for procedure here
	    --SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	END TRY    
	    
	BEGIN CATCH
        EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
            @Field1='ixSKU',		@Value1=@ixSKU, 
            @Field2='ixProposer',	@Value2=@ixProposer,
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
			mMAP, ixProposer, ixAnalyst, ixMerchant, ixBuyer, flgProp65, flgCARB
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
			@mMAP, @ixProposer, @ixAnalyst, @ixMerchant, @ixBuyer, @flgProp65, @flgCARB
			)
	END TRY
		
	BEGIN CATCH
        EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
            @Field1='ixSKU',		@Value1=@ixSKU, 
            @Field2='ixProposer',	@Value2=@ixProposer,
            @Field3='ixAnalyst',	@Value3=@ixAnalyst,
            @Field4='flgCARB',      @Value4=@flgCARB, 
            @Field5='flgProp65',	@Value5=@flgProp65     
    END CATCH			    
        
	END
	    





        USE [AFCOReporting]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateSKU]    Script Date: 10/17/2018 2:36:41 PM ******/
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
    @flgCARB tinyint NULL
AS

    --EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
    --    @Field1='ixSKU',      @Value1=@ixSKU, 
    --    @Field2='ixProposer',	@Value2=@ixProposer,
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
            flgCARB = @flgCARB          -- added 10-17-18
		    where ixSKU = @ixSKU
        -- Insert statements for procedure here
	    --SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	END TRY    
	    
	BEGIN CATCH
        EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
            @Field1='ixSKU',		@Value1=@ixSKU, 
            @Field2='ixProposer',	@Value2=@ixProposer,
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
			mMAP, ixProposer, ixAnalyst, ixMerchant, ixBuyer, flgProp65, flgCARB
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
			@mMAP, @ixProposer, @ixAnalyst, @ixMerchant, @ixBuyer, @flgProp65, @flgCARB
			)
	END TRY
		
	BEGIN CATCH
        EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
            @Field1='ixSKU',		@Value1=@ixSKU, 
            @Field2='ixProposer',	@Value2=@ixProposer,
            @Field3='ixAnalyst',	@Value3=@ixAnalyst,
            @Field4='flgCARB',      @Value4=@flgCARB, 
            @Field5='flgProp65',	@Value5=@flgProp65 
    END CATCH			    
        
	END
	    

/*************************************************************************************************************/
/******    STEP 13) RESUME feeds to SMI/AFCO Reporting                                                 *******/
/******    SOP                                                                                         *******/




/*************************************************************************************************************/
/******    STEP 14) manually push records to test feeds                                                *******/
/******    SOP                                                                                         *******/

        SELECT ixSKU, flgCARB, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM tblSKU
        WHERE ixSKU in ('465AC4004','9133905-4 3/4-TRAD-PLN','2827107','91048423-56-5','91034204-4 1/2','282113184','91048343-583-STD','282160112','106240-9-0-4-3','10616-SMOOTH-9-1-13','91894034')
        ORDER BY dtDateLastSOPUpdate, ixTimeLastSOPUpdate

        SELECT ixSKU, flgCARB, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM tblSKU
        WHERE ixSKU in ('91069890','91510222','91064080','91000056','91076070','4470181001')
        ORDER BY dtDateLastSOPUpdate, ixTimeLastSOPUpdate

         SELECT ixSKU, flgCARB, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM [AFCOReporting].dbo.tblSKU
        WHERE ixSKU in ('60396')
        ORDER BY dtDateLastSOPUpdate, ixTimeLastSOPUpdate


/*************************************************************************************************************/
/******    STEP 15) verify records pushed updated as expected in SMI/AFCO Reporting                    *******/
/******    SOP                   
        -- get test records                                                                      *******/
        SELECT top 10 ixSKU, flgCARB, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM tblSKU
        WHERE dtDateLastSOPUpdate = '10/02/2018'
            and flgDeletedFromSOP = 0
        ORDER BY newid()

        dtDateLastSOPUpdate, ixTimeLastSOPUpdate

        select chTime from tblTime where ixTime = 26959

        SELECT flgCARB, count(*) 'SKUCnt'
        FROM tblSKU
        GROUP BY flgCARB

/*************************************************************************************************************/
/******    16) RE-ENABLE SSA job "SMIJob_AwsExportData"                                                *******/
/******    LNK-SQL-LIVE-1                                                                              *******/
            exec [msdb].dbo.sp_update_job @job_name = 'SMIJob_AwsExportData', @enabled = 1


/*************************************************************************************************************/
/******    STEP 17)	verify updates in SMI Reporting are making their way to corresponding AWS tables   *******/
/******    dw.speedway2.com                                                                            *******/

        SELECT flgCARB, count(*)
        FROM [DW.SPEEDWAY2.COM].SmiReportingRawData.Transfer.tblSKU
        GROUP BY flgCARB


