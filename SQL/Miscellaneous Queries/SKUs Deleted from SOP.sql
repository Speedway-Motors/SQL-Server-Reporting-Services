select distinct SKU.flgDeletedFromSOP, SSKU.ixSKU
from tblSnapshotSKU SSKU
    join tblSKU SKU on SSKU.ixSKU = SKU.ixSKU
where SKU.flgDeletedFromSOP = 0
    and SSKU.ixDate >= 18444 -- 6 month's ago 
    and SSKU.ixSKU not in (select ixSKU from tblSnapshotSKU
                       where ixDate = 18474) -- today
/*
0	91662065
0	91662066
0	9106288-BLACK
*/     

SELECT * from tblSKU where ixSKU in ('6051550','91060793','9106288')
                     
--
91662066
91662065
9106288-BLACK


select ixSKU, dtDateLastSOPUpdate
from tblSKU order by dtDateLastSOPUpdate


425350020ERL
91082156
