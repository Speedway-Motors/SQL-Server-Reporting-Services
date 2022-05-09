SELECT COUNT(DISTINCT F.ixCustomer) AS CustCnt
     , SUM([12MoMerch]) AS '12moMerch'
     , SUM(O.OrdCnt) AS '12moOrdCnt'
     , SUM(LTV.Merch) AS 'LTV' 
     , SUM(LTV.OrdCnt) AS 'LTOrdCnt' 
FROM [SMITemp].dbo.ASC_082316_12MOFile F 
LEFT JOIN tblCustomer C ON C.ixCustomer = F.ixCustomer 
LEFT JOIN (SELECT DISTINCT ixCustomer
                , COUNT(DISTINCT ixOrder) AS OrdCnt 
		   FROM tblOrder O 
		   WHERE ixCustomer IN (SELECT ixCustomer FROM [SMITemp].dbo.ASC_082316_12MOFile F) 
		     AND O.dtOrderDate BETWEEN DATEADD(mm, -12, GETDATE()) AND GETDATE()
		     AND O.sOrderStatus = 'Shipped'
		     AND O.sOrderType = 'Retail' 
		     AND O.sShipToCountry = 'US' 
		     AND O.mMerchandise > 1 
		     AND O.flgIsBackorder = 0 
		   GROUP BY ixCustomer
		   ) O ON O.ixCustomer = F.ixCustomer 	 
LEFT JOIN (SELECT DISTINCT ixCustomer
                , SUM(mMerchandise) AS Merch 
                , COUNT(DISTINCT ixOrder) AS OrdCnt 
		   FROM tblOrder O 
		   WHERE ixCustomer IN (SELECT ixCustomer FROM [SMITemp].dbo.ASC_082316_12MOFile F) 
		     AND O.sOrderStatus = 'Shipped'
		     AND O.sOrderType = 'Retail' 
		     AND O.sShipToCountry = 'US' 
		     AND O.mMerchandise > 1 
		   GROUP BY ixCustomer
		   ) LTV ON LTV.ixCustomer = F.ixCustomer 		     
WHERE 
F.ixCustomer IN (SELECT DISTINCT ixCustomer FROM [SMITemp].dbo.ASC_WebCustomerProjectFile)
--  AND 
 -- dtAccountCreateDate < DATEADD(mm, -12, GETDATE())
-- 30, 811 w/ project on file 
-- 242,876 in 12mo file 
-- 97.5M in 12mo file 
-- 15.5K project in 12mo file 
-- 10.5M project rev contribution 

