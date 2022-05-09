-- SMIHD-16451 - Prop 65 E SKUs with Inventory
SELECT S.ixSKU 'SKU', 
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription', 
    SL.ixLocation, SL.iQAV, SL.iQOS,
    V.ixVendor 'PVNum',
    V.sName 'PrimaryVendor',
    S.sSEMACategory 'Category',
    S.sSEMASubCategory 'Sub-Category',
    S.sSEMAPart 'Part',
    S.dtDiscontinuedDate 'Discontinued',
    S.flgActive,
    PLC.sProductLifeCycleCode 'ProductLifeCycle'
    --, S.dtDateLastSOPUpdate
FROM tblSKU S
    left join tblSKULocation SL on S.ixSKU = SL.ixSKU --and SL.ixLocation = 99
    left join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on VS.ixVendor = V.ixVendor
    left join tblProductLifeCycle PLC on S.ixProductLifeCycleCode = PLC.ixProductLifeCycleCode
where S.flgDeletedFromSOP = 0
    and S.flgIntangible = 0
    and S.flgProp65 = 2
    and (SL.iQAV <> 0 or SL.iQOS > 0)
ORDER BY S.ixSKU, SL.ixLocation