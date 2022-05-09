SELECT ixOrder 
     , ixSKU
     , iQuantity
     , mUnitPrice
     , mExtendedPrice
FROM tblOrderLine
WHERE dtOrderDate BETWEEN '06/19/12' AND '06/23/12' 
  AND ixSKU IN ('9107207-RED-XL', '9107207-RED-S', '9107207-RED-M', '9107207-RED-L', '9107207-BLU-XL', '9107207-BLU-S', '9107207-BLU-M', '9107207-BLU-L',
                '9107207-BLK-XL', '9107207-BLK-S', '9107207-BLK-M', '9107207-BLK-L', '91032311-36', '91032311-34', '91032311-32', '91032311-30', '91015449-16',
                '91015449-14', '91015449-12', '910151-12', '91689400', '91089528', '91082004', '91074802', '91033045', '91031428', '91025610', '91015415',
                '91015348', '9002000', '5606021', '2103454')
  AND flgLineStatus = 'Shipped'                
ORDER BY ixOrder                
                
                   