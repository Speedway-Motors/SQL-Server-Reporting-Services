-- SMIHD-21775 - Clean-up Employee info so Bamboo and SOP data match
SELECT * FROM [SMITemp].dbo.PJC_EmpBambooData_20210628 -- 573 -- 518 MATCH on payroll ID


SELECT E.sPayrollId, B.sPayrollId 'Bamboo',
FROM [SMITemp].dbo.PJC_EmpBambooData_20210628 B -- 573
left join tblEmployee E on B.sPayrollId = E.sPayrollId
WHERE B.sPayrollId is not null
    AND E.flgDeletedFromSOP = 0
ORDER BY E.sPayrollId

-- DROP TABLE [SMITemp].dbo.PJC_EmpBambooData_20210628

select * from [SMITemp].dbo.PJC_EmpBambooData_20210628
where sPayrollId = '3482'

select * from [SMITemp].dbo.PJC_EmpBambooData_20210628
where ixDepartment is NULL

select distinct ixDepartment from tblEmployee
where flgDeletedFromSOP = 0
order by ixDepartment


select top 20 * from [SMITemp].dbo.PJC_EmpBambooData_20210628
order by newid()

-- MAIN Comparison between the two data sets
select E.ixEmployee 'SOPEmp',
    B.sPayrollId 'BMBPayrollId', 
    E.sPayrollId 'SOPPayrollId',
    B.sFirstname 'BMBFirstName',
    E.sFirstname 'SOPFirstName',
    B.sLastname 'BMBLastName',
    E.sLastname 'SOPLastName', 
    B.sEmailAddress 'BMBEmail', 
    E.sEmailAddress 'SOPEmail', 
    B.ixDepartment 'BMBDept#', 
    E.ixDepartment 'SOPDept#', 

    B.Department 'BMBDeptDescription', 

    B.EmploymentStatus 'BMBEmploymentStatus', 
    B.OvertimeStatus 'BMBOvertimeStatus', 
    E.flgCurrentEmployee 'SOPCurrentEmployee',
    E.flgExempt 'SOPExempt',
    E.flgPartTime 'SOPPartTime',
    E.flgPayroll 'SOPPayroll',
    -- the following weren't provided by Bamboo
    FORMAT(E.dtHireDate, 'MM/dd/yyyy') 'SOPHireDate',
    FORMAT(E.dtTerminationDate, 'MM/dd/yyyy') 'SOPTermDate',
    -- the following don't exist in SMI Reporting
    B.Division 'BMBDivision', 
    B.ReportingTo 'BMBReportingTo', 
    B.JobTitle 'BMBJobTitle', 
    B.ixLocation 'BMBLocNum', 
    B.[Location] 'BMBLocation'
from [SMITemp].dbo.PJC_EmpBambooData_20210628 B
    left join tblEmployee E on B.sPayrollId = E.sPayrollId
where E.flgDeletedFromSOP is NULL
    or E.flgDeletedFromSOP = 0
    


select * from tblEmployee
where flgDeletedFromSOP = 0 
and
    ixEmployee like 'R%T%' -- JWB1
order by sLastname

select * from tblEmployee
where flgDeletedFromSOP = 0 
and ixEmployee in ('DWH','JWB1','KWR','RET')


select ixEmployee, sFirstname, sLastname, 
    sPayrollId, 
    E.ixDepartment, D.sDescription 'DeptName', flgCurrentEmployee, flgPayroll,sEmailAddress
 from tblEmployee E
    left join tblDepartment D on E.ixDepartment = D.ixDepartment
where flgDeletedFromSOP = 0 
    and sPayrollId is NULL
    and flgCurrentEmployee = 1
    and E.ixDepartment NOT IN (47) -- AFCO SMI accounts

    and ixEmployee NOT IN ('TAE1','TFE','WEBFEEDS','PSG')
order by E.ixDepartment, E.sFirstname
/*
ixEmployee	sFirstname	sLastname
TAE1	    TEST	    EMAILCHANGE
TFE	        TEST	    EMAILCHANGE
WEBFEEDS	WEB	        FEEDS
PSG	        PHOENIX	    SYSTEMS
*/


/*
Jeff	NULL	Behrens
Douglas	NULL	Harrifeld
Kameron	NULL	Reed
Richard	NULL	Thomas
*/


-- delete the IDs AAM-Abigail Klann and 5-Kurtis Heble?
select * from tblEmployee
where ixEmployee in ('5','AAM')


Select * from tblDate where iYear = 2020
order by ixDate

select iYear, iOperationalPeriod, dtDate, iDayOfOperationalPeriod
from tblDate
where iYear in (2020, 2021)
and iDayOfOperationalPeriod in (1,28)
order by dtDate


select * from tblCallCenterUser




-- Payroll ID's match but Dept# does not
select E.ixEmployee 'SOPEmp',
    B.sPayrollId 'BMBPayrollId', 
    E.sPayrollId 'SOPPayrollId',
    B.sFirstname 'BMBFirstName',
    E.sFirstname 'SOPFirstName',
    B.sLastname 'BMBLastName',
    E.sLastname 'SOPLastName', 
    B.sEmailAddress 'BMBEmail', 
    E.sEmailAddress 'SOPEmail', 
    B.ixDepartment 'BMBDept#', 
    E.ixDepartment 'SOPDept#', 

    B.Department 'BMBDeptDescription', 

    B.EmploymentStatus 'BMBEmploymentStatus', 
    B.OvertimeStatus 'BMBOvertimeStatus', 
    E.flgCurrentEmployee 'SOPCurrentEmployee',
    E.flgExempt 'SOPExempt',
    E.flgPartTime 'SOPPartTime',
    E.flgPayroll 'SOPPayroll',
    -- the following weren't provided by Bamboo
    FORMAT(E.dtHireDate, 'MM/dd/yyyy') 'SOPHireDate',
    FORMAT(E.dtTerminationDate, 'MM/dd/yyyy') 'SOPTermDate',
    -- the following don't exist in SMI Reporting
    B.Division 'BMBDivision', 
    B.ReportingTo 'BMBReportingTo', 
    B.JobTitle 'BMBJobTitle', 
    B.ixLocation 'BMBLocNum', 
    B.[Location] 'BMBLocation'
from [SMITemp].dbo.PJC_EmpBambooData_20210628 B
    join tblEmployee E on B.sPayrollId = E.sPayrollId -- exact match on payrollID
where E.flgDeletedFromSOP is NULL
    or E.flgDeletedFromSOP = 0
    and (B.ixDepartment <> E.ixDepartment
         OR E.ixDepartment is NULL)


-- Payroll ID's match but Dept# does not
select E.ixEmployee 'SOPEmp',
    B.sPayrollId 'BMBPayrollId', 
    E.sPayrollId 'SOPPayrollId',
    B.sFirstname 'BMBFirstName',
    E.sFirstname 'SOPFirstName',
    B.sLastname 'BMBLastName',
    E.sLastname 'SOPLastName', 
    B.sEmailAddress 'BMBEmail', 
    E.sEmailAddress 'SOPEmail', 
    B.ixDepartment 'BMBDept#', 
    E.ixDepartment 'SOPDept#', 

    B.Department 'BMBDeptDescription', 

    B.EmploymentStatus 'BMBEmploymentStatus', 
    B.OvertimeStatus 'BMBOvertimeStatus', 
    E.flgCurrentEmployee 'SOPCurrentEmployee',
    E.flgExempt 'SOPExempt',
    E.flgPartTime 'SOPPartTime',
    E.flgPayroll 'SOPPayroll',
    -- the following weren't provided by Bamboo
    FORMAT(E.dtHireDate, 'MM/dd/yyyy') 'SOPHireDate',
    FORMAT(E.dtTerminationDate, 'MM/dd/yyyy') 'SOPTermDate',
    -- the following don't exist in SMI Reporting
    B.Division 'BMBDivision', 
    B.ReportingTo 'BMBReportingTo', 
    B.JobTitle 'BMBJobTitle', 
    B.ixLocation 'BMBLocNum', 
    B.[Location] 'BMBLocation'
from [SMITemp].dbo.PJC_EmpBambooData_20210628 B
    join tblEmployee E on B.sPayrollId = E.sPayrollId -- exact match on payrollID
where E.flgDeletedFromSOP is NULL
    or E.flgDeletedFromSOP = 0
  --  and B.ixDepartment <> E.ixDepartment
        and (UPPER (B.sEmailAddress) <> UPPER(E.sEmailAddress))



    select * from tblEmployee
    where flgDeletedFromSOP = 0
    and flgCurrentEmployee = 1
    and len(ixEmployee) = 3
    Order by newID()
/*

CRM ID	Firstname	Lastname
======  =========   =========
KMS1	KARA	    SHEIL
LMC	    LAURA	    CLERC
TAH	    TIM	        HENDRICKS
RJF1	RYLAN	    FOGERTY



*/

select distinct ED.sShortName
from tblEmployeeDirectory ED
order by sShortName -- 791 unique values

select distinct ED.sShortName, E.ixEmployee
from tblEmployeeDirectory ED
    left join tblEmployee E on ED.sShortName = E.ixEmployee
order by sShortName -- 791 unique values

select distinct ED.sShortName --, E.ixEmployee
from tblEmployeeDirectory ED
where ED.sShortName
NOT IN (select ixEmployee from tblEmployee)

select distinct ixEmployee  --, E.ixEmployee
from  tblEmployee
where ixEmployee IN
 (select sShortName from tblEmployeeDirectory )

 SELECT * FROM tblEmployeeDirectory




 SELECT * FROM tblCallCenterUser

 SELECT ED.sShortName, CCU.iTeam, ED.flgActive, E.sFirstname, E.sLastname
 FROM tblEmployeeDirectory ED
    left join tblCallCenterUser CCU on ED.ixEmployeeDirectoryID = CCU.ixEmployeeDirectoryID
    left join tblEmployee E on ED.sShortName = E.ixEmployee
 WHERE CCU.iTeam between 1 and 7
    AND ED.flgActive = 1 -- exclude if you need data from former team members included
  ORDER BY CCU.iTeam

 SELECT * FROM tblCallCenterUser
ixCallCenterUser	ixEmployeeDirectoryID	iTeam
256	3570	7
257	2740	3
258	2164	2

 SELECT ED.sShortName, CCU.iTeam, ED.flgActive, E.sFirstname, E.sLastname
 FROM tblEmployeeDirectory ED
    left join tblCallCenterUser CCU on ED.ixEmployeeDirectoryID = CCU.ixEmployeeDirectoryID
    left join tblEmployee E on ED.sShortName = E.ixEmployee
 WHERE CCU.iTeam between 1 and 7
    AND ED.flgActive = 1 -- exclude if you need data from former team members included
  ORDER BY ED.sShortName

  select * from tblEmployeeDirectory
  where sLastName = 'Behrens'


 SELECT *
 FROM tblEmployeeDirectory ED -- 813 users 
 WHERE sShortName is NULL -- 23 are missing sShortName

   SELECT *
 FROM tblEmployeeDirectory ED
 order by sFirstName





