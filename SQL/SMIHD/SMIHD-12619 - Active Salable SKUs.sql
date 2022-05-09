-- SMIHD-12619 - Active Salable SKUs
/*
Needed to identify:
    Active SKUs that are salable on the website only.
    Active Garage Sale SKUs that are salable on the website only.

Current reporting options are somewhat limited on being able to pull SKU information specific to those that are active on the website and salable. 
Since there are multiple fields for determining whether a SKU is active or not, 
I feel it is necessary to reference all of these fields in a separate report.

Fields needed for this report are as follows:


Web Catalog Title (text)
Brand (text)
Product Line (text)
Part Type (text)
Garage Sale (Y/N) - Reference '0009' - Primary Vendor Code in SOP
Considerations:

For the 'Active SKU' field; the active field in SOP is missing from this logic.
         Would it be straight forward to include this as well?

For the 'Garage Sale' field; the primary vendor code in SOP will need to be referenced for this. 
    Do Discontinued SKUs affect the primary vendor code? 
    An example of this possible conflict can be seen attached:   Ex. - 630471-PEARL-718
    This SKU shows a primary vendor code of '9999' (discontinued); 
    however, when referenced on report: "SKUS Retail and Cost for Primary Vendor - 12 Month Rolling" the primary vendor number is displayed as the second one listed in SOP (0632).



This is the basic logic for if something is saleable.
 
    if flgFactoryShip then
          if flgDiscontinued = false then return true;
          else return false;
        end if;
    elseif flgDiscontinued and flgBackorderable = false and iQav < 1 then
        return false;
    elseif iQav > 0 then
        return true;
    elseif flgMTO and flgDiscontinued = false then
        return true;
    elseif flgBackorderable and flgDiscontinued = false then
        return true;
    else
        return false;
    end if;
And <SKU>.flgPublished = 1 and <base>.flgWebPublish = 1
*/

SELECT S.ixSKU 'SKU',
        SS.SOPSKUBase,
        S.sWebDescription 'Web Catalog Title (aka Web Description)',
        B.sBrandDescription 'Brand',
        PL.sTitle 'Product_Line',
        S.sSEMAPart 'Part_Type',
        (CASE WHEN VS.ixVendor = '0009' then 'Y'
              Else 'N'
         End) as 'Garage_Sale_Vendor',
         VS.ixVendor 'Primary_Vendor',
            (-- Garage Sale based on market of SKUBase
              CASE WHEN SS.SKUBase IN (select distinct ixSkuBase 
                                       from [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblskubase_effectivemarket where ixMarket = 222) THEN 'Y'
              ELSE 'N'
              END) as 'Garage_Sale_Market'
FROM tblSKU S
    left join tblBrand B on S.ixBrand = B.ixBrand
    left join tblProductLine PL on S.ixProductLine = PL.ixProductLine
    left join tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
    left join (-- SALEABLE SKUs
               SELECT DISTINCT t.ixSOPSKU AS 'ixSOPSKU', t1.ixSOPSKUBase 'SOPSKUBase', t.ixSKUBase 'SKUBase'  -- 168,191 SKUs
               FROM [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblskuvariant t
                  INNER JOIN [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblskubase t1 ON t.ixSKUBase = t1.ixSKUBase
                  INNER JOIN [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
                  INNER JOIN [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
                WHERE t.ixSOPSKU is NOT NULL
                    AND t.flgPublish = 1
                    AND t1.flgWebPublish = 1
                    AND t3.flgActive = 1
                    AND(t.iTotalQAV > 0 
                        OR t.flgBackorderable = 1)
               ) SS ON S.ixSKU = SS.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE S.flgDeletedFromSOP = 0
   and SS.ixSOPSKU is NOT NULL -- in the saleable SKU sub-query

   -- SKU Base
select distinct ixSKUBase 
from [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblskubasemarket
where ixMarket = 222

select distinct ixSKUBase 
from [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblskubasemarket
where ixMarket = 222

SELECT * FROM [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblskubasemarket AS b WHERE b.ixMarket = 222



    SELECT * FROM tblVendor 
    where ixVendor in ('0009','0999','9999')
    /*
    ixVendor	sName
    0009	    SPEEDWAY GARAGE SALE
    0999	    DISCONTINUED/QOH
    9999	    DISCONTINUED PARTS
    */


SELECT TOP 20 ixSKU, sWebDescription
from tblSKU
where --ixSKU = '3003600'
len (sWebDescription)= 100-- between 80 and 99
and flgActive = 1
and flgDeletedFromSOP = 0
order by newid()




SELECT distinct VS.ixSKU, S.dtDiscontinuedDate, S.flgActive
FROM tblVendorSKU VS
    left join tblSKU S on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
WHERE S.flgDeletedFromSOP = 0
    and VS.ixVendor = '9999' -- 78,910
ORDER BY S.dtDiscontinuedDate DESC


SELECT distinct VS.ixSKU, S.dtDiscontinuedDate, S.flgActive, VS.ixVendor
FROM tblVendorSKU VS
    left join tblSKU S on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
WHERE S.flgDeletedFromSOP = 0
    AND VS.ixSKU = '630471-PEARL-718'
    

SELECT VS.ixSKU, VS.ixVendor, VS.iOrdinality, FORMAT(S.dtDiscontinuedDate,'MM/dd/yyyy') 'DiscontinuedDate'
FROM tblVendorSKU VS
    left join tblSKU S on VS.ixSKU = S.ixSKU
where VS.ixSKU = '630471-PEARL-718'


SELECT COUNT(S.ixSKU) 
FROM tblSKU S
WHERE S.flgDeletedFromSOP = 0
and S.dtDiscontinuedDate <= '02/22/2019' -- 153,757
and flgActive = 0 -- 153,756


153K SKUs have a discontinued date that is in the past
only 78k have 9999 as the Primary Vendor


SELECT S.ixSKU 
FROM tblSKU S
WHERE S.flgDeletedFromSOP = 0
and S.dtDiscontinuedDate <= '02/22/2019' -- 153,757
and flgActive = 1 -- 153756


SELECT ixSKU, dtDateLastSOPUpdate
from tblSKU
where ixSKU = '474113.040GS'

/********** FROM Fitment Coverage report ***************/
                SELECT DISTINCT t.ixSKUVariant AS 'ixSKU'  -- 168,117 SKUs
                  --COUNT(DISTINCT ymm.ixSkuVariant) AS DistinctSkuWithFitment
                FROM [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblskuvariant t
                  INNER JOIN [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblskubase t1 ON t.ixSKUBase = t1.ixSKUBase
                  INNER JOIN [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
                  INNER JOIN [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
                  --LEFT JOIN [DW.SPEEDWAY2.COM].DW.dbo.vwSkuVariantWithChassisFitment ymm ON ymm.ixSkuVariant = t.ixSKUVariant
                WHERE t.flgPublish = 1
                    AND t1.flgWebPublish = 1
                    AND t3.flgActive = 1
                    AND(t.iTotalQAV > 0 
                        OR t.flgBackorderable = 1)

SELECT TOP 10 * 
FROM [DW.SPEEDWAY2.COM].SmiReportingRawData.Transfer.tblOrder

SELECT TOP 10 * FROM [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblproductline

                SELECT COUNT(DISTINCT t.ixSKUVariant) AS DistAllSKUs,  -- 11 seconds
                  COUNT(DISTINCT ymm.ixSkuVariant) AS DistinctSkuWithFitment
                FROM [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblskuvariant t
                  INNER JOIN [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblskubase t1 ON t.ixSKUBase = t1.ixSKUBase
                  INNER JOIN [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
                  INNER JOIN [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
                  LEFT JOIN [DW.SPEEDWAY2.COM].TngRawData.tngLive.vwSkuVariantWithChassisFitment ymm ON ymm.ixSkuVariant = t.ixSKUVariant
                WHERE t.flgPublish = 1
                    AND t1.flgWebPublish = 1
                    AND t3.flgActive = 1
                    AND(t.iTotalQAV > 0 
                        OR t.flgBackorderable = 1)







SELECT VS.ixSKU, VS.ixVendor, VS.iOrdinality, FORMAT(S.dtDiscontinuedDate,'MM/dd/yyyy') 'DiscontinuedDate', SL.iQAV, SL.iQOS
FROM tblVendorSKU VS
    left join tblSKU S on VS.ixSKU = S.ixSKU
    left join tblSKULocation SL on S.ixSKU = SL.ixSKU and ixLocation = 99
WHERE flgDeletedFromSOP = 0
    -- and SL.iQOS > 0 
    and ixVendor = '9999'
    and iOrdinality = 1
order by ixVendor desc, iQOS desc  -- 79k disc. SKUs with 0 qty PV = 9999


SELECT VS.ixSKU, VS.ixVendor, VS.iOrdinality, FORMAT(S.dtDiscontinuedDate,'MM/dd/yyyy') 'DiscontinuedDate', SL.iQAV, SL.iQOS
FROM tblVendorSKU VS
    left join tblSKU S on VS.ixSKU = S.ixSKU
    left join tblSKULocation SL on S.ixSKU = SL.ixSKU and ixLocation = 99
WHERE flgDeletedFromSOP = 0
    and dtDiscontinuedDate <'02/28/2019'
    and SL.iQOS > 0 
    and ixVendor NOT IN ('9999', '0009', '0999')
    and iOrdinality = 1
order by S.dtDiscontinuedDate desc  -- ixVendor desc, iQOS desc  -- 79k disc. SKUs with 0 qty PV = 9999



