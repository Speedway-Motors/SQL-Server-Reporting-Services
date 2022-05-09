-- Bulk upload of Prospects for SC 338801B

/*
select ixCustomer, dtDateLastSOPUpdate--, T.chTime
from tblCustomer
where ixSourceCode = '338801B'
    and flgDeletedFromSOP = 1
order by dtDateLastSOPUpdate desc
*/


select count (ixCustomer)-- 3,886 @8-5-13 10:50AM  -- all were succesfully refed
from tblCustomer         -- 4,181 @8-6-13 6:01PM
where ixSourceCode = '338801B'
    and flgDeletedFromSOP = 0
    and dtDateLastSOPUpdate >= '08/05/2013'
    
-- merged
select ixCustomer, dtDateLastSOPUpdate-- 5 @8-5-13 11:20AM
from tblCustomer
where ixSourceCode = '338801B'
    and flgDeletedFromSOP = 1
