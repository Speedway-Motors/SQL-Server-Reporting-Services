SELECT 
    V.ixVendor,
    V.sName VendorName,
          V.ixBuyer,
    SKU.ixSKU,
    SKU.sDescription SKUDescription,
    SKU.iQOS QtyOnHand,
    -- 12 Mo Usage
    -- Months On Hand = SKU.iQOS / Monthly Avg
    -- Monthly Avg = 12 Mo Usage / 12
    -- Monthly Forecast = Monthly Avg * @ForecastFactor
    dbo.TotQtyOnOrder (SKU.ixSKU) as TotQtyOnOrder,
    -- Months On Order = Qty on Order / Monthly Avg
    -- Total Months O.H. + Months O.O.
    -- TOTAL QTY. O.H. + O.O.
    /*** add Standard PO report ADD PO issue Date ***/
    VS.iLeadTime,
    SKU.iCartonQuantity,
    -- Min Order Qty   A700010008X
    VS.sVendorSKU,
             BO.BOQty,
             (BO.BOQty * SKU.mPriceLevel1) as Retail,
            OBO.OrdersOnBO,
            OBO.OldestBO,
            CBO.CustsOnBO, 
            VOC.VendorOrderCount,
            VCC.VendorCustomerCount
FROM tblVendor V
    left join tblVendorSKU VS on VS.ixVendor = V.ixVendor 
    left join tblSKU SKU on SKU.ixSKU = VS.ixSKU
-- SKU Qty on BO
left join (select OL.ixSKU, sum(OL.iQuantity) BOQty 
         from tblOrder O
            left join tblOrderLine OL on OL.ixOrder = O.ixOrder
         where O.sOrderStatus = 'Backordered'
         group by OL.ixSKU
         ) BO on BO.ixSKU = SKU.ixSKU
-- # of Orders on BO per SKU
left join (select OL.ixSKU,count(distinct O.ixOrder) OrdersOnBO,
       min(O.dtOrderDate) OldestBO
         from tblOrder O
            join tblOrderLine OL on O.ixOrder = OL.ixOrder
         where O.sOrderStatus = 'Backordered'
         group by OL.ixSKU
        ) OBO on BO.ixSKU = OBO.ixSKU
-- # of Customers on BO per SKU
left join (select OL.ixSKU,count(distinct O.ixCustomer) CustsOnBO 
         from tblOrder O
            join tblOrderLine OL on O.ixOrder = OL.ixOrder
         where O.sOrderStatus = 'Backordered'
         group by OL.ixSKU
        ) CBO on CBO.ixSKU = OBO.ixSKU
-- # of Orders on BO per Vendor
left join (select V.ixVendor, count(O.ixOrder) VendorOrderCount
         from tblOrder O
            join tblOrderLine OL on O.ixOrder = OL.ixOrder
            join tblSKU SKU on SKU.ixSKU = OL.ixSKU
            left join tblVendorSKU VS on VS.ixSKU = OL.ixSKU 
            left join tblVendor V on V.ixVendor = VS.ixVendor
         where O.sOrderStatus = 'Backordered'
            and VS.iOrdinality = 1 -- Primary Vendor
             and VS.ixVendor <> '0009'
             and SKU.flgIsKit = 0
             and SKU.iQAV < 0
         group by V.ixVendor
        ) VOC on VOC.ixVendor = V.ixVendor
-- # of Customers on BO per Vendor
left join (select V.ixVendor, count(distinct O.ixCustomer) VendorCustomerCount
         from tblOrder O
            join tblOrderLine OL on O.ixOrder = OL.ixOrder
            join tblSKU SKU on SKU.ixSKU = OL.ixSKU
            left join tblVendorSKU VS on VS.ixSKU = OL.ixSKU 
            left join tblVendor V on V.ixVendor = VS.ixVendor
         where O.sOrderStatus = 'Backordered'
            and VS.iOrdinality = 1 -- Primary Vendor
             and VS.ixVendor <> '0009'
             and SKU.flgIsKit = 0
             and SKU.iQAV < 0
         group by V.ixVendor
        ) VCC on VCC.ixVendor = V.ixVendor
WHERE V.ixVendor in ('5004') -- (@Vendor)
  and VS.iOrdinality = 1 -- Primary Vendor
  and VS.ixVendor <> '0009'
  and SKU.flgIsKit = 0
ORDER BY V.ixVendor, SKU.ixSKU
