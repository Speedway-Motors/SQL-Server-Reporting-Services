/***********************************/
/*** List - Find failed SSA jobs ***/
/***********************************/
use msdb
go
select h.server as [Server],
	j.[name] as [Name],
	h.message as [Message],
	h.run_date as LastRunDate, 
	h.run_time as LastRunTime
from sysjobhistory h
	inner join sysjobs j on h.job_id = j.job_id
		where j.enabled = 1 
		and h.instance_id in
		(select max(h.instance_id)
			from sysjobhistory h group by (h.job_id))
		and h.run_status = 0


/**** REVIEW ALL FAILED JOBS ********/
select h.server as [Server],
	j.[name] as [Name],
	h.message as [Message],
	h.run_date as LastRunDate, 
	h.run_time as LastRunTime
into #SSAJobs
from sysjobhistory h
	inner join sysjobs j on h.job_id = j.job_id
Where j.enabled = 1
 --   and h.run_status = 1
   -- and UPPER(h.message) like '%FAILED%'
ORDER BY h.message -- 25,000 as of 3-19-19, 20190223 is the oldest record.  Log appears to keep the 25k most recent records

     -- AND h.run_date > 20181231

select count(*), Message
from #SSAJobs
group by Message 
order by count(*) desc -- 7,204 unique messages

select count(*), LastRunDate, Message -- 25 days worth of data
from #SSAJobs
group by LastRunDate, Message 
order by LastRunDate, count(*) desc -- 7,204 unique messages

select count(*), Message -- 25 days worth of data
from #SSAJobs
group by Message 
order by  count(*) desc -- Message, count(*) desc -- 7,204 unique messages

select count(*), LastRunDate, Name, Message -- 25 days worth of data
from #SSAJobs
where Message = 'Executed as user: NT Service\SQLSERVERAGENT. The step did not generate any output.  Process Exit Code 0.  The step succeeded.'
group by LastRunDate, Name, Message 
order by LastRunDate, count(*) desc -- 7,204 unique messages



        
select * from #SSAJobs
where Message = 'Executed as user: NT Service\SQLSERVERAGENT. The step did not generate any output.  Process Exit Code 0.  The step succeeded.'

DROP TABLE #SSAJobs