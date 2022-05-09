-- Disable SSA jobs for specific report subscriptions on LNK-DW1

use msdb;

declare @Sql varchar(max);
set @Sql = 'EXEC dbo.sp_update_job  @job_name = N''<JobName>'', @enabled = 0 ;  '

select REPLACE(@Sql,'<JobName>',s.name) as DisableSQL
    ,s.*
from msdb.dbo.sysjobs s
where s.name in
    ('2C735675-109C-457A-A171-3A89416379C6','7C56B12B-0AE1-41BE-A0AC-60BDB08C2B3C','244CB7A3-E82B-42CE-BB5E-126F39825775','61CA5FEF-AFA0-48C8-A9D9-E31B9A928241','3BEFC37F-FED6-4DAA-BCE0-9E5AF3FE5FB4','16E4A2B4-46A0-40F7-A4A1-53C3E7B93111')   

/* 
Just take the results of the query (first column) and execute that sql. 
Type a new message
*/

 
EXEC dbo.sp_update_job  @job_name = N'16E4A2B4-46A0-40F7-A4A1-53C3E7B93111', @enabled = 0 ;  
EXEC dbo.sp_update_job  @job_name = N'244CB7A3-E82B-42CE-BB5E-126F39825775', @enabled = 0 ;  
EXEC dbo.sp_update_job  @job_name = N'2C735675-109C-457A-A171-3A89416379C6', @enabled = 0 ;  
EXEC dbo.sp_update_job  @job_name = N'3BEFC37F-FED6-4DAA-BCE0-9E5AF3FE5FB4', @enabled = 0 ;  
EXEC dbo.sp_update_job  @job_name = N'61CA5FEF-AFA0-48C8-A9D9-E31B9A928241', @enabled = 0 ;  
EXEC dbo.sp_update_job  @job_name = N'7C56B12B-0AE1-41BE-A0AC-60BDB08C2B3C', @enabled = 0 ;  
EXEC dbo.sp_update_job  @job_name = N'2C735675-109C-457A-A171-3A89416379C6', @enabled = 0 ;  


select * from msdb.dbo.sysjobs
where name in
    ('2C735675-109C-457A-A171-3A89416379C6','7C56B12B-0AE1-41BE-A0AC-60BDB08C2B3C')
