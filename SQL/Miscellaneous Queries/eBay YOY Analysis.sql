
SELECT O.ixCustomer -- 15695
     , Auction
     , Counter
     , Other
     , Phone
     , Web
     , TotalOrders
FROM (SELECT DISTINCT ixCustomer
      FROM vwTABOrderMaster O 
      WHERE dtOrderDate BETWEEN '04/01/12' AND '03/31/13'
        AND dtOrderDate = FirstOrderDate
        AND sOrderChannel = 'AUCTION' 
        AND sOrderStatus = 'Shipped' 
      ) O 
LEFT JOIN (SELECT DISTINCT ixCustomer 
                , SUM(CASE WHEN O.sOrderChannel = 'AUCTION' THEN 1 
                           ELSE 0 
                      END) AS Auction 
                , SUM(CASE WHEN O.sOrderChannel = 'COUNTER' THEN 1 
                           ELSE 0 
                      END) AS Counter 
                , SUM(CASE WHEN O.sOrderChannel IN ('E-MAIL', 'FAX', 'MAIL') THEN 1 
                           ELSE 0 
                      END) AS Other
                , SUM(CASE WHEN O.sOrderChannel = 'PHONE' THEN 1 
                           ELSE 0 
                      END) AS Phone 
                , SUM(CASE WHEN O.sOrderChannel IN ('WEB', 'WEB-Mobile') THEN 1 
                           ELSE 0 
                      END) AS Web 
                , COUNT(DISTINCT O.ixOrder) AS TotalOrders                                                                                                               
           FROM vwTABOrderMaster O   
           WHERE dtOrderDate BETWEEN '04/01/12' AND '03/31/13'
             AND sOrderChannel <> 'INTERNAL'    
             AND dtOrderDate <> FirstOrderDate
             AND sOrderStatus = 'Shipped' 
           GROUP BY ixCustomer
           )  SO /*Second Order*/ ON SO.ixCustomer = O.ixCustomer
ORDER BY TotalOrders DESC           




SELECT O.ixCustomer -- 15695
     , Auction
     , Counter
     , Other
     , Phone
     , Web
     , TotalOrders
FROM (SELECT DISTINCT ixCustomer
      FROM vwTABOrderMaster O 
      WHERE dtOrderDate BETWEEN '04/01/12' AND '03/31/13'
        AND dtOrderDate = FirstOrderDate
        AND sOrderChannel = 'AUCTION' 
        AND sOrderStatus = 'Shipped' 
      ) O 
LEFT JOIN (SELECT DISTINCT ixCustomer 
                , SUM(CASE WHEN O.sOrderChannel = 'AUCTION' THEN mMerchandise 
                           ELSE 0 
                      END) AS Auction 
                , SUM(CASE WHEN O.sOrderChannel = 'COUNTER' THEN mMerchandise 
                           ELSE 0 
                      END) AS Counter 
                , SUM(CASE WHEN O.sOrderChannel IN ('E-MAIL', 'FAX', 'MAIL') THEN mMerchandise 
                           ELSE 0 
                      END) AS Other
                , SUM(CASE WHEN O.sOrderChannel = 'PHONE' THEN mMerchandise 
                           ELSE 0 
                      END) AS Phone 
                , SUM(CASE WHEN O.sOrderChannel IN ('WEB', 'WEB-Mobile') THEN mMerchandise 
                           ELSE 0 
                      END) AS Web 
                , SUM(mMerchandise) AS TotalOrders                                                                                                               
           FROM vwTABOrderMaster O   
           WHERE dtOrderDate BETWEEN '04/01/12' AND '03/31/13'
             AND sOrderChannel <> 'INTERNAL'    
             AND dtOrderDate <> FirstOrderDate
             AND sOrderStatus = 'Shipped' 
           GROUP BY ixCustomer
           )  SO /*Second Order*/ ON SO.ixCustomer = O.ixCustomer
ORDER BY TotalOrders DESC           
                      
                      
                      
SELECT SUM(mMerchandise) 
      FROM vwTABOrderMaster O 
      WHERE dtOrderDate BETWEEN '04/01/12' AND '03/31/13'
        AND dtOrderDate = FirstOrderDate
        AND sOrderChannel = 'AUCTION' 
        AND sOrderStatus = 'Shipped'      
          
        
--- '14-'15 = first time order revenue $1,894,365 (other revenue = $1,563,499)
--- '13-'14 = first time order revenue $1,800,758 (other revenue = $1,244,622)
        --- total growth of 5.2% on first time order revenue 

        
--- '14-'15 = total ebay revenue 3,457,864
--- '13-'14 = total ebay revenue 3,045,380    
        --- total growth of 13.5% 
        
        
                      





