SELECT (CASE WHEN S.ixState IN ('CA', 'AZ', 'NM', 'TX', 'LA', 'MS', 'AL', 'FL', 'HI') THEN 'Warm'
             ELSE 'Cold'
       END) AS WeatherType
      , SourceCodeList.ixSourceCode
      , SourceCodeList.sDescription AS SourceDesc 
      , SourceCodeList.iQuantityPrinted AS QtyPrinted
      , AmountMailed.AmtMailed AS AmtOffered
      , SUM(ISNULL(O.mMerchandise,0)) AS MerchTotal 
     -- , SUM(ISNULL(O.mMerchandiseCost,0)) AS MerchCost
      , SUM(ISNULL(O.mMerchandise,0))  - SUM(ISNULL(O.mMerchandiseCost,0)) AS 'GM $'
      , COUNT(DISTINCT(SUBSTRING(O.ixOrder, 1, 7))) AS '# Orders'
FROM (SELECT ixCatalog
           , ixSourceCode
           , sDescription
           , iQuantityPrinted
      FROM tblSourceCode
      WHERE ixCatalog = '327'
          and ixSourceCode BETWEEN '32710' AND '32723'
       )SourceCodeList
LEFT JOIN tblOrder O on O.sMatchbackSourceCode = SourceCodeList.ixSourceCode
LEFT JOIN tblCatalogMaster CAT on SourceCodeList.ixCatalog = CAT.ixCatalog
JOIN tblStates S ON S.ixState = O.sShipToState
JOIN (SELECT (CASE WHEN S.ixState IN ('CA', 'AZ', 'NM', 'TX', 'LA', 'MS', 'AL', 'FL', 'HI') THEN 'Warm'
                   ELSE 'Cold'
              END) AS WeatherType
           , COUNT(DISTINCT CO.ixCustomer) AS AmtMailed
           , CO.ixSourceCode AS SourceCode
      FROM tblCustomerOffer CO
      JOIN tblCustomer C ON C.ixCustomer = CO.ixCustomer
      JOIN tblStates S ON S.ixState = C.sMailToState
      WHERE CO.sType = 'OFFER' 
        and CO.ixSourceCode BETWEEN '32710' AND '32723'
      GROUP BY (CASE WHEN S.ixState IN ('CA', 'AZ', 'NM', 'TX', 'LA', 'MS', 'AL', 'FL', 'HI') THEN 'Warm'
                     ELSE 'Cold'
                END) 
             , CO.ixSourceCode
      ) AmountMailed ON AmountMailed.SourceCode = SourceCodeList.ixSourceCode
                 AND AmountMailed.WeatherType = (CASE WHEN S.ixState IN ('CA', 'AZ', 'NM', 'TX', 'LA', 'MS', 'AL', 'FL', 'HI') THEN 'Warm'
                                                      ELSE 'Cold'
                                                 END)
WHERE ((O.dtOrderDate BETWEEN '11/14/11' AND '09/25/12') 
          OR O.dtOrderDate IS NULL)
  and (O.sOrderStatus NOT IN ('Cancelled', 'Pick Ticket') 
          OR O.sOrderStatus IS NULL)
  and (O.sOrderChannel <> 'INTERNAL' 
         OR O.sOrderChannel IS NULL)
  and (O.mMerchandise > 0 
         OR O.mMerchandise IS NULL)
  and (S.flgContiguous = '0'  OR S.flgNonContiguous = '0')
  and O.sShipToCountry = 'US'
GROUP BY (CASE WHEN S.ixState IN ('CA', 'AZ', 'NM', 'TX', 'LA', 'MS', 'AL', 'FL', 'HI') THEN 'Warm'
               ELSE 'Cold'
          END)
       , SourceCodeList.ixSourceCode
       , SourceCodeList.sDescription
       , SourceCodeList.iQuantityPrinted
       , AmountMailed.AmtMailed
ORDER BY (CASE WHEN S.ixState IN ('CA', 'AZ', 'NM', 'TX', 'LA', 'MS', 'AL', 'FL', 'HI') THEN 'Warm'
               ELSE 'Cold'
          END)
       , SourceCodeList.ixSourceCode
       
       
       
       
       
       
       
SELECT (CASE WHEN S.ixState IN ('CA', 'AZ', 'NM', 'TX', 'LA', 'MS', 'AL', 'FL', 'HI') THEN 'Warm'
             ELSE 'Cold'
       END) AS WeatherType
      , SourceCodeList.ixSourceCode
      , SourceCodeList.sDescription AS SourceDesc 
     -- , SourceCodeList.iQuantityPrinted AS QtyPrinted
      , AmountMailed.AmtMailed AS AmtOffered
      , SUM(ISNULL(O.mMerchandise,0)) AS MerchTotal 
     -- , SUM(ISNULL(O.mMerchandiseCost,0)) AS MerchCost
      , SUM(ISNULL(O.mMerchandise,0))  - SUM(ISNULL(O.mMerchandiseCost,0)) AS 'GM $'
      , COUNT(DISTINCT(SUBSTRING(O.ixOrder, 1, 7))) AS '# Orders'
FROM (SELECT ixCatalog
           , ixSourceCode
           , sDescription
           , iQuantityPrinted
      FROM tblSourceCode
      WHERE ixCatalog = '338'
          and ixSourceCode BETWEEN '33810' AND '33839'
       )SourceCodeList
LEFT JOIN tblOrder O on O.sMatchbackSourceCode = SourceCodeList.ixSourceCode
LEFT JOIN tblCatalogMaster CAT on SourceCodeList.ixCatalog = CAT.ixCatalog
JOIN tblStates S ON S.ixState = O.sShipToState
JOIN (SELECT (CASE WHEN S.ixState IN ('CA', 'AZ', 'NM', 'TX', 'LA', 'MS', 'AL', 'FL', 'HI') THEN 'Warm'
                   ELSE 'Cold'
              END) AS WeatherType
           , COUNT(DISTINCT CO.ixCustomer) AS AmtMailed
           , CO.ixSourceCode AS SourceCode
      FROM tblCustomerOffer CO
      JOIN tblCustomer C ON C.ixCustomer = CO.ixCustomer
      JOIN tblStates S ON S.ixState = C.sMailToState
      WHERE CO.sType = 'OFFER' 
        and CO.ixSourceCode BETWEEN '33810' AND '33839'
      GROUP BY (CASE WHEN S.ixState IN ('CA', 'AZ', 'NM', 'TX', 'LA', 'MS', 'AL', 'FL', 'HI') THEN 'Warm'
                     ELSE 'Cold'
                END) 
             , CO.ixSourceCode
      ) AmountMailed ON AmountMailed.SourceCode = SourceCodeList.ixSourceCode
                 AND AmountMailed.WeatherType = (CASE WHEN S.ixState IN ('CA', 'AZ', 'NM', 'TX', 'LA', 'MS', 'AL', 'FL', 'HI') THEN 'Warm'
                                                      ELSE 'Cold'
                                                 END)
WHERE ((O.dtOrderDate BETWEEN '02/06/12' AND '09/25/12') 
          OR O.dtOrderDate IS NULL)
  and (O.sOrderStatus NOT IN ('Cancelled', 'Pick Ticket') 
          OR O.sOrderStatus IS NULL)
  and (O.sOrderChannel <> 'INTERNAL' 
         OR O.sOrderChannel IS NULL)
  and (O.mMerchandise > 0 
         OR O.mMerchandise IS NULL)
  and (S.flgContiguous = '0'  OR S.flgNonContiguous = '0')
  and O.sShipToCountry = 'US'
GROUP BY (CASE WHEN S.ixState IN ('CA', 'AZ', 'NM', 'TX', 'LA', 'MS', 'AL', 'FL', 'HI') THEN 'Warm'
               ELSE 'Cold'
          END)
       , SourceCodeList.ixSourceCode
       , SourceCodeList.sDescription
       , AmountMailed.AmtMailed
ORDER BY (CASE WHEN S.ixState IN ('CA', 'AZ', 'NM', 'TX', 'LA', 'MS', 'AL', 'FL', 'HI') THEN 'Warm'
               ELSE 'Cold'
          END)
       , SourceCodeList.ixSourceCode
       
       
       

       
