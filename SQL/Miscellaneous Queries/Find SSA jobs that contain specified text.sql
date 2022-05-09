-- Find SSA jobs that contain specified text
select j.name, s.Step_name, s.command from msdb.dbo.sysjobsteps s
inner join msdb.dbo.sysjobs j on s.Job_id = j.Job_id
where command like '%bulk insert%' 