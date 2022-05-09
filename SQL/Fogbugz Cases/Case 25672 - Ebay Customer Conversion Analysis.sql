SELECT RU.ixCustomer
     , MIN(dtOrderDate) dtFirstOrder
     , dtAccountCreateDate
     , DATEPART(year, dtAccountCreateDate) AS YearFirstOrder
     --, SUM(O.mMerchandise) AS FirstOrderSpend
     , RU.MLTotal MLTotal
   --  , NULL AS dtNextOrder
   --  , NULL AS ChannelNextOrder
  -- DROP TABLE [SMITemp].dbo.ASC_25672_EbayConversionAnalysis       
INTO [SMITemp].dbo.ASC_25672_EbayConversionAnalysis     
FROM dbo.tblCSTCustSummary_Rollup RU
LEFT JOIN tblOrder O ON O.ixCustomer = RU.ixCustomer
WHERE sOrderStatus = 'Shipped' 
  AND O.sOrderChannel = 'AUCTION' 
  AND O.sOrderType <> 'Internal' 
  --AND RU.ixCustomer = '2303047'
GROUP BY RU.ixCustomer
       , dtAccountCreateDate
       , MLTotal      
HAVING MIN(dtOrderDate) = dtAccountCreateDate

--56,135 

SELECT ECA.ixCustomer 
     , MIN(O.dtOrderDate) AS dtNextOrder
     , O.sOrderChannel AS NextOrderChannel
-- DROP TABLE [SMITemp].dbo.ASC_25672_EbayConversionPartTwo          
INTO [SMITemp].dbo.ASC_25672_EbayConversionPartTwo       
FROM tblOrder O 
  INNER JOIN [SMITemp].dbo.ASC_25672_EbayConversionAnalysis ECA 
 ON O.ixCustomer = ECA.ixCustomer
WHERE dtOrderDate <> dtFirstOrder
  AND sOrderStatus = 'Shipped' 
  AND sOrderType <> 'Internal' 
GROUP BY ECA.ixCustomer
       , sOrderChannel  

-- 16,214

UPDATE ECA 
SET ECA.dtNextOrder = PT.dtNextOrder
FROM [SMITemp].dbo.ASC_25672_EbayConversionPartTwo PT 
  INNER JOIN [SMITemp].dbo.ASC_25672_EbayConversionAnalysis ECA 
 ON PT.ixCustomer = ECA.ixCustomer 

--12,742
 
UPDATE ECA 
SET ECA.NextOrderChannel = PT.NextOrderChannel
FROM [SMITemp].dbo.ASC_25672_EbayConversionPartTwo PT 
  INNER JOIN [SMITemp].dbo.ASC_25672_EbayConversionAnalysis ECA 
 ON PT.ixCustomer = ECA.ixCustomer  

--12,742

SELECT COUNT(DISTINCT ECA.ixCustomer) AS NewEbayCustomers
     , YearFirstOrder
     , SUM(mMerchandise) / COUNT(DISTINCT ECA.ixCustomer) AS AOVLT
     , SUM(FirstOrderSpend) / COUNT(DISTINCT ECA.ixCustomer) AS AOVFO
FROM [SMITemp].dbo.ASC_25672_EbayConversionAnalysis  ECA 
LEFT JOIN tblOrder O ON O.ixCustomer = ECA.ixCustomer
WHERE O.sOrderStatus = 'Shipped'  
  AND O.sOrderType <> 'Internal' 
GROUP BY YearFirstOrder   
HAVING YearFirstOrder > 2010
ORDER BY YearFirstOrder           


SELECT YearFirstOrder
     , COUNT(NextOrderChannel) AS Cnt  
FROM [SMITemp].dbo.ASC_25672_EbayConversionAnalysis  ECA  
WHERE NextOrderChannel IS NOT NULL 
  AND NextOrderChannel = 'AUCTION'
GROUP BY YearFirstOrder   
HAVING YearFirstOrder > 2010
ORDER BY YearFirstOrder   


SELECT YearFirstOrder
     , COUNT(NextOrderChannel) AS Cnt  
FROM [SMITemp].dbo.ASC_25672_EbayConversionAnalysis  ECA  
WHERE NextOrderChannel IS NOT NULL 
  AND NextOrderChannel <> 'AUCTION'
GROUP BY YearFirstOrder   
HAVING YearFirstOrder > 2010
ORDER BY YearFirstOrder  



SELECT YearFirstOrder
     , COUNT(*) AS Cnt  
FROM [SMITemp].dbo.ASC_25672_EbayConversionAnalysis  ECA  
WHERE NextOrderChannel IS NULL 
GROUP BY YearFirstOrder   
HAVING YearFirstOrder > 2010
ORDER BY YearFirstOrder    


SELECT DISTINCT ECA.ixCustomer
     , dtFirstOrder
     , YearFirstOrder
     , SUM(mMerchandise) AS TotalSpend
     , FirstOrderSpend
     , dtNextOrder 
     , NextOrderChannel 
FROM [SMITemp].dbo.ASC_25672_EbayConversionAnalysis  ECA 
LEFT JOIN tblOrder O ON O.ixCustomer = ECA.ixCustomer
WHERE O.sOrderStatus = 'Shipped' 
  AND O.sOrderType <> 'Internal' 
GROUP BY ECA.ixCustomer
     , dtFirstOrder
     , YearFirstOrder
     , FirstOrderSpend
     , dtNextOrder 
     , NextOrderChannel  