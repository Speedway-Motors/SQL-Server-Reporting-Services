select  -- 1588 all vendors
    'Attn: CFO' Attn,
    V.ixVendor VendorNumber,
    replace(sName,',',' ')      Vendor,
    replace(sAddress1,',',' ')  Address1,
    replace(sAddress2,',',' ')  Address2,
    replace(sCity,',',' ')   City,
    sState      State,
    sZip        Zip,
    sCountry,
    V.ixVendor
from tblVendor V

    join (-- Issued PO since 01/01/09
        select distinct POM.ixVendor    --753 
        from tblPOMaster POM
            join tblDate D on D.ixDate = ixIssueDate
        where D.dtDate >= '01/01/2009'
            and flgIssued = 1
        ) ActivePO on ActivePO.ixVendor = V.ixVendor

    join (-- Has at least one active SKU
        select distinct ixVendor        -- 826
        from tblVendorSKU VS
            join tblSKU SKU on SKU.ixSKU = VS.ixSKU
            join tblDate D on D.ixDate = SKU.ixDiscontinuedDate
        where SKU.flgActive = 1
            and D.dtDate > '10/25/2010'
        ) AcitveSKU on AcitveSKU.ixVendor = V.ixVendor
    -- some "US" countries are showing foreign addresses
    join tblStates S on S.ixState = V.sState
where --(sCountry is null or sCountry like 'US%') -- excluding foreign country of origin
    V.sCity is not null
    and V.ixVendor not in ('0111','0106','9106','0108','2841','0099','0113','0945','0940') -- manual clean-up of some SMI & Afco members
order by Zip
