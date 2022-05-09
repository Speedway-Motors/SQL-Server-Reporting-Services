-- SMIHD-15842 - Bin Inventory

select top 1000 * from tblBinSku
where ixBin = 'AZIT' --in ('RCV','AZIT','AZIT','AZSTG-U','AZSTG-T','AZSTG-1','AZSTG-2','AZSTG-D')
    and ixLocation = 85
order by ixSKU


select count(distinct ixSKU)
from tblBinSku BS

where ixBin = 'AZIT' --in ('RCV','AZIT','AZIT','AZSTG-U','AZSTG-T','AZSTG-1','AZSTG-2','AZSTG-D')
    and ixLocation = 85
    and iSKUQuantity > 0



-- Bin Inventory.rdl
-- ver 19.47.1
/* */
DECLARE @Location tinyint,   @Bin varchar(25)
SELECT @Location = 85,        @Bin = 'AZIT'    

SELECT ixBin 'Bin', 
    BS.ixLocation 'LOC', 
    SL.ixSKU 'SKU', 
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    iSKUQuantity 'SKUQty', 
    SL.iQAV 'QAV',
    SL.sPickingBin 'PickBin' ,
    SL.iPickingBinMin 'PickBinMIN',
    SL.iPickingBinMax 'PickBinMAX',
    SL.iCartonQuantity 'PickBinRestockUnit'
FROM tblBinSku BS
        LEFT JOIN tblSKU S ON S.ixSKU = BS.ixSKU
        LEFT JOIN tblSKULocation SL ON SL.ixSKU = BS.ixSKU 
                                        AND SL.ixLocation = @Location -- 85
WHERE ixBin = 'AZIT' -- @Bin  <-- Truck 11?     ('RCV','AZIT','AZIT','AZSTG-U','AZSTG-T','AZSTG-1','AZSTG-2','AZSTG-D')
    and BS.ixLocation = @Location -- 85
    and BS.iSKUQuantity > 0






    SKU/QTY/DESCRIP/CID??

select top 10 * from tblSKULocation