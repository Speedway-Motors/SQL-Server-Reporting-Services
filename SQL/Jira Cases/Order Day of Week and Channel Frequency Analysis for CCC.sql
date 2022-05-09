-- ALL ORDER HISTORY

SELECT DISTINCT ixCustomer AS ixCustomer  -- 667845 customers
     , COUNT(DISTINCT ixOrder) AS iOrderCount -- 2910819 orders 
INTO [SMITemp].dbo.ASC_AllCustomersInTblOrder     
FROM tblOrder O 
WHERE O.sOrderStatus = 'Shipped' 
  AND O.sOrderType = 'Retail'
  AND O.sOrderChannel <> 'INTERNAL'
GROUP BY ixCustomer  

SELECT DISTINCT ACT.ixCustomer --662955 records 
     , ACT.iOrderCount 
     , MIN(O.ixOrderDate) AS ixFirstOrderDate
INTO [SMITemp].dbo.ASC_CustomersFirstOrderDate    
FROM [SMITemp].dbo.ASC_AllCustomersInTblOrder ACT 
LEFT JOIN tblOrder O ON O.ixCustomer = ACT.ixCustomer
WHERE O.sOrderStatus = 'Shipped' 
  AND O.sOrderType = 'Retail' 
  AND O.sOrderChannel <> 'INTERNAL' 
GROUP BY ACT.ixCustomer
       , ACT.iOrderCount  

SELECT DISTINCT CFO.ixCustomer
     , CFO.iOrderCount
     , CFO.ixFirstOrderDate
     , D.iDayOfWeek
     , D.sDayOfWeek 
     , MIN(CASE WHEN O.flgDeviceType = 'MOBILEDETECTED' THEN 'WEB-Mobile'
             WHEN O.flgDeviceType = 'MOBILEOVERRIDETOFULL' THEN 'WEB-Mobile'
             WHEN O.flgDeviceType = 'MOBILEOVERRIDETOMOBI' THEN 'WEB-Mobile'
             WHEN O.flgDeviceType = 'MOBILESITE' THEN 'WEB-Mobile'
             ELSE O.sOrderChannel
         END) AS sOrderChannel 
INTO [SMITemp].dbo.ASC_FirstOrderDayAndChannel          
FROM [SMITemp].dbo.ASC_CustomersFirstOrderDate CFO 
LEFT JOIN tblDate D ON D.ixDate = CFO.ixFirstOrderDate 
LEFT JOIN tblOrder O ON O.ixCustomer = CFO.ixCustomer AND O.ixOrderDate = CFO.ixFirstOrderDate
GROUP BY CFO.ixCustomer
     , CFO.iOrderCount
     , CFO.ixFirstOrderDate
     , D.iDayOfWeek
     , D.sDayOfWeek 
ORDER BY ixCustomer


SELECT SUM(CASE WHEN sOrderChannel = 1 THEN 1 
                ELSE 0 
           END) AS Mondays 
     , SUM(CASE WHEN sOrderChannel = 2 THEN 1 
                ELSE 0 
           END) AS Tuesdays 
     , SUM(CASE WHEN sOrderChannel = 3 THEN 1 
                ELSE 0 
           END) AS Wednesdays 
     , SUM(CASE WHEN sOrderChannel = 4 THEN 1 
                ELSE 0 
           END) AS Thursdays 
	 , SUM(CASE WHEN sOrderChannel = 5 THEN 1 
                ELSE 0 
           END) AS Fridays
	 , SUM(CASE WHEN sOrderChannel = 6 THEN 1 
                ELSE 0 
           END) AS Saturdays
	 , SUM(CASE WHEN sOrderChannel = 7 THEN 1 
                ELSE 0 
           END) AS Sundays                                                                             
FROM [SMITemp].dbo.ASC_FirstOrderDayAndChannel -- 662955 


-- 2013 ORDER HISTORY 
SELECT DISTINCT ixCustomer AS ixCustomer  -- 199941 customers
     , COUNT(DISTINCT ixOrder) AS iOrderCount -- 433841 orders 
INTO [SMITemp].dbo.ASC_AllCustomersInTblOrder2013     
FROM tblOrder O 
WHERE O.dtOrderDate BETWEEN '01/01/13' AND '12/31/13' 
  AND O.sOrderStatus = 'Shipped' 
  AND O.sOrderType = 'Retail'
  AND O.sOrderChannel <> 'INTERNAL'
GROUP BY ixCustomer  

SELECT DISTINCT ACT.ixCustomer --199941 records 
     , ACT.iOrderCount 
     , MIN(O.ixOrderDate) AS ixFirstOrderDate
INTO [SMITemp].dbo.ASC_CustomersFirstOrderDate2013    
FROM [SMITemp].dbo.ASC_AllCustomersInTblOrder2013 ACT 
LEFT JOIN tblOrder O ON O.ixCustomer = ACT.ixCustomer
WHERE O.sOrderStatus = 'Shipped' 
  AND O.sOrderType = 'Retail' 
  AND O.sOrderChannel <> 'INTERNAL' 
GROUP BY ACT.ixCustomer
       , ACT.iOrderCount  

SELECT DISTINCT CFO.ixCustomer
     , CFO.iOrderCount
     , CFO.ixFirstOrderDate
     , D.iDayOfWeek
     , D.sDayOfWeek 
     , MIN(CASE WHEN O.flgDeviceType = 'MOBILEDETECTED' THEN 'WEB-Mobile'
             WHEN O.flgDeviceType = 'MOBILEOVERRIDETOFULL' THEN 'WEB-Mobile'
             WHEN O.flgDeviceType = 'MOBILEOVERRIDETOMOBI' THEN 'WEB-Mobile'
             WHEN O.flgDeviceType = 'MOBILESITE' THEN 'WEB-Mobile'
             ELSE O.sOrderChannel
         END) AS sOrderChannel 
INTO [SMITemp].dbo.ASC_FirstOrderDayAndChannel2013          
FROM [SMITemp].dbo.ASC_CustomersFirstOrderDate2013 CFO 
LEFT JOIN tblDate D ON D.ixDate = CFO.ixFirstOrderDate 
LEFT JOIN tblOrder O ON O.ixCustomer = CFO.ixCustomer AND O.ixOrderDate = CFO.ixFirstOrderDate
GROUP BY CFO.ixCustomer
     , CFO.iOrderCount
     , CFO.ixFirstOrderDate
     , D.iDayOfWeek
     , D.sDayOfWeek 
ORDER BY ixCustomer


SELECT SUM(CASE WHEN iDayOfWeek = 1 THEN 1 
                ELSE 0 
           END) AS Mondays 
     , SUM(CASE WHEN iDayOfWeek = 2 THEN 1 
                ELSE 0 
           END) AS Tuesdays 
     , SUM(CASE WHEN iDayOfWeek = 3 THEN 1 
                ELSE 0 
           END) AS Wednesdays 
     , SUM(CASE WHEN iDayOfWeek = 4 THEN 1 
                ELSE 0 
           END) AS Thursdays 
	 , SUM(CASE WHEN iDayOfWeek = 5 THEN 1 
                ELSE 0 
           END) AS Fridays
	 , SUM(CASE WHEN iDayOfWeek = 6 THEN 1 
                ELSE 0 
           END) AS Saturdays
	 , SUM(CASE WHEN iDayOfWeek = 7 THEN 1 
                ELSE 0 
           END) AS Sundays                                                                             
FROM [SMITemp].dbo.ASC_FirstOrderDayAndChannel2013 -- 199941



SELECT SUM(CASE WHEN sOrderChannel = 'AUCTION' THEN 1 
                ELSE 0 
           END) AS Auction 
     , SUM(CASE WHEN sOrderChannel = 'COUNTER' THEN 1 
                ELSE 0 
           END) AS Counter
     , SUM(CASE WHEN sOrderChannel = 'E-MAIL' THEN 1 
                ELSE 0 
           END) AS Email  
     , SUM(CASE WHEN sOrderChannel = 'EBAY' THEN 1 
                ELSE 0 
           END) AS Ebay 
	 , SUM(CASE WHEN sOrderChannel = 'FAX' THEN 1 
                ELSE 0 
           END) AS Fax
	 , SUM(CASE WHEN sOrderChannel = 'INTERNAL' THEN 1 
                ELSE 0 
           END) AS Internal 
	 , SUM(CASE WHEN sOrderChannel = 'MAIL' THEN 1 
                ELSE 0 
           END) AS Mail 
	 , SUM(CASE WHEN sOrderChannel = 'PHONE' THEN 1 
                ELSE 0 
           END) AS Phone 
	 , SUM(CASE WHEN sOrderChannel = 'TRADESHOW' THEN 1 
                ELSE 0 
           END) AS Tradeshow 
	 , SUM(CASE WHEN sOrderChannel = 'WEB' THEN 1 
                ELSE 0 
           END) AS Web     
	 , SUM(CASE WHEN sOrderChannel = 'WEB-Mobile' THEN 1 
                ELSE 0 
           END) AS WebMobile                                                                                                                        
FROM [SMITemp].dbo.ASC_FirstOrderDayAndChannel2013 -- 199941


SELECT DISTINCT sDayOfWeek
     , SUM(CASE WHEN sOrderChannel = 'AUCTION' THEN 1 
                ELSE 0 
           END) AS Auction 
     , SUM(CASE WHEN sOrderChannel = 'COUNTER' THEN 1 
                ELSE 0 
           END) AS Counter
     , SUM(CASE WHEN sOrderChannel = 'E-MAIL' THEN 1 
                ELSE 0 
           END) AS Email  
     , SUM(CASE WHEN sOrderChannel = 'EBAY' THEN 1 
                ELSE 0 
           END) AS Ebay 
	 , SUM(CASE WHEN sOrderChannel = 'FAX' THEN 1 
                ELSE 0 
           END) AS Fax
	 , SUM(CASE WHEN sOrderChannel = 'INTERNAL' THEN 1 
                ELSE 0 
           END) AS Internal 
	 , SUM(CASE WHEN sOrderChannel = 'MAIL' THEN 1 
                ELSE 0 
           END) AS Mail 
	 , SUM(CASE WHEN sOrderChannel = 'PHONE' THEN 1 
                ELSE 0 
           END) AS Phone 
	 , SUM(CASE WHEN sOrderChannel = 'TRADESHOW' THEN 1 
                ELSE 0 
           END) AS Tradeshow 
	 , SUM(CASE WHEN sOrderChannel = 'WEB' THEN 1 
                ELSE 0 
           END) AS Web     
	 , SUM(CASE WHEN sOrderChannel = 'WEB-Mobile' THEN 1 
                ELSE 0 
           END) AS WebMobile                                                                                                                        
FROM [SMITemp].dbo.ASC_FirstOrderDayAndChannel2013 -- 199941
GROUP BY sDayOfWeek


-- YTD ORDER HISTORY 
SELECT DISTINCT ixCustomer AS ixCustomer  -- 157746 customers
     , COUNT(DISTINCT ixOrder) AS iOrderCount -- 307784 orders 
INTO [SMITemp].dbo.ASC_AllCustomersInTblOrderYTD     
FROM tblOrder O 
WHERE O.dtOrderDate BETWEEN '01/01/14' AND '08/13/14' 
  AND O.sOrderStatus = 'Shipped' 
  AND O.sOrderType = 'Retail'
  AND O.sOrderChannel <> 'INTERNAL'
GROUP BY ixCustomer  

SELECT DISTINCT ACT.ixCustomer --157746 records 
     , ACT.iOrderCount 
     , MIN(O.ixOrderDate) AS ixFirstOrderDate
INTO [SMITemp].dbo.ASC_CustomersFirstOrderDateYTD    
FROM [SMITemp].dbo.ASC_AllCustomersInTblOrderYTD ACT 
LEFT JOIN tblOrder O ON O.ixCustomer = ACT.ixCustomer
WHERE O.sOrderStatus = 'Shipped' 
  AND O.sOrderType = 'Retail' 
  AND O.sOrderChannel <> 'INTERNAL' 
GROUP BY ACT.ixCustomer
       , ACT.iOrderCount  

SELECT DISTINCT CFO.ixCustomer
     , CFO.iOrderCount
     , CFO.ixFirstOrderDate
     , D.iDayOfWeek
     , D.sDayOfWeek 
     , MIN(CASE WHEN O.flgDeviceType = 'MOBILEDETECTED' THEN 'WEB-Mobile'
             WHEN O.flgDeviceType = 'MOBILEOVERRIDETOFULL' THEN 'WEB-Mobile'
             WHEN O.flgDeviceType = 'MOBILEOVERRIDETOMOBI' THEN 'WEB-Mobile'
             WHEN O.flgDeviceType = 'MOBILESITE' THEN 'WEB-Mobile'
             ELSE O.sOrderChannel
         END) AS sOrderChannel 
INTO [SMITemp].dbo.ASC_FirstOrderDayAndChannelYTD          
FROM [SMITemp].dbo.ASC_CustomersFirstOrderDateYTD CFO 
LEFT JOIN tblDate D ON D.ixDate = CFO.ixFirstOrderDate 
LEFT JOIN tblOrder O ON O.ixCustomer = CFO.ixCustomer AND O.ixOrderDate = CFO.ixFirstOrderDate
GROUP BY CFO.ixCustomer
     , CFO.iOrderCount
     , CFO.ixFirstOrderDate
     , D.iDayOfWeek
     , D.sDayOfWeek 
ORDER BY ixCustomer


SELECT SUM(CASE WHEN iDayOfWeek = 1 THEN 1 
                ELSE 0 
           END) AS Mondays 
     , SUM(CASE WHEN iDayOfWeek = 2 THEN 1 
                ELSE 0 
           END) AS Tuesdays 
     , SUM(CASE WHEN iDayOfWeek = 3 THEN 1 
                ELSE 0 
           END) AS Wednesdays 
     , SUM(CASE WHEN iDayOfWeek = 4 THEN 1 
                ELSE 0 
           END) AS Thursdays 
	 , SUM(CASE WHEN iDayOfWeek = 5 THEN 1 
                ELSE 0 
           END) AS Fridays
	 , SUM(CASE WHEN iDayOfWeek = 6 THEN 1 
                ELSE 0 
           END) AS Saturdays
	 , SUM(CASE WHEN iDayOfWeek = 7 THEN 1 
                ELSE 0 
           END) AS Sundays                                                                             
FROM [SMITemp].dbo.ASC_FirstOrderDayAndChannelYTD -- 157746



SELECT SUM(CASE WHEN sOrderChannel = 'AUCTION' THEN 1 
                ELSE 0 
           END) AS Auction 
     , SUM(CASE WHEN sOrderChannel = 'COUNTER' THEN 1 
                ELSE 0 
           END) AS Counter
     , SUM(CASE WHEN sOrderChannel = 'E-MAIL' THEN 1 
                ELSE 0 
           END) AS Email  
     , SUM(CASE WHEN sOrderChannel = 'EBAY' THEN 1 
                ELSE 0 
           END) AS Ebay 
	 , SUM(CASE WHEN sOrderChannel = 'FAX' THEN 1 
                ELSE 0 
           END) AS Fax
	 , SUM(CASE WHEN sOrderChannel = 'INTERNAL' THEN 1 
                ELSE 0 
           END) AS Internal 
	 , SUM(CASE WHEN sOrderChannel = 'MAIL' THEN 1 
                ELSE 0 
           END) AS Mail 
	 , SUM(CASE WHEN sOrderChannel = 'PHONE' THEN 1 
                ELSE 0 
           END) AS Phone 
	 , SUM(CASE WHEN sOrderChannel = 'TRADESHOW' THEN 1 
                ELSE 0 
           END) AS Tradeshow 
	 , SUM(CASE WHEN sOrderChannel = 'WEB' THEN 1 
                ELSE 0 
           END) AS Web     
	 , SUM(CASE WHEN sOrderChannel = 'WEB-Mobile' THEN 1 
                ELSE 0 
           END) AS WebMobile                                                                                                                        
FROM [SMITemp].dbo.ASC_FirstOrderDayAndChannelYTD -- 157746


SELECT DISTINCT sDayOfWeek
     , SUM(CASE WHEN sOrderChannel = 'AUCTION' THEN 1 
                ELSE 0 
           END) AS Auction 
     , SUM(CASE WHEN sOrderChannel = 'COUNTER' THEN 1 
                ELSE 0 
           END) AS Counter
     , SUM(CASE WHEN sOrderChannel = 'E-MAIL' THEN 1 
                ELSE 0 
           END) AS Email  
     , SUM(CASE WHEN sOrderChannel = 'EBAY' THEN 1 
                ELSE 0 
           END) AS Ebay 
	 , SUM(CASE WHEN sOrderChannel = 'FAX' THEN 1 
                ELSE 0 
           END) AS Fax
	 , SUM(CASE WHEN sOrderChannel = 'INTERNAL' THEN 1 
                ELSE 0 
           END) AS Internal 
	 , SUM(CASE WHEN sOrderChannel = 'MAIL' THEN 1 
                ELSE 0 
           END) AS Mail 
	 , SUM(CASE WHEN sOrderChannel = 'PHONE' THEN 1 
                ELSE 0 
           END) AS Phone 
	 , SUM(CASE WHEN sOrderChannel = 'TRADESHOW' THEN 1 
                ELSE 0 
           END) AS Tradeshow 
	 , SUM(CASE WHEN sOrderChannel = 'WEB' THEN 1 
                ELSE 0 
           END) AS Web     
	 , SUM(CASE WHEN sOrderChannel = 'WEB-Mobile' THEN 1 
                ELSE 0 
           END) AS WebMobile                                                                                                                        
FROM [SMITemp].dbo.ASC_FirstOrderDayAndChannelYTD -- 157746 
GROUP BY sDayOfWeek
