-- SMIHD-13880 - Clearnce SKUs

-- RUN ON DW.SPEEDWAY2.COM

-- SKU with Clearance Attribute
SELECT SV.ixSOPSKU 'SKU'
    , ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription'  -- 696
    , V.ixVendor 'PVNumber'
    , V.sName 'PrimaryVendor'
    , S.flgUnitOfMeasure 'UM'
    , S.mPriceLevel1
    , S.mAverageCost 'AvgCost'
    , S.mLatestCost 'LatestCost'
    , SL.iQOS 'QtyOnHand'
    , SL.iQAV 'QtyAvailable'
    , ISNULL(SALES12m.QtySold12Mo,0) 'QtySold12Mo'
    , ISNULL(SALES12m.Sales12Mo,0) 'Sales12Mo'
    , ISNULL(SALES24m.QtySold24Mo,0) 'QtySold24Mo'
    , ISNULL(SALES24m.Sales24Mo,0) 'Sales24Mo'
    , S.ixBrand
    , B.sBrandDescription
    , S.ixPGC
    , PGC.sDescription
    , S.sSEMACategory 'Category'
    , S.sSEMASubCategory 'SubCategory'
    , S.sSEMAPart 'Part'
    , sa.sTitle
    , tv.sAttributeValue
FROM tblSKU S -- 695
    LEFT JOIN tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    LEFT JOIN tblVendor V on VS.ixVendor = V.ixVendor
    LEFT JOIN tblSKULocation SL on SL.ixSKU = S.ixSKU and SL.ixLocation = 99
    LEFT JOIN  TngRawData.tngLive.tblskuvariant SV on S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = SV.ixSOPSKU
    INNER JOIN TngRawData.tngLive.tblskuvariant_skuattribute_value AS tsv ON SV.ixSKUVariant = tsv.ixSkuVariant
    INNER JOIN TngRawData.tngLive.tblskuattribute_value AS tv ON tsv.ixSkuAttributeValue = tv.ixSkuAttributeValue
    INNER JOIN TngRawData.tngLive.tblskuattribute AS sa ON tv.ixSkuAttribute = sa.ixSkuAttribute
    LEFT JOIN (-- 12 Mo SALES & QTY SOLD
            SELECT OL.ixSKU,SUM(OL.iQuantity) AS 'QtySold12Mo', 
                SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
            FROM tblOrderLine OL 
                left join tblDate D on D.dtDate = OL.dtOrderDate 
            WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
            GROUP BY OL.ixSKU
            ) SALES12m on SALES12m.ixSKU = S.ixSKU  
    LEFT JOIN (-- 24 Mo SALES & QTY SOLD
            SELECT OL.ixSKU,SUM(OL.iQuantity) AS 'QtySold24Mo', 
                SUM(OL.mExtendedPrice) 'Sales24Mo', SUM(OL.mExtendedCost) 'CoGS24Mo'
            FROM tblOrderLine OL 
                left join tblDate D on D.dtDate = OL.dtOrderDate 
            WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                and D.dtDate between DATEADD(yy, -2, getdate()) and DATEADD(yy, -1, getdate()) -- 12-24 months ago
            GROUP BY OL.ixSKU
            ) SALES24m on SALES24m.ixSKU = S.ixSKU  
    LEFT JOIN tblBrand B on B.ixBrand = S.ixBrand
    LEFT JOIN tblPGC PGC on S.ixPGC = PGC.ixPGC
WHERE sa.sTitle = 'Clearance'
    or tv.sAttributeValue = 'Clearance'

/*

    Sell UM	
    Retail	
    Primary Vendor
    Cost	
    Last Cost	
    Qty on Hand	
    Qty Available	
    0-12 Mo. Qty Sold	
    0-12 Mo. Sales	
    13-24 Mo.Qty Sold	
    13-24 Mo.Sales	
Brand	Brand Description	
PGC	PGC Description	
BIN Location	
Clearanc   eY/N

LIMIT 20



select top 10 *
from tblBinSku

															*/



