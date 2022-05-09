-- Records in tblAwsQueueStage
select sMode, -- I instert, D delete, u update
    format(count(1),'###,###,##0') 'Records'
from tblAwsQueueStage (nolock)  
-- where ixAwsQueueTypeReference = 99 -- for tblSKUTransaction updates
  --  and sObjectCode1 = '19482'  
group by sMode -- 146,601  @11:21
order by sMode

SELECT @@SPID as 'Current SPID' -- 114 

/*
Mode    Records
====    =========== 
D	      1,816,883
I	      6,353,065     
U	    473,851,141  @5-5-21 2:24
        449,345,751  @5-6-21 8:28
        349,072,515  @5-7-21 9:58
        234,683,435  @5-8-21 10:25
        117,355,974  @5-9-21 10:35   -- 98 seconds
          8,139,554  @5-10-21 8:40
*/    

/* 
color-coding rules:

  < 250k GREEN
250-500k YELLOW
  > 500k RED

*/

SELECT @@SPID as 'Current SPID' -- 114 



