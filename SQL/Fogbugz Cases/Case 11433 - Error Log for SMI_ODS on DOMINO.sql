--USE DOMINO and SMI_ODS Database

SELECT ixError
     , sOriginFile
     , sErrorText
     , dtErrorLogTime
     , iSeverityLevel
FROM dbo.ErrorLog
WHERE dtErrorLogTime >= DATEADD(day, -1, GetDate()) -- last 24 hours
ORDER BY dtErrorLogTime DESC, ixError