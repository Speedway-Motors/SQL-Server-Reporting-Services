--SELECT DISTINCT ixCustomer --18678 rows
--     , ISNULL(C.sCustomerFirstName, ' ') AS FirstName
--     , ISNULL(C.sCustomerLastName, ' ') AS LastName
--     , ISNULL(C.sEmailAddress, ' ') AS Email
--     , C.sDayPhone AS Phone     
----DROP TABLE [SMITemp].dbo.ASC_20447_200MileRadiusBuyers  
--INTO [SMITemp].dbo.ASC_20447_200MileRadiusBuyers 
--FROM [SMITemp].dbo.ASC_20447_200miZipCodes ZIP
--LEFT JOIN tblCustomer C ON C.sMailToZip = ZIP.ixZipCode
--WHERE ixCustomer IN (SELECT DISTINCT O.ixCustomer 
--					 FROM tblOrder O 
--					 WHERE dtOrderDate BETWEEN DATEADD(yy,-2,GETDATE()) AND GETDATE() 
--					   AND O.sOrderType = 'Retail'
--					   AND O.sOrderChannel <> 'INTERNAL' 
--					   AND O.sOrderStatus = 'Shipped'
--					   AND O.mMerchandise > 0
--					 )
--  AND sCustomerType = 'Retail' --NOT IN ('MRR', 'PRS') 
--  AND sMailingStatus NOT IN ('7','8','9') 
--  AND flgDeletedFromSOP = 0 
--  AND ixCustomerType NOT IN ('30','40') 				 					 

					 
SELECT BUY.* 
     , HIST.TotalMerch
     , HIST.RaceMerch
     , HIST.MMMerch
FROM [SMITemp].dbo.ASC_20447_200MileRadiusBuyers BUY			 
LEFT JOIN (SELECT O.ixCustomer AS ixCustomer
                , SUM(ISNULL(mMerchandise,0)) AS TotalMerch
                , ISNULL(RACE.RaceMerch,0) AS RaceMerch
                , ISNULL(MM.MMMerch,0) AS MMMerch
           FROM tblOrder O 
           LEFT JOIN (SELECT OL.ixCustomer AS ixCustomer
                           , SUM(ISNULL(mExtendedPrice,0)) AS RaceMerch
                      FROM tblOrderLine OL 
                      LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
                      LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
                      LEFT JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC 
                      WHERE O.dtOrderDate BETWEEN DATEADD(yy,-2,GETDATE()) AND GETDATE()
                        AND O.sOrderStatus = 'Shipped'
                        AND O.sOrderType = 'Retail'
                        AND O.sOrderChannel <> 'INTERNAL' 
                        AND O.mMerchandise > 0 
                        AND PGC.ixMarket IN ('R', 'SM')
                        AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') 
                      GROUP BY OL.ixCustomer
                     ) RACE ON RACE.ixCustomer = O.ixCustomer
           LEFT JOIN (SELECT OL.ixCustomer AS ixCustomer
                           , SUM(ISNULL(mExtendedPrice,0)) AS MMMerch
                      FROM tblOrderLine OL 
                      LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder                       
                      LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
                      LEFT JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC 
                      WHERE O.dtOrderDate BETWEEN DATEADD(yy,-2,GETDATE()) AND GETDATE()
                        AND O.sOrderStatus = 'Shipped'
                        AND O.sOrderType = 'Retail'
                        AND O.sOrderChannel <> 'INTERNAL' 
                        AND O.mMerchandise > 0 
                        AND PGC.ixMarket = ('B')
                        AND OL.flgLineStatus IN ('Shipped', 'Dropshipped')
                      GROUP BY OL.ixCustomer
                     ) MM ON MM.ixCustomer = O.ixCustomer                        
           WHERE O.dtOrderDate BETWEEN DATEADD(yy,-2,GETDATE()) AND GETDATE() 
		     AND O.sOrderType = 'Retail'
			 AND O.sOrderChannel <> 'INTERNAL' 
			 AND O.sOrderStatus = 'Shipped'
			 AND O.mMerchandise > 0  
		   GROUP BY O.ixCustomer 
                , ISNULL(RACE.RaceMerch,0) 
                , ISNULL(MM.MMMerch,0)
		  ) HIST ON HIST.ixCustomer = BUY.ixCustomer  
ORDER BY RaceMerch DESC
       , TotalMerch DESC 		  



