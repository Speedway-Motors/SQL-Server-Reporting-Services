-- Case 17033 - Change ownership of Report Subscriptions

-- http://blogs.msdn.com/b/miah/archive/2008/07/10/tip-change-the-owner-of-report-server-subscription.aspx

/* 
[ReportServer].dbo.Subscriptions.OwnerID = [ReportServer].dbo.Users.UserID   

replace the old OwnerID with the new one from the Users table 
that matches the new user that you want to use. 

execute code below
OldUser and NewUser are the users that you want to swap
*/



-- LNK-SQL-LIVE-1
USE [ReportServer]

select UserType, AuthType, UserName, UserID
from dbo.Users 
where --UserID = 'EF7D7B68-39CE-4014-9255-8C93B51BD105'
     UserName like '%alb%'
    or UserName like '%ajfrieri%'
    or UserName like '%ascrook%'
    or UserName like '%bjbisch%'
    or UserName like '%ccchance%'
    or UserName like '%dcd%'--'%dcdemunbrun%'
    or UserName like '%jctrowbridge%'  
    or UserName like '%jdsmith%'       
    or UserName like '%jmcowles%'    
    or UserName like '%kdlarkins%'    
    or UserName like '%klbeck%'   
    or UserName like '%kljenkins%'   
    --or UserName like '%nrnaab%' 
    or UserName like '%pjcrews%'    
    or UserName like '%rmdesimone%'
    or UserName like '%rjmcdowell%'    
    or UserName like '%troldham%'    
ORDER BY UserName


/*
User    Auth
Type	Type	UserName	            UserID

AFCO
0	    1	SPEEDWAYMOTORS\ajfrieri	    BB0E373A-6350-4742-AC0A-D8D46FAF4FB3
0	    1	SPEEDWAYMOTORS\aklittle	    EF7D7B68-39CE-4014-9255-8C93B51BD105
1	    1	SPEEDWAYMOTORS\jctrowbridge	E50DA543-2E79-4064-B41D-7FFCC050AD4F
0	    1	SPEEDWAYMOTORS\rjmcdowell	27CB3086-990E-4BF9-B10F-03C98339B89D
1	    1	speedwaymotors\troldham	    F4AD7CC9-439C-4D66-9037-DB3ED28C7EC7

SPEEDWAY
0	    1	SPEEDWAYMOTORS\albredthauer	C4ACE72E-F898-4212-9E79-011353664B17
1	    1	SPEEDWAYMOTORS\ascrook	    DDBBD21E-38FE-4B23-9DBA-ED9EBDA56E72
1	    1	SPEEDWAYMOTORS\bjbisch	    BDA66726-233A-4466-B659-0750C0A42ECB
0	    1	SPEEDWAYMOTORS\ccchance	    81FC1791-ED7F-4D50-B3F7-F48E0CA08721
0	    1	SPEEDWAYMOTORS\ccchance.all	967EB1EC-BD0E-4CB0-BEEA-4366C10F9ED7
0	    1	SPEEDWAYMOTORS\jdsmith	    D1FF90B1-C3CA-4744-A759-B782F4C14ADE
0	    1	SPEEDWAYMOTORS\jmcowles	    AE0E26D2-96E8-4A93-A4BE-E1D66314E1E5
1	    1	SPEEDWAYMOTORS\kdlarkins	7DFBC4D0-D5B7-428F-949A-8FDF6D386D5E
0	    1	SPEEDWAYMOTORS\klbeck	    C0B2195E-3D8B-4510-9B15-8CE0ABA69F83
1	    1	speedwaymotors\nrnaab	    AC54F114-1D12-4EFB-BD78-38E46429C8D0
0	    1	SPEEDWAYMOTORS\pjcrews	    B46495E0-FBA1-4454-9AB4-48339E71C82F
0	    1	SPEEDWAYMOTORS\rmdesimone	E92AFF8A-5639-4D2D-B41B-C621147216FD

*/

-- ALL CODE MUST BE RUN ON LNK-DW1 UNTIL WE DEPLOY AND COFIGURE SSRS ON LNK-SQL-LIVE-1                 
select CAT.Name 'ReportName',
    CAT.Path 'ReportPath', 
    U.UserName 'SubscriptionOwner',
    U.UserID 'OwnerID',     
    SUB.SubscriptionID,
    SUB.LastRuntime,
    SUB.LastStatus,   
    --  CAT.ParentID 'CAT_ParentID', 
    --  CAT.Description 'ReportDescription', 
    -- U1.UserName 'ReportCreatedBy', 
    CAT.CreationDate 'ReportCreationDate',
    CAT.ModifiedDate 'ReportModifiedDate'
    --    U2.UserName 'ReportModifiedBy', 
    --    CAT.SnapshotLimit 'ReportSnapshotLimit', 
from [ReportServer].dbo.Subscriptions SUB
       left join [ReportServer].dbo.Users U on SUB.OwnerID = U.UserID
       left join [ReportServer].dbo.ReportSchedule RS on RS.SubscriptionID = SUB.SubscriptionID
       left join [ReportServer].dbo.Schedule S on S.ScheduleID = RS.ScheduleID
       left join [ReportServer].dbo.Catalog CAT on CAT.ItemID = SUB.Report_OID  
where 
    --UPPER(UserName) like '%PJCREWS%'
       --   U.UserID     = '9E76464A-8048-4B77-BD78-55C7C4E054E4'
    -- CAT.Name like '%Shocks%'-- Call Center Open Orders%'
     SUB.SubscriptionID IN ('C7D75A25-338E-4D13-A79B-01B954B4C901','FDDF2E29-CC80-46AB-B132-79AC5F826EB7')
    --and SUB.LastStatus LIKE '%pjcrews%'
order by U.UserName  


/* BEFORE CHANGE
ReportPath	                                            SubscriptionOwner	    OwnerID	                                SubscriptionID
/Speedway/Call Center/Wholesale Group Sales Breakdown	SPEEDWAYMOTORS\pjcrews	B46495E0-FBA1-4454-9AB4-48339E71C82F	DF4539F6-68AB-4293-B819-28A77AD340B8

AFTER CHANGE
/Speedway/Call Center/Wholesale Group Sales Breakdown	speedwaymotors\nrnaab	AC54F114-1D12-4EFB-BD78-38E46429C8D0	DF4539F6-68AB-4293-B819-28A77AD340B8
*/


/********  transfer ownership of ALL SUBSCRIPTIONS belonging to one user to a dif user ********/
BEGIN TRAN

    DECLARE @OldUserID uniqueidentifier
    DECLARE @NewUserID uniqueidentifier

    SELECT @OldUserID = UserID 
    FROM dbo.Users 
    WHERE UserName = 'speedwaymotors\jefudge' -- UserID = 'BA274E75-AAC3-4742-9F1E-81A280BF4AF2'

    SELECT @NewUserID = UserID 
    FROM dbo.Users 
    WHERE UserName = 'SPEEDWAYMOTORS\jmcowles'  -- UserID = 'AD3DB032-1DA0-43F0-BA36-0597613EE66E'

    UPDATE dbo.Subscriptions 
    SET OwnerID = @NewUserID 
    WHERE OwnerID = @OldUserID

ROLLBACK TRAN 

-- exec Util.[dbo].[spUtil_FindSSRSSubscription] [SKUs With No End User SKU Flag assigned]

/********  to change ownership of a SPECIFIC LIST of Subscripions ********/
BEGIN TRAN

    UPDATE dbo.Subscriptions 
    SET OwnerID = 'D1FF90B1-C3CA-4744-A759-B782F4C14ADE'
    WHERE SubscriptionID in ('120242E8-81BE-40C9-ABAA-7282C3024256')

ROLLBACK TRAN 


select * from dbo.Subscriptions 

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
    SUB.OwnerID,
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
-- WHERE U3.UserName LIKE '%scales%'-- 'SPEEDWAYMOTORS\klbeck'
WHERE --SUB.OwnerID in ('66E27256-EA22-4A4A-A0EB-43B185F32C77','EF7D7B68-39CE-4014-9255-8C93B51BD105','C0B2195E-3D8B-4510-9B15-8CE0ABA69F83','27CB3086-990E-4BF9-B10F-03C98339B89D','E50DA543-2E79-4064-B41D-7FFCC050AD4F','BB0E373A-6350-4742-AC0A-D8D46FAF4FB3','F4AD7CC9-439C-4D66-9037-DB3ED28C7EC7')
-- CAT.Name = 'Open Orders with Shocks'
--SUB.LastStatus NOT LIKE 'Mail sent to%'
SUB.SubscriptionID in ('B9246A12-FEE3-4875-9368-8D82B00E6F67','98249097-444F-4E7B-88A2-A3EAF4014302','D348A8C6-E368-4A34-BC9D-78DA21C99E86','98E9A071-82FF-46F0-99AF-40C4F388E682','0B21484A-6C53-40EC-B095-B05900AD69DF','2D16CDE3-79D5-4DF7-BFCB-3D84701331E0','86AA88A8-9D4F-4DC2-B072-6F6B82FD0DD8','A8868FDB-8542-40A8-B86F-7D70D8D4DCCB')
order by U3.UserName, CAT.Name desc
--CAT.Path 
--CAT.Name, SUB.LastRunTime

-- DC52813D-11B3-469E-9FAE-66C22B07F09F
/*
UserID
66E27256-EA22-4A4A-A0EB-43B185F32C77    SPEEDWAYMOTORS\jbscales
EF7D7B68-39CE-4014-9255-8C93B51BD105    SPEEDWAYMOTORS\aklittle
C0B2195E-3D8B-4510-9B15-8CE0ABA69F83	SPEEDWAYMOTORS\klbeck
27CB3086-990E-4BF9-B10F-03C98339B89D	SPEEDWAYMOTORS\rjmcdowell
E50DA543-2E79-4064-B41D-7FFCC050AD4F	SPEEDWAYMOTORS\jctrowbridge
BB0E373A-6350-4742-AC0A-D8D46FAF4FB3	SPEEDWAYMOTORS\ajfrieri
F4AD7CC9-439C-4D66-9037-DB3ED28C7EC7	speedwaymotors\troldham

SUBSCRIPTION ID
33E66D79-E285-47D3-BABE-E8DC64BC62E5	rjmcdowell
01AA029E-B9B1-4BD7-83D5-55F92FA5540E	rjmcdowell
C2A75069-5C66-4D52-A990-16357E76E066	troldham
B8688402-3F01-4D71-9557-051F0C78086C	troldham;
DFE78F82-3243-482C-ACDE-765A79A95994	ajfrieri

3FDC22CC-9EA5-4C9C-B7C6-9001D79BEB48	jctrowbridge
B9246A12-FEE3-4875-9368-8D82B00E6F67	jctrowbridge

*/
BEGIN TRAN
    UPDATE dbo.Subscriptions 
    SET OwnerID = 'EF7D7B68-39CE-4014-9255-8C93B51BD105' -- Pat
    --WHERE OwnerID = 'C4ACE72E-F898-4212-9E79-011353664B17' -- Al
    WHERE SubscriptionID = 'B9246A12-FEE3-4875-9368-8D82B00E6F67'
ROLLBACK TRAN

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


select * from dbo.Users where UserName like '%dowel%'   
   
 select S.SubscriptionID, U.UserName
from Subscriptions S
    left join Users U on S.OwnerID = U.UserID
where OwnerID in ('C4ACE72E-F898-4212-9E79-011353664B17')