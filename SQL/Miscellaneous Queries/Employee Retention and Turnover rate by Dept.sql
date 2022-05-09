-- Employee Retention and Turnover rate by Dept
SELECT Dept, DeptName, 
    Format(COUNT(ixEmployee),'###,###') TermedEmpCnt, 
    Format(AVG(DaysEmployed),'###,###') 'AvgDaysEmployed'
FROM (
        SELECT ixEmployee,sLastname,sFirstname, sEmailAddress, 
            CONVERT(VARCHAR, dtHireDate, 101) AS 'HireDate', CONVERT(VARCHAR, dtTerminationDate, 101) AS 'TermDate', 
            E.ixDepartment 'Dept',
            D.sDescription 'DeptName',
            DATEDIFF(DAY,dtHireDate,dtTerminationDate) 'DaysEmployed'
        from [SMI Reporting].dbo.tblEmployee E
            left join tblDepartment D on D.ixDepartment = E.ixDepartment
            -- [AFCOReporting].dbo.tblEmployee
        where flgCurrentEmployee = 0 
        and sFirstname <> ''
        and sLastname <> ''
        and dtTerminationDate <> dtHireDate
        and dtTerminationDate > '07/28/2020'
        and flgDeletedFromSOP = 0
        and ixEmployee NOT LIKE '%47'
        and ixEmployee NOT IN ('PSG','TAE1','TFE','WEBFEEDS','FML1','JTMT','NAT','SSU','WSS','DWS','jds') -- PSG, FEEDS, TEST accounts, etc
        and E.ixDepartment NOT IN (8,9,10,39,45,47) 
        and E.ixDepartment NOT IN (41,42,43,61,65) -- AZ depts   
        and sPayrollId is NOT NULL    
        -- order by Dept, DaysEmployed
        ) X
GROUP BY Dept, DeptName
-- HAVING COUNT(ixEmployee) > 3
ORDER BY Dept


SELECT Dept, DeptName, 
    Format(COUNT(ixEmployee),'###,###') 'EmpCnt', 
    Format(AVG(DaysEmployed),'###,###') 'AvgDaysEmployed'
FROM (
    SELECT ixEmployee,sLastname,sFirstname, sEmailAddress, 
        CONVERT(VARCHAR, dtHireDate, 101) AS 'HireDate', -- CONVERT(VARCHAR, dtTerminationDate, 101) AS 'TermDate', 
        E.ixDepartment 'Dept',
        D.sDescription 'DeptName',
        DATEDIFF(DAY,dtHireDate,GETDATE()) 'DaysEmployed'
    from [SMI Reporting].dbo.tblEmployee E
        left join tblDepartment D on D.ixDepartment = E.ixDepartment
        -- [AFCOReporting].dbo.tblEmployee
    where flgCurrentEmployee = 1 
        and sFirstname <> ''
        and sLastname <> ''
        --and dtTerminationDate <> dtHireDate
        and dtTerminationDate is NULL
        and flgDeletedFromSOP = 0
        and ixEmployee NOT LIKE '%47'
        and ixEmployee NOT IN ('PSG','TAE1','TFE','WEBFEEDS','FML1','JTMT','NAT','SSU','WSS','DWS','jds') -- PSG, FEEDS, TEST accounts, etc
        and E.ixDepartment NOT IN (8,9,10,39,45,47) 
        and E.ixDepartment NOT IN (41,42,43,61,65) -- AZ depts   
        and sPayrollId is NOT NULL
        -- order by Dept, DaysEmployed
    ) X
GROUP BY Dept, DeptName
HAVING COUNT(ixEmployee) > 3
ORDER BY Dept



    SELECT ixEmployee,sLastname,sFirstname, sEmailAddress, 
        CONVERT(VARCHAR, dtHireDate, 101) AS 'HireDate', -- CONVERT(VARCHAR, dtTerminationDate, 101) AS 'TermDate', 
        ixDepartment 'Dept',
        DATEDIFF(YEAR,dtHireDate,GETDATE()) 'YearsEmployed'
    from [SMI Reporting].dbo.tblEmployee
        -- [AFCOReporting].dbo.tblEmployee
    where flgCurrentEmployee = 1 
    and sFirstname <> ''
    and sLastname <> ''
    --and dtTerminationDate <> dtHireDate
    and dtTerminationDate is NULL
    and flgDeletedFromSOP = 0
    and ixEmployee NOT LIKE '%47'
    and ixEmployee NOT IN ('PSG','TAE1','TFE','WEBFEEDS','FML1','JTMT','NAT','SSU','WSS','DWS','jds') -- PSG, FEEDS, TEST accounts, etc
    and ixDepartment NOT IN (8,9,10,39,45,47) 
    and ixDepartment NOT IN (41,42,43,61,65) -- AZ depts   
    and sPayrollId is NOT NULL
    ORDER BY DATEDIFF(YEAR,dtHireDate,GETDATE()) desc