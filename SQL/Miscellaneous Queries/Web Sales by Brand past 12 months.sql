-- Web Sales by Brand past 12 months
SELECT 
/*********** section 1 **********************/
      V.ixVendor
    , V.sName AS PrimaryVendor
    , VSKU.sVendorSKU AS PrimaryVendorSKU  -- Thier Part Number
    , SKU.ixSKU AS SKU -- Our Part Number
    , SKU.sDescription AS SKUDescription
    , RTRIM(SKU.sSEMACategory) AS sSEMACategory
    , RTRIM(SKU.sSEMASubCategory) AS sSEMASubCategory 
    , RTRIM(SKU.sSEMAPart) AS sSEMAPart
    , SKU.flgUnitOfMeasure AS SellUM
    , (CASE WHEN SKU.flgActive = 1 THEN 'Y'
            WHEN SKU.flgActive = 0 THEN 'N'
            ELSE ' '
      END) AS Active
    , SKU.dtDiscontinuedDate
    , SKU.dtCreateDate
    , SKU.ixCreator AS CreatedBy
    , SKU.mPriceLevel1 AS Retail --current price
    , VSKU.mCost AS PrimaryVendorCost
    , SKU.mLatestCost AS LastCost
    , SKU.mAverageCost AS AvgCost    
    , dbo.GetSKUinCatalogsLast12Months (SKU.ixSKU) AS Catalogs
FROM tblSKU SKU
LEFT JOIN tblPGC PGC ON PGC.ixPGC = SKU.ixPGC
LEFT JOIN tblDate D ON D.ixDate = SKU.ixCreateDate
LEFT JOIN tblVendorSKU VSKU ON VSKU.ixSKU = SKU.ixSKU 
LEFT JOIN tblVendor V ON V.ixVendor = VSKU.ixVendor
LEFT JOIN vwSKUQuantityOutstanding vwQO ON vwQO.ixSKU = SKU.ixSKU
LEFT JOIN tblBrand B ON B.ixBrand = SKU.ixBrand
LEFT JOIN (select SalesDollars, Cost, Qty, etc
           from tblOrderLine OL
           where flgLineStatus in ('Shipped','Dropshipped')
WHERE B.ixBrand = '10014'


ORDER BY SKU.ixSKU

select S.ixBrand,
    B.sBrandDescription 'BrandDescription',
--    OL.ixSKU,
--    S.sDescription 'SKUDescription',
--    D.iYearMonth,
    SUM(OL.iQuantity) QTYSold,
    SUM(OL.iQuantity*CAST(OL.mUnitPrice as Money)) Sales,
    SUM((OL.mUnitPrice-OL.mCost)* CAST(OL.iQuantity as Money)) GP
from tblOrder O 
    full join tblOrderLine OL on OL.ixOrder = O.ixOrder 
    --join tblSKU S on OL.ixSKU = S.ixSKU
    left join tblDate D on D.dtDate = OL.dtOrderDate 
    left join vwSKULocalLocation S on S.ixSKU = OL.ixSKU 
    left join tblBrand B on S.ixBrand = B.ixBrand
where O.sOrderChannel in ('EBAY','AUCTION','WEB')
 and O.dtOrderDate >= '12/18/2013'
 and O.sOrderType = 'Retail'
 and OL.flgLineStatus IN ('Shipped','Dropshipped')
group by S.ixBrand, B.sBrandDescription  -- OL.ixSKU,
  --  D.iYearMonth
   -- OL.ixSKU,
   -- S.sDescription
order by GP desc


                            
select distinct sOrderChannel 
from tblOrder                     