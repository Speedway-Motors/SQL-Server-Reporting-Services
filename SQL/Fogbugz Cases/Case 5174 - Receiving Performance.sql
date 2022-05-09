select 
    JT.dtDate,
    JT.ixEmployee,
    JT.sJob,
    JT.JobDescription,
    (sum(JT.iTotDailyJobTime) /3600.00) JobTime
from vwDailyTotJobTime JT
  left join tblReceiver R on JT.ixEmployee = R.ixCreateUser
where (JT.ixDepartment = '81'
       OR JT.ixEmployee = 'AAI') -- Tony is in dept 80
    and JT.dtDate >= '12/23/10'
group by JT.dtDate,JT.ixEmployee,JT.sJob,JT.JobDescription
order by JT.dtDate,JT.ixEmployee,JT.sJob


select 
    JT.dtDate,
    JT.ixEmployee,
    JT.sJob,
    JT.JobDescription,
    (sum(JT.iTotDailyJobTime) /3600.00) JobTime
from vwDailyTotJobTime JT
where JT.ixDepartment = '81'
--    and JT.dtDate >= '12/23/10'
group by JT.dtDate,JT.ixEmployee,JT.sJob,JT.JobDescription
order by JT.dtDate,JT.ixEmployee,JT.sJob


select distinct sJob, JobDescription, sJobSort,
    (sum(iTotDailyJobTime) /3600.00) JobTime
from vwDailyTotJobTime
where ixDepartment = '81'
    and dtDate >= @StartDate
    and dtDate < (@EndDate+1)
group by sJob, JobDescription, sJobSort
order by sJobSort



select TOP 10 * from tblTranslation
select top 10 * from tblSKU
SELECT TOP 10 * FROM tblReceiver


select * from tblReceiver where ixCloseDate >= 16000
select * from tblDate where ixDate >= '16000'
select * from tblEmployee where ixEmployee = 'JWK'
select * from tblJob where ixJob like '80%'
select * from tblJobClock
select * from vwDailyTotJobTime




select distinct sJob 
from tblJobClock JC
    join tblEmployee EMP on JC.ixEmployee = EMP.ixEmployee
and EMP.ixDepartment = '81'

select * from tblJob
where ixDepartment = '81'

select sTransactionType, count(*) QTY
from tblSKUTransaction
group by sTransactionType
order by count(*) desc


select * -- sUser,ixJob
from tblSKUTransaction
where ixDate = 15711
order by ixTime desc

select * from tblTime where ixTime = 46503

select distinct ixJob from tblSKUTransaction
where ixJob like '8%'



select * from tblSKUTransaction
where ixDate = 15711
and sUser in ('TKR1','EJW1','DDV','CAG','BJM','AEA','BKH','CEL','DLC','DLS1','JDL') -- entire receiving team
order by ixJob, sTransactionType


select * from tblSKUTransaction
where ixDate = 15711
and sUser in ('TKR1','EJW1','DDV','CAG','BJM','AEA','BKH','CEL','DLC','DLS1','JDL') -- entire receiving team
and ixJob = '81-10'
order by ixJob, sTransactionType


select sUser
from tblSKUTransaction
where sUser like 'RF%'
and ixDate >= 15711

update tblSKUTransaction
set sUser = 'JLW'
where sUser = 'RFJLW'
and ixDate >= 15711



select *
from tblSKUTransaction
where ixJob in ('81-2','81-3')
    and ixDate = 15711 -- start of sJob tracking
    and sTransactionType = 'R' 
  --  and sCID is not null
--group by sUser, ixDate

select * from tblBin 
where ixBin like 'BS%' --is not null

order by ixBin



/*
select * from tblSKUTransaction
where ixDate ='15711'
and sUser = 'TKR1'
and ixJob = '81-6'

select ixSKU, dWeight from tblSKU where ixSKU in ('564444-BLK','564725T-BLK','5642332','91139616','91062850')
*/


-- RENAME ALL USERS WITH RF% PREFIX
update tblSKUTransaction
set sUser = 'BKH'
where sUser = 'RFBKH'
GO
update tblSKUTransaction
set sUser = 'BKD'
where sUser = 'RFBKD'
GO
update tblSKUTransaction
set sUser = 'BVB'
where sUser = 'RFBVB'
GO
update tblSKUTransaction
set sUser = 'CAG'
where sUser = 'RFCAG'
GO
update tblSKUTransaction
set sUser = 'CRJ'
where sUser = 'RFCRJ'
GO
update tblSKUTransaction
set sUser = 'DDV'
where sUser = 'RFDDV'
GO
update tblSKUTransaction
set sUser = 'JLG1'
where sUser = 'RFJLG1'
GO
update tblSKUTransaction
set sUser = 'JLW'
where sUser = 'RFJLW'
GO
update tblSKUTransaction
set sUser = 'KTS'
where sUser = 'RFKTS'
GO
update tblSKUTransaction
set sUser = 'TMO'
where sUser = 'RFTMO'
/*
1-14-11 10:06
sUser	TransCount
RFJLW	20
RFJLG1	10
RFBKH	7
RFBKD	2
*/


select sUser,  count(*) TransCount
from tblSKUTransaction
where sUser like 'RF%'
and ixDate >= '15715'
group by sUser
order by TransCount desc


vwWarehouseReceivingProductivity 