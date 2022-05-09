-- SMIHD-2504 - SKU Dropship Lead Time by Vendor report

/*
SKU
Description
Vendor Number
Vendor Name
Lead Time
*/

SELECT S.ixSKU 'SKU',
    S.sDescription 'SKUDescription',
    VS.ixVendor 'VendorNum',
    V.sName 'VendorName',
    S.iDropshipLeadTime 'DropShipLeadTime',
    S.dtCreateDate,S.dtDiscontinuedDate
-- S.flgActive, S.dtCreateDate, S.dtDateLastSOPUpdate
FROM tblSKU S
    left join tblVendorSKU VS on S.ixSKU = VS.ixSKU
    left join tblVendor V on VS.ixVendor = V.ixVendor
WHERE S.flgDeletedFromSOP = 0
--and VS.ixVendor = '0493'
ORDER BY VS.ixVendor, S.iDropshipLeadTime




SELECT iDropshipLeadTime, COUNT(*)
FROM tblSKU
where flgDeletedFromSOP = 0
group by iDropshipLeadTime
order by iDropshipLeadTime



SELECT VS.ixVendor 'VendorNum',
    V.sName 'VendorName',
    S.iDropshipLeadTime 'DropShipLeadTime',
    count(S.ixSKU) SKUQty
FROM tblSKU S
    left join tblVendorSKU VS on S.ixSKU = VS.ixSKU
    left join tblVendor V on VS.ixVendor = V.ixVendor
WHERE S.flgDeletedFromSOP = 0
VS.iOrdinality = 1
and VS.ixVendor = '0493'
GROUP BY VS.ixVendor,
    V.sName,
    S.iDropshipLeadTime 
ORDER BY VS.ixVendor, S.iDropshipLeadTime


/*
1 - Do you want SKUs that have no DropShip lead time values included?  (about 78K have a lead time >= 0, about 200K don't have any value at all
2 - Are there any SKUs you would like excluded?  (Discontinued, Kits, Ship Alone SKUs etc)

X - when you enter a vendor do you want every SKU associated with them regardless if they are the primary vendor?   

     