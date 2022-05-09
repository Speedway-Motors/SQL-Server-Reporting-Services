SELECT S.ixSKU AS SKU
     , VS.sVendorSKU AS PVSKU
     , S.mPriceLevel1 AS Retail
     , S.mAverageCost AS AvgCost 
     , S.mPriceLevel1 - S.mAverageCost AS GP
   --  , (S.mPriceLevel1 - S.mAverageCost) / (S.mPriceLevel1 ) AS GPPercent
     , V.sName AS PVName 
     , VS.ixVendor AS PVNumber 
     , OMS.Qty AS OMSQty 
     , OMS.Sales AS OMSales
     , TMS.Qty AS TMSQty
     , TMS.Sales AS TMSales
     , dbo.GetSKUinCatalogsLast12Months (S.ixSKU) AS Catalogs       
     , S.ixBrand AS Brand 
     , B.sBrandDescription AS BrandName 
     , SL.iQAV AS QAV
     , (CASE WHEN S.flgBackorderAccepted = '1' THEN 'Y' 
             ELSE 'N' 
         END) AS BOAccepted
FROM tblSKU S  
LEFT JOIN tblVendorSKU VS ON VS.ixSKU = S.ixSKU     
                         AND VS.iOrdinality = 1 
LEFT JOIN tblVendor V ON V.ixVendor = VS.ixVendor
LEFT JOIN tblBrand B ON B.ixBrand = S.ixBrand 
LEFT JOIN tblSKULocation SL ON SL.ixSKU = S.ixSKU 
                           AND SL.ixLocation = '99' 
LEFT JOIN (SELECT OL.ixSKU AS SKU 
                , Qty.Qty AS Qty
                , SUM(ISNULL(OL.mExtendedPrice,0)) AS Sales 
           FROM tblOrderLine OL  
           LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
           LEFT JOIN (SELECT OL.ixSKU AS SKU
                           , SUM(ISNULL(OL.iQuantity,0)) AS Qty 
                      FROM tblOrderLine OL
                      LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder  
                      WHERE O.dtOrderDate BETWEEN DATEADD(mm,-1,GETDATE()) AND GETDATE() 
					    AND O.sOrderStatus = 'Shipped' 
					    AND O.sOrderType <> 'Internal' 
						AND O.sOrderChannel <> 'INTERNAL' 
						AND O.mMerchandise > 0 
						AND O.ixOrder NOT LIKE '%-%' 
					  GROUP BY OL.ixSKU 
					  ) Qty ON Qty.SKU = OL.ixSKU 
           WHERE O.dtOrderDate BETWEEN DATEADD(mm,-1,GETDATE()) AND GETDATE() 
             AND O.sOrderStatus = 'Shipped' 
             AND O.sOrderType <> 'Internal' 
             AND O.sOrderChannel <> 'INTERNAL' 
             AND O.mMerchandise > 0 
           GROUP BY OL.ixSKU
                  , Qty.Qty
           ) OMS ON OMS.SKU = S.ixSKU  --One Month Sales
LEFT JOIN (SELECT OL.ixSKU AS SKU 
                , Qty.Qty AS Qty
                , SUM(ISNULL(OL.mExtendedPrice,0)) AS Sales 
           FROM tblOrderLine OL  
           LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
           LEFT JOIN (SELECT OL.ixSKU AS SKU
                           , SUM(ISNULL(OL.iQuantity,0)) AS Qty 
                      FROM tblOrderLine OL
                      LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder  
                      WHERE O.dtOrderDate BETWEEN DATEADD(mm,-12,GETDATE()) AND GETDATE() 
					    AND O.sOrderStatus = 'Shipped' 
					    AND O.sOrderType <> 'Internal' 
						AND O.sOrderChannel <> 'INTERNAL' 
						AND O.mMerchandise > 0 
						AND O.ixOrder NOT LIKE '%-%' 
					  GROUP BY OL.ixSKU 
					  ) Qty ON Qty.SKU = OL.ixSKU 
           WHERE O.dtOrderDate BETWEEN DATEADD(mm,-12,GETDATE()) AND GETDATE() 
             AND O.sOrderStatus = 'Shipped' 
             AND O.sOrderType <> 'Internal' 
             AND O.sOrderChannel <> 'INTERNAL' 
             AND O.mMerchandise > 0 
           GROUP BY OL.ixSKU
                  , Qty.Qty
           ) TMS ON TMS.SKU = S.ixSKU  --Twelve Month Sales           
WHERE flgActive ='1' 
  AND dtDiscontinuedDate > GETDATE()   
  AND V.ixVendor NOT IN ('0999', '9999')
 -- AND S.ixSKU = '1011001110'                      


