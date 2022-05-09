/*
			
Employee Name	Employee Number	Department Number	Date	Time In

select * from tblEmployee where sLastName = 'Crews'
select * from tblDoorEvent
select * from tblCard
select * from tblCardUser

*/

SELECT
    E.sFirstName,
    E.sLastName,
    E.ixEmployee, -- placeholder until Employee# is created
    E.ixDepartment,
    CONVERT(VARCHAR(10), DE.dtEventTimeDate, 101) AS [MM/DD/YYYY],
    DE.sAction,
    (Case when DE.dtEventTimeDate > '11/02/10'
          then dateadd(HH,-1,DE.dtEventTimeDate) 
          else DE.dtEventTimeDate
     End) EventTimeDate
FROM
    tblEmployee E
    join tblCardUser CU on CU.ixEmployee = E.ixEmployee
    join tblCard C on C.ixCardUser = CU.ixCardUser
    join tblDoorEvent DE on DE.ixCardScanNum = C.ixCardScanNum
WHERE E.ixEmployee in ('PJC')
and DE.dtEventTimeDate >= '10/27/2010'
and DE.dtEventTimeDate < '11/04/2010'
and E.ixDepartment in ('15')
ORDER BY     E.sLastName,    DE.dtEventTimeDate
