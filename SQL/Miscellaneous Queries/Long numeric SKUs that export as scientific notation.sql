-- long numeric SKUs that export as scientific notation 
select ixSKU, dtCreateDate from tblSKU
where flgDeletedFromSOP = 0
    and (ISNUMERIC(ixSKU) = 1
            and len(ixSKU) >= 17 -- length of 12 or more export as scientific notation
            and ixSKU NOT LIKE '%.%'
            and ixSKU between '33001752506001300' and '37631177290005043' -- 7 long example SKUs
    )
    OR ixSKU in ('81706','HB8FHCSC-10-24-3.63','UP90163')
order by ixSKU desc


select top 10 * from tblSKU
where flgDeletedFromSOP = 0

order by newID()


select ixSKU, dtCreateDate 
from tblSKU
where flgDeletedFromSOP = 0
    and ISNUMERIC(ixSKU) = 0
            and len(ixSKU) between 18 and 21 -->= 22
order by dtCreateDate desc


select ixSKU, dtCreateDate 
from tblSKU
where flgDeletedFromSOP = 0
    and ISNUMERIC(ixSKU) = 1
            and len(ixSKU) >= 17 -- length of 12 or more export as scientific notation
            and ixSKU NOT LIKE '%.%'
order by ixSKU desc


select ixSKU, dtCreateDate 
from tblSKU
where flgDeletedFromSOP = 0
    and ISNUMERIC(ixSKU) = 1
            and len(ixSKU) < 6 -- length of 12 or more export as scientific notation
            and ixSKU NOT LIKE '%.%'
order by dtCreateDate desc



