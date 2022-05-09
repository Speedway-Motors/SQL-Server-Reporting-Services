-- Clearing junk SKU Transaction updates from AWS queue

-- SELECT @@SPID as 'Current SPID' -- 126 

-- SPIDS with OPEN TRANSACTIONS  
-- SELECT * FROM sys.sysprocesses  WHERE open_tran = 1 and program_name <> 'Replication Distribution Agent' and program_name NOT LIKE 'Repl-LogReader%' 
    -- 87 & 120
  -- SELECT @@trancount as 'Open Transactions' -- works ONLY on the SPID it's executed on   

    EXEC sp_blockinfo -- Generic CHECK for BLOCKING 
    /*
    Spid 119 is blocked by spid 107
    Spid 154 is blocked by spid 119
    */
/*
SSA JOB SmiJob_ClearQueue_tblSKUTransaction -- CURRENT SPID 52    RATE= 1.8m/hour    ETA 262 hours (11 days)

dbcc inputbuffer(107) -- EXEC dbo.sp_MSdistribution_cleanup @min_distretention = 0, @max_distretention = 72
dbcc inputbuffer(119) -- distribution.dbo.sp_MSadd_replcmds;1

dbcc inputbuffer(9) -- 
dbcc inputbuffer(9) -- 
dbcc inputbuffer(9) -- 
dbcc inputbuffer(9) -- 


KILL 118
KILL 143
*/

/* OQ log

    THUR 
OQ  Time
=== ====
1   4:38  -- 59 mins 2nd batch   
31  4:18   
391 3:44  -- 76 mins 1st batch
40  3:14
14  2:49 -- SSA job now running at 10k/batch
35  2:45  
10  2:38
24  2:33 -- new test at 10k/batch
122 2:19 -- resumed proc at 7,500/batch    

2,822  1:11 
3,051 12:49 
            -- paused our process, Connie is feeding order that had Avalara issues
482 12:14
427 12:12 
376 12:09 - starting batches of 7.5k
348 12:05
234 11:53
41  11:48 - starting 2nd test batch of 10k
8   11:44 - half way through first test batch  of 10k

64  11:34
346 10:01
43  9:30
155 9:28
8   9:17
34  9:15 -- 5k batch size (3m/hr) started @9:14
18  9:11
145 8:46

    WED @1.5m/hour
234     4:56
200     5:01
25      5:15
4       6:32
3       6:46




EXEC [Util].dbo.usp_who5 X,NULL,NULL,NULL,NULL 

*/
