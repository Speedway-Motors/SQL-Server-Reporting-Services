select distinct
    PO.ixPO              AFCOPO,
VS.sVendorSKU       SMISKU,
    PO.ixSKU            AFCOSKU,
isnull(SKU.sDescription,'* '+AFCOSKU.sDescription)     SKUDescription,
    PO.QTYOrd,
    PO.QTYRec,
    PO.Excess,
(PO.Excess * isnull(SKU.mAverageCost,AFCOSKU.mAverageCost)) CostLostInv,
VS.iOrdinality
from
    (select 
           POM.ixVendor,
           POM.ixPO,
           POD.ixSKU, 
           isnull(POD.iQuantity,0)                          QTYOrd, 
           POD.iQuantityPosted                              QTYRec,
           (POD.iQuantityPosted-isnull(POD.iQuantity,0))    Excess
        from tblPODetail POD
             join tblPOMaster POM on POM.ixPO = POD.ixPO
             join tblDate D on D.ixDate = POD.ixFirstReceivedDate
                       and D.dtDate >= '01/01/10'
                       and D.dtDate < '11/01/10'
        where POD.iQuantityPosted > isnull(POD.iQuantity,0)
          and POM.ixVendor = '5302'-- SPEEDWAY MOTORS, INC
        ) PO -- on PO.ixPO = R.ixPO
    --join tblVendor V on V.ixVendor = PO.ixVendor 
    join tblVendorSKU VS on VS.ixSKU = PO.ixSKU 
    left join [SMI Reporting].dbo.tblSKU SKU on SKU.ixSKU = VS.sVendorSKU
    left join tblSKU AFCOSKU on AFCOSKU.ixSKU = VS.ixSKU
where VS.ixVendor = '5302'
order by  PO.ixPO,PO.ixSKU 





/*

select * from tblInventoryReceipt
--select * from tblVendorSKU where ixVendor = '5302' and iOrdinality <> 1

--select * from tblVendorSKU where ixSKU = '36186'

--select * from tblPOMaster
--select * from tblPODetail

select * from tblPOMaster
where ixPO in ('6614','6949','6963','7136','7498','8034','8045','8307','9372','9374','9495')

select ixPO,iQuantity,iQuantityPosted
from tblPODetail
where ixPO in ('6614','6949','6963','7136','7498','8034','8045','8307','9372','9374','9495')
and iQuantityPosted > iQuantity 

*/