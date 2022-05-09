USE ReportServer
GO

SELECT 
   Cat.Name                 AS ReportName, 
   Cat.Path                 AS ReportPath,
   U.UserName               AS SubscriptionOwner,
   Sched.ScheduleID         AS SQLAgent_Job_Name, 
   Subs.Description         AS sub_desc, 
   Subs.DeliveryExtension   AS sub_delExt
FROM ReportSchedule RS
     INNER JOIN Schedule Sched ON RS.ScheduleID = Sched.ScheduleID 
     INNER JOIN Subscriptions Subs ON RS.SubscriptionID = Subs.SubscriptionID 
     INNER JOIN [Catalog] Cat ON RS.ReportID = Cat.ItemID AND Subs.Report_OID = Cat.ItemID
     INNER JOIN Users U ON U.UserID = Sched.CreatedByID
WHERE 
Subs.SubscriptionID in ('80977E60-99DD-458D-B6FA-65609D3914DD','86AA88A8-9D4F-4DC2-B072-6F6B82FD0DD8')
-- Cat.Name LIKE '%Feedback%'     
-- U.UserName like '%larkins'
-- Subs.Description  LIKE '%salmon%' -- on the recipient list

--ORDER BY SubscriptionOwner 





-- Subscription counts by Owner
SELECT CONVERT(VARCHAR, GETDATE(), 101)  'As of     ',  
   --U.UserName               AS SubscriptionOwner,
   COUNT(Sched.ScheduleID) 'SubCnt', -- count of SQLAgent_Job_Name,    -- 148 non-IT subscriptions @10-9-15
   UPPER(SUBSTRING(U.UserName,16,99)) 'SubscrptnOwner'
FROM ReportSchedule RS
     INNER JOIN Schedule Sched ON RS.ScheduleID = Sched.ScheduleID 
     INNER JOIN Subscriptions Subs ON RS.SubscriptionID = Subs.SubscriptionID 
     INNER JOIN [Catalog] Cat ON RS.ReportID = Cat.ItemID AND Subs.Report_OID = Cat.ItemID
     INNER JOIN Users U ON U.UserID = Sched.CreatedByID
group by UPPER(SUBSTRING(U.UserName,16,99)) 
    -- U.UserName
order by SubCnt desc
/*          Sub Subscrptn
  As of   	Cnt Owner
==========  === =========
10/09/2015	50	KDLARKINS
10/09/2015	38	AEWILCOX
10/09/2015	19	PJCREWS
10/09/2015	17	JMROBERTS
10/09/2015	10	JBSCALES
10/09/2015	10	KLJENKINS
10/09/2015	6	CCCHANCE
10/09/2015	4	AKLITTLE
10/09/2015	4	JMTENBARGE
10/09/2015	3	SMHOPPOCK
10/09/2015	2	JJMALCOM
10/09/2015	2	ASCROOK
10/09/2015	1	BJBISCH
10/09/2015	1	BSSTEWARD
10/09/2015	1	BVBRITTEN
10/09/2015	1	CFSMITH
10/09/2015	1	CLKLANN
10/09/2015	1	DLSTOAKES
10/09/2015	1	GWHENRY
10/09/2015	1	RMDESIMONE
*/                         
                         
/*                          
select UserName from Users where UserID in ('3AB86EC9-336A-4F06-B4B8-173F78E8CE68',
'20685871-8942-4CAE-AD4A-A5A79870F344','BD7DE919-05A7-4FD4-B66B-FF9D93AF239C','BD7DE919-05A7-4FD4-B66B-FF9D93AF239C','D480E4E2-697C-4B7C-BB74-BF18F59C0F73')

CreatedByID
5ECFC8D4-B676-4F34-AFC7-F1761CA37F8A
5ECFC8D4-B676-4F34-AFC7-F1761CA37F8A
5ECFC8D4-B676-4F34-AFC7-F1761CA37F8A
5ECFC8D4-B676-4F34-AFC7-F1761CA37F8A
5ECFC8D4-B676-4F34-AFC7-F1761CA37F8A


3AB86EC9-336A-4F06-B4B8-173F78E8CE68
20685871-8942-4CAE-AD4A-A5A79870F344
BD7DE919-05A7-4FD4-B66B-FF9D93AF239C
BD7DE919-05A7-4FD4-B66B-FF9D93AF239C
D480E4E2-697C-4B7C-BB74-BF18F59C0F73


*/

