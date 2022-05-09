-- Case 18581 - 24 month SKU purchase summary for customer 533015 for Clay Smith

select ( Case when O.dtOrderDate between '05/06/2011' and '05/05/2012' then '13-24' 
            when O.dtOrderDate > '05/06/2012' then '0-12'
            else 'older'
            end) Months,
    OL.ixSKU 'SKU', 
    SKU.sDescription 'Description',
    SUM(OL.iQuantity) 'TotQty',
    SKU.sSEMACategory,
    SKU.sSEMASubCategory,
    SKU.sSEMAPart,
   -- V.sName 'Primary Vendor',
    ( Case-- when VS.ixVendor in ('0106','0108','0126','9106') then 'Afco'
          -- when VS.ixVendor in ('0311','0313','9311') then 'Dynatech'
           when VS.ixVendor = '0582' then 'Y'
           else 'N'
           end
        ) PROSHOCK
  --  SUM(mExtendedPrice)
from tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblSKU SKU on SKU.ixSKU = OL.ixSKU
    left join tblVendorSKU VS on SKU.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on V.ixVendor = VS.ixVendor
where O.ixCustomer = '533015'
    and O.dtOrderDate >= '05/06/2011'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.ixOrder not like '%-%'
    and SKU.flgIntangible = 0
    and OL.flgKitComponent = 0
group by ( Case when O.dtOrderDate between '05/06/2011' and '05/05/2012' then '13-24' 
            when O.dtOrderDate > '05/06/2012' then '0-12'
            else 'older'
            end),
                OL.ixSKU, 
            SKU.sDescription,
                SKU.sSEMACategory,
    SKU.sSEMASubCategory,
    SKU.sSEMAPart,
    ( Case-- when VS.ixVendor in ('0106','0108','0126','9106') then 'Afco'
          -- when VS.ixVendor in ('0311','0313','9311') then 'Dynatech'
           when VS.ixVendor = '0582' then 'Y'
           else 'N'
           end
        )
order by OL.ixSKU, Months


select * from tblCustomer where ixCustomer = '533015'







