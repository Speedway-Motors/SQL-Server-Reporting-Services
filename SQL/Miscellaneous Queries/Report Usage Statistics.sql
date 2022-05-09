-- Report Usage Statistics

USE ReportServer
GO

SELECT
    CAT_PARENT.Name AS ParentName,
    CAT.Name AS ReportName,
    ReportCreatedByUsers.UserName AS ReportCreatedByUserName,
    CAT.CreationDate AS ReportCreationDate,
    ReportModifiedByUsers.UserName AS ReportModifiedByUserName,
    CAT.ModifiedDate AS ReportModifiedDate,
    CountExecution.CountStart AS ReportExecuteCount,
    EL.InstanceName AS LastExecutedServerName,
    EL.UserName AS LastExecutedbyUserName,
    EL.TimeStart AS LastExecutedTimeStart,
    EL.TimeEnd AS LastExecutedTimeEnd,
    EL.Status AS LastExecutedStatus,
    EL.ByteCount AS LastExecutedByteCount,
    EL.[RowCount] AS LastExecutedRowCount,
    SubscriptionOwner.UserName AS SubscriptionOwnerUserName,
    SubscriptionModifiedByUsers.UserName AS SubscriptionModifiedByUserName,
    SUB.ModifiedDate AS SubscriptionModifiedDate,
    SUB.Description AS SubscriptionDescription,
    SUB.LastStatus AS SubscriptionLastStatus,
    SUB.LastRunTime AS SubscriptionLastRunTime
FROM dbo.Catalog CAT
INNER JOIN dbo.Catalog CAT_PARENT ON CAT.ParentID = CAT_PARENT.ItemID
INNER JOIN dbo.Users ReportCreatedByUsers ON CAT.CreatedByID = ReportCreatedByUsers.UserID
INNER JOIN dbo.Users ReportModifiedByUsers ON CAT.ModifiedByID = ReportModifiedByUsers.UserID
LEFT OUTER JOIN
    (SELECT
    ReportID,
    MAX(TimeStart) LastTimeStart
    FROM dbo.ExecutionLog
    GROUP BY ReportID
    ) AS LatestExecution ON CAT.ItemID = LatestExecution.ReportID
LEFT OUTER JOIN
    (SELECT
    ReportID,
    COUNT(TimeStart) CountStart
    FROM dbo.ExecutionLog
    GROUP BY ReportID
    ) AS CountExecution ON CAT.ItemID = CountExecution.ReportID
LEFT OUTER JOIN dbo.ExecutionLog AS EL ON LatestExecution.ReportID = EL.ReportID 
                                          AND LatestExecution.LastTimeStart = EL.TimeStart
LEFT OUTER JOIN dbo.Subscriptions SUB ON CAT.ItemID = SUB.Report_OID
LEFT OUTER JOIN dbo.Users SubscriptionOwner ON SUB.OwnerID = SubscriptionOwner.UserID
LEFT OUTER JOIN dbo.Users SubscriptionModifiedByUsers ON SUB.ModifiedByID = SubscriptionModifiedByUsers.UserID
ORDER BY
ReportExecuteCount desc,
CAT_PARENT.Name,
CAT.Name


select MAX(dtAccountCreateDate) from tblCSTCustSummary_Rollup