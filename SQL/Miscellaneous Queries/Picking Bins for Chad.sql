-- Picking Bins for Chad
select ixSKU, sPickingBin, iQAV 
from tblSKULocation 
where iQAV > 0
    and sPickingBin like '3A%A1'
    and ixLocation = 99



select ixSKU, sPickingBin, iQAV
from tblSKULocation 
where iQAV > 0
    and sPickingBin like '3B%A1'
    and ixLocation = 99




select ixSKU, sPickingBin, iQAV
from tblSKULocation 
where iQAV > 0
    and sPickingBin like '3C%A1'
    and ixLocation = 99
