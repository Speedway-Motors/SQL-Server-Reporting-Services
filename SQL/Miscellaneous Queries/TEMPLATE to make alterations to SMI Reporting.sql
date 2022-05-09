-- TEMPLATE to make alterations to SMI Reporting

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

select * into [SMIArchive].dbo.BU_tblCustomer_20181022 from [SMI Reporting].dbo.tblCustomer     --  2,217,315
select * into [SMIArchive].dbo.BU_AFCO_tblCustomer_20181022 from [AFCOReporting].dbo.tblCustomer --    48,033



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

ALTER TABLE  [DW.SPEEDWAY2.COM].SmiReportingRawData.Transfer.tblSKU -- HAD TO RUN IT DIRECTLY ON dw.speedway2.com  AND had to remove [DW.SPEEDWAY2.COM] from the ALTER statement
ADD flgCARB tinyint NULL

BEGIN TRAN
    ALTER TABLE Transfer.tblCustomer ALTER COLUMN sCustomerFirstName VARCHAR (60)
ROLLBACK TRAN

BEGIN TRAN
    ALTER TABLE Transfer.tblCustomer ALTER COLUMN sCustomerLastName VARCHAR (60)
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
    ALTER TABLE dbo.tblCustomer ALTER COLUMN sCustomerFirstName VARCHAR (60)
ROLLBACK TRAN


BEGIN TRAN
    ALTER TABLE dbo.tblCustomer ALTER COLUMN sCustomerLastName VARCHAR (60)
ROLLBACK TRAN



ALTER TABLE [ChangeLog_SmiReportingRawData].dbo.tblSKU
ADD flgCARB tinyint NULL




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
    ALTER TABLE [SMI Reporting].dbo.tblCustomer ALTER COLUMN sCustomerFirstName VARCHAR (60)
ROLLBACK TRAN

BEGIN TRAN
    ALTER TABLE [SMI Reporting].dbo.tblCustomer ALTER COLUMN sCustomerLastName VARCHAR (60)
ROLLBACK TRAN



-- AFCO
BEGIN TRAN
    ALTER TABLE [AFCOReporting].dbo.tblCustomer ALTER COLUMN sCustomerFirstName VARCHAR (60)
ROLLBACK TRAN

BEGIN TRAN
    ALTER TABLE [AFCOReporting].dbo.tblCustomer ALTER COLUMN sCustomerLastName VARCHAR (60)
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
        SELECT top 10
            ixCustomer, sCustomerFirstName, sCustomerLastName, dtDateLastSOPUpdate, T.chTime
        from tblCustomer C
            left join tblTime T on C.ixTimeLastSOPUpdate = T.ixTime
        WHERE C.flgDeletedFromSOP = 0
            and C.flgTaxable = 0
            --and len(sCustomerFirstName) = 20
            and len(sCustomerLastName) = 20
        ORDER BY NEWID()
            /*
            ('245465','321255','595580','615538','1213822','1323130','1525150','1864270','2053463','2794954')

            245465
            321255
            595580
            615538
            1213822
            1323130
            1525150
            1864270
            2053463
            2794954
            */

        SELECT ixCustomer, sCustomerFirstName, sCustomerLastName, CONVERT(VARCHAR,dtDateLastSOPUpdate, 1) AS 'SOP_L_UD' , T.chTime
        FROM tblCustomer C
            left join tblTime T on C.ixTimeLastSOPUpdate = T.ixTime
        WHERE C.flgDeletedFromSOP = 0
            and C.flgTaxable = 0
            and C.ixCustomer in ('245465','321255','595580','615538','1213822','1323130','1525150','1864270','2053463','2794954')
        ORDER BY C.ixCustomer
            /*
            ixCust	sCustomerFirstName	21->            <-40    sCustomerLastName	21->            <-40    SOP_L_UD	chTime
            ======  =================== ====================    =================== ====================    ========    ========
            245465	NULL	                                    KREITZ OVAL TRACK PA	                    10/08/18	13:48:43  
            321255	NULL	                                    PRECISE RACING PRODU	                    10/19/18	23:53:38  
            595580	NULL	                                    KWIK CHANGE PRODUCTS	                    10/08/18	13:47:43  
            615538	NULL	                                    FINISHLINE PERFORMAN	                    10/08/18	13:47:20  
            1213822	PACIFIC WEST FOAM IN	                    PACIFIC WEST FOAM IN	                    10/08/18	13:47:09  
            1323130	FRANTSEN'S STAINLESS	                    FRANTSEN'S STAINLESS	                    10/08/18	13:47:29  
            1525150	NULL	                                    MARSH RACING V# 2232	                    10/08/18	13:47:29  
            1864270	NULL	                                    POSKE PERFORMANCE PA	                    10/12/18	23:53:57  
            2053463	NULL	                                    MOTORSPORTS WAREHOUS	                    10/18/18	21:54:26  
            2794954	INLAND TRUCK PARTS &	                    INLAND TRUCK PARTS C	                    10/08/18	13:47:44  
            */




    --AFCO TEST DATA
        SELECT top 10
            ixCustomer, sCustomerFirstName, sCustomerLastName, dtDateLastSOPUpdate, T.chTime
        from [AFCOReporting].dbo.tblCustomer C
            left join [AFCOReporting].dbo.tblTime T on C.ixTimeLastSOPUpdate = T.ixTime
        WHERE C.flgDeletedFromSOP = 0
            and C.flgTaxable = 0
            and len(sCustomerFirstName) = 20
            and len(sCustomerLastName) = 20
        ORDER BY NEWID()
            /*
            AFCO
            ('11062','17931','20002','28221','34802','43737','48320','52676','56306','61287')

            11062
            17931
            20002
            28221
            34802
            43737
            48320
            52676
            56306
            61287
            */

        SELECT ixCustomer, sCustomerFirstName, sCustomerLastName, CONVERT(VARCHAR,dtDateLastSOPUpdate, 1) AS 'SOP_L_UD' , T.chTime
        FROM [AFCOReporting].dbo.tblCustomer C
            left join [AFCOReporting].dbo.tblTime T on C.ixTimeLastSOPUpdate = T.ixTime
        WHERE C.flgDeletedFromSOP = 0
            and C.flgTaxable = 0
            and C.ixCustomer in ('11062','17931','20002','28221','34802','43737','48320','52676','56306','61287')
        ORDER BY C.ixCustomer
            /*  BEFORE
            ixCust	sCustomerFirstName	21->            <-40    sCustomerLastName	21->            <-40    SOP_L_UD	chTime
            ======  =================== ====================    =================== ====================    ========    ========
            11062	STREET LETHAL PERFOR	                    STREET LETHAL PERFOR	                    02/02/18	20:30:28  
            17931	NULL	                                    GATEWAY CLASSIC MUST	                    02/09/18	21:20:32  
            20002	NULL	                                    YEARWOOD PERFORMANCE	                    10/24/16	11:21:16  
            28221	NULL	                                    RIVER VIEW COAL, LLC	                    07/31/18	10:22:08  
            34802	NULL	                                    MOTTER MOTORSPORTS (	                    10/17/16	17:52:25  
            43737	NULL	                                    HIGH SPEED PERFORMAN	                    10/16/17	21:20:04  
            48320	COMPETITION SUSPENSI	                    (ROBBIE STANLEY RACI	                    10/18/16	10:29:57  
            52676	PRECISION ENGINEERED	                    PRECISION ENGINEERED	                    05/02/17	10:30:07  
            56306	COLEMAN TAPE SPECIAL	                    COLEMAN TAPE SPECIAL	                    07/12/17	08:31:13  
            61287	NULL	                                    WES GARDE COMPONENTS	                    03/17/18	07:41:49   

                AFTER
            ixCust	sCustomerFirstName	21->            <-40    sCustomerLastName	21->            <-40    SOP_L_UD	chTime
            ======  =================== ====================    =================== ====================    ========    ========
            */








/*************************************************************************************************************/
/******    STEP 15) verify records pushed updated as expected in SMI/AFCO Reporting                    *******/
/******    SOP                                                                                         *******/

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
/******    dw.speedway2.com   
                                                                         *******/
        SELECT flgCARB, count(*)
        FROM [DW.SPEEDWAY2.COM].SmiReportingRawData.Transfer.tblSKU
        GROUP BY flgCARB



        SELECT top 10 ixCustomer, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM [DW.SPEEDWAY2.COM].SmiReportingRawData.Transfer.tblCustomer
        order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc

        select * from tblTime where ixTime = 47096