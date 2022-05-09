-- SMIHD-12795 - SKUs flagged ORM-D or Lithium

/* I think SKU, primary vendor,  description, quantity on hand, 12 mos sales, discontinued date..

select flgORMD, count(*)
from tblSKU
where flgDeletedFromSOP = 0 -- 933 ORMD
and flgORMD is NOT NULL
group by flgORMD

SELECT flgLithium, COUNT(*)
FROM [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblskuvariant
GROUP BY flgLithium -- 77

*/

SELECT top 1 SL.ixSKU
    , VS.sVendorSKU 'VendorSKU'
    , S.ixOriginalPart
    , ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription'
    , S.ixBrand
    , B.sBrandDescription 'BrandDescription'
    , V.ixVendor 'PrimaryVendor'
    , V.sName 'PVName'
    , S.mPriceLevel1
    , S.dtDiscontinuedDate
    , S.flgActive
    , S.flgIntangible
    , S.flgIsKit
    , S.sSEMACategory 'SEMACategory'
    , S.sSEMASubCategory 'SEMASubCat'
    , S.sSEMAPart 'SEMAPart'
    , ISNULL(SALES.QtySold12Mo,0) 'QtySold12Mo'  
    , (CASE WHEN BT.ixFinishedSKU IS NOT NULL THEN 'Y'
       ELSE 'N'
       END) 'BOMFinishedSKU'
    , SL.iQOS 'QtyOnShelf'
    , SL.iQAV 'QtvAvailableForSale'
    , SL.iQCB 'QtyCommittedToBackorders'
    , SL.iQCBOM 'QtyCommittedToBOMs'
    , (CASE WHEN S.flgProp65 IS NULL THEN NULL
        WHEN S.flgProp65 = 1 THEN 'Y'
        WHEN S.flgProp65 = 0 THEN 'N'
        ELSE 'UK'
        END) 'flgProp65'
    , (CASE WHEN flgCARB = 0 THEN 'N'
            WHEN flgCARB = 1 THEN 'Y'
            WHEN flgCARB = 2 THEN 'E'
            WHEN flgCARB = 3 THEN 'OEM'
            WHEN flgCARB = 4 THEN 'NS'
            WHEN flgCARB is NULL THEN 'Not Reviewed'
         ELSE '?'
         END) 'flgCARB'
    , S.flgORMD
    , SV2.flgLithium
FROM tblSKULocation SL
    LEFT JOIN tblSKU S on SL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU
    LEFT JOIN [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblskuvariant SV ON SV.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
                                                                    AND SV.sEoNumber is not null and SV.sEoNumber <> ''-- QUERY TAKES FOREVER WITHOUT THIS!
    LEFT JOIN [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblskuvariant SV2 ON SV2.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
    LEFT JOIN tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    LEFT JOIN tblVendor V on VS.ixVendor = V.ixVendor
    LEFT JOIN tblBrand B on B.ixBrand = S.ixBrand
	LEFT JOIN (-- 12 Mo Sales & Qty Sold
                SELECT OL.ixSKU
	                ,SUM(OL.iQuantity) AS 'QtySold12Mo', SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
                FROM tblOrderLine OL 
	                join tblDate D on D.dtDate = OL.dtOrderDate 
                WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
	                and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                GROUP BY OL.ixSKU
                ) SALES on SALES.ixSKU = S.ixSKU 
    LEFT JOIN tblBOMTemplateMaster BT on BT.ixFinishedSKU = S.ixSKU
WHERE  S.flgDeletedFromSOP = 0 
   AND SL.ixLocation = 99
   AND(S.flgORMD = 1  OR
       SV2.flgLithium = 1
       )
-- ORDER BY V.ixVendor, S.ixSKU -- SV2.flgLithium, S.flgORMD

/*

919 ORMD ONLY
 63 LITHIUM ONLY
 14 BOTH
*/

