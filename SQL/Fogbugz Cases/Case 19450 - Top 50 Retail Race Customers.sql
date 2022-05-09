--SELECT DISTINCT C.ixCustomer 
--     , sCustomerFirstName
--     , sCustomerLastName 
--     , sMailToCity
--     , sMailToZip 
--     , sEmailAddress
--     , sDayPhone
--     , Buyers.OrdCnt
----INTO dbo.ASC_19450_RetailBuyerPool     
--FROM dbo.ASC_19450_200MileRadiusZip68528 Zip
--LEFT JOIN [SMI Reporting].dbo.tblCustomer C ON C.sMailToZip = Zip.ixZipCode 
--LEFT JOIN (SELECT DISTINCT ixCustomer 
--                , COUNT(DISTINCT ixOrder) AS OrdCnt 
--           FROM [SMI Reporting].dbo.tblOrder 
--           WHERE dtShippedDate BETWEEN DATEADD(year,-1,GETDATE()) AND '08/01/13'
--             AND sOrderStatus = 'Shipped' 
--             AND sOrderChannel <> 'INTERNAL'
--             AND sOrderType <> 'Internal'
--           GROUP BY ixCustomer 
--           ) Buyers ON Buyers.ixCustomer = C.ixCustomer 
--WHERE C.flgDeletedFromSOP = 0 
--  AND C.ixCustomerType = '1' 
--  AND Buyers.ixCustomer IS NOT NULL
  
SELECT BUY.* 
     , HIST.TotalMerch
     , HIST.RaceMerch
     , HIST.RaceOrdCnt
     , HIST.MMMerch
     , HIST.MMOrdCnt
FROM [SMITemp].dbo.ASC_19450_RetailBuyerPool BUY			 
LEFT JOIN (SELECT O.ixCustomer AS ixCustomer
                , SUM(ISNULL(mMerchandise,0)) AS TotalMerch
                , ISNULL(RACE.RaceMerch,0) AS RaceMerch
                , ISNULL(RACE.RaceOrdCnt,0) AS RaceOrdCnt
                , ISNULL(MM.MMMerch,0) AS MMMerch
                , ISNULL(MM.MMOrdCnt,0) AS MMOrdCnt
           FROM tblOrder O 
           LEFT JOIN (SELECT OL.ixCustomer AS ixCustomer
                           , SUM(ISNULL(mExtendedPrice,0)) AS RaceMerch
                           , COUNT(DISTINCT ixOrder) AS RaceOrdCnt
                      FROM tblOrderLine OL 
                      LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
                      LEFT JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC 
                      WHERE PGC.ixMarket IN ('R', 'SM')
                        AND OL.flgLineStatus <> 'Cancelled'
                        AND OL.dtOrderDate BETWEEN DATEADD(yy,-1,GETDATE()) AND '08/01/13' 
                      GROUP BY OL.ixCustomer
                     ) RACE ON RACE.ixCustomer = O.ixCustomer
           LEFT JOIN (SELECT OL.ixCustomer AS ixCustomer
                           , SUM(ISNULL(mExtendedPrice,0)) AS MMMerch
                           , COUNT(DISTINCT ixOrder) AS MMOrdCnt 
                      FROM tblOrderLine OL 
                      LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
                      LEFT JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC 
                      WHERE PGC.ixMarket = ('B')
                        AND OL.flgLineStatus <> 'Cancelled'
                        AND OL.dtOrderDate BETWEEN DATEADD(yy,-1,GETDATE()) AND '08/01/13' 
                      GROUP BY OL.ixCustomer
                     ) MM ON MM.ixCustomer = O.ixCustomer                          
           WHERE O.dtOrderDate BETWEEN DATEADD(yy,-1,GETDATE()) AND '08/01/13' 
		     AND O.sOrderType <> 'Internal'
			 AND O.sOrderChannel <> 'INTERNAL' 
			 AND O.sOrderStatus = 'Shipped' 
		   GROUP BY O.ixCustomer 
                  , ISNULL(RACE.RaceMerch,0) 
                  , ISNULL(RACE.RaceOrdCnt,0) 
                  , ISNULL(MM.MMMerch,0) 
                  , ISNULL(MM.MMOrdCnt,0) 
		  ) HIST ON HIST.ixCustomer = BUY.ixCustomer  
		          
  
  