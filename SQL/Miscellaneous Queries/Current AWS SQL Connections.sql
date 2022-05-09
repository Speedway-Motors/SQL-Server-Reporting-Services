-- CURRENT AWS SQL CONNECTIONS

SELECT @@SPID as 'Current SPID' -- 61 

-- SPIDS with OPEN TRANSACTIONS  
SELECT * FROM sys.sysprocesses  WHERE open_tran = 1 and program_name <> 'Replication Distribution Agent' and program_name NOT LIKE 'Repl-LogReader%' 
  -- SELECT @@trancount as 'Open Transactions' -- works ONLY on the SPID it's executed on   

EXEC util.dbo.usp_who5

    /* when spid ### is blocked by spid ###
        dbcc inputbuffer(122) -- 
        dbcc inputbuffer(124) -- 
        dbcc inputbuffer(117) -- 
     */

 -- # of user connections
     SELECT (D.sDayOfWeek3Char + ' ' +FORMAT(getdate(),'MM/dd/yy HH:mm')) 'As Of             ', PC.cntr_value 'UserConnections'
     FROM sys.dm_os_performance_counters PC       Left join tblDate D on FORMAT(getdate(),'MM/dd/yyyy') = D.dtDate
     WHERE counter_name = 'User Connections'
 /*                     User
    As Of             	Connctns	Range 54 (typically 54+/-?)
    ==================  ========	================================				
    THU 04/28/22 17:36	54

*/

SELECT * FROM sys.dm_exec_connections


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

                                                        -- ====
                                                        -- 41
 

