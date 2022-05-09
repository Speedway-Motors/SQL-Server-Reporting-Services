-- Case 24817 - SKU list for vendor 0674

SELECT S.ixSKU SMI_SKU,-- VS.iOrdinality 
VS.ixSKU VendorSKU, S.sDescription 'Description', S.dtCreateDate 'Created'
FROM tblSKU S
    join tblVendorSKU VS on S.ixSKU = VS.ixSKU
    join tblSKULocation SL on S.ixSKU = SL.ixSKU and SL.ixLocation = 99
where S.ixCreator = 'NJS'
    and VS.ixVendor = '0674'
   and VS.iOrdinality = 2
    and S.dtCreateDate >= '12/01/2014'
    and SL.iQOS > 0
order by S.ixSKU

