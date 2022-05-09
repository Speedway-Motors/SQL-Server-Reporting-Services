select count(*) 
from tblSKU
where flgDeletedFromSOP = 0             
and dtDateLastSOPUpdate < '11/26/2013' -- 31,549 @12:00PM
                                       --  9,475 @12:45PM
                                          
select ixSKU
from tblSKU
where flgDeletedFromSOP = 0             
and dtDateLastSOPUpdate < '11/26/2013' -- 47,285


45,381 @clock start
41,431
======
 3,950
 
 
 select * from tblSKULocation where ixSKU = '910555'
 
 
select * from tblSKU where ixSKU = '41811016.1' 


select ixSKU
from tblSKU
where flgDeletedFromSOP = 0             
and dtDateLastSOPUpdate < '11/26/2013' -- 31,549 @12:00PM
                                       --  9,475 @12:45PM