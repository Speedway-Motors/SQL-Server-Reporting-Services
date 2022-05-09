--SELECT DISTINCT ixCustomer --8078 rows
----DROP TABLE [SMITemp].dbo.ASC_17348_75MileRadiusBuyers 
----INTO [SMITemp].dbo.ASC_17348_75MileRadiusBuyers 
--FROM [SMITemp].dbo.ASC_17348_75MileRadiusZips ZIP
--LEFT JOIN tblCustomer C ON C.sMailToZip = ZIP.sMailToZip
--WHERE ixCustomer IN (SELECT O.ixCustomer 
--					 FROM tblOrder O 
--					 WHERE dtOrderDate BETWEEN DATEADD(yy,-2,GETDATE()) AND GETDATE() 
--					   AND O.sOrderType <> 'Internal'
--					   AND O.sOrderChannel <> 'INTERNAL' 
--					   AND O.sOrderStatus = 'Shipped'
--					   AND O.mMerchandise > 0
--					 )
					 
SELECT BUY.ixCustomer 
     , HIST.Name
     , HIST.Email
     , HIST.Phone
     , HIST.TotalMerch
     , HIST.RaceMerch
     , HIST.MMMerch
FROM [SMITemp].dbo.ASC_17348_75MileRadiusBuyers BUY			 
LEFT JOIN (SELECT O.ixCustomer AS ixCustomer
                , ISNULL(C.sCustomerFirstName, ' ') + ' ' + ISNULL(C.sCustomerLastName, ' ') AS Name
                , ISNULL(C.sEmailAddress, ' ') AS Email
                , C.sDayPhone AS Phone
                , SUM(ISNULL(mMerchandise,0)) AS TotalMerch
                , ISNULL(RACE.RaceMerch,0) AS RaceMerch
                , ISNULL(MM.MMMerch,0) AS MMMerch
           FROM tblOrder O 
           LEFT JOIN (SELECT OL.ixCustomer AS ixCustomer
                           , SUM(ISNULL(mExtendedPrice,0)) AS RaceMerch
                      FROM tblOrderLine OL 
                      LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
                      LEFT JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC 
                      WHERE PGC.ixMarket IN ('R', 'SM')
                        AND OL.flgLineStatus <> 'Cancelled'
                        AND OL.dtOrderDate BETWEEN DATEADD(yy,-2,GETDATE()) AND GETDATE() 
                      GROUP BY OL.ixCustomer
                     ) RACE ON RACE.ixCustomer = O.ixCustomer
           LEFT JOIN (SELECT OL.ixCustomer AS ixCustomer
                           , SUM(ISNULL(mExtendedPrice,0)) AS MMMerch
                      FROM tblOrderLine OL 
                      LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
                      LEFT JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC 
                      WHERE PGC.ixMarket = ('B')
                        AND OL.flgLineStatus <> 'Cancelled'
                        AND OL.dtOrderDate BETWEEN DATEADD(yy,-2,GETDATE()) AND GETDATE() 
                      GROUP BY OL.ixCustomer
                     ) MM ON MM.ixCustomer = O.ixCustomer                     
           LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer   
                 --AND flgDeletedFromSOP = '0'
                 --AND sMailingStatus NOT IN ('7','8','9')       
           WHERE O.dtOrderDate BETWEEN DATEADD(yy,-2,GETDATE()) AND GETDATE() 
		     AND O.sOrderType <> 'Internal'
			 AND O.sOrderChannel <> 'INTERNAL' 
			 AND O.sOrderStatus = 'Shipped'
			 AND O.mMerchandise > 0  
		   GROUP BY O.ixCustomer 
                , ISNULL(C.sCustomerFirstName, ' ') + ' ' + ISNULL(C.sCustomerLastName, ' ') 
                , ISNULL(C.sEmailAddress, ' ') 
                , C.sDayPhone 
                , RACE.RaceMerch 
                , MM.MMMerch
		  ) HIST ON HIST.ixCustomer = BUY.ixCustomer  
		          
