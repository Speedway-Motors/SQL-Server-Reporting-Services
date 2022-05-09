-- employee data - clean up tblEmployee

-- current fulltime employees at SMI
select * from tblEmployee  -- 465 @10/28/2020
where flgCurrentEmployee = 1
    and flgDeletedFromSOP = 0
    and ixDepartment NOT IN (8,9,10,39,45,47) 
    and ixDepartment NOT IN (41,42,43,61,65) -- AZ depts   
    and flgPartTime = 0   
`
    --and (UPPER(sFirstname) like '%TEST%'       or UPPER(sLastname) like '%TEST%')
    --and (sPayrollId is NULL or sEmailAddress is NULL)
order by sFirstname, sLastname



select * from tblDepartment
where ixDepartment in (44,61,65,98)

select * from tblDepartment
where sDescription like '%AZ%'

-- NULL payrold IDs by department
select E.ixDepartment, D.sDescription,  count(ixEmployee) 'Employees'
from tblEmployee E
left join tblDepartment D on E.ixDepartment = D.ixDepartment
where flgCurrentEmployee = 1
    and flgDeletedFromSOP = 0
    and E.ixDepartment NOT IN (8,9,10,39,45,47) 
    and E.ixDepartment NOT IN (41,42,43,61,65) -- AZ depts
    and E.sPayrollId is NULL
group by D.sDescription, E.ixDepartment
order by D.sDescription --count(ixEmployee) desc

-- NO EMAIL address
select * from tblEmployee -- 71
where flgCurrentEmployee = 1
    and flgDeletedFromSOP = 0
    and ixDepartment NOT IN (0,8,9,10,39,45,47) 
    --and ixDepartment NOT IN (41,42,43,61,65) -- AZ depts
    and ixEmployee NOT IN ('PSG','TAE1','TFE','WEBFEEDS','FML1','JTMT','NAT','SSU','WSS','DWS','jds') -- PSG, FEEDS, TEST accounts, etc
    and (sEmailAddress is NULL or sPayrollId is NULL)
order by sLastname

-- NO Payroll ID
select * from tblEmployee -- 58
where flgCurrentEmployee = 1
    and flgDeletedFromSOP = 0
    and ixDepartment NOT IN (0,8,9,10,39,45,47) 
    --and ixDepartment NOT IN (41,42,43,61,65) -- AZ depts
    and ixEmployee NOT IN ('PSG','TAE1','TFE','WEBFEEDS','FML1','JTMT','NAT','SSU','WSS','DWS','jds') -- PSG, FEEDS, TEST accounts, etc
    and sPayrollId is NULL
order by ixCustomer

SELECT * FROM tblCustomer where ixCustomer = '2457298'

select * from tblEmployee
where ixDepartment = 98


select sEmailAddress, count(*)
from tblEmployee -- 529
where flgCurrentEmployee = 1
    and flgDeletedFromSOP = 0
    and ixDepartment NOT IN (0,8,9,10,39,45,47) 
    and ixDepartment NOT IN (41,42,43,61,65) -- AZ depts
group by sEmailAddress
having count(*) > 1

select ixEmployee,	sFirstname,	sLastname,	sEmailAddress,	dtDateLastSOPUpdate
from tblEmployee
where sEmailAddress in ('AAKLANN@SPEEDWAYMOTORS.COM','KLHEBLE@SPEEDWAYMOTORS.COM')
and flgDeletedFromSOP = 0
and flgCurrentEmployee = 1
order by sEmailAddress


select * from tblEmployee 
where dtDateLastSOPUpdate = '10/28/2020'







select * from tblEmployee -- 535
where flgDeletedFromSOP = 0
and dtDateLastSOPUpdate < '10/27/20'
ORDER by dtDateLastSOPUpdate

select * from tblEmployee
where flgCurrentEmployee = 1
and sLastname in ('BRANSCOMBE')
order by sLastname

select * from tblEmployee
where flgCurrentEmployee = 1
    and flgDeletedFromSOP = 0
--and sLastname in ('LESSLEY','VOLKMER','KOEN','ARIZOLA')
--and ixDepartment in (47) --(8,9,10,39,45,47)
--and ixEmployee in ('TAE1','TFE','FML1','JTMT','NAT')
and sFirstname in ('WHITNEY')
-- and sPayrollId in ('4053')
order by ixDepartment

select * from tblDepartment where ixDepartment = 10



select sFirstname, sLastname, count(ixEmployee)
from tblEmployee
where flgCurrentEmployee = 1
    and flgDeletedFromSOP = 0
group by sFirstname, sLastname
having count(ixEmployee) > 1
order by sFirstname

-- Terminated AFCO Employees that still have an SMI active employee record
SELECT SMI.*, AFCO.* -- 24
FROM tblEmployee SMI
    join [AFCOReporting].dbo.tblEmployee AFCO on SMI.sFirstname = AFCO.sFirstname COLLATE SQL_Latin1_General_CP1_CI_AS
                                                and SMI.sLastname = AFCO.sLastname COLLATE SQL_Latin1_General_CP1_CI_AS
where SMI.flgCurrentEmployee = 1
    and SMI.flgDeletedFromSOP = 0
    AND SMI.ixDepartment = 47
    AND AFCO.flgCurrentEmployee = 0
    AND AFCO.flgDeletedFromSOP = 0
    AND AFCO.dtTerminationDate IS NOT NULL
order by SMI.ixEmployee



BEGIN TRAN

    UPDATE tblEmployee
        SET flgCurrentEmployee = 0
    WHERE flgCurrentEmployee = 1
    AND flgDeletedFromSOP = 1

ROLLBACK TRAN



