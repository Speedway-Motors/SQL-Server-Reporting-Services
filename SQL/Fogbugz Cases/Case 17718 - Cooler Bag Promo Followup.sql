SELECT ixCustomer, 
	   ixOrder,
	   dtOrderDate	 
--DROP TABLE [SMITemp].dbo.ASC_17718_OriginalCustPool   	     
--INTO [SMITemp].dbo.ASC_17718_OriginalCustPool   
FROM tblOrder 
WHERE dtOrderDate BETWEEN '01/01/12' AND GETDATE() 
  AND sPromoApplied IN ('DT500', 'DT500H') 
  AND mMerchandise > 0

--SELECT * FROM [SMITemp].dbo.ASC_17718_OriginalCustPool  

SELECT OCP.ixCustomer 
     , COUNT (DISTINCT O.ixOrder) AS OrdCnt
     , SUM(ISNULL(O.mMerchandise,0)) AS Merch
     , SUM(ISNULL(O.mMerchandiseCost,0)) AS COGS
     , SUM(ISNULL(O.mPromoDiscount,0)) AS Discount 
FROM [SMITemp].dbo.ASC_17718_OriginalCustPool OCP
LEFT JOIN tblOrder O ON O.ixCustomer = OCP.ixCustomer
WHERE O.ixOrder NOT IN (SELECT OCP.ixOrder 
						FROM [SMITemp].dbo.ASC_17718_OriginalCustPool OCP
						) 
  AND O.dtOrderDate >= OCP.dtOrderDate	
  AND O.mMerchandise > 0 		
  AND O.sOrderStatus = 'Shipped'
  AND O.sOrderType <> 'Internal' 
  AND O.sOrderChannel <> 'INTERNAL' 			
GROUP BY OCP.ixCustomer