SELECT Sold.ixSKU 
     , Sold.sDescription
     , Sold.sBrandDescription
     , ISNULL(EbayUS.Qty,0) + ISNULL(EbayFor.Qty,0) AS EbayTotQty
     , ISNULL(EbayUS.Sales,0) + ISNULL(EbayFor.Sales,0) AS EbayTotSales
     , ISNULL(EbayUS.Cost,0) + ISNULL(EbayFor.Cost,0) AS EbayTotCost
     , ISNULL(EbayUS.Qty,0) AS EbayUSQty
     , ISNULL(EbayUS.Orders,0) AS EbayUSOrders
     , ISNULL(EbayFor.Qty,0) AS EbayForQty
     , ISNULL(EbayFor.Orders,0) AS EbayForOrders  
     , ISNULL(Phone.Qty,0) AS PhoneQty 
     , ISNULL(Web.Qty,0) AS WebQty 
     , ISNULL(Ctr.Qty,0) AS CtrQty 
     , ISNULL(Mail.Qty,0) AS MailQty 
     , ISNULL(Fax.Qty,0) AS FaxQty 
     , ISNULL(Email.Qty,0) AS EmailQty                          
     , ISNULL(Other.Qty,0) AS EmailQty   
     , Sold.sSEMACategory
     , Sold.sSEMASubCategory
     , Sold.sSEMAPart   
     , Sold.Kit
     , Sold.dWeight
     , Sold.HandlingCode
     , Sold.ProductLine      
--This query returns all SKUs sold between a given date range 
FROM (SELECT DISTINCT OL.ixSKU 
           , S.sDescription 
           , B.sBrandDescription
           , RTRIM(S.sSEMACategory) AS sSEMACategory
           , RTRIM(S.sSEMASubCategory) AS sSEMASubCategory
           , RTRIM(S.sSEMAPart) AS sSEMAPart
           , (CASE WHEN S.flgIsKit = '1' THEN 'Y' 
                   ELSE ''
              END) AS Kit
           , S.dWeight 
           , HC.sDescription AS HandlingCode 
           , PL.sTitle AS ProductLine 
	  FROM tblOrder O 
	  LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
	  LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU  
	  LEFT JOIN tblBrand B ON B.ixBrand = S.ixBrand 
	  LEFT JOIN tblHandlingCode HC ON HC.ixHandlingCode = S.sHandlingCode 
	  LEFT JOIN tblProductLine PL ON PL.ixProductLine = S.ixProductLine 
	  WHERE O.dtOrderDate BETWEEN @StartDate AND @EndDate --'05/31/13' AND '06/03/13'  
	    AND O.sOrderType <> 'Internal' 
	    AND O.sOrderChannel <> 'INTERNAL' 
	    AND O.sOrderStatus = 'Shipped' 
	    AND S.flgIntangible = 0
	  ) Sold 
--This query returns data for all SKUs sold on Ebay within the US 	  
LEFT JOIN (SELECT OL.ixSKU
                , SUM(ISNULL(iQuantity,0)) AS Qty 
                , SUM(OL.mExtendedPrice) AS Sales 
                , SUM(OL.mExtendedCost) AS Cost
                , SUM(CASE WHEN O.ixOrder LIKE '%-%' THEN 0
                           ELSE 1 
                      END) AS Orders
		   FROM tblOrder O 
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
		   WHERE O.dtOrderDate BETWEEN @StartDate AND @EndDate --'05/31/13' AND '06/03/13'  
		     AND O.sOrderChannel IN ('AUCTION', 'EBAY')
		     AND O.sShipToCountry = 'US'
		     AND O.sOrderType <> 'Internal'
		     AND O.sOrderStatus = 'Shipped'
		     AND S.flgIntangible = 0
		   GROUP BY OL.ixSKU   
		   ) EbayUS ON EbayUS.ixSKU = Sold.ixSKU 	   	    
--This query returns data for all SKUs sold on Ebay outside of the US 	  
LEFT JOIN (SELECT OL.ixSKU
                , SUM(ISNULL(iQuantity,0)) AS Qty 
                , SUM(OL.mExtendedPrice) AS Sales 
                , SUM(OL.mExtendedCost) AS Cost
                , SUM(CASE WHEN O.ixOrder LIKE '%-%' THEN 0
                           ELSE 1 
                      END) AS Orders
		   FROM tblOrder O 
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
		   WHERE O.dtOrderDate BETWEEN @StartDate AND @EndDate --'05/31/13' AND '06/03/13'  
		     AND O.sOrderChannel IN ('AUCTION', 'EBAY')
		     AND O.sShipToCountry <> 'US'
		     AND O.sOrderType <> 'Internal'
		     AND O.sOrderStatus = 'Shipped'
		     AND S.flgIntangible = 0
		   GROUP BY OL.ixSKU   
		   ) EbayFor ON EbayFor.ixSKU = Sold.ixSKU 	
--This query returns data for all SKUs sold on phone orders  	  
LEFT JOIN (SELECT OL.ixSKU
                , SUM(ISNULL(iQuantity,0)) AS Qty 
                , SUM(OL.mExtendedPrice) AS Sales 
		   FROM tblOrder O 
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
		   WHERE O.dtOrderDate BETWEEN @StartDate AND @EndDate --'05/31/13' AND '06/03/13'  
		     AND O.sOrderChannel IN ('PHONE')
		     AND O.sOrderType <> 'Internal'
		     AND O.sOrderStatus = 'Shipped'
		     AND S.flgIntangible = 0
		   GROUP BY OL.ixSKU   
		   ) Phone ON Phone.ixSKU = Sold.ixSKU 		
--This query returns data for all SKUs sold on web orders  	  
LEFT JOIN (SELECT OL.ixSKU
                , SUM(ISNULL(iQuantity,0)) AS Qty 
                , SUM(OL.mExtendedPrice) AS Sales 
		   FROM tblOrder O 
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
		   WHERE O.dtOrderDate BETWEEN @StartDate AND @EndDate --'05/31/13' AND '06/03/13'  
		     AND O.sOrderChannel = ('WEB')
		     AND O.sOrderType <> 'Internal'
		     AND O.sOrderStatus = 'Shipped'
		     AND S.flgIntangible = 0
		   GROUP BY OL.ixSKU   
		   ) Web ON Web.ixSKU = Sold.ixSKU 			   	 
--This query returns data for all SKUs sold on counter orders  	  
LEFT JOIN (SELECT OL.ixSKU
                , SUM(ISNULL(iQuantity,0)) AS Qty 
                , SUM(OL.mExtendedPrice) AS Sales 
		   FROM tblOrder O 
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
		   WHERE O.dtOrderDate BETWEEN @StartDate AND @EndDate --'05/31/13' AND '06/03/13'  
		     AND O.sOrderChannel = ('COUNTER')
		     AND O.sOrderType <> 'Internal'
		     AND O.sOrderStatus = 'Shipped'
		     AND S.flgIntangible = 0
		   GROUP BY OL.ixSKU   
		   ) Ctr ON Ctr.ixSKU = Sold.ixSKU 	
--This query returns data for all SKUs sold on mail orders  	  
LEFT JOIN (SELECT OL.ixSKU
                , SUM(ISNULL(iQuantity,0)) AS Qty 
                , SUM(OL.mExtendedPrice) AS Sales 
		   FROM tblOrder O 
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
		   WHERE O.dtOrderDate BETWEEN @StartDate AND @EndDate --'05/31/13' AND '06/03/13'  
		     AND O.sOrderChannel = ('MAIL')
		     AND O.sOrderType <> 'Internal'
		     AND O.sOrderStatus = 'Shipped'
		     AND S.flgIntangible = 0
		   GROUP BY OL.ixSKU   
		   ) Mail ON Mail.ixSKU = Sold.ixSKU 	
--This query returns data for all SKUs sold on fax orders  	  
LEFT JOIN (SELECT OL.ixSKU
                , SUM(ISNULL(iQuantity,0)) AS Qty 
                , SUM(OL.mExtendedPrice) AS Sales 
		   FROM tblOrder O 
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
		   WHERE O.dtOrderDate BETWEEN @StartDate AND @EndDate --'05/31/13' AND '06/03/13'  
		     AND O.sOrderChannel = ('FAX')
		     AND O.sOrderType <> 'Internal'
		     AND O.sOrderStatus = 'Shipped'
		     AND S.flgIntangible = 0
		   GROUP BY OL.ixSKU   
		   ) Fax ON Fax.ixSKU = Sold.ixSKU 	
--This query returns data for all SKUs sold on e-mail orders  	  
LEFT JOIN (SELECT OL.ixSKU
                , SUM(ISNULL(iQuantity,0)) AS Qty 
                , SUM(OL.mExtendedPrice) AS Sales 
		   FROM tblOrder O 
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
		   WHERE O.dtOrderDate BETWEEN @StartDate AND @EndDate --'05/31/13' AND '06/03/13'  
		     AND O.sOrderChannel = ('E-MAIL')
		     AND O.sOrderType <> 'Internal'
		     AND O.sOrderStatus = 'Shipped'
		     AND S.flgIntangible = 0
		   GROUP BY OL.ixSKU   
		   ) Email ON Email.ixSKU = Sold.ixSKU 	
--This query returns data for all SKUs sold on e-mail orders  	  
LEFT JOIN (SELECT OL.ixSKU
                , SUM(ISNULL(iQuantity,0)) AS Qty 
                , SUM(OL.mExtendedPrice) AS Sales 
		   FROM tblOrder O 
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
		   WHERE O.dtOrderDate BETWEEN @StartDate AND @EndDate --'05/31/13' AND '06/03/13'  
		     AND (O.sOrderChannel = ('TRADESHOW')
		                OR O.sOrderChannel IS NULL)
		     AND O.sOrderType <> 'Internal'
		     AND O.sOrderStatus = 'Shipped'
		     AND S.flgIntangible = 0
		   GROUP BY OL.ixSKU   
		   ) Other ON Other.ixSKU = Sold.ixSKU 			   
		   		   		   		   		     
ORDER BY EbayTotQty DESC		   

