SELECT * 
FROM tblPromoCodeMaster 
WHERE ixPromoCode LIKE '%RAD16%'

/*
ixPromoId	ixPromoCode		sDescription
926		RAD16			RAD 2016 10% Discount
927		RAD16H			Haggle for RAD 2016 10% Discount
*/ 

SELECT * 
FROM tblSourceCode
WHERE ixSourceCode LIKE 'RAD%' -- RAD0206

SELECT COUNT(DISTINCT ixOrder) -- 592 orders total 
FROM tblOrderPromoCodeXref
WHERE ixPromoId IN ('926', '927') 

SELECT * --COUNT(DISTINCT ixOrder) -- 586
FROM tblOrder 
WHERE sSourceCodeGiven = 'RAD0206' 
  AND sOrderStatus = 'Shipped' 
  AND mMerchandise > 0 
  


-- To generate Customer Data Sheet
SELECT DISTINCT O.ixCustomer 
     , C.dtAccountCreateDate
     , C.sCustomerFirstName + ' ' + C.sCustomerLastName
     , C.sEmailAddress
     , (CASE WHEN sMailingStatus IS NULL THEN 'OK to Mail' 
             WHEN sMailingStatus = 0 THEN 'OK to Mail' 
             ELSE 'Do NOT Mail' 
          END) AS sMailingStatus   
     , C.sMailToCOLine
     , C.sMailToStreetAddress1 + ' ' + ISNULL(C.sMailToStreetAddress2, '')
     , sMailToCity + ', ' + sMailToState + ' ' + sMailToZip
     , ISNULL(Xref.ixPromoId, 'NONE') AS ixPromoCode
     , ISNULL(O.sSourceCodeGiven, '') AS sSourceCodeGiven
     , O.ixOrder
     , O.dtOrderDate
     , O.mMerchandise
    -- , O.mMerchandiseCost
     , (O.mMerchandise - O.mMerchandiseCost) / (O.mMerchandise) AS 'GP%' 
FROM tblOrder O 
LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer 
FULL JOIN tblOrderPromoCodeXref Xref ON Xref.ixOrder = O.ixOrder 
--LEFT JOIN tblPromoCodeMaster PCM ON PCM.ixPromoId = Xref.ixPromoId  
WHERE O.sOrderStatus = 'Shipped' 
  AND (ixSourceCode = 'RAD0206' OR Xref.ixPromoId IN ('926', '927'))
  AND sOrderType <> 'Internal'  
  AND mMerchandise > 0 
ORDER BY ixCustomer 


-- To generate SKU Data Sheet from RAD16 Promo 
SELECT O.ixOrder 
     , OL.ixSKU 
     , ISNULL(S.sWebDescription, S.sDescription) AS Description 
     , SUM(iQuantity) AS QtySold
     , SUM(mExtendedPrice) AS Merch
     , SUM(mExtendedCost) AS Cost 
     , SL.iQAV 
     , dtDiscontinuedDate 
     , flgActive   
     , flgIsKit 
     , flgMadeToOrder
     , sSEMACategory
     , sSEMASubCategory
     , sSEMAPart  
FROM tblOrder O 
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
LEFT JOIN tblSKULocation SL ON SL.ixSKU = OL.ixSKU AND SL.ixLocation = 99 
LEFT JOIN tblOrderPromoCodeXref Xref ON Xref.ixOrder = O.ixOrder 
WHERE Xref.ixPromoId IN ('926', '927')   
  AND O.sOrderStatus = 'Shipped' 
  AND sOrderType <> 'Internal'  
  AND mMerchandise > 0 
  AND flgLineStatus IN ('Shipped', 'Dropshipped') 
  AND flgKitComponent = 0 
  AND flgIntangible = 0 
GROUP BY O.ixOrder 
       , OL.ixSKU 
       , ISNULL(S.sWebDescription, S.sDescription)
       , SL.iQAV 
       , dtDiscontinuedDate 
       , flgActive   
       , flgIsKit 
       , flgMadeToOrder
       , sSEMACategory
       , sSEMASubCategory
       , sSEMAPart 
ORDER BY O.ixOrder       
               


-- To generate SKU Data Sheet from RAD0206 SC that DID NOT Use Above Promo  
SELECT O.ixOrder  
     , OL.ixSKU 
     , ISNULL(S.sWebDescription, S.sDescription) AS Description 
     , SUM(iQuantity) AS QtySold
     , SUM(mExtendedPrice) AS Merch
     , SUM(mExtendedCost) AS Cost 
     , SL.iQAV 
     , dtDiscontinuedDate 
     , flgActive   
     , flgIsKit 
     , flgMadeToOrder
     , sSEMACategory
     , sSEMASubCategory
     , sSEMAPart  
FROM tblOrder O 
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
LEFT JOIN tblSKULocation SL ON SL.ixSKU = OL.ixSKU AND SL.ixLocation = 99 
LEFT JOIN tblOrderPromoCodeXref Xref ON Xref.ixOrder = O.ixOrder 
WHERE O.sSourceCodeGiven = 'RAD0206' 
  AND (Xref.ixPromoId NOT IN ('926', '927')  OR Xref.ixPromoId IS NULL) 
  AND O.sOrderStatus = 'Shipped' 
  AND sOrderType <> 'Internal'  
  AND mMerchandise > 0 
  AND flgLineStatus IN ('Shipped', 'Dropshipped') 
  AND flgKitComponent = 0 
  AND flgIntangible = 0 
GROUP BY O.ixOrder
       , OL.ixSKU 
       , ISNULL(S.sWebDescription, S.sDescription)
       , SL.iQAV 
       , dtDiscontinuedDate 
       , flgActive   
       , flgIsKit 
       , flgMadeToOrder
       , sSEMACategory
       , sSEMASubCategory
       , sSEMAPart
ORDER BY ixOrder       