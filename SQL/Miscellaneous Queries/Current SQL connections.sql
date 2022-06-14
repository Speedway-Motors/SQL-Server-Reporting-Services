-- CURRENT SQL CONNECTIONS

SELECT @@SPID as 'Current SPID' -- 60 

-- SPIDS with OPEN TRANSACTIONS  
SELECT * FROM sys.sysprocesses  WHERE open_tran = 1 and program_name <> 'Replication Distribution Agent' and program_name NOT LIKE 'Repl-LogReader%' 
  -- SELECT @@trancount as 'Open Transactions' -- works ONLY on the SPID it's executed on   

    -- Generic CHECK for BLOCKING 
    EXEC sp_blockinfo    -- Spid 157 is blocked by spid 119
    /* when spid ### is blocked by spid ###
        dbcc inputbuffer(121) -- 
        dbcc inputbuffer(124) -- 
     */

	EXEC [Util].dbo.usp_who5 X,NULL,NULL,NULL,NULL  
/*  
    KILL 64
    KILL 108
	KILL 129
	KILL 122
*/   
 -- # of user connections
     SELECT (D.sDayOfWeek3Char + ' ' +FORMAT(getdate(),'MM/dd/yy HH:mm')) 'As Of             ', PC.cntr_value 'UserConnections'
     FROM sys.dm_os_performance_counters PC       Left join tblDate D on FORMAT(getdate(),'MM/dd/yyyy') = D.dtDate
     WHERE counter_name = 'User Connections'
 /*                     User
    As Of             	Connctns	Range 51-117 (typically 60-85)
    ==================  ========	================================	
	TUE 06/14/22 08:44	68

    WED 06/23/21 09:08	83
    MON 05/24/21 09:03	91
    THU 05/13/21 10:34	70
*/

SELECT * FROM sys.dm_exec_connections

EXEC sp_connections  						
/*SUMMARY                                           Connection  Typical
    loginname						HostName	    Count       Range		
    =========================		==============	========    =======		
    sa								LNK-SQL-LIVE-1		43		39-51		
    SPEEDWAYMOTORS\mssqldw			LNK-SQL-LIVE-1		27      22-28
	SPEEDWAYMOTORS\LNK-SQL-LIVE-1$	LNK-SQL-LIVE-1      45		22-34
	SPEEDWAYMOTORS\phoenix			LNK-SQL-LIVE-1	     7	     1-7

    SPEEDWAYMOTORS\pjcrews			LNK-IS-07B    		 14
    SPEEDWAYMOTORS\rmdesimone		LNK-SQL-LIVE-1       3
	SPEEDWAYMOTORS\jtbergmann		LNK-SQL-LIVE-1       3                                                                
    SPEEDWAYMOTORS\ascrook			LNK-IS-04B			 0
    
    SPEEDWAYMOTORS\ccchance	        LNK-MRKT-CCC         1
   	SPEEDWAYMOTORS\aklittle			BVL-AKL              0
    SPEEDWAYMOTORS\blparks	        LNK-SQL-LIVE-1	     1
    SPEEDWAYMOTORS\albredthauer		LNK-IS-01			 0
	*/ 

EXEC sp_WhoIsActive  

    /****   specific DB    *****/
    EXEC [Util].dbo.usp_who5 X,NULL,NULL,[SMI Reporting],NULL  
    EXEC [Util].dbo.usp_who5 X,NULL,NULL,[AFCOReporting],NULL   

    EXEC [Util].dbo.usp_who5 X,NULL,aklittle,AFCOReporting,NULL  
   
    /****   specific users    *****
    EXEC [Util].dbo.usp_who5 X,NULL,ascrook,NULL,NULL   --  7
    GO
    EXEC [Util].dbo.usp_who5 X,NULL,pjcrews,NULL,NULL   -- 11
    GO
    EXEC [Util].dbo.usp_who5 X,NULL,ccChance,NULL,NULL  --  4
    GO
    EXEC [Util].dbo.usp_who5 X,NULL,rmdesimone,NULL,NULL--  3
    GO
    EXEC [Util].dbo.usp_who5 X,NULL,mssqldw,NULL,NULL   -- 16
    GO
    EXEC [Util].dbo.usp_who5 X,NULL,phoenix,NULL,NULL   -- 16
                                                        -- ====
                                                        -- 41
    EXEC [Util].dbo.usp_who5 X,NULL,cakulig,NULL,NULL
    EXEC [Util].dbo.usp_who5 X,NULL,aklittle,NULL,NULL

    /****   specific PROC call  *****/
    EXEC [Util].dbo.usp_who5 X,NULL,NULL,NULL,'spExecPOReport'

    /****   specific DB   *****/
    EXEC [Util].dbo.usp_who5 X,NULL,NULL,SMITemp,NULL   -- 11

    /****   SQL statements containing specific text   *****/
    EXEC [Util].dbo.usp_who5 X,NULL,NULL,NULL,'tblOrder'   -- 11    


/**** TO SET UP A SQL SERVER PROFILE TRACE *****
FROM SQL Server Management Studio >> Go to Tools >> SQL Server Profiler
    Under "Events Selection" Tab >> Column Filters >> <login (ALL LOWERCASE) find user to trace>  e.g. %roberts%' 
best not to leave traces running too long, always set an end time in case you forget to turn it off.
    Under "General" Tab >> check "Enable trace stop time" >> specify end date/time    
*/


/*
	@Filter   : Limit the result set by passing one or more values listed below (can be combined in any order)
		A - Active sessions only
		B - Blocked sessions only
		C - Exclude "SQL_Statement_Batch", "SQL_Statement_Current", "Batch_Pct", and "Query_Plan_XML" columns FROM the output (less resource-intensive)
		X - Exclude system reserved SPIDs (1-50)
	@SPID     : Limit the result set to a specific session
	@Login    : Limit the result set to a specific Windows user name (if populated, otherwise by SQL Server login name)
	@Database : Limit the result set to a specific database
	@SQL_Text : Limit the result set to SQL statements containing specific text (ignored when "@Filter" parameter contains "C")
*/

"Using SOP fields for purposes they weren't intended for causes a lot of issues behind the scenes and reporting problems downstream.  
When there is a need to store new data, please request that a new field be created for it in SOP."