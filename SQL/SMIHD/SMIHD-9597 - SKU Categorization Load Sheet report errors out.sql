/*  SMIHD-9597 - SKU Categorization Load Sheet report errors out

*/
DECLARE
    @StartDate datetime,
    @EndDate datetime

SELECT
    @StartDate = '03/12/18', -- eComm subscription runs on Monday morning for prev Monday through Sunday
    @EndDate = '03/18/18'  

SELECT DISTINCT --SKU.dtDateLastSOPUpdate,
        SB.ixSOPSKUBase 'SKUBase',
        SKU.ixSKU		'SKUVariant', -- Part Number
       '' PartType,
       SKU.sDescription 'Description',
       M.ixMarket + ' - ' + M.sDescription 'MarketCode',
       PGC.ixPGC + ' - ' + PGC.sDescription as 'ProductGroupCode',       
       SKU.flgUnitOfMeasure 'UnitOfMeasure',  
       V.ixVendor+' - '+V.sName 'Vendor',
       VSKU.sVendorSKU 'VendorPartNumber',
--       B.ixBrand+' - '+B.sBrandDescription as 'Brand',
B.ixBrand as 'Brand',
B.sBrandDescription as 'BrandDescription',
--SKU.flgMadeToOrder,       
       (Case when SKU.flgMadeToOrder = 1 then 'Y'
        else 'N'
        end) as 'MTO',
        (Case when BS.ixBin = '999' then 'Y'
        else 'N'
        end) as 'DropshipOnly',
 --       SKU.iLeadTime 'DropShipLeadTime', -- is this correct
         (CASE WHEN SKU.flgEndUserSKU = 1 THEN 'Y'
             WHEN SKU.flgEndUserSKU = 0 then 'N'
             ELSE NULL
        END
       ) AS EndUserSKU, 
        SKU.ixCreator 'Creator',
        SKU.dtCreateDate 'DateCreated'
       -- SKU.sSEMACategory,
       -- SKU.sSEMASubCategory,
       -- SKU.sSEMAPart, 
        --BS.*
FROM vwSKULocalLocation SKU
		left join tblPGC PGC on PGC.ixPGC = SKU.ixPGC
		left join tblDate D on D.ixDate = SKU.ixCreateDate
		left join tblVendorSKU VSKU on VSKU.ixSKU = SKU.ixSKU 
		left join tblVendor V on V.ixVendor = VSKU.ixVendor
		left join tblBrand B on SKU.ixBrand = B.ixBrand
		left join vwTNGSKUBase SB on SKU.ixSKU = SB.ixSOPSKUBase
		left join tblMarket M on PGC.ixMarket = M.ixMarket
		left join vwGarageSaleSKUs GS on SKU.ixSKU = GS.ixSKU
		left join tblBinSku BS on BS.ixSKU = SKU.ixSKU and BS.ixLocation = 99
WHERE --SKU.ixSKU like '550150%'
     D.dtDate between @StartDate and @EndDate
     and VSKU.iOrdinality = 1
     and SKU.flgDeletedFromSOP = 0
     and GS.ixSKU is NULL
     --and VSKU.ixVendor = '0009'
     and SKU.ixSKU NOT like 'UP%' -- Wyatt's team won't modify these even if they're not GS SKUs.
    and SKU.ixSKU NOT like 'AUP%'
order by SKU.ixSKU