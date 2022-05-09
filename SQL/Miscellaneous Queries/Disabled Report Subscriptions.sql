-- Disabled Report Subscriptions
    SELECT distinct
-- Mayhave to replace lnk-sql-live-1 with reports.speedwaymotors.com depending on the machine you run this on
        'http://reports.speedwaymotors.com/Reports/manage/catalogitem/subscriptions'+ C.path, --replace(C.path,' ','%20'),
        LastStatus
    FROM ReportServer.dbo.Subscriptions S
    INNER JOIN ReportServer.dbo.Users U  ON  S.OwnerID = U.UserID
    INNER JOIN ReportServer.dbo.Catalog C ON S.Report_OID = C.ItemID
    INNER JOIN ReportServer.dbo.ReportSchedule RS ON S.SubscriptionID = RS.SubscriptionID
    INNER JOIN ReportServer.dbo.Schedule Sc ON RS.ScheduleID = Sc.ScheduleID
    where S.LastStatus = 'Disabled'