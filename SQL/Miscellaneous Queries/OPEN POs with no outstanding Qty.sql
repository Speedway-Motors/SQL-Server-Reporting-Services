-- OPEN POs with no outstanding Qty

select distinct POM.*  -- 1,229 open POs
    --POD.ixPO, ix
from tblPOMaster POM
    join tblPODetail POD on POM.ixPO = POD.ixPO
where POM.flgOpen = 1
and POM.flgIssued = 1
--and POM.ixPO =  '113046'
--and POD.iQuantityReceivedPending <> 0
--and POD.iQuantityPosted < POD.iQuantity
and POM.ixPO NOT in (-- PO still has outstanding QTY
                SELECT distinct ixPO
                 from tblPODetail 
                 where (iQuantity - iQuantityPosted) > 0
                -- order by ixPO
             )


select ixPO SUMfrom tblPODetail
where iQuantityReceivedPending = 0

select * from tblPOMaster where ixPO = '113046'
select *, (iQuantity - iQuantityPosted) OpenQty from tblPODetail where ixPO = '113046'

