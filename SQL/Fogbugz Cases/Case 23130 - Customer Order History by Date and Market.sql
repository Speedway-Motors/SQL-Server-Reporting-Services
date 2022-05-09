-- Create starting pool table 

SELECT DISTINCT O.ixCustomer AS CustNum
     , C.sCustomerFirstName AS FirstName 
     , C.sCustomerLastName AS LastName
     , C.ixCustomerType AS CurCustType
     , C.sMailToState AS State
     , C.sMailToZip AS Zip 
     , C.sMailToCountry AS Country 
     , SO.dtOffered AS StreetDt
     , RO.dtOffered AS RaceDt 
     , TBO.dtOffered AS TBucketDt 
     , SMO.dtOffered AS OpenWheelDt 
     , ZT.OrdCnt AS '0-12 Ord Cnt' 
     , ZT.SKUCnt AS '0-12 SKU Cnt' 
     , ZT.Rev AS '0-12 Rev' 
     , ZT.GP AS '0-12 GP' 
     , TTF.OrdCnt AS '13-24 Ord Cnt' 
     , TTF.SKUCnt AS '13-24 SKU Cnt' 
     , TTF.Rev AS '13-24 Rev' 
     , TTF.GP AS '13-24 GP' 
INTO [SMITemp].dbo.ASC_23130_CAStartingPoolNEW2      
FROM tblOrder O 
JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer 
LEFT JOIN (SELECT MAX(dtCreateDate) AS dtOffered
                , ixCustomer
		   FROM tblCustomerOffer CO 
		   LEFT JOIN tblSourceCode SC ON SC.ixSourceCode = CO.ixSourceCode
		   WHERE sCatalogMarket = 'SR'
		     AND sType = 'OFFER'  
		   GROUP BY ixCustomer  
		  ) SO ON SO.ixCustomer = O.ixCustomer -- Street Offer 
LEFT JOIN (SELECT MAX(dtCreateDate) AS dtOffered
                , ixCustomer
		   FROM tblCustomerOffer CO 
		   LEFT JOIN tblSourceCode SC ON SC.ixSourceCode = CO.ixSourceCode
		   WHERE sCatalogMarket = 'R'
		     AND sType = 'OFFER'  
		   GROUP BY ixCustomer  
		  ) RO ON RO.ixCustomer = O.ixCustomer -- Race Offer 
LEFT JOIN (SELECT MAX(dtCreateDate) AS dtOffered
                , ixCustomer
		   FROM tblCustomerOffer CO 
		   LEFT JOIN tblSourceCode SC ON SC.ixSourceCode = CO.ixSourceCode
		   WHERE sCatalogMarket = '2B'
		     AND sType = 'OFFER'  
		   GROUP BY ixCustomer  
		  ) TBO ON TBO.ixCustomer = O.ixCustomer -- TBucket Offer 
LEFT JOIN (SELECT MAX(dtCreateDate) AS dtOffered
                , ixCustomer
		   FROM tblCustomerOffer CO 
		   LEFT JOIN tblSourceCode SC ON SC.ixSourceCode = CO.ixSourceCode
		   WHERE sCatalogMarket = 'SM'
		     AND sType = 'OFFER'  
		   GROUP BY ixCustomer  
		  ) SMO ON SMO.ixCustomer = O.ixCustomer -- Open Wheel / Spring / Midget Offer 		  		  		  
LEFT JOIN (SELECT DISTINCT O.ixCustomer 
                , COUNT(CASE WHEN O.ixOrder LIKE '%-%' THEN 0 
                             ELSE 1 
                       END) AS OrdCnt -- to avoid double counting backorders 
                --, COUNT(DISTINCT OL.ixOrder) AS OrdCnt 
                , SUM(OL.iQuantity) AS SKUCnt 
                , SUM(OL.mExtendedPrice) AS Rev 
                , SUM(OL.mExtendedPrice) - SUM(OL.mExtendedCost) AS GP 
		   FROM tblOrder O 
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
		   WHERE O.dtShippedDate BETWEEN DATEADD(mm, -12, GETDATE()) AND GETDATE() 
		     AND sShipToState = 'CA'
		     AND (O.sShipToCountry = 'US' OR O.sShipToCountry = 'UNITED STATES' OR O.sShipToCountry IS NULL) 
		     AND O.sOrderStatus = 'Shipped' 		     
		     AND O.sOrderChannel <> 'INTERNAL' 
		     AND O.sOrderType = 'Retail' 
		     AND O.mMerchandise > 0 
		     AND OL.mExtendedPrice > 0 
		     AND flgKitComponent = 0 
		     AND iShipMethod <> 1 
		     AND flgDeletedFromSOP = 0 
		     AND OL.ixSKU <> '999' -- creating a discrepency because it is not assigned to any market; exclude per CCC
		     AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') -- what was forgotten the 1st go around 
		   GROUP BY O.ixCustomer 
		  ) ZT ON ZT.ixCustomer = O.ixCustomer -- ZT = 0-12 Months 
LEFT JOIN (SELECT DISTINCT O.ixCustomer 
                , COUNT(CASE WHEN O.ixOrder LIKE '%-%' THEN 0 
                             ELSE 1 
                       END) AS OrdCnt -- to avoid double counting backorders 
                --, COUNT(DISTINCT OL.ixOrder) AS OrdCnt 
                , SUM(OL.iQuantity) AS SKUCnt 
                , SUM(OL.mExtendedPrice) AS Rev 
                , SUM(OL.mExtendedPrice) - SUM(OL.mExtendedCost) AS GP 
		   FROM tblOrder O 
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 		   
		   WHERE O.dtShippedDate BETWEEN DATEADD(mm, -24, GETDATE()) AND DATEADD(mm, -13, GETDATE())
		     AND sShipToState = 'CA'
		     AND (O.sShipToCountry = 'US' OR O.sShipToCountry = 'UNITED STATES' OR O.sShipToCountry IS NULL) 
		     AND O.sOrderStatus = 'Shipped' 		     
		     AND O.sOrderChannel <> 'INTERNAL' 
		     AND O.sOrderType = 'Retail' 
		     AND O.mMerchandise > 0 
		     AND OL.mExtendedPrice > 0 
		     AND flgKitComponent = 0 
		     AND iShipMethod <> 1 
		     AND flgDeletedFromSOP = 0 
		     AND OL.ixSKU <> '999' -- creating a discrepency because it is not assigned to any market; exclude per CCC
		     AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') -- what was forgotten the 1st go around 		     
		   GROUP BY O.ixCustomer 
		  ) TTF ON TTF.ixCustomer = O.ixCustomer -- TTF = 13-24 Months 
WHERE O.dtShippedDate BETWEEN DATEADD(mm, -24, GETDATE()) AND GETDATE() 
  AND sShipToState = 'CA'
  AND (O.sShipToCountry = 'US' OR O.sShipToCountry = 'UNITED STATES' OR O.sShipToCountry IS NULL) 
  AND O.sOrderStatus = 'Shipped' 		     
  AND O.sOrderChannel <> 'INTERNAL' 
  AND O.sOrderType = 'Retail' 
  AND iShipMethod <> 1 
  AND (ZT.OrdCnt IS NOT NULL 
   OR TTF.OrdCnt IS NOT NULL)	  
ORDER BY O.ixCustomer     -- 31914

-- Run full query of results 


SELECT SP.*       
-- TBucket
     , ZTTB.OrdCnt AS '0-12 Ord Cnt 2B' 
     , NULL AS '0-12 Ord Cnt % Tot 2B'      
     , ZTTB.SKUCnt AS '0-12 SKU Cnt 2B' 
     , NULL AS '0-12 SKU Cnt % Tot 2B'       
     , ZTTB.Rev AS '0-12 Rev 2B' 
     , NULL AS '0-12 Rev % Tot 2B'       
     , ZTTB.GP AS '0-12 GP 2B' 
     , NULL AS '0-12 GP % Tot 2B'       
     , TTFTB.OrdCnt AS '13-24 Ord Cnt 2B' 
     , NULL AS '13-24 Ord Cnt % Tot 2B'      
     , TTFTB.SKUCnt AS '13-24 SKU Cnt 2B' 
     , NULL AS '13-24 SKU Cnt % Tot 2B'        
     , TTFTB.Rev AS '13-24 Rev 2B' 
     , NULL AS '13-24 Rev % Tot 2B'        
     , TTFTB.GP AS '13-24 GP 2B' 
     , NULL AS '13-24 GP % Tot 2B'             
-- Both + Tools/Equipment 
     , ZTBTE.OrdCnt AS '0-12 Ord Cnt B+TE' 
     , NULL AS '0-12 Ord Cnt % Tot B+TE'      
     , ZTBTE.SKUCnt AS '0-12 SKU Cnt B+TE' 
     , NULL AS '0-12 SKU Cnt % Tot B+TE'       
     , ZTBTE.Rev AS '0-12 Rev B+TE' 
     , NULL AS '0-12 Rev % Tot B+TE'       
     , ZTBTE.GP AS '0-12 GP B+TE' 
     , NULL AS '0-12 GP % Tot B+TE'       
     , TTFBTE.OrdCnt AS '13-24 Ord Cnt B+TE' 
     , NULL AS '13-24 Ord Cnt % Tot B+TE'       
     , TTFBTE.SKUCnt AS '13-24 SKU Cnt B+TE' 
     , NULL AS '13-24 SKU Cnt % Tot B+TE'       
     , TTFBTE.Rev AS '13-24 Rev B+TE' 
     , NULL AS '13-24 Rev % Tot B+TE'       
     , TTFBTE.GP AS '13-24 GP B+TE' 
     , NULL AS '13-24 GP % Tot B+TE'            
-- Race + Safety + Sport Compact 
     , ZTRSESC.OrdCnt AS '0-12 Ord Cnt R+S+SC' 
     , NULL AS '0-12 Ord Cnt % Tot R+S+SC'      
     , ZTRSESC.SKUCnt AS '0-12 SKU Cnt R+S+SC' 
     , NULL AS '0-12 SKU Cnt % Tot R+S+SC'
     , ZTRSESC.Rev AS '0-12 Rev R+S+SC' 
     , NULL AS '0-12 Rev % Tot R+S+SC'
     , ZTRSESC.GP AS '0-12 GP R+S+SC' 
     , NULL AS '0-12 GP % Tot R+S+SC'
     , TTFRSESC.OrdCnt AS '13-24 Ord Cnt R+S+SC' 
     , NULL AS '13-24 Ord Cnt % Tot R+S+SC'
     , TTFRSESC.SKUCnt AS '13-24 SKU Cnt R+S+SC' 
     , NULL AS '13-24 SKU Cnt % Tot R+S+SC'
     , TTFRSESC.Rev AS '13-24 Rev R+S+SC' 
     , NULL AS '13-24 Rev % Tot R+S+SC'
     , TTFRSESC.GP AS '13-24 GP R+S+SC' 
     , NULL AS '13-24 GP % Tot R+S+SC'
-- Sprint Midget 
     , ZTSM.OrdCnt AS '0-12 Ord Cnt SM' 
     , NULL AS '0-12 Ord Cnt % Tot SM'     
     , ZTSM.SKUCnt AS '0-12 SKU Cnt SM' 
     , NULL AS '0-12 SKU Cnt % Tot SM' 
     , ZTSM.Rev AS '0-12 Rev SM' 
     , NULL AS '0-12 Rev % Tot SM' 
     , ZTSM.GP AS '0-12 GP SM' 
     , NULL AS '0-12 GP % Tot SM' 
     , TTFSM.OrdCnt AS '13-24 Ord Cnt SM' 
     , NULL AS '13-24 Ord Cnt % Tot SM' 
     , TTFSM.SKUCnt AS '13-24 SKU Cnt SM' 
     , NULL AS '13-24 SKU Cnt % Tot SM' 
     , TTFSM.Rev AS '13-24 Rev SM' 
     , NULL AS '13-24 Rev % Tot SM' 
     , TTFSM.GP AS '13-24 GP SM' 
     , NULL AS '13-24 GP % Tot SM' 
-- Street + Pedal Car 
     , ZTSRPC.OrdCnt AS '0-12 Ord Cnt SR+PC' 
     , NULL AS '0-12 Ord Cnt % Tot SR+PC' 
     , ZTSRPC.SKUCnt AS '0-12 SKU Cnt SR+PC'
     , NULL AS '0-12 SKU Cnt % Tot SR+PC'  
     , ZTSRPC.Rev AS '0-12 Rev SR+PC' 
     , NULL AS '0-12 Rev % Tot SR+PC' 
     , ZTSRPC.GP AS '0-12 GP SR+PC' 
     , NULL AS '0-12 GP % Tot SR+PC' 
     , TTFSRPC.OrdCnt AS '13-24 Ord Cnt SR+PC' 
     , NULL AS '13-24 Ord Cnt % Tot SR+PC' 
     , TTFSRPC.SKUCnt AS '13-24 SKU Cnt SR+PC' 
     , NULL AS '13-24 SKU Cnt % Tot SR+PC' 
     , TTFSRPC.Rev AS '13-24 Rev SR+PC' 
     , NULL AS '13-24 Rev % Tot SR+PC' 
     , TTFSRPC.GP AS '13-24 GP SR+PC' 
     , NULL AS '13-24 GP % Tot SR+PC' 
FROM [SMITemp].dbo.ASC_23130_CAStartingPoolNEW2 SP 
-- (2)T(B)ucket 		  
LEFT JOIN (SELECT DISTINCT O.ixCustomer 
                , COUNT(CASE WHEN O.ixOrder LIKE '%-%' THEN 0 
                             ELSE 1 
                       END) AS OrdCnt -- to avoid double counting backorders 
                --, COUNT(DISTINCT OL.ixOrder) AS OrdCnt 
                , SUM(OL.iQuantity) AS SKUCnt 
                , SUM(OL.mExtendedPrice) AS Rev 
                , SUM(OL.mExtendedPrice) - SUM(OL.mExtendedCost) AS GP 
		   FROM tblOrder O 
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
		   LEFT JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC
		   WHERE O.dtShippedDate BETWEEN DATEADD(mm, -12, GETDATE()) AND GETDATE() 
		     AND sShipToState = 'CA'
		     AND (O.sShipToCountry = 'US' OR O.sShipToCountry = 'UNITED STATES' OR O.sShipToCountry IS NULL) 
		     AND O.sOrderStatus = 'Shipped' 		     
		     AND O.sOrderChannel <> 'INTERNAL' 
		     AND O.sOrderType = 'Retail' 
		     AND OL.mExtendedPrice > 0 
		     AND flgKitComponent = 0 
		     AND iShipMethod <> 1 
		     AND PGC.ixMarket = '2B' 
		     AND flgDeletedFromSOP = 0 
		     AND OL.ixSKU <> '999' -- creating a discrepency because it is not assigned to any market; exclude per CCC
		     AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') -- what was forgotten the 1st go around 		     
		   GROUP BY O.ixCustomer 
		  ) ZTTB ON ZTTB.ixCustomer = SP.CustNum  -- ZTTB = 0-12 Months TBucket	
LEFT JOIN (SELECT DISTINCT O.ixCustomer 
                , COUNT(CASE WHEN O.ixOrder LIKE '%-%' THEN 0 
                             ELSE 1 
                       END) AS OrdCnt -- to avoid double counting backorders 
                --, COUNT(DISTINCT OL.ixOrder) AS OrdCnt 
                , SUM(OL.iQuantity) AS SKUCnt 
                , SUM(OL.mExtendedPrice) AS Rev 
                , SUM(OL.mExtendedPrice) - SUM(OL.mExtendedCost) AS GP 
		   FROM tblOrder O 
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
		   LEFT JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC		   
		   WHERE O.dtShippedDate BETWEEN DATEADD(mm, -24, GETDATE()) AND DATEADD(mm, -13, GETDATE())
		     AND sShipToState = 'CA'
		     AND (O.sShipToCountry = 'US' OR O.sShipToCountry = 'UNITED STATES' OR O.sShipToCountry IS NULL) 
		     AND O.sOrderStatus = 'Shipped' 		     
		     AND O.sOrderChannel <> 'INTERNAL' 
		     AND O.sOrderType = 'Retail' 
		     AND OL.mExtendedPrice > 0 
		     AND flgKitComponent = 0 
		     AND iShipMethod <> 1 
		     AND PGC.ixMarket = '2B' 
		     AND flgDeletedFromSOP = 0 
		     AND OL.ixSKU <> '999' -- creating a discrepency because it is not assigned to any market; exclude per CCC
		     AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') -- what was forgotten the 1st go around 		     
		   GROUP BY O.ixCustomer 
		  ) TTFTB ON TTFTB.ixCustomer = SP.CustNum  -- TTFTB = 13-24 Months TBucket 	
-- (B)oth + (T)ools(E)quipment
LEFT JOIN (SELECT DISTINCT O.ixCustomer 
                , COUNT(CASE WHEN O.ixOrder LIKE '%-%' THEN 0 
                             ELSE 1 
                       END) AS OrdCnt -- to avoid double counting backorders 
                --, COUNT(DISTINCT OL.ixOrder) AS OrdCnt 
                , SUM(OL.iQuantity) AS SKUCnt 
                , SUM(OL.mExtendedPrice) AS Rev 
                , SUM(OL.mExtendedPrice) - SUM(OL.mExtendedCost) AS GP 
		   FROM tblOrder O 
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
		   LEFT JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC
		   WHERE O.dtShippedDate BETWEEN DATEADD(mm, -12, GETDATE()) AND GETDATE() 
		     AND sShipToState = 'CA'
		     AND (O.sShipToCountry = 'US' OR O.sShipToCountry = 'UNITED STATES' OR O.sShipToCountry IS NULL) 
		     AND O.sOrderStatus = 'Shipped' 		     
		     AND O.sOrderChannel <> 'INTERNAL' 
		     AND O.sOrderType = 'Retail' 
		     AND OL.mExtendedPrice > 0 
		     AND flgKitComponent = 0 
		     AND iShipMethod <> 1 
		     AND PGC.ixMarket IN ('B', 'TE')  
		     AND flgDeletedFromSOP = 0 
		     AND OL.ixSKU <> '999' -- creating a discrepency because it is not assigned to any market; exclude per CCC
		     AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') -- what was forgotten the 1st go around 		     
		   GROUP BY O.ixCustomer 
		  ) ZTBTE ON ZTBTE.ixCustomer = SP.CustNum  -- ZTBTE = 0-12 Months Both + Tools 	
LEFT JOIN (SELECT DISTINCT O.ixCustomer 
                , COUNT(CASE WHEN O.ixOrder LIKE '%-%' THEN 0 
                             ELSE 1 
                       END) AS OrdCnt -- to avoid double counting backorders 
                --, COUNT(DISTINCT OL.ixOrder) AS OrdCnt 
                , SUM(OL.iQuantity) AS SKUCnt 
                , SUM(OL.mExtendedPrice) AS Rev 
                , SUM(OL.mExtendedPrice) - SUM(OL.mExtendedCost) AS GP 
		   FROM tblOrder O 
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
		   LEFT JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC		   
		   WHERE O.dtShippedDate BETWEEN DATEADD(mm, -24, GETDATE()) AND DATEADD(mm, -13, GETDATE())
		     AND sShipToState = 'CA'
		     AND (O.sShipToCountry = 'US' OR O.sShipToCountry = 'UNITED STATES' OR O.sShipToCountry IS NULL) 
		     AND O.sOrderStatus = 'Shipped' 		     
		     AND O.sOrderChannel <> 'INTERNAL' 
		     AND O.sOrderType = 'Retail' 
		     AND OL.mExtendedPrice > 0 
		     AND flgKitComponent = 0 
		     AND iShipMethod <> 1 
		     AND PGC.ixMarket IN ('B', 'TE')  
		     AND flgDeletedFromSOP = 0 
		     AND OL.ixSKU <> '999' -- creating a discrepency because it is not assigned to any market; exclude per CCC
		     AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') -- what was forgotten the 1st go around 		     
		   GROUP BY O.ixCustomer 
		  ) TTFBTE ON TTFBTE.ixCustomer = SP.CustNum  -- TTFBTE = 13-24 Months Both + Tools  
-- (R)ace + (S)afety(E)quipment + (S)port(C)ompact  	
LEFT JOIN (SELECT DISTINCT O.ixCustomer 
                , COUNT(CASE WHEN O.ixOrder LIKE '%-%' THEN 0 
                             ELSE 1 
                       END) AS OrdCnt -- to avoid double counting backorders 
               -- , COUNT(DISTINCT OL.ixOrder) AS OrdCnt 
                , SUM(OL.iQuantity) AS SKUCnt 
                , SUM(OL.mExtendedPrice) AS Rev 
                , SUM(OL.mExtendedPrice) - SUM(OL.mExtendedCost) AS GP 
		   FROM tblOrder O 
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
		   LEFT JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC
		   WHERE O.dtShippedDate BETWEEN DATEADD(mm, -12, GETDATE()) AND GETDATE() 
		     AND sShipToState = 'CA'
		     AND (O.sShipToCountry = 'US' OR O.sShipToCountry = 'UNITED STATES' OR O.sShipToCountry IS NULL) 
		     AND O.sOrderStatus = 'Shipped' 		     
		     AND O.sOrderChannel <> 'INTERNAL' 
		     AND O.sOrderType = 'Retail' 
		     AND OL.mExtendedPrice > 0 
		     AND flgKitComponent = 0 
		     AND iShipMethod <> 1 
		     AND PGC.ixMarket IN ('R', 'SE', 'SC') 
		     AND flgDeletedFromSOP = 0 
		     AND OL.ixSKU <> '999' -- creating a discrepency because it is not assigned to any market; exclude per CCC
		     AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') -- what was forgotten the 1st go around 		     
		   GROUP BY O.ixCustomer 
		  ) ZTRSESC ON ZTRSESC.ixCustomer = SP.CustNum  -- ZTRSESC = 0-12 Months Race 	
LEFT JOIN (SELECT DISTINCT O.ixCustomer 
                , COUNT(CASE WHEN O.ixOrder LIKE '%-%' THEN 0 
                             ELSE 1 
                       END) AS OrdCnt -- to avoid double counting backorders 
                --, COUNT(DISTINCT OL.ixOrder) AS OrdCnt 
                , SUM(OL.iQuantity) AS SKUCnt 
                , SUM(OL.mExtendedPrice) AS Rev 
                , SUM(OL.mExtendedPrice) - SUM(OL.mExtendedCost) AS GP 
		   FROM tblOrder O 
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
		   LEFT JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC		   
		   WHERE O.dtShippedDate BETWEEN DATEADD(mm, -24, GETDATE()) AND DATEADD(mm, -13, GETDATE())
		     AND sShipToState = 'CA'
		     AND (O.sShipToCountry = 'US' OR O.sShipToCountry = 'UNITED STATES' OR O.sShipToCountry IS NULL) 
		     AND O.sOrderStatus = 'Shipped' 		     
		     AND O.sOrderChannel <> 'INTERNAL' 
		     AND O.sOrderType = 'Retail' 
		     AND OL.mExtendedPrice > 0 
		     AND flgKitComponent = 0 
		     AND iShipMethod <> 1 
		     AND PGC.ixMarket IN ('R', 'SE', 'SC') 
		     AND flgDeletedFromSOP = 0 
		     AND OL.ixSKU <> '999' -- creating a discrepency because it is not assigned to any market; exclude per CCC
		     AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') -- what was forgotten the 1st go around 		     
		   GROUP BY O.ixCustomer 
		  ) TTFRSESC ON TTFRSESC.ixCustomer = SP.CustNum  -- TTFRSESC = 13-24 Months Race  	
-- (S)print(M)idget 
LEFT JOIN (SELECT DISTINCT O.ixCustomer 
                , COUNT(CASE WHEN O.ixOrder LIKE '%-%' THEN 0 
                             ELSE 1 
                       END) AS OrdCnt -- to avoid double counting backorders 
                --, COUNT(DISTINCT OL.ixOrder) AS OrdCnt 
                , SUM(OL.iQuantity) AS SKUCnt 
                , SUM(OL.mExtendedPrice) AS Rev 
                , SUM(OL.mExtendedPrice) - SUM(OL.mExtendedCost) AS GP 
		   FROM tblOrder O 
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
		   LEFT JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC
		   WHERE O.dtShippedDate BETWEEN DATEADD(mm, -12, GETDATE()) AND GETDATE() 
		     AND sShipToState = 'CA'
		     AND (O.sShipToCountry = 'US' OR O.sShipToCountry = 'UNITED STATES' OR O.sShipToCountry IS NULL) 
		     AND O.sOrderStatus = 'Shipped' 		     
		     AND O.sOrderChannel <> 'INTERNAL' 
		     AND O.sOrderType = 'Retail' 
		     AND OL.mExtendedPrice > 0 
		     AND flgKitComponent = 0 
		     AND iShipMethod <> 1 
		     AND PGC.ixMarket = 'SM' 
		     AND flgDeletedFromSOP = 0 
		     AND OL.ixSKU <> '999' -- creating a discrepency because it is not assigned to any market; exclude per CCC
		     AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') -- what was forgotten the 1st go around 		     
		   GROUP BY O.ixCustomer 
		  ) ZTSM ON ZTSM.ixCustomer = SP.CustNum  -- ZTSM = 0-12 Months Sprint/Midget	
LEFT JOIN (SELECT DISTINCT O.ixCustomer 
                , COUNT(CASE WHEN O.ixOrder LIKE '%-%' THEN 0 
                             ELSE 1 
                       END) AS OrdCnt -- to avoid double counting backorders 
                --, COUNT(DISTINCT OL.ixOrder) AS OrdCnt 
                , SUM(OL.iQuantity) AS SKUCnt 
                , SUM(OL.mExtendedPrice) AS Rev 
                , SUM(OL.mExtendedPrice) - SUM(OL.mExtendedCost) AS GP 
		   FROM tblOrder O 
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
		   LEFT JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC		   
		   WHERE O.dtShippedDate BETWEEN DATEADD(mm, -24, GETDATE()) AND DATEADD(mm, -13, GETDATE())
		     AND sShipToState = 'CA'
		     AND (O.sShipToCountry = 'US' OR O.sShipToCountry = 'UNITED STATES' OR O.sShipToCountry IS NULL) 
		     AND O.sOrderStatus = 'Shipped' 		     
		     AND O.sOrderChannel <> 'INTERNAL' 
		     AND O.sOrderType = 'Retail' 
		     AND OL.mExtendedPrice > 0 
		     AND flgKitComponent = 0 
		     AND iShipMethod <> 1 
		     AND PGC.ixMarket = 'SM' 
		     AND flgDeletedFromSOP = 0 
		     AND OL.ixSKU <> '999' -- creating a discrepency because it is not assigned to any market; exclude per CCC
		     AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') -- what was forgotten the 1st go around 		     
		   GROUP BY O.ixCustomer 
		  ) TTFSM ON TTFSM.ixCustomer = SP.CustNum  -- TTFSM = 13-24 Months Sprint/Midget	
-- (S)treet(R)od + (P)edal(C)ar
LEFT JOIN (SELECT DISTINCT O.ixCustomer 
                , COUNT(CASE WHEN O.ixOrder LIKE '%-%' THEN 0 
                             ELSE 1 
                       END) AS OrdCnt -- to avoid double counting backorders 
                --, COUNT(DISTINCT OL.ixOrder) AS OrdCnt 
                , SUM(OL.iQuantity) AS SKUCnt 
                , SUM(OL.mExtendedPrice) AS Rev 
                , SUM(OL.mExtendedPrice) - SUM(OL.mExtendedCost) AS GP 
		   FROM tblOrder O 
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
		   LEFT JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC
		   WHERE O.dtShippedDate BETWEEN DATEADD(mm, -12, GETDATE()) AND GETDATE() 
		     AND sShipToState = 'CA'
		     AND (O.sShipToCountry = 'US' OR O.sShipToCountry = 'UNITED STATES' OR O.sShipToCountry IS NULL) 
		     AND O.sOrderStatus = 'Shipped' 		     
		     AND O.sOrderChannel <> 'INTERNAL' 
		     AND O.sOrderType = 'Retail' 
		     AND OL.mExtendedPrice > 0 
		     AND flgKitComponent = 0 
		     AND iShipMethod <> 1 
		     AND PGC.ixMarket IN ('SR', 'PC') 
		     AND flgDeletedFromSOP = 0 
		     AND OL.ixSKU <> '999' -- creating a discrepency because it is not assigned to any market; exclude per CCC
		     AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') -- what was forgotten the 1st go around 		     
		   GROUP BY O.ixCustomer 
		  ) ZTSRPC ON ZTSRPC.ixCustomer = SP.CustNum  -- ZTSRPC = 0-12 Months Street + Pedal 	
LEFT JOIN (SELECT DISTINCT O.ixCustomer 
                , COUNT(CASE WHEN O.ixOrder LIKE '%-%' THEN 0 
                             ELSE 1 
                       END) AS OrdCnt -- to avoid double counting backorders 
                --, COUNT(DISTINCT OL.ixOrder) AS OrdCnt 
                , SUM(OL.iQuantity) AS SKUCnt 
                , SUM(OL.mExtendedPrice) AS Rev 
                , SUM(OL.mExtendedPrice) - SUM(OL.mExtendedCost) AS GP 
		   FROM tblOrder O 
		   LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
		   LEFT JOIN tblPGC PGC ON PGC.ixPGC = S.ixPGC		   
		   WHERE O.dtShippedDate BETWEEN DATEADD(mm, -24, GETDATE()) AND DATEADD(mm, -13, GETDATE())
		     AND sShipToState = 'CA'
		     AND (O.sShipToCountry = 'US' OR O.sShipToCountry = 'UNITED STATES' OR O.sShipToCountry IS NULL) 
		     AND O.sOrderStatus = 'Shipped' 		     
		     AND O.sOrderChannel <> 'INTERNAL' 
		     AND O.sOrderType = 'Retail' 
		     AND OL.mExtendedPrice > 0 
		     AND flgKitComponent = 0 
		     AND iShipMethod <> 1 
		     AND PGC.ixMarket IN ('SR', 'PC') 
		     AND flgDeletedFromSOP = 0 
		     AND OL.ixSKU <> '999' -- creating a discrepency because it is not assigned to any market; exclude per CCC
		     AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') -- what was forgotten the 1st go around 		     
		   GROUP BY O.ixCustomer 
		  ) TTFSRPC ON TTFSRPC.ixCustomer = SP.CustNum  -- TTFSRPC = 13-24 Months Street + Pedal 		
WHERE Zip <> 'F' 
  AND (Country = 'USA' OR Country IS NULL) -- 31,484		    		  	  		  			  	    	  		  		  		  		  		  
--ORDER BY SP.CustNum   


