SELECT SUM(mMerchandise) AS Sales 
     , COUNT(DISTINCT O.ixOrder) AS OrderCount 
     , sMatchbackSourceCode
FROM tblOrder O 
WHERE dtOrderDate BETWEEN '02/03/14' AND '03/16/14' 
  AND sMatchbackSourceCode LIKE '386%' 
  AND sMatchbackSourceCode NOT IN ('386004', '38609', '38610', '38612', '38614', '38615', '38661', '38670', '38698', '38699')
  AND O.sOrderChannel <> 'INTERNAL'
  AND O.sOrderStatus IN ('Shipped', 'Open') 
  AND O.sOrderType <> 'Internal'
GROUP BY sMatchbackSourceCode 
ORDER BY sMatchbackSourceCode   


SELECT SUM(mMerchandise) AS Sales 
     , COUNT(DISTINCT O.ixOrder) AS OrderCount 
     , sSourceCodeGiven
FROM tblOrder O 

WHERE dtOrderDate BETWEEN '02/03/14' AND '03/16/14' 
  AND sSourceCodeGiven LIKE '386%' 
  AND sSourceCodeGiven NOT IN ('386004', '38609', '38610', '38612', '38614', '38615', '38661', '38670', '38698', '38699')
  AND O.sOrderChannel <> 'INTERNAL'
  AND O.sOrderStatus IN ('Shipped', 'Open') 
  AND O.sOrderType <> 'Internal'
GROUP BY sSourceCodeGiven
ORDER BY sSourceCodeGiven   



SELECT SUM(mMerchandise) AS Sales 
     , COUNT(DISTINCT O.ixOrder) AS OrderCount 
     , CO.ixSourceCode
FROM tblCustomerOffer CO 
LEFT JOIN tblOrder O ON O.ixCustomer = CO.ixCustomer
WHERE CO.ixSourceCode IN ('38602', '38603', '38604', '38605', '38606', '38607', '38608', '38611', '38613'
                            , '38620', '38621', '38622', '38623', '38624', '38625', '38626', '38627', '38628') 
  AND dtOrderDate BETWEEN '02/03/14' AND '03/16/14'  
  AND O.sOrderChannel <> 'INTERNAL'
  AND O.sOrderStatus IN ('Shipped', 'Open') 
  AND O.sOrderType <> 'Internal'
GROUP BY CO.ixSourceCode
ORDER BY CO.ixSourceCode
                            
                      
