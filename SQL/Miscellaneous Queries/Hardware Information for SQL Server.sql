-- Hardware Information for SQL Server

-- SQL Server 2005
SELECT cpu_count AS [Logical CPU Count], hyperthread_ratio AS [Hyperthread Ratio],
cpu_count/hyperthread_ratio AS [Physical CPU Count], 
physical_memory_in_bytes/1073741824 AS [Physical Memory (GB)]
FROM sys.dm_os_sys_info WITH (NOLOCK) OPTION (RECOMPILE);

/*
-- SQL Server 2008
SELECT cpu_count AS [Logical CPU Count], hyperthread_ratio AS [Hyperthread Ratio],
cpu_count/hyperthread_ratio AS [Physical CPU Count], 
physical_memory_in_bytes/1073741824 AS [Physical Memory (GB)]
, sqlserver_start_time
FROM sys.dm_os_sys_info WITH (NOLOCK) OPTION (RECOMPILE);
*/

-- SQL Server 2008 R2  
SELECT cpu_count AS [Logical CPU Count], hyperthread_ratio AS [Hyperthread Ratio],
cpu_count/hyperthread_ratio AS [Physical CPU Count], 
physical_memory_in_bytes/1073741824 AS [Physical Memory (GB)]
, sqlserver_start_time
, sqlserver_start_time
, affinity_type_desc 
FROM sys.dm_os_sys_info WITH (NOLOCK) OPTION (RECOMPILE);

/*
-- SQL Server 2012
SELECT cpu_count AS [Logical CPU Count], hyperthread_ratio AS [Hyperthread Ratio],
cpu_count/hyperthread_ratio AS [Physical CPU Count], 
physical_memory_in_bytes/1073741824 AS [Physical Memory (GB)], affinity_type_desc, 
virtual_machine_type_desc, sqlserver_start_time
FROM sys.dm_os_sys_info WITH (NOLOCK) OPTION (RECOMPILE);
*/



use msdb
go
select h.server as [Server],
	j.[name] as [Name],
	h.message as [Message],
	h.run_date as LastRunDate, 
	CAST(h.run_date AS CHAR(8)),
	h.run_time as LastRunTime
from sysjobhistory h
	inner join sysjobs j on h.job_id = j.job_id
		where j.enabled = 1 
		and h.instance_id in
		(select max(h.instance_id)
			from sysjobhistory h group by (h.job_id))
		and h.run_status = 0
and h.run_date >= getdate() --datepart("dd",DATEADD(dd, -1, getdate()) )
		
		

