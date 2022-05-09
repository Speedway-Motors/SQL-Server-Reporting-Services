-- SMIHD-23789 - analysis for WH cross-department hours
DECLARE @StartDate DATETIME = '01/01/2022',
        @EndDate DATETIME = '01/19/2022',
        @Dept varchar(3) = '81'

SELECT-- JT.dtDate,
 --  JT.ixEmployee,
--   E.sFirstname+' '+E.sLastname  EmpName,
    E.ixDepartment,
    D.sDescription,
--    JT.sJob,
 --   JT.JobDescription,
 --   JT.sJobSort,
    (sum(JT.iTotDailyJobTime) /3600.00) JobTime
FROM vwDailyTotJobTime JT
  join tblEmployee E on E.ixEmployee = JT.ixEmployee
  left join tblDepartment D on E.ixDepartment = D.ixDepartment
  left join vwWarehouseReceivingProductivity VW on VW.ixDate = JT.ixDate 
                                                 and VW.sUser = JT.ixEmployee
                                                 and VW.ixJob COLLATE SQL_Latin1_General_CP1_CS_AS = JT.sJob COLLATE SQL_Latin1_General_CP1_CS_AS
WHERE JT.sJob like @Dept+'%'
    and JT.dtDate >= @StartDate --  '01/05/11' 
    and JT.dtDate < (@EndDate+1)
 --   and (JT.ixEmployee in (@Employee)  
 --           OR @Everybody = 'Y')
GROUP BY --JT.dtDate,
 --  JT.ixEmployee,
--   E.sFirstname+' '+E.sLastname  EmpName,
    E.ixDepartment,
    D.sDescription
--    JT.sJob,
 --   JT.JobDescription,    
 --   JT.sJobSort

ORDER BY --JT.dtDate,JT.sJobSort,
    E.ixDepartment

/*
select * from tblDepartment
where ixDepartment like '8%'

ixDepartment	sDescription
80	Warehouse
81	Warehouse - Receiving
82	Warehouse - Restock

84	Warehouse - Carousel
85	Warehouse - Big Pack

87	Warehouse - Small Pack
*/
