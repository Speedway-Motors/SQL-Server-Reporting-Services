
-- drop table PJC_CurrentEmployee 
select * 
into PJC_CurrentEmployee
from tblEmployee where flgCurrentEmployee = 1


select * from tblEmployee
order by sPayrollId

ixEmployee	sLastname	sFirstname	sPhone	iExtension	ixDepartment	sPayrollId	flgCurrentEmployee
JMM	MOSS	JOHN	402.323.3265	3265	1	1034	1


select * from PJC_CurrentEmployee -- 304
select * from PJC_EmployeeHR -- 266 Employees from HR


ALTER TABLE PJC_CurrentEmployee ALTER COLUMN ixEmployee 
            varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 



select * from PJC_EmployeeHR
where ixEmployee not in (select ixEmployee from PJC_CurrentEmployee)
/*
ixEmployee	sPayrollId	sName
SLC	        1041	    Clifton, Stephen
GWN	        1071	    Nacke, Gerald
TLM	        2440	    Meyer, Tom
MLL	        2472	    Long, Marvin
PWD	        2582	    Orth, Patrick
JRM	        2778	    Hutchison, Jerry
MST	        2812	    Tavlin, Marvona
TFW	        2856	    Wesely, Tyler             <-- file from HR showed a blank space before TFW
TDN	        2915	    Nieveen, Trevor
CDW	        2996	    Wilcox, Charles
RCO	        3019	    Oliver, Robert  C.
*/


select ixEmployee, sLastname, sFirstname,ixDepartment,sPayrollId, flgCurrentEmployee from PJC_CurrentEmployee 
where ixEmployee not in (select ixEmployee from PJC_EmployeeHR)
order by ixEmployee



select ixEmployee, sLastname, sFirstname,ixDepartment,sPayrollId, flgCurrentEmployee
from PJC_EmployeeHR
order by ixEmployee


delete from tblEmployee
where sLastname = 'Heaven'



