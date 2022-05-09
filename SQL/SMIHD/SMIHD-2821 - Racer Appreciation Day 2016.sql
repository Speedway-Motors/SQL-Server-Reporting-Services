/*
SELECT DISTINCT ixCustomer 
INTO [SMITemp].dbo.ASC_RaceBanquet_QualifyingCustomers
-- DROP TABLE [SMITemp].dbo.ASC_RaceBanquet_QualifyingCustomers
FROM [SMITemp].dbo.ASC_RaceBanquet_ZipCodes ZIP 
LEFT JOIN tblCustomer C ON C.sMailToZip = ZIP.ixZipCode 
   --- 175,057
*/

/*
SELECT DISTINCT QC.ixCustomer 
INTO [SMITemp].dbo.ASC_RaceBanquet_QualifyingCustomersNarrowed
-- DROP TABLE [SMITemp].dbo.ASC_RaceBanquet_QualifyingCustomersNarrowed
FROM [SMITemp].dbo.ASC_RaceBanquet_QualifyingCustomers QC  -- 175,057
LEFT JOIN tblCustomer C ON C.ixCustomer = QC.ixCustomer 
WHERE QC.ixCustomer IN (SELECT DISTINCT O.ixCustomer 
                     FROM tblOrder O 
                     WHERE dtOrderDate BETWEEN DATEADD(yy,-1,GETDATE()) AND GETDATE() 
                       AND sOrderType = 'Retail' 
                       AND sOrderStatus = 'Shipped' 
                       AND O.mMerchandise > 0 -- 347,260
                    ) 
  AND C.ixCustomerType NOT IN ('30', '40', '6') 
  AND sMailingStatus NOT IN ('7', '8', '9') 
  AND flgDeletedFromSOP = 0  -- 20,351
*/ 

/*
SELECT QCN.ixCustomer 
     , HIST.TotalMerch
     , HIST.RaceMerch
     , HIST.MMMerch
INTO [SMITemp].dbo.ASC_RaceBanquet_FinalCustomerList   
-- DROP TABLE [SMITemp].dbo.ASC_RaceBanquet_FinalCustomerList   
FROM [SMITemp].dbo.ASC_RaceBanquet_QualifyingCustomersNarrowed QCN -- 29,961
LEFT JOIN (SELECT DISTINCT O.ixCustomer AS ixCustomer
                , ISNULL(AM.TotalMerch,0) AS TotalMerch
                , ISNULL(RACE.RaceMerch,0) AS RaceMerch
                , ISNULL(MM.MMMerch,0) AS MMMerch
           FROM tblOrder O 
           LEFT JOIN (SELECT DISTINCT OL.ixCustomer AS ixCustomer
                           , SUM(ISNULL(mExtendedPrice,0)) AS RaceMerch
                      FROM tblOrderLine OL 
                      LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
                      LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
                      LEFT JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC 
                      WHERE O.dtOrderDate BETWEEN DATEADD(yy,-1,GETDATE()) AND GETDATE()
                        AND O.sOrderStatus = 'Shipped'
                        AND O.sOrderType = 'Retail'
                        AND O.mMerchandise > 0 
                        AND PGC.ixMarket IN ('R', 'SM')
                        AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') 
                        AND OL.ixOrder NOT LIKE '%-%' 
                      GROUP BY OL.ixCustomer
                     ) RACE ON RACE.ixCustomer = O.ixCustomer
           LEFT JOIN (SELECT DISTINCT OL.ixCustomer AS ixCustomer
                           , SUM(ISNULL(mExtendedPrice,0)) AS MMMerch
                      FROM tblOrderLine OL 
                      LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder                       
                      LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
                      LEFT JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC 
                      WHERE O.dtOrderDate BETWEEN DATEADD(yy,-1,GETDATE()) AND GETDATE()
                        AND O.sOrderStatus = 'Shipped'
                        AND O.sOrderType = 'Retail'
                        AND O.mMerchandise > 0 
                        AND PGC.ixMarket = ('B')
                        AND OL.flgLineStatus IN ('Shipped', 'Dropshipped')
                        AND OL.ixOrder NOT LIKE '%-%'                         
                      GROUP BY OL.ixCustomer
                     ) MM ON MM.ixCustomer = O.ixCustomer      
           LEFT JOIN (SELECT DISTINCT O.ixCustomer AS ixCustomer
                           , SUM(ISNULL(mMerchandise,0)) AS TotalMerch
                      FROM tblOrder O 
                      WHERE O.dtOrderDate BETWEEN DATEADD(yy,-1,GETDATE()) AND GETDATE()
                        AND O.sOrderStatus = 'Shipped'
                        AND O.sOrderType = 'Retail'
                        AND O.mMerchandise > 0 
                      GROUP BY O.ixCustomer
                     ) AM ON AM.ixCustomer = O.ixCustomer                                         
           WHERE O.dtOrderDate BETWEEN DATEADD(yy,-1,GETDATE()) AND GETDATE() 
		     AND O.sOrderType = 'Retail'
			 AND O.sOrderStatus = 'Shipped'
			 AND O.mMerchandise > 0  
		   GROUP BY O.ixCustomer 
                  , ISNULL(AM.TotalMerch,0) 
                  , ISNULL(RACE.RaceMerch,0)  
                  , ISNULL(MM.MMMerch,0)  
		  ) HIST ON HIST.ixCustomer = QCN.ixCustomer  
WHERE HIST.TotalMerch > 0 
  AND (HIST.RaceMerch > 0 
         OR HIST.MMMerch > 0
        ) -- 15,055
*/ 

SELECT FCL.*
     , C.sEmailAddress
     , C.sCustomerFirstName
     , C.sCustomerLastName
     , C.sMailToStreetAddress1 + ' ' + ISNULL(sMailToStreetAddress2, '') AS StreetAddress 
     , C.sMailToCOLine
     , C.sMailToCity
     , C.sMailToState
     , C.sMailToZip
FROM [SMITemp].dbo.ASC_RaceBanquet_FinalCustomerList FCL
LEFT JOIN tblCustomer C ON C.ixCustomer = FCL.ixCustomer 
WHERE RaceMerch > 0 -- 11,790	
ORDER BY RaceMerch DESC  
			 					 
