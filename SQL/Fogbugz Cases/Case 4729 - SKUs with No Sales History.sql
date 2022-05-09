SELECT 
    V.ixVendor,
    V.sName                 PrimaryVendor,
    VSKU.sVendorSKU         PrimaryVendorSKU,   -- Thier Part Number
    SKU.ixSKU               SKU,                -- Our Part Number
    SKU.sDescription        SKUDescription,
    SKU.flgUnitOfMeasure    SellUM,
    SKU.mPriceLevel1        Retail,             -- current price
    VSKU.mCost              PrimaryVendorCost,
    dbo.GetSKUinCatalogsLast12Months (SKU.ixSKU) as Catalogs,
    (case when BOM.ixSKU IS NULL THEN BOM.ixSKU
          ELSE 'Y'
    end)                    'BOM',
    'TBD'               Owner,
    PGC.ixPGC PGC,  PGC.sDescription PGCDescription,  -- concat on report side
    SKU.iQOS OH, isNull(vwQO.QTYOutstanding,0) OPOQ, -- add both together on report side for "INV OH+OPO QTY" field
    (case when SKU.flgAdditionalHandling = '1' then 'Truck'
              else 'Parcel'
     end)                    ShipMethod,    
    B.sBrandDescription      Brand,
    'TBD'                    Proprietary,   
    D.dtDate                 ItemCreationDate
FROM (select ixSKU from tblSKU where ixSKU NOT IN
                      (select ixSKU from tblOrderLine where ixSKU is not null)
      )NOSales
        join tblSKU SKU on SKU.ixSKU = NOSales.ixSKU
        left join tblPGC PGC on PGC.ixPGC = SKU.ixPGC
        left join tblDate D on D.ixDate = SKU.ixCreateDate
        left join tblVendorSKU VSKU on VSKU.ixSKU = SKU.ixSKU and VSKU.iOrdinality = 1
        left join tblVendor V on V.ixVendor = VSKU.ixVendor
        left join vwSKUQuantityOutstanding vwQO on vwQO.ixSKU = SKU.ixSKU
        left join tblBrand B on B.ixBrand = SKU.ixBrand
        left join (select distinct(ixSKU)
                      from tblBOMTemplateDetail
                      ) BOM on BOM.ixSKU = SKU.ixSKU
--WHERE SKU.ixSKU like '5503%'
ORDER BY SKU.ixSKU