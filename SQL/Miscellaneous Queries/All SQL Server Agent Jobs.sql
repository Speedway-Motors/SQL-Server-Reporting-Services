USE msdb
SELECT dbo.sysjobs.name, CAST(dbo.sysschedules.active_start_time / 10000 AS VARCHAR(10))  
+ ':' + RIGHT('00' + CAST(dbo.sysschedules.active_start_time % 10000 / 100 AS VARCHAR(10)), 2) AS active_start_time,  
dbo.udf_schedule_description(dbo.sysschedules.freq_type, 
dbo.sysschedules.freq_interval, 
dbo.sysschedules.freq_subday_type, 
dbo.sysschedules.freq_subday_interval, 
dbo.sysschedules.freq_relative_interval, 
dbo.sysschedules.freq_recurrence_factor, 
dbo.sysschedules.active_start_date, 
dbo.sysschedules.active_end_date, 
dbo.sysschedules.active_start_time, 
dbo.sysschedules.active_end_time) AS ScheduleDscr, dbo.sysjobs.enabled 
FROM dbo.sysjobs INNER JOIN 
dbo.sysjobschedules ON dbo.sysjobs.job_id = dbo.sysjobschedules.job_id INNER JOIN 
dbo.sysschedules ON dbo.sysjobschedules.schedule_id = dbo.sysschedules.schedule_id  
/* to check for a specific time range...
WHERE CAST(dbo.sysschedules.active_start_time / 10000 AS VARCHAR(10))  
+ ':' + RIGHT('00' + CAST(dbo.sysschedules.active_start_time % 10000 / 100 AS VARCHAR(10)), 2) BETWEEN '6:39' AND '7:59'
*/
ORDER by active_start_time
                      