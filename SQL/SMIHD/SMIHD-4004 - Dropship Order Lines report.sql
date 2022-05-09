-- SMIHD-4004 - Dropship Order Lines report

DECLARE
    @ShipStartDate datetime,
    @ShipEndDate datetime
SELECT
    @ShipStartDate = '01/01/15',
    @ShipEndDate = '07/01/15'  
    
select 
    OL.flgLineStatus,
    OL.dtOrderDate, OL.dtShippedDate, 
    OL.ixOrder, OL.ixCustomer, OL.ixSKU, OL.iQuantity, OL.mUnitPrice, OL.mExtendedPrice, 
    OL.mCost, OL.mExtendedCost, 
    OL.flgKitComponent,
    V.ixVendor 'VendorNum',
    V.sName 'Vendor'
from tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblVendorSKU VS on VS.ixSKU = OL.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on V.ixVendor = VS.ixVendor
where OL.dtShippedDate between @ShipStartDate and @ShipEndDate -- '02/01/2016' and '02/29/2016'
    and OL.flgLineStatus = 'Dropshipped'
    and O.sOrderStatus = 'Shipped'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
order by V.sName,OL.ixSKU, OL.ixOrder



