-- refreshing Kit SKUs

select DISTINCT K.ixKitSKU, S.dtDateLastSOPUpdate, S.ixTimeLastSOPUpdate,  S.flgDeletedFromSOP
from tblKit K
    join tblSKU S on K.ixKitSKU = S.ixSKU
where S.dtDateLastSOPUpdate < '12/06/2017' 
    --and S.ixTimeLastSOPUpdate < 40500   -- 2,714
order by K.ixKitSKU
    -- S.dtDateLastSOPUpdate
    -- S.flgDeletedFromSOP desc, 


BEGIN TRAN
    -- DELETE FROM tblKit where ixKitSKU in ('91034911.GS','91034911.GS','91770501-17','91770501-17','946-1-1','946-1-1','96621284','96621284','80298345-60-4 3/4','80298345-60-4 3/4','80298345-60-4 3/4')
ROLLBACK TRAN

