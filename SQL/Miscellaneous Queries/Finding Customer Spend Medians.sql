SELECT DISTINCT CM.ixCustomer 
     , CM.MedianMerch AS [0to12MoMedian] 
     , AVG(x.mMerchandise) AS [0to24MoMedian] 
INTO [SMITemp].dbo.ASC_LB_24MoCustMedian     -- DROP TABLE [SMITemp].dbo.ASC_LB_12MoCustMedian
FROM [SMITemp].dbo.ASC_LB_12MoCustMedian CM 
LEFT JOIN (SELECT ixCustomer 
           , mMerchandise
           , ROW_NUMBER() OVER (PARTITION BY ixCustomer
                                ORDER BY mMerchandise ASC, 
                                ixOrder ASC) AS RowAsc
           , ROW_NUMBER() OVER (PARTITION BY ixCustomer 
								ORDER BY mMerchandise DESC, 
								ixOrder DESC) AS RowDesc
      FROM  tblOrder O   
      WHERE dtOrderDate BETWEEN DATEADD(month, -24, GETDATE()) AND GETDATE() 
        AND sOrderStatus = 'Shipped' 
        AND sOrderType = 'Retail' 
        AND mMerchandise > 1 
	 ) x ON x.ixCustomer = CM.ixCustomer 
WHERE RowAsc IN (RowDesc, RowDesc -1, RowDesc + 1) 
 -- AND CM.ixCustomer = '641244'
GROUP BY CM.ixCustomer
       , CM.MedianMerch
ORDER BY CM.ixCustomer





SELECT DISTINCT CM.ixCustomer 
     , TFMCM.[0to12MoMedian] AS [0to12MoMedian] 
     , TFMCM.[0to24MoMedian] AS [0to24MoMedian] 
     , AVG(x.mMerchandise) AS [0to36MoMedian] 
INTO [SMITemp].dbo.ASC_LB_36MoCustMedian     -- DROP TABLE [SMITemp].dbo.ASC_LB_12MoCustMedian
FROM [SMITemp].dbo.ASC_LB_12MoCustMedian CM 
LEFT JOIN [SMITemp].dbo.ASC_LB_24MoCustMedian TFMCM ON TFMCM.ixCustomer = CM.ixCustomer 
LEFT JOIN (SELECT ixCustomer 
           , mMerchandise
           , ROW_NUMBER() OVER (PARTITION BY ixCustomer
                                ORDER BY mMerchandise ASC, 
                                ixOrder ASC) AS RowAsc
           , ROW_NUMBER() OVER (PARTITION BY ixCustomer 
								ORDER BY mMerchandise DESC, 
								ixOrder DESC) AS RowDesc
      FROM  tblOrder O   
      WHERE dtOrderDate BETWEEN DATEADD(month, -36, GETDATE()) AND GETDATE() 
        AND sOrderStatus = 'Shipped' 
        AND sOrderType = 'Retail' 
        AND mMerchandise > 1 
	 ) x ON x.ixCustomer = CM.ixCustomer 
WHERE RowAsc IN (RowDesc, RowDesc -1, RowDesc + 1) 
 -- AND CM.ixCustomer = '641244'
GROUP BY CM.ixCustomer
       , TFMCM.[0to12MoMedian]
       , TFMCM.[0to24MoMedian]
ORDER BY CM.ixCustomer



SELECT DISTINCT CM.ixCustomer 
     , TFMCM.[0to12MoMedian] AS [0to12MoMedian] 
     , TFMCM.[0to24MoMedian] AS [0to24MoMedian] 
     , TFMCM.[0to36MoMedian] AS [0to36MoMedian]
     , AVG(x.mMerchandise) AS [0to60MoMedian] 
INTO [SMITemp].dbo.ASC_LB_60MoCustMedian     -- DROP TABLE [SMITemp].dbo.ASC_LB_12MoCustMedian
FROM [SMITemp].dbo.ASC_LB_12MoCustMedian CM 
LEFT JOIN [SMITemp].dbo.ASC_LB_36MoCustMedian TFMCM ON TFMCM.ixCustomer = CM.ixCustomer 
LEFT JOIN (SELECT ixCustomer 
           , mMerchandise
           , ROW_NUMBER() OVER (PARTITION BY ixCustomer
                                ORDER BY mMerchandise ASC, 
                                ixOrder ASC) AS RowAsc
           , ROW_NUMBER() OVER (PARTITION BY ixCustomer 
								ORDER BY mMerchandise DESC, 
								ixOrder DESC) AS RowDesc
      FROM  tblOrder O   
      WHERE dtOrderDate BETWEEN DATEADD(month, -60, GETDATE()) AND GETDATE() 
        AND sOrderStatus = 'Shipped' 
        AND sOrderType = 'Retail' 
        AND mMerchandise > 1 
	 ) x ON x.ixCustomer = CM.ixCustomer 
WHERE RowAsc IN (RowDesc, RowDesc -1, RowDesc + 1) 
 -- AND CM.ixCustomer = '641244'
GROUP BY CM.ixCustomer
       , TFMCM.[0to12MoMedian]
       , TFMCM.[0to24MoMedian]
       , TFMCM.[0to36MoMedian]
ORDER BY CM.ixCustomer



select CM.*
     , Orders.OrdCnt 
from [SMITemp].dbo.ASC_LB_60MoCustMedian CM 
left join (SELECT DISTINCT ixCustomer 
                , COUNT(DISTINCT ixOrder) AS OrdCnt 
		   FROM tblOrder O 
		   WHERE dtOrderDate BETWEEN DATEADD(month, -60, GETDATE()) AND GETDATE() 
				AND sOrderStatus = 'Shipped' 
				AND sOrderType = 'Retail' 
				AND mMerchandise > 1 
		   GROUP BY ixCustomer
		  ) Orders ON Orders.ixCustomer = CM.ixCustomer 
ORDER BY Orders.OrdCnt DESC		  


SELECT * 
FROM tblOrder 
WHERE ixCustomer = '1378165'
  AND dtOrderDate BETWEEN DATEADD(month, -60, GETDATE()) AND GETDATE() 
				AND sOrderStatus = 'Shipped' 
				AND sOrderType = 'Retail' 
				AND mMerchandise > 1 
ORDER BY dtOrderDate		


SELECT * 
FROM [SMITemp].dbo.ASC_LB_60MoCustMedian  		