-- List all SSRS subscriptions 
USE [ReportServer];  -- You may change the database name. 
GO 
 
SELECT  CAT.[Path] AS 'ReportPath'
    ,SUB.LastStatus 
    ,SUB.LastRunTime 
    ,USR.UserName AS 'SubscriptionOwner' 
    ,SUB.[Description] 'SubscriptionDescription' 
    ,SUB.DeliveryExtension 
    ,SUB.SubscriptionID
    -- ,SUB.ModifiedDate 
    -- ,SUB.EventType 
    -- ,SCH.NextRunTime 
    -- ,SCH.Name AS ScheduleName       
    -- ,CAT.[Description] AS ReportDescription 
--into #TEMPSubscriptions
FROM dbo.Subscriptions AS SUB 
     INNER JOIN dbo.Users AS USR          ON SUB.OwnerID = USR.UserID 
     INNER JOIN dbo.[Catalog] AS CAT      ON SUB.Report_OID = CAT.ItemID 
     INNER JOIN dbo.ReportSchedule AS RS  ON SUB.Report_OID = RS.ReportID 
                                             AND SUB.SubscriptionID = RS.SubscriptionID 
     INNER JOIN dbo.Schedule AS SCH ON RS.ScheduleID = SCH.ScheduleID 
WHERE --SUB.LastStatus NOT LIKE 'Mail sent%'
    --and SUB.LastStatus NOT LIKE '%Vendor Purchase History%'
    --and SUB.LastStatus NOT IN ('Ready')
    --SUB.LastRunTime > = '09/28/18'
    CAT.[Path] LIKE '%DMS%'
   -- SUB.SubscriptionID in ('A5ADA721-9580-49E7-B0F6-8D666D934ADF')
ORDER BY USR.UserName
    -- SUB.LastRunTime -- DESC 
    -- SUB.InactiveFlags 
    -- USR.UserName ,CAT.[Path];

select SubscriptionOwner, count(*) 'RptSubscriptions'
from #TEMPSubscriptions
group by SubscriptionOwner
order by SubscriptionOwner

select * from #TEMPSubscriptions
where SubscriptionOwner = 'SPEEDWAYMOTORS\gwhenry'


