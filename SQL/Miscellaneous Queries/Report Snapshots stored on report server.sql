-- Report Snapshots stored on report server
SELECT c.name                                      AS ReportName,
       c.path                                      AS ReportPath,       
       FORMAT(h.snapshotdate,'yyyy.MM.dd HH:mm') 'SnaphsotDate'
 /* CONVERT(VARCHAR(20), sc.nextruntime, 113)   AS ScheduleNextRunTime,
    c.itemid                                    AS ReportID,
    s.effectiveparams                           AS SnapshotEffectiveParams,      
    s.queryparams                               AS SnapshotQueryParams,   
    s.DESCRIPTION                               AS SnapshotDescription,      
    sc.name                                     AS ScheduleName
     */  
FROM ReportServer.dbo.History h (NOLOCK)
    INNER JOIN ReportServer.dbo.SnapshotData s (NOLOCK) ON h.snapshotdataid = s.snapshotdataid
    INNER JOIN ReportServer.dbo.Catalog c (NOLOCK) ON c.itemid = h.reportid
    INNER JOIN ReportServer.dbo.ReportSchedule rs (NOLOCK) ON rs.reportid = h.reportid
    INNER JOIN ReportServer.dbo.Schedule sc (NOLOCK) ON sc.scheduleid = rs.scheduleid
WHERE rs.reportaction = 2 -- Create schedule
    --AND c.Name LIKE '%' + ISNULL(@ReportName, '') + '%' 
ORDER BY c.name,
        h.snapshotdate


SELECT c.name                                  AS ReportName,
--   c.path                                      AS ReportPath,       
       FORMAT(COUNT(h.snapshotdate),'###,###') AS SnapshotCount
FROM ReportServer.dbo.History h (NOLOCK)
    INNER JOIN ReportServer.dbo.SnapshotData s (NOLOCK) ON h.snapshotdataid = s.snapshotdataid
    INNER JOIN ReportServer.dbo.Catalog c (NOLOCK) ON c.itemid = h.reportid
    INNER JOIN ReportServer.dbo.ReportSchedule rs (NOLOCK) ON rs.reportid = h.reportid
    INNER JOIN ReportServer.dbo.Schedule sc (NOLOCK) ON sc.scheduleid = rs.scheduleid
WHERE rs.reportaction = 2 -- Create schedule
    --AND c.Name LIKE '%' + ISNULL(@ReportName, '') + '%' 
GROUP BY c.name
ORDER BY c.name
/*                      Snapshot
Report Name	            Count
=====================   ========
Prop 65 Flag SKU Count	40
Receiving On Dock Times	100
Weight Deviance	        52
*/