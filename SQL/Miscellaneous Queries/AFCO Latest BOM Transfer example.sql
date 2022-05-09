-- AFCO Latest BOM Transfer example

SELECT BTM.ixTransferNumber, BTM.ixFinishedSKU
    --, BTD.iQuantity, 
    , BTM.iCompletedQuantity, BTM.iOpenQuantity
    , CONVERT(VARCHAR,D1.dtDate, 1) AS  'CreateDate'
    , CONVERT(VARCHAR,D2.dtDate, 1) AS  'ExpectedDate'
FROM --tblBOMTransferDetail BTD
    tblBOMTransferMaster BTM --on BTD.ixTransferNumber = BTM.ixTransferNumber
    join tblDate D1 on D1.ixDate = BTM.ixCreateDate
    join tblDate D2 on D2.ixDate = BTM.ixDueDate
where BTM.ixFinishedSKU = '0000050'
    and BTM.flgClosed = 0
    and BTM.dtCanceledDate is NULL
    and BTM.ixCreateDate >= 18264 -- 1/1/18
ORDER BY BTM.ixFinishedSKU, D2.dtDate




select * from tblVendorSKU where ixSKU = 'A550010072XU'

select * from tblVendorSKU where ixSKU = '0000050'

1206
0006

SELECT * FROM tblVendor where ixVendor in ('0006','1206')

