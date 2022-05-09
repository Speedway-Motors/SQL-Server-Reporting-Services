-- SMIHD-13069 - add ixLocation field to tblPOMaster

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

select * into [SMIArchive].dbo.BU_tblPOMaster_20190213 from [SMI Reporting].dbo.tblPOMaster     --    140,427
select * into [SMIArchive].dbo.BU_AFCO_tblPOMaster_20190213 from [AFCOReporting].dbo.tblPOMaster --    43,441



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

BEGIN TRAN
    ALTER TABLE  SmiReportingRawData.Transfer.tblPOMaster -- HAD TO RUN IT DIRECTLY ON dw.speedway2.com  AND had to remove [DW.SPEEDWAY2.COM] from the ALTER statement
        ADD ixLocation tinyint NULL
ROLLBACK TRAN






/*************************************************************************************************************/
/******    STEP 5) Rebuild any affected indexes in in SMiReportingRawData                              *******/
/******    dw.speedway2.com                                                                            *******/

            N/A




/*************************************************************************************************************/
/******    STEP 6)	Script & drop any affected indexes in ChangeLog_smiReporting                       *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

            N/A



/*************************************************************************************************************/
/******    STEP 7)	Add the column to the corresponding table in ChangeLog_smiReporting                *******/
/******            (Schema is dbo)                                                                     *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

BEGIN TRAN
    ALTER TABLE  ChangeLog_smiReportingRawData.dbo.tblPOMaster -- HAD TO RUN IT DIRECTLY ON dw.speedway2.com  AND had to remove [DW.SPEEDWAY2.COM] from the ALTER statement
        ADD ixLocation tinyint NULL
ROLLBACK TRAN





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
BEGIN TRAN
    ALTER TABLE [SMI Reporting].dbo.tblPOMaster 
    ADD ixLocation tinyint NULL
ROLLBACK TRAN





-- AFCO
BEGIN TRAN
    ALTER TABLE [AFCOReporting].dbo.tblPOMaster 
    ADD ixLocation tinyint NULL
ROLLBACK TRAN



/*************************************************************************************************************/
/******    STEP 12) Rebuild any affected indexes in SMI/AFCO Reporting                                 *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

           N/A




/*************************************************************************************************************/
/******    STEP 13) apply script changes to the appropriate stored procedure(s)                        *******/
/******            (usually spUpdate<tablename>)                                                       *******/
/******    LNK-SQL-LIVE-1                                                                              *******/

PROCS each have their own TAB
Paste here AFTER changes are made


/*************************************************************************************************************/
/******    STEP 14) RESUME feeds to SMI/AFCO Reporting                                                 *******/
/******    SOP                                                                                         *******/




/*************************************************************************************************************/
/******    STEP 14) manually push records to test feeds                                                *******/
/******    SOP                                                                                         *******/

    --SMI TEST DATA
        SELECT top 10 ixPO, ixLocation, dtDateLastSOPUpdate, T.chTime 'TimeLastSOPUpdate'
        from [SMI Reporting].dbo.tblPOMaster 
            left join [SMI Reporting].dbo.tblTime T on ixTimeLastSOPUpdate = T.ixTime
        WHERE --flgDeletedFromSOP = 0
          --  ixLocation <> 99
          ixLocation is NOT NULL
        ORDER BY NEWID()

        SELECT ixLocation, count(*)
        FROM [SMI Reporting].dbo.tblPOMaster
        GROUP BY ixLocation

        BEGIN TRAN
            UPDATE [SMI Reporting].dbo.tblPOMaster
            SET ixLocation = 99
        ROLLBACK TRAN
                     




    --AFCO TEST DATA
        SELECT top 10 ixPO, ixLocation, dtDateLastSOPUpdate, T.chTime 'TimeLastSOPUpdate'
        from [AFCOReporting].dbo.tblPOMaster 
            left join [SMI Reporting].dbo.tblTime T on ixTimeLastSOPUpdate = T.ixTime
        WHERE --flgDeletedFromSOP = 0
          --  ixLocation <> 99
          ixLocation is NOT NULL
        ORDER BY NEWID()

        SELECT ixLocation, count(*)
        FROM [AFCOReporting].dbo.tblPOMaster
        GROUP BY ixLocation

        BEGIN TRAN
            UPDATE [AFCOReporting].dbo.tblPOMaster
            SET ixLocation = 99
        ROLLBACK TRAN
       

/*************************************************************************************************************/
/******    STEP 15) verify records pushed updated as expected in SMI/AFCO Reporting                    *******/
/******    SOP                                                                                         *******/

        -- get test records                                                                      *******/





/*************************************************************************************************************/
/******    17) RE-ENABLE SSA job "SMIJob_AwsExportData"                                                *******/
/******    LNK-SQL-LIVE-1                                                                              *******/
            exec [msdb].dbo.sp_update_job @job_name = 'SMIJob_AwsExportData', @enabled = 1


/*************************************************************************************************************/
/******    STEP 17)	verify updates in SMI Reporting are making their way to corresponding AWS tables   *******/
/******    dw.speedway2.com   
                                                                         *******/
        SELECT ixLocation, count(*)
        FROM [DW.SPEEDWAY2.COM].SmiReportingRawData.Transfer.tblPOMaster
        GROUP BY ixLocation

