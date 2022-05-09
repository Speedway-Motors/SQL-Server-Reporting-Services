SELECT COUNT(DISTINCT O.ixOrder) AS OrdCnt 
     , sOrderChannel
FROM tblOrder O 
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
WHERE O.dtOrderDate BETWEEN DATEADD(mm, -12, GETDATE()) AND GETDATE() 
  AND sOrderStatus = 'Shipped' 
  AND sOrderType = 'Retail' 
--  AND S.flgIntangible = 0 
--  AND flgKitComponent = 0 
  AND O.ixOrder IN (SELECT DISTINCT OL.ixOrder 
				    FROM tblOrderLine OL 
				    LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder
				    LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
				    WHERE O.dtOrderDate BETWEEN DATEADD(mm, -12, GETDATE()) AND GETDATE() 
					  AND sOrderStatus = 'Shipped' 
					  AND sOrderType = 'Retail' 
					  AND S.flgIntangible = 0 
					  AND flgKitComponent = 0 --460,179
				    GROUP BY OL.ixOrder
				    HAVING SUM(iQuantity) = 1 
				   )
GROUP BY sOrderChannel






-- Detail Data

SELECT O.ixOrder
     , OL.ixSKU
     , ISNULL(S.sWebDescription, S.sDescription) AS SKUDescription 
     , O.dtOrderDate
     , sOrderChannel
     , S.mPriceLevel1 AS Retail
     , OL.mUnitPrice AS AmtCharged 
     , O.mShipping 
     , (CASE WHEN R.Rate > R2.Rate THEN R.Rate
             WHEN R2.Rate > R.Rate THEN R2.Rate
             ELSE R.Rate
          END) AS UPSRateSOP 
     --, (CASE WHEN R.Rate > R3.Rate THEN R.Rate
     --        WHEN R3.Rate > R.Rate THEN R3.Rate
     --        ELSE R.Rate
     --     END) AS UPSRateCalc                  
     , S.dWeight
     , S.dDimWeight
     , ((iLength*iHeight*iWidth)/166.00) AS CalcDimWeight  
     , S.iHeight
     , S.iLength
     , S.iWidth
FROM tblOrder O 
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
LEFT JOIN [SMITemp].dbo.ASC_UPS_Zone4_Rates R ON R.Weight = (CEILING(S.dWeight))
LEFT JOIN [SMITemp].dbo.ASC_UPS_Zone4_Rates R2 ON R2.Weight = (CEILING(S.dDimWeight))
--LEFT JOIN [SMITemp].dbo.ASC_UPS_Zone4_Rates R3 ON R3.Weight = (CEILING((iLength*iHeight*iWidth)/166.00))
WHERE O.dtOrderDate BETWEEN DATEADD(mm, -12, GETDATE()) AND GETDATE() 
  AND sOrderStatus = 'Shipped' 
  AND sOrderType = 'Retail' 
  AND S.flgIntangible = 0 
  AND flgKitComponent = 0 
  AND O.iShipMethod IN (2, 9, 13,14,15,18,32)
  AND OL.ixSKU NOT IN (SELECT ixSKU FROM [SMITemp].dbo.ASC_UPS_LargePackageSurchargeSKUs) -- added per CCC's request 7/15
  AND S.flgAdditionalHandling = 0 -- added per CCC's request 7/15
  AND S.flgORMD = 0 -- added per CCC's request 7/15 
  AND O.iShipMethod IN (2, 9, 13,14,15,18,32)
  AND O.ixOrder IN (SELECT DISTINCT OL.ixOrder 
				    FROM tblOrderLine OL 
				    LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder
				    LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
				    WHERE O.dtOrderDate BETWEEN DATEADD(mm, -12, GETDATE()) AND GETDATE() 
					  AND sOrderStatus = 'Shipped'
					  AND O.ixOrder NOT LIKE '%-%' -- added per CCC's request 7/15
					  AND OL.ixSKU NOT IN (SELECT ixSKU FROM [SMITemp].dbo.ASC_UPS_LargePackageSurchargeSKUs) -- added per CCC's request 7/15
					  AND S.flgAdditionalHandling = 0 -- added per CCC's request 7/15
					  AND S.flgORMD = 0 -- added per CCC's request 7/15 
					  AND sOrderType = 'Retail' 
					  AND S.flgIntangible = 0 
					  AND flgKitComponent = 0 --460,179
					  AND O.iShipMethod IN (2, 9, 13,14,15,18,32)
				    GROUP BY OL.ixOrder
				    HAVING SUM(iQuantity) = 1 
				   )

