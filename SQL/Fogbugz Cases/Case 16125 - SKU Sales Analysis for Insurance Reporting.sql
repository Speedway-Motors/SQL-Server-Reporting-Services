-- Total 12 Month Sales for all SKUs 

SELECT ISNULL(SUM(OL.mExtendedPrice),0) AS TotalSales 
FROM tblOrderLine OL
LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
WHERE O.dtShippedDate BETWEEN DATEADD(yy, -1, GETDATE()) AND GETDATE()
 -- and O.sOrderType <> 'Internal'
 -- and O.sOrderChannel <> 'INTERNAL' 
  and O.sOrderStatus = 'Shipped'
  and S.flgIsKit = '0' --Exclude per CWS 
  and OL.flgLineStatus IN ('Shipped', 'Dropshipped')  
  
-- Total 12 Month Sales of shop items with any vendor in SHOP.LIST1 // provided by CWS // 

SELECT ListOne.SKU
     , ISNULL(SUM(OL.mExtendedPrice),0) AS Sales 
     , ISNULL(SUM(OL.iQuantity),0) AS QtySold
     , S.mPriceLevel1 AS CurrentRetail 
    -- , ISNULL(SUM(OL.iQuantity),0) * S.mPriceLevel1 AS PotentialSales 
FROM tblOrderLine OL 
JOIN (SELECT VS.ixSKU AS SKU 
		   FROM tblVendorSKU VS 
		   WHERE VS.ixVendor IN ('0006', '0016', '0494', '0555', 
		                         '0900', '0916', '0917', '0940',
		                         '0945', '2238', '2840', '2841') 
		  ) AS ListOne ON ListOne.SKU = OL.ixSKU      
JOIN tblOrder O ON O.ixOrder = OL.ixOrder
JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
WHERE O.dtShippedDate BETWEEN DATEADD(yy, -1, GETDATE()) AND GETDATE()
 -- and O.sOrderType <> 'Internal'
 -- and O.sOrderChannel <> 'INTERNAL' 
  and O.sOrderStatus = 'Shipped'
  and S.flgIsKit = '0' --Exclude per CWS 
  and OL.flgLineStatus IN ('Shipped', 'Dropshipped')   
GROUP BY ListOne.SKU 		
       , S.mPriceLevel1 
ORDER BY Sales       
       
-- Create temp table of above SKUs to exclude from queries written in lata data analysis 
           
--DROP TABLE ASC_SHOP_List1_SKUs

-- Total 12 Month Sales of shop items with primary vendor in SHOP.LIST1 // provided by CWS // 

SELECT ListOne.SKU
     , ISNULL(SUM(OL.mExtendedPrice),0) AS Sales 
     , ISNULL(SUM(OL.iQuantity),0) AS QtySold
     , S.mPriceLevel1 AS CurrentRetail 
    -- , ISNULL(SUM(OL.iQuantity),0) * S.mPriceLevel1 AS PotentialSales 
FROM tblOrderLine OL 
JOIN (SELECT VS.ixSKU AS SKU 
		   FROM tblVendorSKU VS 
		   WHERE VS.ixVendor IN ('0006', '0016', '0494', '0555', 
		                         '0900', '0916', '0917', '0940',
		                         '0945', '2238', '2840', '2841') 
		     and VS.iOrdinality = '1'                     
		  ) AS ListOne ON ListOne.SKU = OL.ixSKU      
JOIN tblOrder O ON O.ixOrder = OL.ixOrder
JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
WHERE O.dtShippedDate BETWEEN DATEADD(yy, -1, GETDATE()) AND GETDATE()
 -- and O.sOrderType <> 'Internal'
 -- and O.sOrderChannel <> 'INTERNAL' 
  and O.sOrderStatus = 'Shipped'
  and S.flgIsKit = '0' --Exclude per CWS 
  and OL.flgLineStatus IN ('Shipped', 'Dropshipped')   
GROUP BY ListOne.SKU 		
       , S.mPriceLevel1     
ORDER BY Sales           

-- Total 12 Month Sales for items made in the USA to our specs excluding any SKUs with SHOP.LIST1 as a vendor 
-- and with a primary vendor in the provided list per CWS 

SELECT USA.SKU
     , ISNULL(SUM(OL.mExtendedPrice),0) AS Sales 
     , ISNULL(SUM(OL.iQuantity),0) AS QtySold
     , S.mPriceLevel1 AS CurrentRetail 
    -- , ISNULL(SUM(OL.iQuantity),0) * S.mPriceLevel1 AS PotentialSales 
FROM tblOrderLine OL 
JOIN (SELECT VS.ixSKU AS SKU 
	  FROM tblVendorSKU VS 
	  WHERE VS.ixVendor IN ('0345', '0914', '1115', '1810', 
		                    '2117', '2779', '2838', '2927', 
		                    '3243') 
		and VS.iOrdinality = '1'  
		and VS.ixSKU NOT IN (SELECT SKU
							 FROM ASC_SHOP_List1_SKUs)
	  ) AS USA ON USA.SKU = OL.ixSKU      
JOIN tblOrder O ON O.ixOrder = OL.ixOrder
JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
WHERE O.dtShippedDate BETWEEN DATEADD(yy, -1, GETDATE()) AND GETDATE()
 -- and O.sOrderType <> 'Internal'
 -- and O.sOrderChannel <> 'INTERNAL' 
  and O.sOrderStatus = 'Shipped'
  and S.flgIsKit = '0' --Exclude per CWS 
  and OL.flgLineStatus IN ('Shipped', 'Dropshipped')   
GROUP BY USA.SKU 		
       , S.mPriceLevel1          
ORDER BY Sales                       

-- Total 12 Month Sales for items made outside of the USA excluding any SKUs with SHOP.LIST1 as a vendor 
-- and with a primary vendor in the provided list per CWS 

SELECT FOREIGNV.SKU
     , ISNULL(SUM(OL.mExtendedPrice),0) AS Sales 
     , ISNULL(SUM(OL.iQuantity),0) AS QtySold
     , S.mPriceLevel1 AS CurrentRetail 
    -- , ISNULL(SUM(OL.iQuantity),0) * S.mPriceLevel1 AS PotentialSales 
FROM tblOrderLine OL 
JOIN (SELECT VS.ixSKU AS SKU 
	  FROM tblVendorSKU VS 
	  WHERE VS.ixVendor IN ('0099', '1600', '1625', '1729', 
		                    '2423', '2558', '2895', '3895') 
		and VS.iOrdinality = '1'  
		and VS.ixSKU NOT IN (SELECT SKU
							 FROM ASC_SHOP_List1_SKUs)
	  ) AS FOREIGNV ON FOREIGNV.SKU = OL.ixSKU      
JOIN tblOrder O ON O.ixOrder = OL.ixOrder
JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
WHERE O.dtShippedDate BETWEEN DATEADD(yy, -1, GETDATE()) AND GETDATE()
 -- and O.sOrderType <> 'Internal'
 -- and O.sOrderChannel <> 'INTERNAL' 
  and O.sOrderStatus = 'Shipped'
  and S.flgIsKit = '0' --Exclude per CWS 
  and OL.flgLineStatus IN ('Shipped', 'Dropshipped')   
GROUP BY FOREIGNV.SKU 		
       , S.mPriceLevel1  		               
ORDER BY Sales 		                         
		                  
		