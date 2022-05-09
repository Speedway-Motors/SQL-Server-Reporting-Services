-- SMIHD-4717 - analysis of Dropship orders sent to CA from specified vendors (for sales tax info)

-- vendor list ('0546') -- ('0127','0326','0836','1122','1999','3710','3716')

SELECT * from tblVendor where ixVendor in ('0546') -- ('0127','0326','0836','1122','1999','3710','3716')


SELECT VS.ixVendor, COUNT(Distinct O.ixOrder) Orders, SUM(OL.mExtendedPrice) Merch -- VERIFY ONLY SALES of the Dropshipped line items 
FROM tblOrder O
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
    join tblVendorSKU VS on VS.ixSKU = OL.ixSKU AND VS.iOrdinality = 1
where O.dtShippedDate between '06/15/2015' and '06/14/2016'
    and O.sOrderStatus = 'Shipped'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    --and O.sOrderType = 'Retail' -- VERIFY ONLY RETAIL ORDERS
    and O.sShipToState = 'CA'
    and O.sShipToCountry = 'US'
    and VS.ixVendor in ('0546') -- ('0127','0326','0836','1122','1999','3710','3716')
  --  and OL.flgLineStatus = 'Dropshipped'
GROUP BY VS.ixVendor   
ORDER BY VS.ixVendor 
/*
Vendor	Orders	Merch
0127	2	409.98
0326	113	28234.23
0836	107	59355.91
1122	4	9911.96
1999	1	46.99
3710	5	845.31
*/


SELECT VS.ixVendor, COUNT(Distinct O.ixOrder) Orders, SUM(OL.mExtendedPrice) Merch -- VERIFY ONLY SALES of the Dropshipped line items 
FROM tblOrder O
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
    join tblVendorSKU VS on VS.ixSKU = OL.ixSKU AND VS.iOrdinality = 1
where O.dtShippedDate between '06/01/2014' and '05/31/2015'
    and O.sOrderStatus = 'Shipped'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    --and O.sOrderType = 'Retail' -- VERIFY ONLY RETAIL ORDERS
    and O.sShipToState = 'CA'
    and O.sShipToCountry = 'US'
    and VS.ixVendor in ('0546') -- ('0127','0326','0836','1122','1999','3710','3716')
    and OL.flgLineStatus = 'Dropshipped'
GROUP BY VS.ixVendor   
ORDER BY VS.ixVendor 
/*
Vendor	Orders	Merch
0127	2	409.98
0326	113	28234.23
0836	107	59355.91
1122	4	9911.96
1999	1	46.99
3710	5	845.31
*/


