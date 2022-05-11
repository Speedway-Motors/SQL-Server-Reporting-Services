-- Vendor Royalty info for Kevin Larkins

/*  pulls sales for a SKU if it has a value in ixRoyaltyVendor
	works ok for kit components as long as we pay based on QTY sold
	if we have kit components that pay a royalty based on % of Sales$ then there is a PROBLEM because kit components are always $0 -- to avoid double counting Revenue

Larkins did a test and we confirmed SKU qty sold is accurate on the report -- it doesn't care if it's in a kit or not
Based on that, KITS THEMSELVES SHOULD NEVER HAVE A ixRoyaltyVendor VALUE (if they are we'll being duping royalties)

Query from Vendor Royalty.rdf (in Accounting project)
*/

DECLARE @start_date DATETIME = '01/01/2022', @end_date DATETIME = '05/10/2022'

select 
      SKU.ixSKU					SKU,
      SKU.sDescription			SKUdescription,
      sum(OL.iQuantity)			ShippedQTY,
      sum(OL.mExtendedPrice)	ShippedRevenue,
      sum(OL.mExtendedCost)   ShippedCost,
	  (select sum(VDSR.ReturnQTY) 
       from vwDailySKUReturns VDSR
       where VDSR.MemoCreateDate >= @start_date
		     and VDSR.MemoCreateDate < @end_date+1
		     and VDSR.SKU = SKU.ixSKU 
	   )
			 					ReturnedQTY,
	  (select sum(VDSR.ReturnRevenue) 
       from vwDailySKUReturns VDSR
       where VDSR.MemoCreateDate >= @start_date
		     and VDSR.MemoCreateDate < @end_date+1
		     and VDSR.SKU = SKU.ixSKU 
	   )
			 					ReturnRevenue,
	  (select sum(VDSR.ReturnCost) 
       from vwDailySKUReturns VDSR
       where VDSR.MemoCreateDate >= @start_date
		     and VDSR.MemoCreateDate < @end_date+1
		     and VDSR.SKU = SKU.ixSKU 
	   )
			 					ReturnCost				 					
      -- NetRevenue WILL BE CALCULATED IN REPORT
from
      tblOrderLine OL
      right join vwSKULocalLocation SKU on OL.ixSKU = SKU.ixSKU
      left join tblOrder O on OL.ixOrder = O.ixOrder
where
      O.dtShippedDate >= @start_date
      and O.dtShippedDate < @end_date+1
      and OL.flgLineStatus = 'Shipped'
      and SKU.ixRoyaltyVendor = 3635 --@Vendor -- 3635
	  and SKU.ixSKU = '91624360-HS' -- comp
--	  and SKU.ixSKU = '9109094' -- Kit SKU      14 KITS sold YTD
-- 	  and SKU.ixSKU = '91624360-HS' -- comp
	 

group by
      SKU.ixSKU,
      SKU.sDescription
order by
      SKU.ixSKU




/*
SELECT ixSKU, ixRoyaltyVendor
from tblSKU
where ixSKU in ('91624360-HS','9109094')
*/

DECLARE @start_date DATETIME = '01/01/2022', @end_date DATETIME = '05/10/2022'

SELECT OL.ixSKU,       
      SKU.sDescription			SKUdescription,
	  OL.flgKitComponent,
      OL.iQuantity			,
      OL.mExtendedPrice	,
      OL.mExtendedCost   
from
      tblOrderLine OL
      right join vwSKULocalLocation SKU on OL.ixSKU = SKU.ixSKU
      left join tblOrder O on OL.ixOrder = O.ixOrder
where
      O.dtShippedDate >= @start_date
      and O.dtShippedDate < @end_date+1
      and OL.flgLineStatus = 'Shipped'
      and SKU.ixRoyaltyVendor = 3635 --@Vendor -- 3635
	  and SKU.ixSKU = '91624360-HS' -- comp
order by flgKitComponent




SELECT ixSKU, sDescription, ixRoyaltyVendor, flgIsKit, dtDateLastSOPUpdate
FROM tblSKU
WHERE flgDeletedFromSOP = 0
and ixRoyaltyVendor is NOT NULL -- 424
and flgIsKit = 1
order by ixRoyaltyVendor, ixSKU


