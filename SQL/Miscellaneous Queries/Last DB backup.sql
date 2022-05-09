-- Last DB backup
-- http://blog.sqlauthority.com/2014/04/14/sql-server-finding-last-backup-time-for-all-database-last-full-differential-and-log-backup-optimized/

SELECT d.name AS 'DATABASE_Name',
MAX(CASE WHEN bu.type = 'D' THEN bu.LastBackupDate END) AS 'Full DB Backup Status',
MAX(CASE WHEN bu.type = 'I' THEN bu.LastBackupDate END) AS 'Differential DB Backup Status',
MAX(CASE WHEN bu.type = 'L' THEN bu.LastBackupDate END) AS 'Transaction DB Backup Status',
CASE d.recovery_model WHEN 1 THEN 'Full' WHEN 2 THEN 'Bulk Logged' WHEN 3 THEN 'Simple' END RecoveryModel
FROM master.sys.databases d
LEFT OUTER JOIN (SELECT database_name, type, MAX(backup_start_date) AS LastBackupDate
FROM msdb.dbo.backupset
GROUP BY database_name, type) AS bu ON d.name = bu.database_name
GROUP BY d.Name, d.recovery_model
order by d.name