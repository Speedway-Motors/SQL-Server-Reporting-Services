SELECT * 
FROM tblPromoCodeMaster 
WHERE ixPromoCode LIKE '%RAD14%'

/*
ixPromoId	ixPromoCode		sDescription
424			RAD14			RAD 2014 10% Discount
462			RAD14H			Haggle for RAD 2014 10% Discount
463			RAD14E			EXTENDED RAD 2014 10% Discount
469			RAD14H			Haggle for RAD 2014 10% Discount Extended
*/ 

SELECT COUNT(*) -- 262 orders total 
FROM tblOrderPromoCodeXref
WHERE ixPromoId IN ('424', '462', '463', '469') 

-- To generate Customer Data Sheet
SELECT O.ixCustomer 
     , C.dtAccountCreateDate
     , C.sCustomerFirstName + ' ' + C.sCustomerLastName
     , C.sEmailAddress
    -- , flgMarketingEmailSubscription
     , sMailingStatus -- 12 have '9' DO NOT MAIL status 
   --  , flgDeletedFromSOP
     , C.sMailToCOLine
     , C.sMailToStreetAddress1 + ' ' + ISNULL(C.sMailToStreetAddress2, '')
     , sMailToCity + ', ' + sMailToState + ' ' + sMailToZip
     , PCM.ixPromoCode
     , O.ixOrder
     , O.dtOrderDate
     , O.mMerchandise
     , O.mMerchandiseCost
     , (O.mMerchandise - O.mMerchandiseCost) / (O.mMerchandise) AS 'GP%' 
FROM tblOrder O 
LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer 
LEFT JOIN tblOrderPromoCodeXref Xref ON Xref.ixOrder = O.ixOrder 
LEFT JOIN tblPromoCodeMaster PCM ON PCM.ixPromoId = Xref.ixPromoId  
WHERE Xref.ixPromoId IN ('424', '462', '463', '469')    
  AND O.sOrderStatus = 'Shipped' 
  AND sOrderType <> 'Internal'  
  AND mMerchandise > 0 
ORDER BY ixCustomer 


-- To generate SKU Data Sheet
SELECT OL.ixSKU 
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
WHERE Xref.ixPromoId IN ('424', '462', '463', '469')    
  AND O.sOrderStatus = 'Shipped' 
  AND sOrderType <> 'Internal'  
  AND mMerchandise > 0 
  AND flgLineStatus IN ('Shipped', 'Dropshipped') 
  AND flgKitComponent = 0 
  AND flgIntangible = 0 
GROUP BY OL.ixSKU 
       , ISNULL(S.sWebDescription, S.sDescription)
       , SL.iQAV 
       , dtDiscontinuedDate 
       , flgActive   
       , flgIsKit 
       , flgMadeToOrder
       , sSEMACategory
       , sSEMASubCategory
       , sSEMAPart         


-- To generate RAW DATA Sheet
SELECT O.ixCustomer 
     , C.dtAccountCreateDate
     , C.sCustomerFirstName 
     , C.sCustomerLastName
     , C.sEmailAddress
    -- , flgMarketingEmailSubscription
     , sMailingStatus -- 12 have '9' DO NOT MAIL status 
   --  , flgDeletedFromSOP
     , C.sMailToCOLine
     , C.sMailToStreetAddress1 
     , ISNULL(C.sMailToStreetAddress2, '')
     , sMailToCity 
     , sMailToState 
     , sMailToZip
     , PCM.ixPromoCode
     , O.ixOrder
     , O.dtOrderDate
     , OL.ixSKU 
     , S.sDescription 
     , iQuantity
     , mExtendedPrice
     , mExtendedCost      
FROM tblOrder O 
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer 
LEFT JOIN tblOrderPromoCodeXref Xref ON Xref.ixOrder = O.ixOrder 
LEFT JOIN tblPromoCodeMaster PCM ON PCM.ixPromoId = Xref.ixPromoId  
WHERE Xref.ixPromoId IN ('424', '462', '463', '469')    
  AND O.sOrderStatus = 'Shipped' 
  AND sOrderType <> 'Internal'  
  AND mMerchandise > 0 
  AND flgLineStatus IN ('Shipped', 'Dropshipped') 
  AND flgKitComponent = 0 
ORDER BY ixCustomer 