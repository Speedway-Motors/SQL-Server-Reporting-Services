-- Report Names and Locations
USE ReportServer
GO

SELECT 
CASE WHEN C.Name = '' THEN 'Home' ELSE C.Name END AS ItemName, 
/*
LEN(C.Path) - LEN(REPLACE(C.Path, '/', '')) AS ItemLevel, 
CASE 
WHEN C.type = 1 THEN '1-Folder' 
WHEN C.type = 2 THEN '2-Report' 
WHEN C.type = 3 THEN '3-File' 
WHEN C.type = 4 THEN '4-Linked Report' 
WHEN C.type = 5 THEN '5-Datasource' 
WHEN C.type = 6 THEN '6-Model' 
WHEN C.type = 7 Then '7-ReportPart'
WHEN C.type = 8 Then '8-Shared Dataset'
ELSE '9-Unknown' END AS ItemType, 
CASE WHEN C.Path = '' THEN 'Home' ELSE C.Path END AS Path, 
*/
ISNULL(CASE WHEN CP.Name = '' THEN 'Home' ELSE CP.Name END, 'Home') AS ParentName 
--,ISNULL(LEN(CP.Path) - LEN(REPLACE(CP.Path, '/', '')), 0) AS ParentLevel
,ISNULL(CASE WHEN CP.Path = '' THEN ' Home' ELSE CP.Path END, ' Home') AS ParentPath 
--,LEN(ISNULL(CASE WHEN CP.Path = '' THEN ' Home' ELSE CP.Path END, ' Home')) PathLength
,C.Description as 'Description'
FROM dbo.Catalog AS CP 
    RIGHT OUTER JOIN dbo.Catalog AS C ON CP.ItemID = C.ParentID
where C.type in (2,4) --= 2 -- 2=Report' 4=Linked Report    see CASE statmente above for full list
order by ItemName -- ParentName, ParentPath,     PathLength desc

