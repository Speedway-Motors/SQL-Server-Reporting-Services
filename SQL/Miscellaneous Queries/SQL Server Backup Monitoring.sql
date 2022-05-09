-- SQL Server Backup Monitoring

-- DW1
select
    @@SERVERNAME, database_name COLLATE Latin1_General_CI_AS,
    max(backup_finish_date) as LastFullBackup
from sys.databases d
inner join msdb.dbo.backupset b on b.database_name = d.name and d.owner_sid <> 1
where type = 'D'
group by database_name
-- order by database_name desc;

UNION ALL

-- DWStaging
select
    ( select * from openquery ([lnk-dwstaging1], 'select @@servername')) as ServerName,
       database_name,
    max(backup_finish_date) as LastFullBackup
from [lnk-dwstaging1].master.sys.databases d
inner join [lnk-dwstaging1].msdb.dbo.backupset b on b.database_name = d.name and d.owner_sid <> 1
where type = 'D'
group by database_name
--order by database_name desc;

UNION ALL

-- LNK-web2
select
       ( select * from openquery ([LNK-WEB2\SQLEXPRESS], 'select @@servername')) COLLATE SQL_Latin1_General_CP1_CI_AS  as ServerName,
   -- @@SERVERNAME,
    database_name,
    max(backup_finish_date) as LastFullBackup
from [LNK-WEB2\SQLEXPRESS].master.sys.databases d 
inner join [LNK-WEB2\SQLEXPRESS].msdb.dbo.backupset b on b.database_name = d.name and d.owner_sid <> 1
where type = 'D'
group by database_name
-- order by database_name desc;

