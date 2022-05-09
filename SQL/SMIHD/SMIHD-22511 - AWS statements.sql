-- SMIHD-22511 - AWS statements
-- DW.SPEEDWAY2.COM

SELECT @@SPID as 'Current SPID' -- 91 

 
/*************************************************************************************************************/
/******    STEP 3) DISABLE SSA job "JobAwsImportData"       ON dw.speedway2.com                        *******/
/******                                                                                                *******/

    exec [msdb].dbo.sp_update_job @job_name = 'JobAwsImportData', @enabled = 0
    -- have to manually disable



/*************************************************************************************************************/
/******    STEP 4)	Script & drop any affected indexes in SMiReportingRawData    ON dw.speedway2.com   *******/

            N/A



/*************************************************************************************************************/
/******    STEP 5) Add/alter corresponding table in SMiReportingRawData        ON dw.speedway2.com     *******/
/******           (Schema is Transfer)                                                                 *******/


BEGIN TRANSACTION   -- 50 sec
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
ALTER TABLE [DW].[Transfer].tblOrder ADD
    dtWebRejectReleaseDate datetime,
    ixWebRejectReleaseTime int,
    sWebRejectReleaseUser varchar(10),
    dtWebHeldReleaseDate datetime,
    ixWebHeldReleaseTime int,
    sWebHeldReleaseUser varchar(10)

GO
ALTER TABLE [DW].[Transfer].tblOrder SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


-- ROLLBACK TRAN



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
                                                                         

    --SMI TEST DATA   - Copy query from Step 15 on the LNK-SQL-LIVE-1 script
        SELECT ixOrder, dtOrderDate, S.ixOrderTime   ,dtWebRejectReleaseDate, ixWebRejectReleaseTime, sWebRejectReleaseUser, dtWebHeldReleaseDate, ixWebHeldReleaseTime, sWebHeldReleaseUser,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM tblOrder S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixOrder in ('10280961','10300265','10335669')

        -- last check 12:43  12:55  1:00

        SELECT ixOrder, dtOrderDate, S.ixOrderTime   ,dtWebRejectReleaseDate, ixWebRejectReleaseTime, sWebRejectReleaseUser, dtWebHeldReleaseDate, ixWebHeldReleaseTime, sWebHeldReleaseUser,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'SOPFeedDate', 
            T.chTime 'SOPFeedTime'
        FROM tblOrder S
            left join tblTime T on S.ixTimeLastSOPUpdate = T.ixTime
        WHERE ixOrder in ('10280961','10300265','10335669')


        SELECT O.ixOrder, FORMAT((TNG.dtOrderDate AT TIME ZONE 'UTC'  AT TIME ZONE 'Central Standard Time'),'yyyy.MM.dd hh:MM tt') TNGOrderDate,
            dtWebRejectReleaseDate, T1.chTime 'WebRejRelease',  --sWebRejectReleaseUser, 
            dtWebHeldReleaseDate, T2.chTime 'WebHeldRelease' --, sWebHeldReleaseUser,
        INTO #WebRejOrHeld  -- DROP TABLE #WebRejOrHeld
        FROM tblOrder O
            left join tblTime T1 on O.ixWebRejectReleaseTime = T1.ixTime
            left join tblTime T2 on O.ixWebHeldReleaseTime = T2.ixTime
            left join [DW].tng.tblorder TNG on O.ixOrder = TNG.ixSopOrderNumber
        WHERE dtWebRejectReleaseDate is NOT NULL
            or ixWebRejectReleaseTime is NOT NULL
            or sWebRejectReleaseUser is NOT NULL
            or dtWebHeldReleaseDate is NOT NULL
            or ixWebHeldReleaseTime is NOT NULL
            or sWebHeldReleaseUser is NOT NULL

        SELECT O.ixOrder, FORMAT((TNG.dtOrderDate AT TIME ZONE 'UTC'  AT TIME ZONE 'Central Standard Time'),'yyyy.MM.dd HH:MM:ss') TNGOrderDate,
            (dtWebRejectReleaseDate+ T1.chTime) 'WebRejectRelease',
            (dtWebHeldReleaseDate+ T2.chTime) 'WebHeldRelease' --, sWebHeldReleaseUser,
        INTO #WebRejOrHeld  -- DROP TABLE #WebRejOrHeld
        FROM tblOrder O
            left join tblTime T1 on O.ixWebRejectReleaseTime = T1.ixTime
            left join tblTime T2 on O.ixWebHeldReleaseTime = T2.ixTime
            left join [DW].tng.tblorder TNG on O.ixOrder = TNG.ixSopOrderNumber
        WHERE O.ixOrder = '10279661'

SELECT ixOrder, TNGOrderDate, WebRejectRelease, 
    DATEDIFF (, TNGOrderDate , WebRejectRelease ) 

FROM #WebRejOrHeld
where ixOrder = '10279661'

TNGOrderDate	WebRejectRelease
2021.09.06 14:09:56	2021-09-06 15:08:58.000



WHERE dtWebRejectReleaseDate is NOT NULL

        
SELECT O.dtOrderDate, T.chTime 'OrderTime', FORMAT((TNG.dtOrderDate AT TIME ZONE 'UTC'  AT TIME ZONE 'Central Standard Time'),'yyyy.MM.dd hh:MM tt') TNGOrderDate
    --TNG.dtOrderDate
from tblOrder O
  left join tblTime T on O.ixOrderTime = T.ixTime
  left join [DW].tng.tblorder TNG on O.ixOrder = TNG.ixSopOrderNumber
where O.dtShippedDate = '09/09/2021'


SELECT FORMAT((TNG.dtOrderDate AT TIME ZONE 'UTC'  AT TIME ZONE 'Central Standard Time'),'yyyy.MM.dd hh:MM tt') TNGOrderDate


select top 10 * from [DW].tng.tblorder
order by ixorder desc


ixSopOrderNumber
10374867


