-- SMIHD-25025 - Clean up Keri Door DB for terminated employees

SELECT ixEmployee, sLastname, sFirstname, ixDepartment, sEmailAddress, dtTerminationDate
from tblEmployee
where dtTerminationDate >= '1/1/2022'
order by dtTerminationDate desc

