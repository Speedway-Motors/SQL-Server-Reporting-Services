-- Buffer cache hit ratio
 -- sys.dm_os_performance_counters dynamic management view 
		and filtering against the counter_name column using the value “Buffer cache hit ratio”.


 SELECT * FROM sys.dm_os_performance_counters
 WHERE counter_name = 'Buffer cache hit ratio'