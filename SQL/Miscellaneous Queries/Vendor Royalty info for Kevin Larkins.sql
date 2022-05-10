-- Vendor Royalty info for Kevin Larkins

/*  pulls sales for a SKU if it has a value in ixRoyaltyVendor
	works ok for kit components as long as we pay based on QTY sold
	if we have kit components that pay a royalty based on % of Sales$ then there is a PROBLEM because kit components are always $0 -- to avoid double counting Revenue

Query from Vendor Royalty.rdf (in Accounting project)
*/


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
group by
      SKU.ixSKU,
      SKU.sDescription
order by
      SKU.ixSKU
