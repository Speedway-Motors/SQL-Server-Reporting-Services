-- SMIHD-25170 - add new Landed Cost fields to tblVendorSKU
SELECT @@SPID as 'Current SPID' -- 85

/*  TABLE: tblVendorSKU
    CHANGES TO BE MADE: add mLandedCost,mTariffCost,mContainerUnitCost to tblVendorSKU

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
/******    STEP 3) Back-up tables to be modified to SMIArchive                                         *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

select * into [SMIArchive].dbo.BU_tblVendorSKU_20220621 from [SMI Reporting].dbo.tblVendorSKU      --   892,461
select * into [SMIArchive].dbo.BU_AFCO_tblVendorSKU_20220621 from [AFCOReporting].dbo.tblVendorSKU --   175,849

-- DROP TABLE [SMIArchive].dbo.BU_tblVendorSKU_20220104
-- DROP TABLE [SMIArchive].dbo.BU_AFCO_tblVendorSKU_20220104

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
ALTER TABLE [ChangeLog_smiReportingRawData].dbo.tblVendorSKU ADD
	mLandedCost money,
	mTariffCost money,
	mContainerUnitCost money
GO  
ALTER TABLE [ChangeLog_smiReportingRawData].dbo.tblVendorSKU SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE [SMI Reporting].dbo.tblVendorSKU ADD
	mLandedCost money,
	mTariffCost money,
	mContainerUnitCost money
GO
ALTER TABLE [SMI Reporting].dbo.tblVendorSKU SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
 --ROLLBACK TRAN

 -- SELECT TOP 1 * FROM dbo.tblVendorSKULocation

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
ALTER TABLE [AFCOReporting].dbo.tblVendorSKU ADD
	mLandedCost money,
	mTariffCost money,
	mContainerUnitCost money
GO
ALTER TABLE [AFCOReporting].dbo.tblVendorSKU SET (LOCK_ESCALATION = TABLE)
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
/****** Object:  StoredProcedure [dbo].[spUpdateVendorSKU]    Script Date: 6/20/2022 6:03:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spUpdateVendorSKU]
	@sVendorSKU varchar(30),
	@ixSKU varchar(30),
	@ixVendor varchar(5),
	@mCost varchar(10),
	@iOrdinality tinyint,
	@iLeadTime smallint,
	@mLandedCost money,
	@mTariffCost money,
	@mContainerUnitCost money
AS

SET DEADLOCK_PRIORITY LOW -- switched to low 7-10-17 to see if it will  help with that Tableau refresh transaction deadlock errors
 
if exists (select * from tblVendorSKU where ixSKU = @ixSKU and ixVendor = @ixVendor)
BEGIN
	begin try
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;
	update tblVendorSKU set
		sVendorSKU = @sVendorSKU,
		ixSKU = @ixSKU,
		ixVendor = @ixVendor,
		mCost = @mCost,
		iOrdinality = @iOrdinality,
		iLeadTime = @iLeadTime,
	    dtDateLastSOPUpdate = DATEADD(dd,0,DATEDIFF(dd,0,GETDATE())),
	    ixTimeLastSOPUpdate = dbo.GetCurrentixTime(),
		mLandedCost = @mLandedCost,
		mTariffCost = @mTariffCost,
		mContainerUnitCost = @mContainerUnitCost
		where ixSKU = @ixSKU and ixVendor = @ixVendor
	
    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	end try
	 BEGIN CATCH
        EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                 @Field1='ixSKU',       @Value1=@ixSKU, 
                 @Field2='ixVendor',    @Value2=@ixVendor,
                 @Field3='mLandedCost', @Value3=@mLandedCost,
                 @Field4='mTariffCost',  @Value4=@mTariffCost, 
                 @Field5='mContainerUnitCost',	@Value5=@mContainerUnitCost
        END CATCH
END
else
	begin
	begin try
		insert tblVendorSKU 
		    (sVendorSKU, ixSKU, ixVendor, 
			mCost, iOrdinality, iLeadTime,
			dtDateLastSOPUpdate,ixTimeLastSOPUpdate,
			mLandedCost, mTariffCost, mContainerUnitCost)
		values
			(@sVendorSKU, @ixSKU, @ixVendor, 
			@mCost, @iOrdinality, @iLeadTime,
			DATEADD(dd,0,DATEDIFF(dd,0,GETDATE())), dbo.GetCurrentixTime(),
			@mLandedCost, @mTariffCost, @mContainerUnitCost)
	end try
	 BEGIN CATCH
        EXEC Log_ProcedureCall @ObjectID = @@PROCID, 
                 @Field1='ixSKU',       @Value1=@ixSKU, 
                 @Field2='ixVendor',    @Value2=@ixVendor,
                 @Field3='mLandedCost', @Value3=@mLandedCost,
                 @Field4='mTariffCost',  @Value4=@mTariffCost, 
                 @Field5='mContainerUnitCost',	@Value5=@mContainerUnitCost
        END CATCH
	end


-- EXEC spUpdateVendorSKU '2138','91028A','3231',0.890,4,NULL

-- SELECT * FROM tblVendorSKU where ixSKU = '91028A' and 	iOrdinality = 4





USE [AFCOReporting]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateVendorSKU]    Script Date: 6/20/2022 6:10:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spUpdateVendorSKU]
	@sVendorSKU varchar(30),
	@ixSKU varchar(30),
	@ixVendor varchar(5),
	@mCost varchar(10),
	@iOrdinality tinyint,
	@iLeadTime smallint,
	@mLandedCost money,
	@mTariffCost money,
	@mContainerUnitCost money
AS
if exists (select * from tblVendorSKU where ixSKU = @ixSKU and ixVendor = @ixVendor)
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;
	update tblVendorSKU set
		sVendorSKU = @sVendorSKU,
		ixSKU = @ixSKU,
		ixVendor = @ixVendor,
		mCost = @mCost,
		iOrdinality = @iOrdinality,
		iLeadTime = @iLeadTime,
	    dtDateLastSOPUpdate = DATEADD(dd,0,DATEDIFF(dd,0,GETDATE())),
	    ixTimeLastSOPUpdate = dbo.GetCurrentixTime(),
		mLandedCost = @mLandedCost,
		mTariffCost = @mTariffCost,
		mContainerUnitCost = @mContainerUnitCost
		where ixSKU = @ixSKU and ixVendor = @ixVendor 	
    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
END
else
	begin
		insert tblVendorSKU 
		    (sVendorSKU, ixSKU, ixVendor, 
			mCost, iOrdinality, iLeadTime,
			dtDateLastSOPUpdate,ixTimeLastSOPUpdate,
			mLandedCost, mTariffCost, mContainerUnitCost)
		values
			(@sVendorSKU, @ixSKU, @ixVendor, 
			@mCost, @iOrdinality, @iLeadTime,
			DATEADD(dd,0,DATEDIFF(dd,0,GETDATE())), dbo.GetCurrentixTime(),
			@mLandedCost, @mTariffCost, @mContainerUnitCost)
	end



/* select count(*) from tblVendor -- 2689
   where dtDateLastSOPUpdate = '02-18-2017' -- 0
*/   



/*************************************************************************************************************/
/******    STEP 15) manually push records to test feeds                                                *******/
/******    SOP                                                                                         *******/


/*************************************************************************************************************/
/******    STEP 16) verify records pushed updated as expected in SMI/AFCO Reporting                    *******/
/******    SOP                                                                                         *******/
                                                                                                        
    --SMI TEST DATA
        SELECT ixVendor, ixSKU,iOrdinality, mLandedCost, mTariffCost, mContainerUnitCost,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM tblVendorSKU S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixVendor in ('###')
			and ixSKU in ('###')
        ORDER BY dtDateLastSOPUpdate, T.chTime

		SELECT ixVendor, ixSKU,iOrdinality, mLandedCost, mTariffCost, mContainerUnitCost, mCost,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM tblVendorSKU S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE mLandedCost is NOT NULL
			or mTariffCost is NOT NULL
			or mContainerUnitCost is NOT NULL
        ORDER BY dtDateLastSOPUpdate, T.chTime


		SELECT ixVendor, ixSKU,iOrdinality, mLandedCost, mTariffCost, mContainerUnitCost, mCost,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM tblVendorSKU S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixSKU = '910353-46-PLN'
        ORDER BY dtDateLastSOPUpdate, T.chTime
                    
                    
    --AFCO TEST DATA
        SELECT ixVendor, ixSKU,iOrdinality, mLandedCost, mTariffCost, mContainerUnitCost,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM [AFCOReporting].dbo.tblVendorSKU S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixVendor in ('###')
			and ixSKU in ('###')
        ORDER BY dtDateLastSOPUpdate, T.chTime

         SELECT ixVendor, ixSKU,iOrdinality, mLandedCost, mTariffCost, mContainerUnitCost,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM [AFCOReporting].dbo.tblVendorSKU S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE mLandedCost is NOT NULL
			or mTariffCost is NOT NULL
			or mContainerUnitCost is NOT NULL
        ORDER BY dtDateLastSOPUpdate, T.chTime

select ixSKU, ixLocation, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblSKULocation 
where ixSKU = '910353-46-PLN'
order by ixLocation
/*					dtDateLast
ixSKU			Loc	SOPUpdate	ixTimeLastSOPUpdate
910353-46-PLN	25	2022-06-21 	41444
910353-46-PLN	47	2022-06-21 	41444
910353-46-PLN	85	2022-06-21 	41444
910353-46-PLN	99	2022-06-21 	41444

910353-46-PLN	25	2022-06-21 00:00:00.000	41967
910353-46-PLN	47	2022-06-21 00:00:00.000	41967
910353-46-PLN	85	2022-06-21 00:00:00.000	41967
910353-46-PLN	99	2022-06-21 00:00:00.000	41966



*/



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
    select * from tblErrorCode where sDescription like '%tblVendorSKU%'
    --  1166	Failure to update tblVendorSKU.

    -- ERROR CODE feeds are DELAYED
    -- CHECK FOR THE CODES DIRECTLY IN SOP !!!!!!!


    -- ERROR COUNTS by Day
    SELECT DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
        ,count(*) AS 'ErrorQty'
    FROM tblErrorLogMaster
    WHERE ixErrorCode = '1166'
      and dtDate >=  DATEADD(month, -60, getdate())  -- past X months
    GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
    --HAVING count(*) > 10
    ORDER BY dtDate desc 
    /*
    DataBaseName	Date      	ErrorQty
	SMI Reporting	06-21-22	20
	*/


	    -- ERROR COUNTS by Day
    SELECT DB_NAME() AS DataBaseName,CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
        ,count(*) AS 'ErrorQty'
    FROM [AFCOReporting].dbo.tblErrorLogMaster
    WHERE ixErrorCode = '1166'
      and dtDate >=  DATEADD(month, -60, getdate())  -- past X months
    GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
    --HAVING count(*) > 10
    ORDER BY dtDate desc 
    /*
    DataBaseName	Date      	ErrorQty
	AFCOReporting	11-12-21	32
	*/




SELECT * FROM tblErrorLogMaster
    WHERE ixErrorCode = '1166'
	ORDER BY dtDate desc

