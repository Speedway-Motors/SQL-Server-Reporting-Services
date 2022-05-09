-- SMIHD-17456 - SKUs without Merchant Assignment

SELECT S.ixSKU 'SKU',
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    S.ixPGC 'PGC',
    VS.ixVendor 'PVNum',
    V.sName 'PVName',
    S.mPriceLevel1 'RetailPrice',
    S.ixCreator 'CreatedBy',
    S.dtCreateDate 'CreateDate',
    S.dtDiscontinuedDate 'DiscontinuedDate',
    SL.iQOS 'QOS',
    SL.iQAV 'QAV',
    PLC.sProductLifeCycleCode
FROM tblSKU S
    left join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on VS.ixVendor = V.ixVendor
    left join tblSKULocation SL on SL.ixSKU = S.ixSKU and SL.ixLocation = 99
    left join tblProductLifeCycle PLC on PLC.ixProductLifeCycleCode = S.ixProductLifeCycleCode
WHERE flgDeletedFromSOP = 0
    and ixMerchant is NULL
order by S.ixSKU


/*
SKU
SOP Description
Product Group Code
Vendor Number
Vendor Name
Retail Price
Creator Initials
Item Create Date
*/


