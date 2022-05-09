-- SMIHD-23094 - Add fields to Discontinued SKUs in Catalog report

/*
select count (*)
from tblSKU
where flgActive = 1
and flgDeletedFromSOP = 0 -- 211,839
--and sAlternateItem1 is NOT NULL -- 19,104
    -- and sAlternateItem2 is NOT NULL -- 7,297
    and sAlternateItem3 is NOT NULL -- 2,385
--and sAlternateItem1 is NOT NULL

select top 10 *
from tblCatalogMaster
where ixCatalog like '4%'
order by ixStartDate desc

Cat	dtStartDate	ixInHomeDate
532	2021-07-19	19574
531	2021-04-26	19489
530	2021-02-01	19406

423	2021-03-29	19461
422	2021-01-18	19391
421	2020-04-06	19104

*/

/*Discontinued SKUs in Catalog.rdl
    ver 21.45.1

DECLARE @Catalog VARCHAR(10)  
SELECT  @Catalog = '532'
    */
SELECT  CM.iQuantityPrinted AS 'Total Catalogs Printed', 
         (CM.mPrintingCost+CM.mPostageCost+CM.mPreparationCost+CM.mPaperCost+CM.mBMCFreightForwardingCost)  AS 'Catalog Cost', 
--  (CM.mPrintingCost+CM.mPostageCost+CM.mPreparationCost+CM.mPaperCost+CM.mBMCFreightForwardingCost)        
        CAST(CM.iQuantityPrinted * CM.iPages AS BIGINT) AS 'Total Pages', 
        ISNULL(NULLIF ((CM.mPrintingCost+CM.mPostageCost+CM.mPreparationCost+CM.mPaperCost+CM.mBMCFreightForwardingCost), 0) / (71 * CAST(CM.iPages AS BIGINT)), 0) AS 'Cost Per Square Inch', 
        CM.iPages AS 'Pages in Catalog', 
        D.dtDate as 'InHomeDate',
        71 * CAST(CM.iQuantityPrinted * CM.iPages AS BIGINT) AS 'Total Square Inches', 
        CD.i1stPage, 
        CD.i2ndPage,
        CD.i3rdPage,
        CD.i4thPage,
        CD.i5thPage,
        CD.i6thPage,
        CD.i7thPage,             
        CD.ixSKU, 
        SKU.iQAV,
        VS.sVendorSKU 'VendorSKU',
        VS.ixVendor 'PrimaryVendor',
        SKU.sAlternateItem1 'AltPart1',
        SKU.sAlternateItem2 'AltPart2',
        SKU.sAlternateItem3 'AltPart3',
        isnull(SKU.sWebDescription, SKU.sDescription) sDescription,
        SKU.dtDiscontinuedDate,        
        SKU.ixPGC,
        SKU.sSEMACategory 'SEMACat',
        SKU.sSEMASubCategory 'SEMASubCat',
        SKU.sSEMAPart 'SEMAPart',
        SKU.mAverageCost AS 'Current Cost', 
        SKU.mPriceLevel1 AS 'Retail', 
        SALES.QtySold12Mo,
        SALES.Sales12Mo,
        SALES.CoGS12Mo,
  --      SUM(ISNULL(vwCSS.iQuantity, 0)) AS 'Actual Units Sold', 
 --       SUM(ISNULL(vwCSS.mExtendedPrice, 0)) AS 'Sales', 
 --       SUM(ISNULL(vwCSS.mExtendedCost, 0)) AS 'Cost of Goods', 
        CD.dSquareInches, 
        SKU.iQOS AS QuantityOnShelf

       --   DEL.sUser 
FROM    tblCatalogDetail AS CD 
        LEFT OUTER JOIN tblSKU AS SKU ON CD.ixSKU = SKU.ixSKU 
        LEFT JOIN tblVendorSKU VS on SKU.ixSKU = VS.ixSKU and VS.iOrdinality = 1
       -- LEFT OUTER JOIN vwCatalogSalesSummary AS vwCSS ON CD.ixCatalog = vwCSS.ixCatalog and SKU.ixSKU = vwCSS.ixSKU
        LEFT OUTER JOIN tblCatalogMaster AS CM ON CM.ixCatalog = CD.ixCatalog
        LEFT JOIN tblDate D on D.ixDate = CM.ixInHomeDate
        LEFT JOIN (-- 12 Mo QTY SOLD
                    SELECT OL.ixSKU
                        ,SUM(OL.iQuantity) AS 'QtySold12Mo', SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
                    FROM tblOrderLine OL 
                        join tblDate D on D.dtDate = OL.dtOrderDate 
                    WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                        and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                    GROUP BY OL.ixSKU
                    ) SALES on SALES.ixSKU = CD.ixSKU          
WHERE   (CD.ixCatalog = @Catalog) -- '302')
    AND (CD.i1stPage <> '0') 
    AND (SKU.flgActive <> '1')
    AND SKU.flgDeletedFromSOP = '0'
 --  AND SKU.ixSKU in ('91072050','9180044')
--AND SKU.ixSKU = '91081904'  
/*      
GROUP BY CM.iQuantityPrinted,
        (CM.mPrintingCost+CM.mPostageCost+CM.mPreparationCost+CM.mPaperCost+CM.mBMCFreightForwardingCost),
         CAST(CM.iQuantityPrinted * CM.iPages AS BIGINT), 
        ISNULL(NULLIF ((CM.mPrintingCost+CM.mPostageCost+CM.mPreparationCost+CM.mPaperCost+CM.mBMCFreightForwardingCost), 0) / (71 * CAST(CM.iPages AS BIGINT)), 0), 
        CM.iPages, 
        D.dtDate,
        71 * CAST(CM.iQuantityPrinted * CM.iPages AS BIGINT), 
        CD.i1stPage, 
        CD.i2ndPage,
        CD.i3rdPage,
        CD.i4thPage,
        CD.i5thPage,
        CD.i6thPage,
        CD.i7thPage, 
        CD.ixSKU, 
        SKU.sDescription, 
        SKU.dtDiscontinuedDate,
        SKU.ixPGC, 
        SKU.sSEMACategory,
        SKU.sSEMASubCategory,
        SKU.sSEMAPart,
        SKU.mAverageCost, 
        SKU.mPriceLevel1, 
        SALES.QtySold12Mo,
        SALES.Sales12Mo,
        SALES.CoGS12Mo,
        CD.dSquareInches, 
        SKU.iQOS,
        SKU.iQAV         
*/        
ORDER BY CD.i1stPage, CD.ixSKU

/*
SELECT distinct ixCatalog
from tblCatalogDetail 
where ixSKU in ('91072050','9180044')

select * from tblSKU where ixSKU in ('91072050','9180044')

*/


SELECT *
from tblCatalogDetail CD
where  ixCatalog = '532'
    and (CD.i2ndPage is NOT NULL
        OR CD.i3rdPage is NOT NULL
        OR CD.i4thPage is NOT NULL
        OR CD.i5thPage is NOT NULL
        OR CD.i6thPage is NOT NULL 
        OR CD.i7thPage is NOT NULL
        )
order by ixCatalog


tblHoldCodeAuditHistory

select sHoldCode, count(*)
from tblHoldCodeAuditHistory
group by sHoldCode
