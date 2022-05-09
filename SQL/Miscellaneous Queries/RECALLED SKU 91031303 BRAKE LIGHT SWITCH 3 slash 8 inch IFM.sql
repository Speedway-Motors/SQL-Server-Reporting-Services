-- RECALLED SKU 91031303 BRAKE LIGHT SWITCH 3/8 IFM
/*

     REPLACED WITH SKU 91031304 BRAKE LIGHT SWITCH W/ADPTR

-- all replacement orders will go out in a 1-2 period around 5-12-14
-- SourceCode = CUST-SERVE 
-- mMerchandise = 0
-- Order Channel = 'INTERNAL'


SELECT * FROM tblSKU where ixSKU = '91031304'

select * from tblOrder where sOrderStatus = 'Recall'

select * from tblOrderLine where ixSKU = '91031304'
and dtOrderDate >= '05/12/14'


SELECT * from tblOrder
where dtOrderDate >= '05/12/14'

se


