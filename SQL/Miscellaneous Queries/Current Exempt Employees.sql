-- Current Exempt Employees
select * from tblEmployee
where flgCurrentEmployee = 1
    and ixEmployee NOT LIKE '5%'
    and ixEmployee NOT LIKE '%47'
    and ixDepartment <> 47
    and ixEmployee NOT IN ('SSU','TAE1','TFE','WEBFEEDS','WSS') -- 382
    and flgExempt = 1   -- 90
order by ixDepartment -- ixDepartment -- sLastname -- LEN(sFirstname)
-- order by ixEmployee