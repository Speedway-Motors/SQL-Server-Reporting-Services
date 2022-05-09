
USE [ReportServer];

SELECT 
  --  CAT.Name 'ReportName',
    CAT.Path 'ReportPathAndName', 
--  CAT.ParentID 'CAT_ParentID', 
--  CAT.Description 'ReportDescription', 
--    U1.UserName 'ReportCreatedBy', 
--    CAT.CreationDate 'ReportCreationDate',
--    U2.UserName 'ReportModifiedBy', 
--    CAT.ModifiedDate 'ReportModifiedDate',
--    CAT.SnapshotLimit 'ReportSnapshotLimit', 
--    CAT.Type 'CAT_Type',     
--    CAT.ExecutionFlag 'CAT_ExecutionFlag',
    /*SUBSCRIPTION INFO*/
--    U5.UserName 'SubscriptionCreatedBy',
    U3.UserName 'SubscriptionOwner',
--    U4.UserName 'SubscriptionModifiedBy',
--    SUB.ModifiedDate 'SubscriptionModifiedDate',
    SUB.Description 'SubscriptionDescription',
    SUB.LastStatus 'SubscriptionLastStatus',
    SUB.LastRunTime 'SubscriptionLastRunTime',
--    SUB.Parameters 'SubscriptionParameters',
--    SUB.DeliveryExtension 'SUB_DeliveryExtension',
--    SUB.SubscriptionID,
--    SUB.OwnerID,
--    S.StartDate 'ScheduleStartDate',
    S.LastRunTime 'ScheduleLastRunTime',
    S.DaysOfWeek,
    N'exec msdb.dbo.sp_start_job  [' + cast(RS.ScheduleID as nvarchar(100)) + N']'
--    S.EndDate 'ScheduleEndDate',
--    S.RecurrenceType 'S_RecurrenceType' -- get values
--    S.EventType 'S_EventType'
--    RS.ScheduleID 'SSA_ScheduleID'-- SSA Job the runs the subscription schedule
--    ,SUB.*
FROM dbo.[Subscriptions] SUB
   left join ReportSchedule RS on RS.SubscriptionID = SUB.SubscriptionID
   left join Schedule S on S.ScheduleID = RS.ScheduleID
   left join Catalog CAT on CAT.ItemID = SUB.Report_OID
   left join Users U1 on U1.UserID = CAT.CreatedByID 
   left join Users U2 on U2.UserID = CAT.CreatedByID    
   left join Users U3 on U3.UserID = SUB.OwnerID 
   left join Users U4 on U4.UserID = SUB.ModifiedByID
   left join Users U5 on U5.UserID = S.CreatedById
--WHERE S.LastRunTime >= '2021-01-07 00:00:00.001'
   -- and CAT.Path LIKE '/Speedway%'
   --and CAT.Path LIKE '/AFCO%'
   --and SUB.LastStatus = 'Pending'
--S.DaysOfWeek like '%7%' -- Saturdays
 -- UPPER(U3.UserName) like '%MIKE%'
    -- CAT.Name like '%Loyalty%'
  -- and CAT.Name LIKE 'Parts%'
--SUB.LastStatus NOT LIKE 'Mail sent to%'
--SUB.SubscriptionID in ('3B7A365D-9632-4202-8C4E-71BE02AEE02A','945B31F8-5F26-4B69-A6E3-DB359AFB08FA','04DAB12C-44F6-434E-8BB0-32A681010D2F','9BE40A5A-CCAF-4633-B9A2-5B778A0194F8','96A1D6A0-BE35-4C57-A445-E1BDD42C5655','5D4A0CBE-86F0-4EB5-900E-E65C85A7DDB5','F70081B5-05DE-4779-A905-EBC445CC95B2','F1B2E22E-DDD7-4345-B004-26512A3B79F1','800AE1A3-019D-47B1-B2DA-4CC7C3720CB9','87B3DB76-1431-4B70-BCAB-77664E414750','979B1F19-83BA-4E5F-BCCA-2EB889C22F4C','4B0C7002-63AA-444B-9B22-B13F5960D954','039589D5-6D97-49AB-A4A2-FB3112515DA0','C42649E9-58AA-49F0-B117-135E4277BA57','A93D4221-C128-4728-A94A-3AE6F6689D0C','BF392430-9E5C-40CB-ADED-DFFF112E20C9','27C85157-E2F3-405F-B582-3B1AAFFBFF28','580F978E-6E69-4301-B358-E01E7CFB800B','1CF4DDA7-DFC0-44B8-ADC5-EB33B340FB59','CE4AB503-9EBC-41B3-875E-ED153E7D90B4','A5ADA721-9580-49E7-B0F6-8D666D934ADF','67A9266C-F31C-4290-BA35-C482D59F35C1','E3CC48EF-D288-4796-B0C6-270B0840516A')
--and SUB.LastRunTime > DATEADD(DD,-7,GETDATE())

order by S.LastRunTime,--SUB.LastStatus
--SUB.LastRunTime
 --S.LastRunTime
 CAT.Path
--CAT.Name, SUB.LastRunTime

/*
-- to change ownership of a SINGLE Subscripion
UPDATE dbo.Subscriptions 
SET OwnerID = '7DFBC4D0-D5B7-428F-949A-8FDF6D386D5E'
WHERE SubscriptionID = 'DF096ED6-D0E1-488E-B855-20570ECA6D79'
*/

SELECT * FROM ReportSchedule
SELECT * FROM Schedule

SELECT 


exec Util.[dbo].[spUtil_FindSSRSSubscription] [Loyalty Builder Customer File Processed]


/Speedway/Systems/Loyalty Builder Customer File Processed


exec msdb.dbo.sp_start_job  [058C457C-F843-458A-8E56-3747792C45AE]
exec[ReoportServer].dbo.AddEvent @EventType = 'Timed Subscription', @EventDate = 