

/*Order Channel Query*/

SELECT distinct sOrderChannel, 
       SUM(mMerchandise) as 'Merch$',
       SUM(mMerchandiseCost) as 'Merch$Cost',
      -- COUNT (DISTINCT ixOrder) as 'Order Count'
       SUM(case when O.ixOrder like '%-%' then 0 else 1 end) as 'Order Count'

FROM tblOrder

WHERE dtShippedDate BETWEEN '01/01/2010' and '12/31/2010'
  and sOrderStatus = 'Shipped'
  and sOrderType in ('Retail', 'MRR', 'PRS')
  and sOrderChannel in ('PHONE', 'WEB', 'AUCTION', 'COUNTER', 'MAIL', 'FAX')
  and mMerchandise > '0' 
  
GROUP BY sOrderChannel
                 
ORDER BY sOrderChannel
                
/*Source Code Type Query*/
        
SELECT distinct SC.sSourceCodeType,
       SUM(O.mMerchandise) as 'Merch$',
       SUM(O.mMerchandiseCost) as 'Merch$Cost',
      -- COUNT (DISTINCT ixOrder) as 'Order Count'
       SUM(case when O.ixOrder like '%-%' then 0 else 1 end) as 'Order Count'

FROM tblOrder O

JOIN tblSourceCode SC on SC.ixSourceCode = O.sSourceCodeGiven

WHERE O.dtShippedDate BETWEEN '01/01/2010' and '12/31/2010'
  and O.sOrderStatus = 'Shipped'
  and O.sOrderType in ('Retail', 'MRR', 'PRS')
  and O.sOrderChannel in ('PHONE', 'WEB', 'AUCTION', 'COUNTER', 'MAIL', 'FAX')
  and O.mMerchandise > '0' 
  
GROUP BY SC.sSourceCodeType
                 
ORDER BY SC.sSourceCodeType
      
/*Order Type Query*/

SELECT distinct sOrderType, 
       SUM(mMerchandise) as 'Merch$',
       SUM(mMerchandiseCost) as 'Merch$Cost',
     --  COUNT (DISTINCT ixOrder) as 'Order Count'
       SUM(case when O.ixOrder like '%-%' then 0 else 1 end) as 'Order Count'

FROM tblOrder

WHERE dtShippedDate BETWEEN '01/01/2010' and '12/31/2010'
  and sOrderStatus = 'Shipped'
  and sOrderType in ('Retail', 'MRR', 'PRS')
  and sOrderChannel in ('PHONE', 'WEB', 'AUCTION', 'COUNTER', 'MAIL', 'FAX')
  and mMerchandise > '0' 
  
GROUP BY sOrderType
                 
ORDER BY sOrderType
