--DOMINO

--PROMO CODE ORDER PULL

SELECT ixOrder
     , ixCustomer
     , sOrderType
     , sOrderChannel
     , sSourceCodeGiven
     , sMatchbackSourceCode
     , sPromoApplied
     , dtOrderDate
     , dtShippedDate
FROM tblOrder 
WHERE sPromoApplied IN 
                 ('GG52011', 'GG6311', 'GG6311H', 'GG7111'
                   , 'GG7111H', 'GG7811', 'GG7811H', 'GG81211', 'GG81211H'
                   , 'GG81911', 'GG81911H', 'GG82611', 'GG82611H', 'GG9211', 'GG9211H'
                   , 'GG91611', 'GG91611H', 'GG91611', 'GG91611H', 'GG93011', 'GG93011H'
                   , 'GG111811', 'GG111811H', 'GG112511', 'GG112511H')
  AND sOrderStatus = 'Shipped' 
  AND mMerchandise > '0'
  AND sOrderChannel <> 'INTERNAL'
  AND sOrderType <> 'Internal' 
ORDER BY ixOrder


--SOURCE CODE ORDER PULL

SELECT ixOrder
     , ixCustomer
     , sOrderType
     , sOrderChannel
     , sSourceCodeGiven
     , sMatchbackSourceCode
     , sPromoApplied
     , dtOrderDate
     , dtShippedDate
FROM tblOrder 
WHERE sMatchbackSourceCode IN 
                 ('305GG33', '310GG33', '312GG33', '314GG33', '318GG33'
                   , '305GG34', '312GG34', '314GG34', '318GG34', '305GG35', '312GG35', '314GG35'
                   , '318GG35', '305GG36', '312GG36', '314GG36', '318GG36', '305GG37', '313GG37'
                   , '316GG37', '319GG37', '305GG38', '313GG38', '316GG38', '319GG38', '305GG39'
                   , '313GG39', '316GG39', '319GG39', '305GG40', '313GG40', '316GG40', '319GG40'
                   , '30520', '31320', '31620', '32020', '30520', '31320', '31620', '32020'
                   , '305502', '313502', '316502', '32022', '305506', '313506', '316506', '32026'
                   , '325507', '313507', '323507', '32027' )
  AND sOrderStatus = 'Shipped' 
  AND mMerchandise > '0'
  AND sOrderChannel <> 'INTERNAL'
  AND sOrderType <> 'Internal' 
ORDER BY ixOrder
  
  