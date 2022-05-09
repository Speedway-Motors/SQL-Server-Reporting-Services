-- Case 19864 - Timeclock Exceptions report

/* NOTES:

tblTimeClock now will be populated with 0 if there is a missing clock in/out time in SOP 
that's preventing the calculation (seconds worked) from completing.
We'll then display the data on the exceptions report so that Deb can review it.

DEB needs exempt employees excluded
exclude all ixEmployees ending in 47
exclude CTR & WEB 

*/

-- Employees with a clock-in/clock-out identical time or missing a clock-out time
select TC.dtDate, TC.ixEmployee, E.sPayrollId, TC.ixTime,  TC.sComment
from tblTimeClock TC
    left join tblEmployee E on TC.ixEmployee = E.ixEmployee
where TC.ixTime = 0
and TC.ixDate = 16866 --16803
and TC.ixEmployee NOT like '%47'
and TC.ixEmployee NOT in ('CTR','WEB') -- accounts for non-humans
and (E.flgExempt is NULL
    OR E.flgExempt = 0)

-- checking for detail records from above query
select * from tblTimeClockDetail
where ixDate = 16866 --16803
and ixEmployee NOT like '%47'
and ixEmployee IN ('CWA','DMH','IDA','JLM2','JXO','KKY','LDD','LEB','SAH','TLR','TRM1')

-- CAROL IS WORKING ON CHANGING SOP TO ALLOW THE NULL VALUES INTO tblTimeClockDetail 

    
    



