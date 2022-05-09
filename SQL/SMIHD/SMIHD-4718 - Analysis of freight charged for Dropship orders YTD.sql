-- SMIHD-4718 - Analysis of freight charged for Dropship orders YTD


-- temp table to show orders that contain ONLY dropship SKUs
-- DROP TABLE [SMITemp].dbo.PJC_SMIHD4717_OrdersWonlyDropshippedSKUs
select distinct O.ixOrder 
into [SMITemp].dbo.PJC_SMIHD4717_OrdersWonlyDropshippedSKUs -- 16,269
                  from tblOrder O
                    join tblOrderLine OL on O.ixOrder = OL.ixOrder
                  WHERE O.dtShippedDate between '01/01/2014' and '06/07/2016'
                    and O.sOrderStatus = 'Shipped'
                    and O.mMerchandise > 0 
                    --and O.mMerchandise < 100
                    and O.sOrderType <> 'Internal'   -- USUALLY filtered
                    and OL.flgLineStatus = 'Dropshipped'
                    and O.sOrderType = 'Retail' -- VERIFY THEY WANT RETAIL ONLY!                     
                    and O.ixOrder NOT IN (-- contains non-dropshipped SKUs
                                          select distinct O.ixOrder 
                                          from tblOrder O
                                            join tblOrderLine OL on O.ixOrder = OL.ixOrder
                                          WHERE O.dtShippedDate between '01/01/2016' and '06/07/2016'
                                            and O.sOrderStatus = 'Shipped'
                                            and O.mMerchandise > 0 
                                            --and O.mMerchandise < 100
                                            and O.sOrderType <> 'Internal'   -- USUALLY filtered
                                            and OL.flgLineStatus = 'Shipped'
                                            and O.sOrderType = 'Retail' -- VERIFY THEY WANT RETAIL ONLY! 
                                            and OL.mExtendedPrice > 0 )
                                            
                                            
                                            
-- Orders dropship SKUs only, <$100 (so not eligible for free shipping)
SELECT COUNT(O.ixOrder) OrderCnt, SUM(O.mMerchandise) 'Merch', SUM(mMerchandiseCost) 'MerchCost', SUM(mShipping) 'SHCharged'
FROM tblOrder O
    join [SMITemp].dbo.PJC_SMIHD4717_OrdersWonlyDropshippedSKUs DS on O.ixOrder = DS.ixOrder
where dtShippedDate between '01/01/2016' and '06/07/2016'
    and O.sOrderStatus = 'Shipped'
    and O.mMerchandise > 0 
    and O.mMerchandise < 100
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and O.sOrderType = 'Retail' -- VERIFY THEY WANT RETAIL ONLY!     
and O.ixOrder in (select distinct O.ixOrder 
                  from tblOrder O
                    join tblOrderLine OL on O.ixOrder = OL.ixOrder
                    join tblSKU SKU on OL.ixSKU = SKU.ixSKU
                  WHERE O.dtShippedDate between '01/01/2016' and '06/07/2016'
                    and O.sOrderStatus = 'Shipped'
                    and O.mMerchandise > 0 
                    and O.mMerchandise < 100
                    and O.sOrderType <> 'Internal'   -- USUALLY filtered
                    and OL.flgLineStatus = 'Dropshipped'
                    and O.sOrderType = 'Retail' -- VERIFY THEY WANT RETAIL ONLY!                     
                    )

/*   RESULTS SEND TO JEF
Orders: 799	    	        	
Sales:	$40,027               
MerchCost: $27,139
Shipping: $9,107 (charged to customer) 22.7% of Merch Sales
*/



-- Orders dropship SKUs only, >=$100 (PRIOR TO Free SH launch)
SELECT COUNT(O.ixOrder) OrderCnt, SUM(O.mMerchandise) 'Merch', SUM(mMerchandiseCost) 'MerchCost', SUM(mShipping) 'SHCharged'
FROM tblOrder O
    join [SMITemp].dbo.PJC_SMIHD4717_OrdersWonlyDropshippedSKUs DS on O.ixOrder = DS.ixOrder
where dtShippedDate between '01/01/2014' and '06/25/2015'
    and O.sOrderStatus = 'Shipped'
    and O.mMerchandise > 0 
    and O.mMerchandise >= 100
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and O.sOrderType = 'Retail' -- VERIFY THEY WANT RETAIL ONLY! 
and O.ixOrder in (select distinct O.ixOrder 
                  from tblOrder O
                    join tblOrderLine OL on O.ixOrder = OL.ixOrder
                    join tblSKU SKU on OL.ixSKU = SKU.ixSKU
                  WHERE O.dtShippedDate between '01/01/2014' and '06/25/2015'
                    and O.sOrderStatus = 'Shipped'
                    and O.mMerchandise > 0 
                    and O.mMerchandise >= 100
                    and O.sOrderType <> 'Internal'   -- USUALLY filtered
                    and O.sOrderType = 'Retail'   -- VERIFY THEY WANT RETAIL ONLY!                 
                    and OL.flgLineStatus = 'Dropshipped'
                    )

/*   RESULTS SEND TO JEF
Orders: 5,514	    	        	
Sales:	$2,987,593             
MerchCost: $1,904,646
Shipping: $153,058 (charged to customer)
*/

-- Orders dropship SKUs only, >=$100 (so eligible for free shipping after 6-25-2015)
SELECT COUNT(O.ixOrder) OrderCnt, SUM(O.mMerchandise) 'Merch', SUM(mMerchandiseCost) 'MerchCost', SUM(mShipping) 'SHCharged'
FROM tblOrder O
    join [SMITemp].dbo.PJC_SMIHD4717_OrdersWonlyDropshippedSKUs DS on O.ixOrder = DS.ixOrder
where dtShippedDate between '06/26/2015' and '06/07/2016'
    and O.sOrderStatus = 'Shipped'
    and O.mMerchandise > 0 
    and O.mMerchandise >= 100
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and O.sOrderType = 'Retail' -- VERIFY THEY WANT RETAIL ONLY!     
    and O.ixOrder in (select distinct O.ixOrder 
                  from tblOrder O
                    join tblOrderLine OL on O.ixOrder = OL.ixOrder
                    join tblSKU SKU on OL.ixSKU = SKU.ixSKU
                  WHERE O.dtShippedDate between '06/26/2015' and '06/07/2016'
                    and O.sOrderStatus = 'Shipped'
                    and O.mMerchandise > 0 
                    and O.mMerchandise >= 100
                    and O.sOrderType <> 'Internal'   -- USUALLY filtered
                    and OL.flgLineStatus = 'Dropshipped'
                    and O.sOrderType = 'Retail' -- VERIFY THEY WANT RETAIL ONLY!                     
                    )

/*   RESULTS SEND TO JEF
Orders: 5,514	    	        	
Sales:	$2,987,593             
MerchCost: $1,904,646
Shipping: $153,058 (charged to customer)
*/


SELECT ixSKU, mPriceLevel1, sDescription, sSEMACategory, sSEMASubCategory, sSEMAPart, flgAdditionalHandling, dDimWeight, dWeight, iLength, iWidth, iHeight, sHandlingCode
FROM tblSKU
where flgDeletedFromSOP = 0
and UPPER(sSEMACategory) like '%ENGINE%'
order by dWeight desc

select * from tblSKU
where sHandlingCode = 'TR'
and flgAdditionalHandling = 0 



                 

select OL.* from tblOrderLine OL
    join [SMITemp].dbo.PJC_SMIHD4717_OrdersWonlyDropshippedSKUs DS on OL.ixOrder = DS.ixOrder -- 2,378
order by OL.ixOrder, flgLineStatus
    

select COUNT(*) from [SMITemp].dbo.PJC_SMIHD4717_OrdersWonlyDropshippedSKUs -- 799


select D.iYear, D.iYearMonth, COUNT(O.ixOrder) OrdersWFreeSH
from tblOrder O
join tblDate D on O.ixShippedDate = D.ixDate
where     O.sOrderStatus = 'Shipped'
    and O.dtShippedDate > '01/01/2015'
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and O.sOrderType = 'Retail'
    and O.ixCustomerType = '1'
    and O.mShipping = 0
    and O.mMerchandise >= 100
    and O.iTotalTangibleLines > 0
    and D.iYear >= 2015
group by   D.iYear, D.iYearMonth
order by   D.iYear, D.iYearMonth  
