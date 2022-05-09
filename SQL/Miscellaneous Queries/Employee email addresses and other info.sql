-- Employee email addresses and other info

-- 

SELECT ixEmployee, sFirstname, sLastname, sEmailAddress, ixDepartment, 
    flgCurrentEmployee, flgExempt, flgPartTime, flgPayroll, 
    dtHireDate, dtTerminationDate
FROM tblEmployee 
WHERE
 flgCurrentEmployee =1
 and sLastname = 'MUTH'




