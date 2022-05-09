-- SMIHD-19357 - SKUs flagged SLAPR but not shipping as a Slapper
/*  ver 20.49.3

DECLARE @ShippedDate datetime
SELECT @ShippedDate = '11/24/2020'
*/
-- SKUs flagged SLAPR but not shipping as a Slapper.rdl
SELECT OL.ixSKU 'SKU',  count(P.sTrackingNumber) 'Pkgs',
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    VS.ixVendor 'PV',
    V.sName 'PVName',
    S.iLength,
    S.iWidth,
    S.iHeight,
    S.dWeight,
    S.sHandlingCode 'ShippingCode',
    S.sPackageType,
    (CASE when S.flgAdditionalHandling = 1 then 'Y'
        else ''
        END) AS 'AdditionalHandling',
    BS.sPickingBin 'PickingBin'
    --Bin location
    --Does item ship is cardboard?
FROM tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblSKU S on OL.ixSKU = S.ixSKU
    left join tblPackage P on OL.sTrackingNumber = P.sTrackingNumber
                             and OL.ixOrder = P.ixOrder
    left join tblVendorSKU VS on S.ixSKU =VS.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on VS.ixVendor = V.ixVendor
    left join tblBinSku BS on S.ixSKU = BS.ixSKU and BS.ixLocation = 99
WHERE O.dtShippedDate = @ShippedDate -- 153
    and O.sOrderStatus = 'Shipped'
    and OL.flgLineStatus = 'Shipped'
    and S.sPackageType = 'SLAPR' 
    and O.iShipMethod NOT IN (1,8)
    and P.ixBoxSKU is NOT NULL
    and P.ixBoxSKU != OL.ixSKU
    and OL.ixSKU NOT LIKE 'NS%'
    and OL.ixSKU NOT LIKE 'UP%'
    and OL.ixSKU NOT LIKE 'AUP%'
group by OL.ixSKU,
    ISNULL(S.sWebDescription, S.sDescription),
    VS.ixVendor,
    V.sName,
    S.iLength,
    S.iWidth,
    S.iHeight,
    S.dWeight,
    S.sHandlingCode,
    S.sPackageType,
    (CASE when S.flgAdditionalHandling = 1 then 'Y'
        else ''
     END),
     BS.sPickingBin 
order by count(P.sTrackingNumber) desc, OL.ixSKU


/*
Bin location
Packaging Flag
Does item ship is cardboard?
*/