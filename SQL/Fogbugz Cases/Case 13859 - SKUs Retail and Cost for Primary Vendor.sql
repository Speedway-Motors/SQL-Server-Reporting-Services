SELECT SKU.ixSKU AS SKU -- Our Part Number
     , VSKU.sVendorSKU AS PrimaryVendorSKU -- Their Part Number 
     , V.ixVendor AS PrimaryVendorNumber
     , V.sName AS PrimaryVendor
     , SKU.sDescription AS ProductDescription
     --SEMA 
     , RTRIM(SKU.sSEMACategory) AS Category
     , RTRIM(SKU.sSEMASubCategory) AS SubCategory
     , RTRIM(SKU.sSEMAPart) AS PartTerminology
     , SKU.flgUnitOfMeasure AS SellUM
     , SKU.mPriceLevel1 AS Retail -- Current price
     , VSKU.mCost AS PrimaryVendorCost
     , (CASE WHEN flgActive = 1 THEN 'Y'
             WHEN flgActive = 0 then 'N'
             ELSE '?'
        END
       ) AS Active
     , SKU.dtDiscontinuedDate AS DiscontinuedDate
     , SKU.dtCreateDate AS ItemCreationDate
     , SKU.ixCreator AS CreatedBy
     , M.ixMarket AS MarketCode
     , M.sDescription AS MarketDescription
     , SKU.ixPGC AS PGC
     , PGC.sDescription AS PGCDescription
     , SKU.iQOS AS OH
     , ISNULL(vwQO.QTYOutstanding,0) AS OPOQty -- add both together on report side for "INV OH+OPO QTY" field
FROM vwSKULocalLocation SKU
        left join tblVendorSKU VSKU on VSKU.ixSKU = SKU.ixSKU 
        left join tblVendor V on V.ixVendor = VSKU.ixVendor
        left join tblPGC PGC on PGC.ixPGC = SKU.ixPGC
        left join tblMarket M on M.ixMarket = PGC.ixMarket
        left join vwSKUQuantityOutstanding vwQO on vwQO.ixSKU = SKU.ixSKU
WHERE VSKU.iOrdinality = 1
  and  V.ixVendor not in ('0494','2921','JUNK')
  --and  V.ixVendor >= @VendorStart
  --and  V.ixVendor <= @VendorEnd
ORDER BY V.ixVendor