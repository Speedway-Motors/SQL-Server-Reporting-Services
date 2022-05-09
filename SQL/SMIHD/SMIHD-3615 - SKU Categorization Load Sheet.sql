-- SMIHD-3615 - SKU Categorization Load Sheet
/*
Market Code	        	               	    Dropship    Lead Time	Creator	Date Created
B - BothRaceStreet		    10191 - Speedway	N		                        JMC1	1/3/2003
*/



DECLARE
    @StartDate datetime,
    @EndDate datetime

SELECT
    @StartDate = '02/18/16',
    @EndDate = '02/18/16'  

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
       B.ixBrand+' - '+B.sBrandDescription as 'Brand',
--SKU.flgMadeToOrder,       
       (Case when SKU.flgMadeToOrder = 1 then 'Y'
        else 'N'
        end) as 'MTO',
        (Case when BS.ixBin = '999' then 'Y'
        else 'N'
        end) as 'DropshipOnly',
        VSKU.iLeadTime 'DropShipLeadTime', -- is this correct!?!,
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
     -- and SKU.ixSKU like 'UP%'
order by SKU.ixSKU

-- select top 10 * from tblSKU

/*
select * from vwTNGSKUBase
where ixSOPSKUBase like '%5457376%'

select * from tblSKU where ixSKU = '5457376'


select dtCreateDate, ixSKU, ixPGC, ixBrand
from tblSKU
where flgMadeToOrder = 1
and flgDeletedFromSOP = 0
order by dtCreateDate desc

*/
