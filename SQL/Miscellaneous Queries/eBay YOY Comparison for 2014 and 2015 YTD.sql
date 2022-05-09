SELECT DISTINCT D.iYear
     , D.iISOWeek
     , COUNT(DISTINCT O.ixOrder) AS OrdCnt 
     , SUM(mMerchandise)/COUNT(DISTINCT O.ixOrder) AS AOV
     , SUM(mMerchandise) AS Revenue
     , SUM(mMerchandise) - SUM(mMerchandiseCost) AS 'GM$' 
     , (SUM(mMerchandise) - SUM(mMerchandiseCost)) / SUM(mMerchandise) AS 'GM%' 
     , SUM(mMerchandise) - SUM(mMerchandiseCost) - (SUM(mShipping)*.75) - (SUM(mMerchandise)*.08) AS EstCM
     , COUNT(DISTINCT NEW.ixCustomer) AS NewCustCnt 
     , COUNT(DISTINCT NEXTORD.ixCustomer) AS NextOrdCustCnt
     , COUNT(DISTINCT ALLORD.ixCustomer) AS AllOrdCustCnt
     , COUNT(DISTINCT DS.ixOrder) DropshippedOrdCnt 
FROM tblOrder O 
LEFT JOIN tblDate D ON D.ixDate = O.ixOrderDate 
LEFT JOIN (SELECT DISTINCT ixCustomer  
           FROM [SMITemp].dbo.ASC_EbayConversionAnalysis ECA 
          ) NEW ON NEW.ixCustomer = O.ixCustomer
LEFT JOIN (SELECT DISTINCT ixCustomer 
		   FROM [SMITemp].dbo.ASC_EbayConversionAnalysis ECA 
		   WHERE dtNextOrder IS NOT NULL
		     AND NextOrderChannel <> 'AUCTION' 
		  ) NEXTORD ON NEXTORD.ixCustomer = O.ixCustomer    
LEFT JOIN (SELECT DISTINCT ECA.ixCustomer 
		   FROM [SMITemp].dbo.ASC_EbayConversionAnalysis ECA 
		   LEFT JOIN tblOrder O ON O.ixCustomer = ECA.ixCustomer 
		   WHERE dtNextOrder IS NOT NULL
		     AND (dtFirstOrder <> dtOrderDate AND dtNextOrder <> dtOrderDate)
		     AND sOrderChannel <> 'AUCTION'
		   ) ALLORD ON ALLORD.ixCustomer = O.ixCustomer
LEFT JOIN (SELECT DISTINCT ixOrder 
		   FROM tblOrderLine 
		   WHERE flgLineStatus = 'Dropshipped' 
		  ) DS ON DS.ixOrder = O.ixOrder		      		   
WHERE D.iYear IN ('2014', '2015') 
  AND D.iISOWeek BETWEEN '1' AND '52' 
  AND sOrderChannel = 'AUCTION'
GROUP BY D.iYear 
       , D.iISOWeek 
ORDER BY D.iISOWeek
       , D.iYear




-- DETERMINING EBAY NEW CUSTOMER AND CONVERSION RATES 


SELECT RU.ixCustomer
     , MIN(dtOrderDate) dtFirstOrder
     , dtAccountCreateDate
     , DATEPART(year, dtAccountCreateDate) AS YearFirstOrder
     --, SUM(O.mMerchandise) AS FirstOrderSpend
     , RU.MLTotal MLTotal
     , NULL AS dtNextOrder
     , NULL AS NextOrderChannel
  -- DROP TABLE [SMITemp].dbo.ASC_EbayConversionAnalysis       
INTO [SMITemp].dbo.ASC_EbayConversionAnalysis    
FROM dbo.tblCSTCustSummary_Rollup RU
LEFT JOIN tblOrder O ON O.ixCustomer = RU.ixCustomer
WHERE sOrderStatus = 'Shipped' 
  AND O.sOrderChannel = 'AUCTION' 
  AND O.sOrderType <> 'Internal' 
GROUP BY RU.ixCustomer
       , dtAccountCreateDate
       , MLTotal      
HAVING MIN(dtOrderDate) = dtAccountCreateDate
    -- 69,523 rows 
    
SELECT ECA.ixCustomer 
     , MIN(O.dtOrderDate) AS dtNextOrder
     , O.sOrderChannel AS NextOrderChannel
-- DROP TABLE [SMITemp].dbo.ASC_EbayConversionPartTwo          
INTO [SMITemp].dbo.ASC_EbayConversionPartTwo       
FROM tblOrder O 
  INNER JOIN [SMITemp].dbo.ASC_EbayConversionAnalysis ECA 
 ON O.ixCustomer = ECA.ixCustomer
WHERE dtOrderDate <> dtFirstOrder
  AND sOrderStatus = 'Shipped' 
  AND sOrderType <> 'Internal' 
GROUP BY ECA.ixCustomer
       , sOrderChannel      
    -- 21,210 rows
    
-- update ASC_EbayConversionAnalysis dtNextOrder to datetime and NextOrderChannel to varchar(10)    
UPDATE ECA 
SET ECA.dtNextOrder = PT.dtNextOrder
FROM [SMITemp].dbo.ASC_EbayConversionPartTwo PT 
  INNER JOIN [SMITemp].dbo.ASC_EbayConversionAnalysis ECA 
 ON PT.ixCustomer = ECA.ixCustomer            
   -- 16,467 rows

UPDATE ECA 
SET ECA.NextOrderChannel = PT.NextOrderChannel
FROM [SMITemp].dbo.ASC_EbayConversionPartTwo PT 
  INNER JOIN [SMITemp].dbo.ASC_EbayConversionAnalysis ECA 
 ON PT.ixCustomer = ECA.ixCustomer     
   -- 16,467 rows
      
SELECT * 
FROM [SMITemp].dbo.ASC_EbayConversionAnalysis ECA   
WHERE YearFirstOrder IN ('2014', '2015') -- 29,487