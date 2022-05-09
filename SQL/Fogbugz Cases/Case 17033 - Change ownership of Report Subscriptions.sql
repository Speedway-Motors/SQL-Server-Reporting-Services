-- Case 17033 - Change ownership of Report Subscriptions

-- http://blogs.msdn.com/b/miah/archive/2008/07/10/tip-change-the-owner-of-report-server-subscription.aspx

/* 
[ReportServer].dbo.Subscriptions.OwnerID = [ReportServer].dbo.Users.UserID   

replace the old OwnerID with the new one from the Users table 
that matches the new user that you want to use. 

execute code below
OldUser and NewUser are the users that you want to swap
*/

--RUN ON LNK-DW1
USE [ReportServer]

select * from dbo.Users where UserName like '%\klb%'   
/*
UserID	                                Sid	                                                        UserType	AuthType	UserName
B46495E0-FBA1-4454-9AB4-48339E71C82F	0x0105000000000005150000000A5D10BB9F3F8B16BD66AC105B1A0000	0	        1	        SPEEDWAYMOTORS\pjcrews
7DFBC4D0-D5B7-428F-949A-8FDF6D386D5E	0x0105000000000005150000000A5D10BB9F3F8B16BD66AC1046050000	1	        1	        SPEEDWAYMOTORS\kdlarkins
81FC1791-ED7F-4D50-B3F7-F48E0CA08721	0x0105000000000005150000000A5D10BB9F3F8B16BD66AC10210E0000	0	        1	        SPEEDWAYMOTORS\ccchance
AD3DB032-1DA0-43F0-BA36-0597613EE66E	0x0105000000000005150000000A5D10BB9F3F8B16BD66AC1078210000	0	        1	        SPEEDWAYMOTORS\jmroberts
C0B2195E-3D8B-4510-9B15-8CE0ABA69F83	0x0105000000000005150000000A5D10BB9F3F8B16BD66AC10CD1D0000	0	        1	        SPEEDWAYMOTORS\klbeck
*/
   
select S.SubscriptionID, U.UserName --,S.*
from Subscriptions S
    left join Users U on S.OwnerID = U.UserID
where OwnerID in ('AD3DB032-1DA0-43F0-BA36-0597613EE66E','C0B2195E-3D8B-4510-9B15-8CE0ABA69F83')
order by U.UserName                 
                 
/* BEFORE CHANGE
SubscriptionID	                        UserName
B8688402-3F01-4D71-9557-051F0C78086C	SPEEDWAYMOTORS\klbeck
C2A75069-5C66-4D52-A990-16357E76E066	SPEEDWAYMOTORS\klbeck
DA4116E2-E088-436E-B68A-40DB16CBBA9E	SPEEDWAYMOTORS\klbeck
01AA029E-B9B1-4BD7-83D5-55F92FA5540E	SPEEDWAYMOTORS\klbeck
80977E60-99DD-458D-B6FA-65609D3914DD	SPEEDWAYMOTORS\klbeck
86AA88A8-9D4F-4DC2-B072-6F6B82FD0DD8	SPEEDWAYMOTORS\klbeck
DFE78F82-3243-482C-ACDE-765A79A95994	SPEEDWAYMOTORS\klbeck
B9246A12-FEE3-4875-9368-8D82B00E6F67	SPEEDWAYMOTORS\klbeck
3FDC22CC-9EA5-4C9C-B7C6-9001D79BEB48	SPEEDWAYMOTORS\klbeck
9EF1B445-7C06-4E93-AD88-A12F3A52FDC5	SPEEDWAYMOTORS\klbeck
BAA57DA5-7464-4503-97BF-AE1F58478D20	SPEEDWAYMOTORS\klbeck
568DF338-8E5D-475C-85AE-AF3DCE46EE56	SPEEDWAYMOTORS\klbeck
92F4B640-F3D3-4B04-97FB-B896DF562965	SPEEDWAYMOTORS\klbeck
0E09E390-9968-42CE-A1DE-B9E761D0349E	SPEEDWAYMOTORS\klbeck
6D131EF8-707B-41AA-9E44-BDA40F0DB88B	SPEEDWAYMOTORS\klbeck
E34C66C7-76F0-4305-A456-BE1ED60CF554	SPEEDWAYMOTORS\klbeck
37E9A0E0-6F3E-43A5-9D77-C85A880D64FB	SPEEDWAYMOTORS\klbeck
90D60D17-07FC-4BF0-BDB8-DAD5963B35E7	SPEEDWAYMOTORS\klbeck
E5D014E3-F096-4263-8B14-DE56444F1892	SPEEDWAYMOTORS\klbeck
C33B3749-57DD-4D1E-8E13-DEBDA8D2909E	SPEEDWAYMOTORS\klbeck
AAB6959A-C780-4941-B32A-E719A90DACE3	SPEEDWAYMOTORS\klbeck
33E66D79-E285-47D3-BABE-E8DC64BC62E5	SPEEDWAYMOTORS\klbeck
*/

DECLARE @OldUserID uniqueidentifier
DECLARE @NewUserID uniqueidentifier

SELECT @OldUserID = UserID 
FROM dbo.Users 
WHERE UserName = 'SPEEDWAYMOTORS\jmroberts' -- UserID = 'BA274E75-AAC3-4742-9F1E-81A280BF4AF2'

SELECT @NewUserID = UserID 
FROM dbo.Users 
WHERE UserName = 'SPEEDWAYMOTORS\klbeck'  -- UserID = 'AD3DB032-1DA0-43F0-BA36-0597613EE66E'

/******** this will transfer ownership of ALL of the subscriptions belonging to one user to a dif user ********/
UPDATE dbo.Subscriptions 
SET OwnerID = @NewUserID 
WHERE OwnerID = @OldUserID

/********  to change ownership of a SINGLE Subscripion ********/

SELECT 
    CAT.Name 'ReportName',
    CAT.Path 'ReportPath', 
--  CAT.ParentID 'CAT_ParentID', 
--  CAT.Description 'ReportDescription', 
--    U1.UserName 'ReportCreatedBy', 
    CAT.CreationDate 'ReportCreationDate',
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
    SUB.Parameters 'SubscriptionParameters',
--    SUB.DeliveryExtension 'SUB_DeliveryExtension',
    SUB.SubscriptionID,
--    SUB.OwnerID,
--    S.StartDate 'ScheduleStartDate',
    S.LastRunTime 'ScheduleLastRunTime'
--    S.EndDate 'ScheduleEndDate',
--    S.RecurrenceType 'S_RecurrenceType' -- get values
--    S.EventType 'S_EventType'
FROM dbo.[Subscriptions] SUB
   left join ReportSchedule RS on RS.SubscriptionID = SUB.SubscriptionID
   left join Schedule S on S.ScheduleID = RS.ScheduleID
   left join Catalog CAT on CAT.ItemID = SUB.Report_OID
   left join Users U1 on U1.UserID = CAT.CreatedByID 
   left join Users U2 on U2.UserID = CAT.CreatedByID    
   left join Users U3 on U3.UserID = SUB.OwnerID 
   left join Users U4 on U4.UserID = SUB.ModifiedByID
   left join Users U5 on U5.UserID = S.CreatedById
-- WHERE CAT.Name like '%Type%'   
WHERE-- U3.UserName = 'SPEEDWAYMOTORS\ccchance'
CAT.Name = 'Open Orders with Shocks'
--SUB.LastStatus NOT LIKE 'Mail sent to%'
order by SUB.LastStatus
--CAT.Name, SUB.LastRunTime

-- DC52813D-11B3-469E-9FAE-66C22B07F09F

UPDATE dbo.Subscriptions 
SET OwnerID = '7DFBC4D0-D5B7-428F-949A-8FDF6D386D5E' -- Larkins
WHERE SubscriptionID = 'DC52813D-11B3-469E-9FAE-66C22B07F09F'

SELECT * FROM dbo.Subscriptions
--WHERE SubscriptionID 
ORDER by LastRunTime desc

-- verify change
select S.SubscriptionID, U.UserName
from Subscriptions S
    left join Users U on S.OwnerID = U.UserID
where OwnerID in ('66E27256-EA22-4A4A-A0EB-43B185F32C77')--,                 'AD3DB032-1DA0-43F0-BA36-0597613EE66E')
order by U.UserName 

/* AFTER change
SubscriptionID	                        UserName
B8688402-3F01-4D71-9557-051F0C78086C	SPEEDWAYMOTORS\jmroberts
80977E60-99DD-458D-B6FA-65609D3914DD	SPEEDWAYMOTORS\jmroberts
86AA88A8-9D4F-4DC2-B072-6F6B82FD0DD8	SPEEDWAYMOTORS\jmroberts
B9246A12-FEE3-4875-9368-8D82B00E6F67	SPEEDWAYMOTORS\jmroberts
568DF338-8E5D-475C-85AE-AF3DCE46EE56	SPEEDWAYMOTORS\jmroberts
92F4B640-F3D3-4B04-97FB-B896DF562965	SPEEDWAYMOTORS\jmroberts
D127B686-4525-41B4-8779-B910C9E5C15B	SPEEDWAYMOTORS\jmroberts
6D131EF8-707B-41AA-9E44-BDA40F0DB88B	SPEEDWAYMOTORS\jmroberts
90D60D17-07FC-4BF0-BDB8-DAD5963B35E7	SPEEDWAYMOTORS\jmroberts
C33B3749-57DD-4D1E-8E13-DEBDA8D2909E	SPEEDWAYMOTORS\jmroberts
33E66D79-E285-47D3-BABE-E8DC64BC62E5	SPEEDWAYMOTORS\jmroberts
*/


select * from dbo.Users where UserName like '%long%'   
   
 select S.SubscriptionID, U.UserName
from Subscriptions S
    left join Users U on S.OwnerID = U.UserID
where OwnerID in ('9DB4AD09-43A5-407D-BFD6-E4AB83E1C0D0')