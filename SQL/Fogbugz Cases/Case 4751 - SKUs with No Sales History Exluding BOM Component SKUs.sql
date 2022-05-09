SELECT 
    V.ixVendor,
    V.sName                 PrimaryVendor,
    VSKU.sVendorSKU         PrimaryVendorSKU,   -- Thier Part Number
    SKU.ixSKU               SKU,                -- Our Part Number
    SKU.sDescription        SKUDescription,
    SKU.flgUnitOfMeasure    SellUM,
    SKU.mPriceLevel1        Retail,             -- current price
    VSKU.mCost              PrimaryVendorCost,
    PGC.ixPGC PGC,  PGC.sDescription PGCDescription,  -- concat on report side
    SKU.iQOS OH, isNull(vwQO.QTYOutstanding,0) OPOQ, -- add both together on report side for "INV OH+OPO QTY" field
    (case when SKU.flgAdditionalHandling = '1' then 'Truck'
              else 'Parcel'
     end)                    ShipMethod,    
    D.dtDate                 ItemCreationDate
FROM (select ixSKU from dbo.tblSKU where ixSKU NOT IN
                      (select ixSKU from tblOrderLine where ixSKU is not null)
      )NOSales
        join dbo.tblSKU SKU on SKU.ixSKU= NOSales.ixSKU
        left join tblPGC PGC on PGC.ixPGC = SKU.ixPGC
        left join tblDate D on D.ixDate = SKU.ixCreateDate
        left join tblVendorSKU VSKU on VSKU.ixSKU = SKU.ixSKU and VSKU.iOrdinality = 1
        left join tblVendor V on V.ixVendor = VSKU.ixVendor
        left join vwSKUQuantityOutstanding vwQO on vwQO.ixSKU = SKU.ixSKU
WHERE SKU.ixSKU NOT IN (SELECT ixSKU FROM tblBOMTemplateDetail)
  AND V.ixVendor NOT IN ('0010', '0999', '6076', '9000', '9999')
ORDER BY SKU.ixSKU