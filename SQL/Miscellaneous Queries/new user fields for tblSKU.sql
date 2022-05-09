-- new user fields for tblSKU
select ixSKU, ixCreator, ixBuyer, ixProposer, ixMerchant, ixAnalyst
from tblSKU
where flgDeletedFromSOP = 0 
    and dtCreateDate >= '02/20/2018'
    AND (
        ixBuyer is NOT NULL
        OR
        ixProposer is NOT NULL
        OR
        ixMerchant is NOT NULL
        OR
        ixAnalyst is NOT NULL
        )


                     











