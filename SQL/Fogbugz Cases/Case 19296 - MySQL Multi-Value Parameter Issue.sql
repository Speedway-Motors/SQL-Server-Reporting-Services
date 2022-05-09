-- Case 19296 - MySQL multi-value parameter issue 
SELECT PL.ixSOPProductLine 
     , PL.sTitle
FROM tblproductline PL 
LEFT JOIN tblbrand B ON B.ixBrand = PL.ixBrand 
WHERE B.ixSOPBrand IN ('10015') --(@ixSOPBrand) 


select count(*) from tblCustomer 
where flgDeletedFromSOP  = 0    -- 759,954 ALL                      
and sEmailAddress is NOT NULL    -- 87,402 1/1/13 - 11/22/13
and dtAccountCreateDate >= '01/01/2013' 
go

select count(distinct sEmailAddress) from tblCustomer where flgDeletedFromSOP  = 0 -- 734,817   -- 86,533
and sEmailAddress is NOT NULL
and dtAccountCreateDate >= '01/01/2013'


select distinct(ixCustomer)
from tblCustomer
where flgDeletedFromSOP  = 0 
and sEmailAddress EXISTS (

select sEmailAddress, count(ixCustomer)
                 from tblCustomer
                        where flgDeletedFromSOP  = 0
                        and sEmailAddress is NOT NULL
                        group by sEmailAddress
                        having count(ixCustomer) > 1)
