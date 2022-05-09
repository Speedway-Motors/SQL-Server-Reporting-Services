/*

-- Top Level Info 

SELECT DISTINCT ixOrder 
     , O.ixCustomer
     , sCustomerFirstName
     , sCustomerLastName
     , sEmailAddress
     , (CASE WHEN sMailingStatus IS NULL THEN 'OK to Mail' 
             WHEN sMailingStatus = 0 THEN 'OK to Mail' 
             ELSE 'Do NOT Mail' 
          END) AS sMailingStatus  
     , CONVERT(varchar(10), dtAccountCreateDate, 101) AS AccountCreateDate 
     , sShipToStreetAddress1 + ' ' + ISNULL(sShipToStreetAddress2, '') AS ShipToAddress 
     , sShipToCity
     , sShipToState
     , sShipToZip
     , ISNULL(sShipToCountry, 'US') AS ShipToCountry
     , iShipMethod
     , mMerchandise
     , (CASE WHEN mMerchandise = 0 THEN NULL ELSE  
		(mMerchandise - ISNULL(mMerchandiseCost, 0))/mMerchandise
		END) AS 'GM%' 
     , dtOrderDate
     , dtShippedDate
FROM tblOrder O -- 32,879
LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
WHERE dtOrderDate BETWEEN '01/01/14' AND '12/31/14' 
  AND sOrderChannel IN ('AUCTION', 'EBAY') 
  AND sOrderStatus = 'Shipped' 
  AND flgDeletedFromSOP = 0 
  
*/



/*
-- Detail level Info  

SELECT DISTINCT O.ixOrder 
     , O.ixCustomer
     , (CASE WHEN sMailingStatus IS NULL THEN 'OK to Mail' 
             WHEN sMailingStatus = 0 THEN 'OK to Mail' 
             ELSE 'Do NOT Mail' 
          END) AS sMailingStatus 
     , sShipToState
     , sShipToZip
     , OL.ixSKU 
     , S.sDescription AS SKUDescription
     , S.ixPGC
     , PGC.sDescription AS PGCDescription
     , PGC.ixMarket
     , S.ixBrand
     , B.sBrandDescription
     --, PL.ixProductLine
     --, PL.sTitle
     , sSEMACategory
     , sSEMASubCategory
     , sSEMAPart
     , (CASE WHEN flgIsKit = 1 THEN 'Y' 
            ELSE 'N' 
          END) AS KitSKU
     , OL.iQuantity
     , OL.mExtendedPrice
     , (CASE WHEN mExtendedPrice = 0 THEN NULL ELSE  
		(mExtendedPrice - ISNULL(mExtendedCost, 0))/mExtendedPrice
		END) AS 'GM%' 
     , O.dtOrderDate
     , O.dtShippedDate		
FROM tblOrder O -- 32,879
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
LEFT JOIN tblBrand B ON B.ixBrand = S.ixBrand
LEFT JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC
--LEFT JOIN tblProductLine PL ON PL.ixBrand = B.ixBrand
WHERE O.dtOrderDate BETWEEN '01/01/14' AND '12/31/14' 
  AND sOrderChannel IN ('AUCTION', 'EBAY') 
  AND sOrderStatus = 'Shipped' 
  AND flgLineStatus IN ('Shipped', 'Dropshipped') 
  AND flgKitComponent = 0 
  
*/



-- SKU Detail   
SELECT OL.ixSKU 
     , S.sDescription AS SKUDescription
     , S.ixPGC
     , PGC.sDescription AS PGCDescription
     , PGC.ixMarket
     , S.ixBrand
     , B.sBrandDescription
     , sSEMACategory
     , sSEMASubCategory
     , sSEMAPart
     , (CASE WHEN flgIsKit = 1 THEN 'Y' 
            ELSE 'N' 
          END) AS KitSKU
     , SUM(OL.iQuantity) AS Qty
     , SUM(OL.mExtendedPrice) AS Merch
     , (CASE WHEN SUM(mExtendedPrice) = 0 THEN NULL ELSE  
		(SUM(mExtendedPrice) - ISNULL(SUM(mExtendedCost), 0))/SUM(mExtendedPrice)
		END) AS 'GM%' 		
FROM tblOrder O -- 32,879
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
LEFT JOIN tblBrand B ON B.ixBrand = S.ixBrand
LEFT JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC
--LEFT JOIN tblProductLine PL ON PL.ixBrand = B.ixBrand
WHERE O.dtOrderDate BETWEEN '01/01/14' AND '12/31/14' 
  AND sOrderChannel IN ('AUCTION', 'EBAY') 
  AND sOrderStatus = 'Shipped' 
  AND flgLineStatus IN ('Shipped', 'Dropshipped') 
  AND flgKitComponent = 0 
GROUP BY OL.ixSKU 
     , S.sDescription 
     , S.ixPGC
     , PGC.sDescription 
     , PGC.ixMarket
     , S.ixBrand
     , B.sBrandDescription
     , sSEMACategory
     , sSEMASubCategory
     , sSEMAPart
     , (CASE WHEN flgIsKit = 1 THEN 'Y' 
            ELSE 'N' 
          END) 