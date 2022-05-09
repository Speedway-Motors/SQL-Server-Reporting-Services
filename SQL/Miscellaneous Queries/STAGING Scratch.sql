/******************************/


update tblSKU
set flgDeletedFromSOP = 1
where ixSKU in (
'7151331.P1',
'7151331.P')


-- to Delete a SKU from tblSKU, it must first be deleted from tblVendorSKU,tblSKULocation,tblInventoryForecast,tblBinSku

select * from tblSKU
where ixSKU = '311PART'

DELETE from tblSKU
where ixSKU = '311PART'

select * from tblVendorSKU
where ixSKU = '311PART'

DELETE from tblVendorSKU
where ixSKU = '311PART'

select * from tblSKULocation
where ixSKU = '311PART'

DELETE from tblSKULocation
where ixSKU = '311PART'

select * from tblInventoryForecast
where ixSKU = '311PART'

DELETE from tblInventoryForecast
where ixSKU = '311PART'

select * from tblBinSku
where ixSKU = '311PART'

DELETE from tblBinSku
where ixSKU = '311PART'

/******************************/









/******************************/





/******************************/





/******************************/






/******************************/






/******************************/






/******************************/






/******************************/





/******************************/






/******************************/





/******************************/






/******************************/






/******************************/





/******************************/
