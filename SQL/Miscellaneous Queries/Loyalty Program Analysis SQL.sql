SELECT DISTINCT O.ixCustomer 
INTO [SMITemp].dbo.ASC_LoyaltyProgramBase_080216
FROM tblOrder O
LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
WHERE dtOrderDate BETWEEN DATEADD(mm,-60,'08/01/16') AND '08/01/16'
  AND sOrderStatus = 'Shipped' 
  AND sOrderType = 'Retail' 
  AND mMerchandise > 1 
  AND C.flgDeletedFromSOP = 0 
  AND O.ixOrder NOT LIKE '%-%' 
  
SELECT * FROM [SMITemp].dbo.ASC_LoyaltyProgramBase_080216

UPDATE A 
set A.[0to12moOrders] = Y1.[0to12moOrders],
    A.[0to12moSales] = Y1.[0to12moSales],
	A.[0to12moCost] = Y1.[0to12moCost]
from [SMITemp].dbo.ASC_LoyaltyProgramBase_080216 A
 join (-- 0-12 months
	SELECT O.ixCustomer
	     , count(O.ixOrder) '0to12moOrders'
	     , SUM(O.mMerchandise) '0to12moSales'
	     , SUM(O.mMerchandiseCost) '0to12moCost' 
	FROM tblOrder O
	LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
	WHERE dtOrderDate BETWEEN DATEADD(mm,-12,'08/01/16') AND '08/01/16'
	AND sOrderStatus = 'Shipped' 
	AND sOrderType = 'Retail' 
	AND mMerchandise > 1 
	AND C.flgDeletedFromSOP = 0 
	AND O.ixOrder NOT LIKE '%-%'
	GROUP BY O.ixCustomer
	)Y1 on A.ixCustomer = Y1.ixCustomer
	
UPDATE A 
set A.[13to24moOrders] = Y2.[13to24moOrders],
    A.[13to24moSales] = Y2.[13to24moSales],
	A.[13to24moCost] = Y2.[13to24moCost]
from [SMITemp].dbo.ASC_LoyaltyProgramBase_080216 A
 join (-- 13to24 months
	SELECT O.ixCustomer
	     , count(O.ixOrder) '13to24moOrders'
	     , SUM(O.mMerchandise) '13to24moSales'
	     , SUM(O.mMerchandiseCost) '13to24moCost' 
	FROM tblOrder O
	LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
	WHERE dtOrderDate BETWEEN DATEADD(mm,-24,'08/01/16') AND DATEADD(mm,-13,'08/01/16')
	AND sOrderStatus = 'Shipped' 
	AND sOrderType = 'Retail' 
	AND mMerchandise > 1 
	AND C.flgDeletedFromSOP = 0 
	AND O.ixOrder NOT LIKE '%-%'
	GROUP BY O.ixCustomer
	)Y2 on A.ixCustomer = Y2.ixCustomer	
	
UPDATE A 
set A.[25to36moOrders] = Y3.[25to36moOrders],
    A.[25to36moSales] = Y3.[25to36moSales],
	A.[25to36moCost] = Y3.[25to36moCost]
from [SMITemp].dbo.ASC_LoyaltyProgramBase_080216 A
 join (-- 25to36 months
	SELECT O.ixCustomer
	     , count(O.ixOrder) '25to36moOrders'
	     , SUM(O.mMerchandise) '25to36moSales'
	     , SUM(O.mMerchandiseCost) '25to36moCost' 
	FROM tblOrder O
	LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
	WHERE dtOrderDate BETWEEN DATEADD(mm,-36,'08/01/16') AND DATEADD(mm,-25,'08/01/16')
	AND sOrderStatus = 'Shipped' 
	AND sOrderType = 'Retail' 
	AND mMerchandise > 1 
	AND C.flgDeletedFromSOP = 0 
	AND O.ixOrder NOT LIKE '%-%'
	GROUP BY O.ixCustomer
	)Y3 on A.ixCustomer = Y3.ixCustomer		
	
UPDATE A 
set A.[37to48moOrders] = Y4.[37to48moOrders],
    A.[37to48moSales] = Y4.[37to48moSales],
	A.[37to48moCost] = Y4.[37to48moCost]
from [SMITemp].dbo.ASC_LoyaltyProgramBase_080216 A
 join (-- 37to48 months
	SELECT O.ixCustomer
	     , count(O.ixOrder) '37to48moOrders'
	     , SUM(O.mMerchandise) '37to48moSales'
	     , SUM(O.mMerchandiseCost) '37to48moCost' 
	FROM tblOrder O
	LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
	WHERE dtOrderDate BETWEEN DATEADD(mm,-48,'08/01/16') AND DATEADD(mm,-37,'08/01/16')
	AND sOrderStatus = 'Shipped' 
	AND sOrderType = 'Retail' 
	AND mMerchandise > 1 
	AND C.flgDeletedFromSOP = 0 
	AND O.ixOrder NOT LIKE '%-%'
	GROUP BY O.ixCustomer
	)Y4 on A.ixCustomer = Y4.ixCustomer		
	

UPDATE A 
set A.[49to60moOrders] = Y5.[49to60moOrders],
    A.[49to60moSales] = Y5.[49to60moSales],
	A.[49to60moCost] = Y5.[49to60moCost]
from [SMITemp].dbo.ASC_LoyaltyProgramBase_080216 A
 join (-- 49to60 months
	SELECT O.ixCustomer
	     , count(O.ixOrder) '49to60moOrders'
	     , SUM(O.mMerchandise) '49to60moSales'
	     , SUM(O.mMerchandiseCost) '49to60moCost' 
	FROM tblOrder O
	LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
	WHERE dtOrderDate BETWEEN DATEADD(mm,-60,'08/01/16') AND DATEADD(mm,-49,'08/01/16')
	AND sOrderStatus = 'Shipped' 
	AND sOrderType = 'Retail' 
	AND mMerchandise > 1 
	AND C.flgDeletedFromSOP = 0 
	AND O.ixOrder NOT LIKE '%-%'
	GROUP BY O.ixCustomer
	)Y5 on A.ixCustomer = Y5.ixCustomer			
	
SELECT * FROM [SMITemp].dbo.ASC_LoyaltyProgramBase_080216	
	
UPDATE A 
set A.flgActive = 1
from [SMITemp].dbo.ASC_LoyaltyProgramBase_080216 A
 WHERE [0to12moOrders] IS NOT NULL 	
    
UPDATE A 
set A.flgActive = 0
from [SMITemp].dbo.ASC_LoyaltyProgramBase_080216 A
 WHERE [0to12moOrders] IS NULL 

UPDATE A 
set A.flgPotential = 1
from [SMITemp].dbo.ASC_LoyaltyProgramBase_080216 A
 WHERE [0to12moOrders] IS NULL 
    AND ([13to24moOrders] IS NOT NULL OR [25to36moOrders] IS NOT NULL)
    
UPDATE A 
set A.flgPotential = 0
from [SMITemp].dbo.ASC_LoyaltyProgramBase_080216 A
 WHERE [0to12moOrders] IS NOT NULL  	
	
UPDATE A 
set A.flgLapsed = 1
from [SMITemp].dbo.ASC_LoyaltyProgramBase_080216 A
 WHERE [0to12moOrders] IS NULL 
    AND [13to24moOrders] IS NULL 
    AND [25to36moOrders] IS NULL
    AND ([37to48moOrders] IS NOT NULL OR [49to60moOrders] IS NOT NULL) 	
    
UPDATE A 
set A.flgLapsed = 0
from [SMITemp].dbo.ASC_LoyaltyProgramBase_080216 A
 WHERE [0to12moOrders] IS NOT NULL 
    OR [13to24moOrders] IS NOT NULL 
    OR [25to36moOrders] IS NOT NULL
    

UPDATE A 
set A.flgEmailonFile = C.flgEmailonFile
from [SMITemp].dbo.ASC_LoyaltyProgramBase_080216 A
 join (
	SELECT DISTINCT ixCustomer
	     , (CASE WHEN sEmailAddress IS NOT NULL THEN '1'
	          ELSE '0' 
	        END) AS flgEmailonFile  
	FROM tblCustomer C 
	)C on A.ixCustomer = C.ixCustomer	    
	
SELECT * 
FROM [SMITemp].dbo.ASC_LoyaltyProgramBase_080216	
WHERE flgActive = 1
	