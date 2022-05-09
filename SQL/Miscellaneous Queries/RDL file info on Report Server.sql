USE ReportServer

Select C.Path
,C.Name as 'Report Name'
,C.Description
,C.Hidden
,U1.UserName as 'Created By'
,C.CreationDate
,U2.UserName as 'Modified By'
,C.ModifiedDate
,C.SnapshotLimit
,C.Parameter
,C.ExecutionFlag
/*
 [Name],
               [Description],
               SubString([Path],1,Len([Path]) - (CharIndex('/',Reverse([Path]))-1)) As [Path],
*/               
From    Catalog C
    join Users U1 on C.CreatedByID = U1.UserID     
    join Users U2 on C.ModifiedByID = U2.UserID     
Where  C.[Type] = 2
/* -- created or modified by CCC
   and (U1.UserName = 'SPEEDWAYMOTORS\ccchance'
        OR
        U2.UserName = 'SPEEDWAYMOTORS\ccchance')
  */        
Order By --SubString([Path],1,Len([Path]) - (CharIndex('/',Reverse([Path]))-1)),[Name]
               C.CreationDate desc
        --  C.ModifiedDate desc
               
               
--select * from dbo.Users where UserID = '9E76464A-8048-4B77-BD78-55C7C4E054E4'


