-- SMIHD-4737 - New report - Web Purge History

/*
Scheduled once a week - Monday, I don't really care to check this daily.

Source of data :  From DW1 - exec ('call spPurgeHistory_Report') at [TNGREADREPLICA]

Display as sent from the stored procedure.

Do not display ixPurgeHistoryID or ErrorFlag.

If the field ErrorFlag is set to 1, then display in red.

Note: There is currently one that is in the error status, I won't work on fixing that until report is done.
*/

select DBName,sPurgeType,	dtStartDate,	dtEndDate,	iRowsToPurge,	RunTime,	AverageRunTimeSecoonds,	MaxRunTimeSecoonds,	MinRunTimeSecoonds
FROM (
exec ('call spPurgeHistory_Report') at [TNGREADREPLICA]
     ) x
     
     
     
DBName,sPurgeType,	dtStartDate,	dtEndDate,	iRowsToPurge,	RunTime,	AverageRunTimeSecoonds,	MaxRunTimeSecoonds,	MinRunTimeSecoonds
