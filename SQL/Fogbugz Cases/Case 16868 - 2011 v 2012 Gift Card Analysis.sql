
/******************************
***********************************

		  2011 DATA  
		  
****************************		  
*******************************/


/******************************
      INITIAL Temp Table
   to achieve starting pool 
*******************************/

SELECT O.ixCustomer 
     , COUNT(OL.ixSKU) AS GCcount -- should sum 1,386 --1,388 true result
     , MIN(O.dtOrderDate) AS MinGCOrderDate 
     , SUM(O.mMerchandise) AS TotalMerch 
     , SUM(O.mMerchandiseCost) AS TotalMerchCost -- These will be SUMs of all orders placed in the given date range   
--DROP TABLE ASC_16868_2011InitialTable   
--INTO ASC_16868_2011InitialTable
FROM [SMI Reporting].dbo.tblOrder O
LEFT JOIN [SMI Reporting].dbo.tblOrderLine OL ON OL.ixOrder = O.ixOrder 
WHERE O.dtOrderDate BETWEEN '11/01/2011' AND '12/16/2011'
  AND O.sOrderStatus = 'Shipped'
  AND O.sOrderType NOT IN ('Internal','Customer Service')
  AND O.sOrderChannel NOT IN ('INTERNAL','TRADESHOW')
  AND O.mMerchandise > 0 
  AND (OL.ixSKU LIKE 'GIFT%' 
    OR OL.ixSKU = 'EGIFT'
       )
  AND O.ixCustomer NOT IN ('707952', '1034425')  
  
-- CHECK TO SEE IF NOT IN tblGiftCardMaster (GCM)    
  --AND O.ixOrder NOT IN (select ixOrder from  [SMI Reporting].dbo.tblGiftCardMaster)   
  
/* GCs NOT IN GCM

ixCustomer	GCcount	MinGCOrderDate	TotalMerch	TotalMerchCost
 148244		   1	  2011-12-12      25.00			0.00
 483030		   1	  2011-12-12      25.00			0.00
 1030928	   1	  2011-12-12      25.00			0.00
 704224		   1	  2011-12-12      25.00			0.00
 
*/

  AND O.ixOrder NOT IN ('4896740','4895740','4895749','4895742') -- Remove the above (4) orders since they are not in GCM
GROUP BY O.ixCustomer   
ORDER BY GCcount DESC

--Check final counts after inserting table to check against later 
SELECT COUNT(DISTINCT ixCustomer) 
FROM ASC_16868_2011InitialTable -- 1,265

/**********************************************************
                     2nd Temp Table
   We need to find the minimum order date of customers
  from the initial temp table AFTER their MinGCOrderDate
***********************************************************/

SELECT O.ixCustomer 
     , MIN(O.dtOrderDate) AS MinNextOrderDate 
--DROP TABLE ASC_16868_2011NextOrderDates   
--INTO ASC_16868_2011NextOrderDates 
FROM [SMI Reporting].dbo.tblOrder O
JOIN ASC_16868_2011InitialTable IT ON IT.ixCustomer = O.ixCustomer
WHERE O.dtOrderDate > IT.MinGCOrderDate
  AND O.sOrderStatus = 'Shipped'
  AND O.sOrderType NOT IN ('Internal','Customer Service')
  AND O.sOrderChannel NOT IN ('INTERNAL','TRADESHOW')
  AND O.mMerchandise > 0 
GROUP BY O.ixCustomer  
   
--Check final counts after inserting table to check against later 
SELECT COUNT(DISTINCT ixCustomer) 
FROM ASC_16868_2011NextOrderDates  -- 779 (customers who have ordered since the initial gift card purchase)


/**********************************************************
                3rd Temp Table =  Final Table
***********************************************************/

SELECT IT.ixCustomer
     , IT.MinGCOrderDate -- 1,265 distinct customers
     , IT.TotalMerch
     , IT.TotalMerchCost
     , NOD.MinNextOrderDate
     , NULL AS NextOrderMerch 
     , NULL AS NextOrderMerchCost -- <-- these two will be sums
--DROP TABLE ASC_16868_2011FinalTable      
--INTO ASC_16868_2011FinalTable  
FROM ASC_16868_2011InitialTable IT
LEFT JOIN ASC_16868_2011NextOrderDates NOD ON IT.ixCustomer = NOD.ixCustomer

/**********************************************************
                     4th Temp Table
   We need to find the SUM of the merchandise and cost
  from the MinNextOrderDate for each customers (i.e. a 
  customer may have placed multiple orders on that day)
***********************************************************/

SELECT O.ixCustomer
     , SUM(O.mMerchandise) AS NextOrderMerch 
     , SUM(O.mMerchandiseCost) AS NextOrderMerchCost
--DROP TABLE ASC_16868_2011NextOrderTotals      
--INTO ASC_16868_2011NextOrderTotals 
FROM [SMI Reporting].dbo.tblOrder O
JOIN ASC_16868_2011FinalTable FIN ON FIN.ixCustomer = O.ixCustomer
WHERE O.dtOrderDate = FIN.MinNextOrderDate
  AND O.sOrderStatus = 'Shipped'
  AND O.sOrderType NOT IN ('Internal','Customer Service')
  AND O.sOrderChannel NOT IN ('INTERNAL','TRADESHOW')
  AND O.mMerchandise > 0 
GROUP BY O.ixCustomer     

/**********************************************************
             Last Step: Update the NULL values
             in the Final Table to include the 
             found merchandise summaries above
***********************************************************/     

UPDATE A
SET NextOrderMerch = B.NextOrderMerch
  , NextOrderMerchCost = B.NextOrderMerchCost
FROM ASC_16868_2011FinalTable A
JOIN ASC_16868_2011NextOrderTotals  B ON A.ixCustomer = B.ixCustomer 

--Perform a few quick checks
SELECT * 
FROM  ASC_16868_2011FinalTable
ORDER BY NextOrderMerch DESC

SELECT * 
FROM ASC_16868_2011FinalTable 
WHERE MinGCOrderDate >= MinNextOrderDate
   

/********************************
   GIFT CARD REDEMPTION INFO
********************************/

-- GC sold during the 2011 timeframe

SELECT GCM.ixGiftCard -- 1,386
     , GCM.ixOrder
     , GCM.mAmountIssued
     , GCM.mAmountOutstanding
     , O.ixCustomer
FROM [SMI Reporting].dbo.tblGiftCardMaster GCM
JOIN [SMI Reporting].dbo.tblOrder O ON O.ixOrder = GCM.ixOrder
WHERE O.dtOrderDate BETWEEN '11/01/2011' AND '12/16/2011'
  AND O.sOrderStatus = 'Shipped'
  AND O.sOrderType NOT IN ('Internal', 'Customer Service')
  AND O.sOrderChannel NOT IN ('INTERNAL', 'TRADESHOW')
  AND O.mMerchandise > 0 
  AND O.ixCustomer NOT IN ('707952', '1034425')
ORDER BY mAmountOutstanding
    
-- GC sold during 2011 timeframe that were partially or fully used
SELECT GCM.ixGiftCard --  1,044 
     , GCM.ixOrder
     , GCM.mAmountIssued
     , GCM.mAmountOutstanding
     , O.ixCustomer
FROM [SMI Reporting].dbo.tblGiftCardMaster GCM
JOIN [SMI Reporting].dbo.tblOrder O ON O.ixOrder = GCM.ixOrder
WHERE O.dtOrderDate BETWEEN '11/01/2011' AND '12/16/2011'
  AND O.sOrderStatus = 'Shipped'
  AND O.sOrderType NOT IN ('Internal', 'Customer Service')
  AND O.sOrderChannel NOT IN ('INTERNAL', 'TRADESHOW')
  AND O.mMerchandise > 0 
  AND O.ixCustomer NOT IN ('707952', '1034425')         
  AND mAmountOutstanding <> mAmountIssued
ORDER BY mAmountOutstanding      




/******************************
***********************************

		  2012 DATA  
		  
****************************		  
*******************************/


/******************************
      INITIAL Temp Table
   to achieve starting pool 
*******************************/

SELECT O.ixCustomer 
     , COUNT(OL.ixSKU) AS GCcount -- should sum 1,282 --1,277 true result
     , MIN(O.dtOrderDate) AS MinGCOrderDate 
     , SUM(O.mMerchandise) AS TotalMerch 
     , SUM(O.mMerchandiseCost) AS TotalMerchCost -- These will be SUMs of all orders placed in the given date range   
--DROP TABLE ASC_16868_2012InitialTable   
--INTO ASC_16868_2012InitialTable
FROM [SMI Reporting].dbo.tblOrder O
LEFT JOIN [SMI Reporting].dbo.tblOrderLine OL ON OL.ixOrder = O.ixOrder 
WHERE O.dtOrderDate BETWEEN '11/01/2012' AND '12/16/2012'
  AND O.sOrderStatus = 'Shipped'
  AND O.sOrderType NOT IN ('Internal','Customer Service')
  AND O.sOrderChannel NOT IN ('INTERNAL','TRADESHOW')
  AND O.mMerchandise > 0 
  AND (OL.ixSKU LIKE 'GIFT%' 
    OR OL.ixSKU = 'EGIFT'
       )
  AND O.ixCustomer NOT IN ('707952', '1034425')  
  
-- CHECK TO SEE IF NOT IN tblGiftCardMaster (GCM)    
  --AND O.ixOrder NOT IN (select ixOrder from  [SMI Reporting].dbo.tblGiftCardMaster)   
  
/* GCs NOT IN GCM

NONE
 
*/

GROUP BY O.ixCustomer   
ORDER BY GCcount DESC

--Check final counts after inserting table to check against later 
SELECT COUNT(DISTINCT ixCustomer) 
FROM ASC_16868_2012InitialTable -- 1,118

/**********************************************************
                     2nd Temp Table
   We need to find the minimum order date of customers
  from the initial temp table AFTER their MinGCOrderDate
***********************************************************/

SELECT O.ixCustomer 
     , MIN(O.dtOrderDate) AS MinNextOrderDate 
--DROP TABLE ASC_16868_2012NextOrderDates   
--INTO ASC_16868_2012NextOrderDates 
FROM [SMI Reporting].dbo.tblOrder O
JOIN ASC_16868_2012InitialTable IT ON IT.ixCustomer = O.ixCustomer
WHERE O.dtOrderDate > IT.MinGCOrderDate
  AND O.sOrderStatus = 'Shipped'
  AND O.sOrderType NOT IN ('Internal','Customer Service')
  AND O.sOrderChannel NOT IN ('INTERNAL','TRADESHOW')
  AND O.mMerchandise > 0 
GROUP BY O.ixCustomer  
   
--Check final counts after inserting table to check against later 
SELECT COUNT(DISTINCT ixCustomer) 
FROM ASC_16868_2012NextOrderDates  -- 264 (customers who have ordered since the initial gift card purchase)


/**********************************************************
                3rd Temp Table =  Final Table
***********************************************************/

SELECT IT.ixCustomer
     , IT.MinGCOrderDate -- 1,118 distinct customers
     , IT.TotalMerch
     , IT.TotalMerchCost
     , NOD.MinNextOrderDate
     , NULL AS NextOrderMerch 
     , NULL AS NextOrderMerchCost -- <-- these two will be sums
--DROP TABLE ASC_16868_2012FinalTable      
--INTO ASC_16868_2012FinalTable  
FROM ASC_16868_2012InitialTable IT
LEFT JOIN ASC_16868_2012NextOrderDates NOD ON IT.ixCustomer = NOD.ixCustomer

/**********************************************************
                     4th Temp Table
   We need to find the SUM of the merchandise and cost
  from the MinNextOrderDate for each customers (i.e. a 
  customer may have placed multiple orders on that day)
***********************************************************/

SELECT O.ixCustomer
     , SUM(O.mMerchandise) AS NextOrderMerch 
     , SUM(O.mMerchandiseCost) AS NextOrderMerchCost
--DROP TABLE ASC_16868_2012NextOrderTotals      
--INTO ASC_16868_2012NextOrderTotals 
FROM [SMI Reporting].dbo.tblOrder O
JOIN ASC_16868_2012FinalTable FIN ON FIN.ixCustomer = O.ixCustomer
WHERE O.dtOrderDate = FIN.MinNextOrderDate
  AND O.sOrderStatus = 'Shipped'
  AND O.sOrderType NOT IN ('Internal','Customer Service')
  AND O.sOrderChannel NOT IN ('INTERNAL','TRADESHOW')
  AND O.mMerchandise > 0 
GROUP BY O.ixCustomer     

/**********************************************************
             Last Step: Update the NULL values
             in the Final Table to include the 
             found merchandise summaries above
***********************************************************/     

UPDATE A
SET NextOrderMerch = B.NextOrderMerch
  , NextOrderMerchCost = B.NextOrderMerchCost
FROM ASC_16868_2012FinalTable A
JOIN ASC_16868_2012NextOrderTotals  B ON A.ixCustomer = B.ixCustomer 

--Perform a few quick checks
SELECT * 
FROM  ASC_16868_2012FinalTable
ORDER BY NextOrderMerch DESC

SELECT * 
FROM ASC_16868_2012FinalTable 
WHERE MinGCOrderDate >= MinNextOrderDate
   

/********************************
   GIFT CARD REDEMPTION INFO
********************************/

-- GC sold during the 2012 timeframe

SELECT GCM.ixGiftCard -- 1,282
     , GCM.ixOrder
     , GCM.mAmountIssued
     , GCM.mAmountOutstanding
     , O.ixCustomer
FROM [SMI Reporting].dbo.tblGiftCardMaster GCM
JOIN [SMI Reporting].dbo.tblOrder O ON O.ixOrder = GCM.ixOrder
WHERE O.dtOrderDate BETWEEN '11/01/2012' AND '12/16/2012'
  AND O.sOrderStatus = 'Shipped'
  AND O.sOrderType NOT IN ('Internal', 'Customer Service')
  AND O.sOrderChannel NOT IN ('INTERNAL', 'TRADESHOW')
  AND O.mMerchandise > 0 
  AND O.ixCustomer NOT IN ('707952', '1034425')
ORDER BY mAmountOutstanding
    
-- GC sold during 2012 timeframe that were partially or fully used
SELECT GCM.ixGiftCard --  384 
     , GCM.ixOrder
     , GCM.mAmountIssued
     , GCM.mAmountOutstanding
     , O.ixCustomer
FROM [SMI Reporting].dbo.tblGiftCardMaster GCM
JOIN [SMI Reporting].dbo.tblOrder O ON O.ixOrder = GCM.ixOrder
WHERE O.dtOrderDate BETWEEN '11/01/2012' AND '12/16/2012'
  AND O.sOrderStatus = 'Shipped'
  AND O.sOrderType NOT IN ('Internal', 'Customer Service')
  AND O.sOrderChannel NOT IN ('INTERNAL', 'TRADESHOW')
  AND O.mMerchandise > 0 
  AND O.ixCustomer NOT IN ('707952', '1034425')         
  AND mAmountOutstanding <> mAmountIssued
ORDER BY mAmountOutstanding      



