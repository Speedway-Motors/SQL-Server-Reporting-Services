
/******************************
***********************************

2011 DATA  + ADD IN ORDER CHANNELS
		  
******************************		  
*******************************/


--To create the final table where the information will be stored 
SELECT FYFT.ixCustomer
     , FYFT.MinGCOrderDate 
     , NULL AS GCOrderChannel
     , FYFT.TotalMerch
     , FYFT.TotalMerchCost
     , FYFT.MinNextOrderDate 
     , NULL AS NextOrderChannel
     , FYFT.NextOrderMerch
     , FYFT.NextOrderMerchCost
--DROP TABLE ASC_17139_GC_AnalysisFollowup      
--INTO ASC_17139_GC_AnalysisFollowup
FROM dbo.ASC_16868_2011FinalTable FYFT

--To determine order channels for the initial gift card orders 
SELECT FYFT.ixCustomer --1265
     , MIN(O.sOrderChannel) AS GCOrderChannel --To eliminate duplicate rows for customer; most customers used same order channel
--DROP TABLE ASC_17139_FYGCOrderChannel   
--INTO ASC_17139_FYGCOrderChannel     
FROM dbo.ASC_16868_2011FinalTable FYFT
LEFT JOIN [SMI Reporting].dbo.tblOrder O ON O.ixCustomer = FYFT.ixCustomer 
WHERE FYFT.MinGCOrderDate = O.dtOrderDate 
GROUP BY FYFT.ixCustomer
--ORDER BY GCOrderChannel

--To update the value of order channel for the initial gift card order 
UPDATE A
SET GCOrderChannel = B.GCOrderChannel
FROM ASC_17139_GC_AnalysisFollowup A
JOIN ASC_17139_FYGCOrderChannel B ON A.ixCustomer = B.ixCustomer 

SELECT *
FROM ASC_17139_GC_AnalysisFollowup
ORDER BY GCOrderChannel

--To determine order channels for the next order placed by the customer  
SELECT FYFT.ixCustomer --779
     , MIN(O.sOrderChannel) AS NextOrderChannel --To eliminate duplicate rows for customer; most customers used same order channel
--DROP TABLE ASC_17139_FYNextOrderChannel   
--INTO ASC_17139_FYNextOrderChannel     
FROM dbo.ASC_16868_2011FinalTable FYFT
LEFT JOIN [SMI Reporting].dbo.tblOrder O ON O.ixCustomer = FYFT.ixCustomer 
WHERE FYFT.MinNextOrderDate = O.dtOrderDate 
GROUP BY FYFT.ixCustomer
--ORDER BY NextOrderChannel

--To update the value of order channel for the initial gift card order 
UPDATE A
SET NextOrderChannel = B.NextOrderChannel
FROM ASC_17139_GC_AnalysisFollowup A
JOIN ASC_17139_FYNextOrderChannel B ON A.ixCustomer = B.ixCustomer 

SELECT *
FROM ASC_17139_GC_AnalysisFollowup
ORDER BY NextOrderChannel

/********************************
   GIFT CARD REDEMPTION INFO
********************************/

-- GC sold during the 2011 timeframe

SELECT GCM.ixGiftCard -- 1,386
     , GCM.ixOrder
     , GCM.mAmountIssued
     , GCM.mAmountOutstanding
     , O.ixCustomer
     , O.sOrderChannel
FROM [SMI Reporting].dbo.tblGiftCardMaster GCM
JOIN [SMI Reporting].dbo.tblOrder O ON O.ixOrder = GCM.ixOrder
WHERE O.dtOrderDate BETWEEN '11/01/2011' AND '12/16/2011'
  AND O.sOrderStatus = 'Shipped'
  AND O.sOrderType NOT IN ('Internal', 'Customer Service')
  AND O.sOrderChannel NOT IN ('INTERNAL', 'TRADESHOW')
  AND O.mMerchandise > 0 
  AND O.ixCustomer NOT IN ('707952', '1034425')
ORDER BY sOrderChannel, mAmountOutstanding
    
-- GC sold during 2011 timeframe that were partially or fully used
SELECT GCM.ixGiftCard --  1,044 
     , GCM.ixOrder
     , GCM.mAmountIssued
     , GCM.mAmountOutstanding
     , O.ixCustomer
     , O.sOrderChannel
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

2012 DATA  + ADD IN ORDER CHANNELS
		  
******************************		  
*******************************/


--To create the final table where the information will be stored 
SELECT TYFT.ixCustomer
     , TYFT.MinGCOrderDate 
     , NULL AS GCOrderChannel
     , TYFT.TotalMerch
     , TYFT.TotalMerchCost
     , TYFT.MinNextOrderDate 
     , NULL AS NextOrderChannel
     , TYFT.NextOrderMerch
     , TYFT.NextOrderMerchCost
--DROP TABLE ASC_17139_2012_GC_AnalysisFollowup      
--INTO ASC_17139_2012_GC_AnalysisFollowup
FROM dbo.ASC_16868_2012FinalTable TYFT

--To determine order channels for the initial gift card orders 
SELECT TYFT.ixCustomer --1118
     , MIN(O.sOrderChannel) AS GCOrderChannel --To eliminate duplicate rows for customer; most customers used same order channel
--DROP TABLE ASC_17139_TYGCOrderChannel   
--INTO ASC_17139_TYGCOrderChannel     
FROM dbo.ASC_16868_2012FinalTable TYFT
LEFT JOIN [SMI Reporting].dbo.tblOrder O ON O.ixCustomer = TYFT.ixCustomer 
WHERE TYFT.MinGCOrderDate = O.dtOrderDate 
GROUP BY TYFT.ixCustomer
--ORDER BY GCOrderChannel

--To update the value of order channel for the initial gift card order 
UPDATE A
SET GCOrderChannel = B.GCOrderChannel
FROM ASC_17139_2012_GC_AnalysisFollowup A
JOIN ASC_17139_TYGCOrderChannel B ON A.ixCustomer = B.ixCustomer 

SELECT *
FROM ASC_17139_2012_GC_AnalysisFollowup
ORDER BY GCOrderChannel

--To determine order channels for the next order placed by the customer  
SELECT TYFT.ixCustomer --264
     , MIN(O.sOrderChannel) AS NextOrderChannel --To eliminate duplicate rows for customer; most customers used same order channel
--DROP TABLE ASC_17139_TYNextOrderChannel   
--INTO ASC_17139_TYNextOrderChannel     
FROM dbo.ASC_16868_2012FinalTable TYFT
LEFT JOIN [SMI Reporting].dbo.tblOrder O ON O.ixCustomer = TYFT.ixCustomer 
WHERE TYFT.MinNextOrderDate = O.dtOrderDate 
GROUP BY TYFT.ixCustomer
--ORDER BY NextOrderChannel

--To update the value of order channel for the initial gift card order 
UPDATE A
SET NextOrderChannel = B.NextOrderChannel
FROM ASC_17139_2012_GC_AnalysisFollowup A
JOIN ASC_17139_TYNextOrderChannel B ON A.ixCustomer = B.ixCustomer 

SELECT *
FROM ASC_17139_2012_GC_AnalysisFollowup
ORDER BY NextOrderChannel



-- Numbers Check 2011
SELECT *
FROM dbo.ASC_17139_GC_AnalysisFollowup
ORDER BY NextOrderChannel DESC

-- Numbers Check 2012
SELECT *
FROM dbo.ASC_17139_2012_GC_AnalysisFollowup
ORDER BY NextOrderChannel DESC


/********************************
   GIFT CARD REDEMPTION INFO
********************************/

-- GC sold during the 2012 timeframe

SELECT GCM.ixGiftCard -- 1,282
     , GCM.ixOrder
     , GCM.mAmountIssued
     , GCM.mAmountOutstanding
     , O.ixCustomer
     , O.sOrderChannel
FROM [SMI Reporting].dbo.tblGiftCardMaster GCM
JOIN [SMI Reporting].dbo.tblOrder O ON O.ixOrder = GCM.ixOrder
WHERE O.dtOrderDate BETWEEN '11/01/2012' AND '12/16/2012'
  AND O.sOrderStatus = 'Shipped'
  AND O.sOrderType NOT IN ('Internal', 'Customer Service')
  AND O.sOrderChannel NOT IN ('INTERNAL', 'TRADESHOW')
  AND O.mMerchandise > 0 
  AND O.ixCustomer NOT IN ('707952', '1034425')
ORDER BY sOrderChannel, mAmountOutstanding
    
-- GC sold during 2012 timeframe that were partially or fully used
SELECT GCM.ixGiftCard --  384 
     , GCM.ixOrder
     , GCM.mAmountIssued
     , GCM.mAmountOutstanding
     , O.ixCustomer
     , O.sOrderChannel
FROM [SMI Reporting].dbo.tblGiftCardMaster GCM
JOIN [SMI Reporting].dbo.tblOrder O ON O.ixOrder = GCM.ixOrder
WHERE O.dtOrderDate BETWEEN '11/01/2012' AND '12/16/2012'
  AND O.sOrderStatus = 'Shipped'
  AND O.sOrderType NOT IN ('Internal', 'Customer Service')
  AND O.sOrderChannel NOT IN ('INTERNAL', 'TRADESHOW')
  AND O.mMerchandise > 0 
  AND O.ixCustomer NOT IN ('707952', '1034425')         
  AND mAmountOutstanding <> mAmountIssued
ORDER BY sOrderChannel, mAmountOutstanding      

