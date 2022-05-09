
/************************
   2012 Threshold 
     Analysis
**********************/

--$125 Threshold Promo Codes for 2012
SELECT COUNT(DISTINCT ixOrder) AS OrdCnt 
FROM tblOrder 
WHERE sPromoApplied IN ('RC336', 'HLW12', 'SMFRS12', 'SMRS12CC', 'SR344', 'RC347', 'FR12E', 'FR12W', 'FR12CC', 'RC357', 'SM362', 'SR349')
  AND sOrderStatus = 'Shipped' 
  AND dtShippedDate BETWEEN '01/01/12' AND '12/31/12'  --3860
  AND sOrderChannel <> 'INTERNAL' --3839
  AND sOrderType <> 'Internal' --3837
  AND ixOrder NOT LIKE '%-%' --3698  
  AND mMerchandise < 125 --80/3698 = 2.16%
  
  
--$125 Threshold Haggle Codes for 2012  
SELECT COUNT(DISTINCT ixOrder) AS OrdCnt 
FROM tblOrder 
WHERE sPromoApplied IN ('RC336H', 'HLW12H', 'SMFRS12H', 'SR344H', 'RC347H', 'FR12H', 'RC357H', 'SM362H', 'SR349H')
  AND sOrderStatus = 'Shipped' 
  AND dtShippedDate BETWEEN '01/01/12' AND '12/31/12'  --6
  AND sOrderChannel <> 'INTERNAL' --6
  AND sOrderType <> 'Internal' --6
  AND ixOrder NOT LIKE '%-%' --6   
  AND mMerchandise < 125 --2/6 = 33.33%  
  
--$100 Threshold Promo Codes for 2012
SELECT COUNT(DISTINCT ixOrder) AS OrdCnt 
FROM tblOrder 
WHERE sPromoApplied IN ('MD2012', 'FRS0812')
  AND sOrderStatus = 'Shipped' 
  AND dtShippedDate BETWEEN '01/01/12' AND '12/31/12'  --437
  AND sOrderChannel <> 'INTERNAL' --437
  AND sOrderType <> 'Internal' --436
  AND ixOrder NOT LIKE '%-%' --416
  AND mMerchandise < 100 --15/416 = 3.6%
  
--$100 Threshold Haggle Codes for 2012  
SELECT COUNT(DISTINCT ixOrder) AS OrdCnt 
FROM tblOrder 
WHERE sPromoApplied IN ('MD2012H', 'FRS0812H')
  AND sOrderStatus = 'Shipped' 
  AND dtShippedDate BETWEEN '01/01/12' AND '12/31/12'  --11
  AND sOrderChannel <> 'INTERNAL' --11
  AND sOrderType <> 'Internal' --11
  AND ixOrder NOT LIKE '%-%' --11  
  AND mMerchandise < 100 --0/11 = 0%    
  
--$150 Threshold Promo Codes for 2012
SELECT COUNT(DISTINCT ixOrder) AS OrdCnt 
FROM tblOrder 
WHERE sPromoApplied IN ('BDAY12')
  AND sOrderStatus = 'Shipped' 
  AND dtShippedDate BETWEEN '01/01/12' AND '12/31/12'  --233
  AND sOrderChannel <> 'INTERNAL' --231
  AND sOrderType <> 'Internal' --231
  AND ixOrder NOT LIKE '%-%' --220   
  AND mMerchandise < 150 --4/220 = 1.8%
  
--$150 Threshold Haggle Codes for 2012  
SELECT COUNT(DISTINCT ixOrder) AS OrdCnt 
FROM tblOrder 
WHERE sPromoApplied IN ('BDAY12H')
  AND sOrderStatus = 'Shipped' 
  AND dtShippedDate BETWEEN '01/01/12' AND '12/31/12'  --5
  AND sOrderChannel <> 'INTERNAL' --5
  AND sOrderType <> 'Internal' --5
  AND ixOrder NOT LIKE '%-%' --5   
  AND mMerchandise < 150 --1/5 = 20%    

/************************
   2013 Threshold 
     Analysis
**********************/

--$125 Threshold Promo Codes for 2013
SELECT COUNT(DISTINCT ixOrder) AS OrdCnt 
FROM tblOrder 
WHERE sPromoApplied IN ('RC336', 'HLW12', 'SMFRS12', 'SMRS12CC', 'SR344', 'RC347', 'FR12E', 'FR12W', 'FR12CC', 'RC357', 'SM362', 'SR349', 
                          'VAL13S', 'RC358', 'GGDM', 'SR351', 'IMCASM', 'GGNN', 'RC360', 'GGSG', 'GGCN', 'ST353' , 'F135', 'ST354')
  AND sOrderStatus = 'Shipped' 
  AND dtShippedDate BETWEEN '01/01/13' AND '12/31/13'  --290
  AND sOrderChannel <> 'INTERNAL' --287
  AND sOrderType <> 'Internal' --287
  AND ixOrder NOT LIKE '%-%' --222    
  AND mMerchandise < 125 --8/222 = 3.6%
  
--$125 Threshold Haggle Codes for 2013  
SELECT COUNT(DISTINCT ixOrder) AS OrdCnt 
FROM tblOrder 
WHERE sPromoApplied IN ('RC336H', 'HLW12H', 'SMFRS12H', 'SR344H', 'RC347H', 'FR12H', 'RC357H', 'SM362H', 'SR349H',
						   'VAL13SH', 'RC358H', 'GGDMH', 'SR351H', 'IMCASMH', 'GGNNH', 'RC360H', 'GGSGH', 'GGCNH', 'ST353H' , 'F135H', 'ST354H')
  AND sOrderStatus = 'Shipped' 
  AND dtShippedDate BETWEEN '01/01/13' AND '12/31/13'  --0
  AND sOrderChannel <> 'INTERNAL' --0
  AND sOrderType <> 'Internal' --0
  AND ixOrder NOT LIKE '%-%' --0    
  AND mMerchandise < 125 --0 = 0%  
  
--$100 Threshold Promo Codes for 2013
SELECT COUNT(DISTINCT ixOrder) AS OrdCnt 
FROM tblOrder 
WHERE sPromoApplied IN ('MD2012', 'FRS0812')
  AND sOrderStatus = 'Shipped' 
  AND dtShippedDate BETWEEN '01/01/13' AND '12/31/13'  --0
  AND sOrderChannel <> 'INTERNAL' --0
  AND sOrderType <> 'Internal' --0
  AND ixOrder NOT LIKE '%-%' --0    
  AND mMerchandise < 100 --0 = 0%
  
--$100 Threshold Haggle Codes for 2013  
SELECT COUNT(DISTINCT ixOrder) AS OrdCnt 
FROM tblOrder 
WHERE sPromoApplied IN ('MD2012H', 'FRS0812H')
  AND sOrderStatus = 'Shipped' 
  AND dtShippedDate BETWEEN '01/01/13' AND '12/31/13'  --0
  AND sOrderChannel <> 'INTERNAL' --0
  AND sOrderType <> 'Internal' --0
  AND ixOrder NOT LIKE '%-%' --0    
  AND mMerchandise < 100 --0 = 0%    
  
--$150 Threshold Promo Codes for 2013
SELECT COUNT(DISTINCT ixOrder) AS OrdCnt 
FROM tblOrder 
WHERE sPromoApplied IN ('BDAY12', 'BDAY13')
  AND sOrderStatus = 'Shipped' 
  AND dtShippedDate BETWEEN '01/01/13' AND '12/31/13'  --0
  AND sOrderChannel <> 'INTERNAL' --0
  AND sOrderType <> 'Internal' --0
  AND ixOrder NOT LIKE '%-%' --0    
  AND mMerchandise < 150 --0 = 0%
  
--$150 Threshold Haggle Codes for 2013  
SELECT COUNT(DISTINCT ixOrder) AS OrdCnt 
FROM tblOrder 
WHERE sPromoApplied IN ('BDAY12H', 'BDAY13H')
  AND sOrderStatus = 'Shipped' 
  AND dtShippedDate BETWEEN '01/01/13' AND '12/31/13'  --0
  AND sOrderChannel <> 'INTERNAL' --0
  AND sOrderType <> 'Internal' --0
  AND ixOrder NOT LIKE '%-%' --0    
  AND mMerchandise < 150 --0 = 0%    
  
  /**************************
     Using Promo Code ID
     for 2013 Analysis 
  ***************************/ 
  
--$125 Threshold for 2013    

SELECT COUNT(DISTINCT SP.ixOrder) AS OrdCnt 
FROM tblShippingPromo SP   
LEFT JOIN tblOrder O ON O.ixOrder = SP.ixOrder 
WHERE ixPromoId IN ('132', '139', '147', '156', '158', '159', '160', '179', '194', '206', '215', 
                      '225', '227', '229', '231', '251', '258', '282', '313', '318')
  AND sOrderStatus = 'Shipped' 
  AND dtShippedDate BETWEEN '01/01/13' AND '12/31/13'  --2103
  AND sOrderChannel <> 'INTERNAL' --2095
  AND sOrderType <> 'Internal' --2095
  AND O.ixOrder NOT LIKE '%-%' --2095   
  AND mMerchandise < 125 --39/2095   = 1.86%   
  
-- Plus the above 1/1/13 thru 1/2/13 data = ((39+8)/(2095+222)) = 47/2317 = 2.03%

   
--$125 Threshold Haggle Codes for 2013    

SELECT COUNT(DISTINCT SP.ixOrder) AS OrdCnt 
FROM tblShippingPromo SP   
LEFT JOIN tblOrder O ON O.ixOrder = SP.ixOrder 
WHERE ixPromoId IN ('162', '163', '164', '172', '183', '187', '195', '218', '226', '228', 
                       '230', '232', '252', '259', '283', '314', '319') 
  AND sOrderStatus = 'Shipped' 
  AND dtShippedDate BETWEEN '01/01/13' AND '12/31/13'  --63
  AND sOrderChannel <> 'INTERNAL' --63
  AND sOrderType <> 'Internal' --63
  AND O.ixOrder NOT LIKE '%-%' --63  
  AND mMerchandise < 125 --2/63   = 3.17%    
  
--$150 Threshold for 2013    

SELECT COUNT(DISTINCT SP.ixOrder) AS OrdCnt 
FROM tblShippingPromo SP   
LEFT JOIN tblOrder O ON O.ixOrder = SP.ixOrder 
WHERE ixPromoId IN ('295')
  AND sOrderStatus = 'Shipped' 
  AND dtShippedDate BETWEEN '01/01/13' AND '12/31/13'  --149
  AND sOrderChannel <> 'INTERNAL' --149
  AND sOrderType <> 'Internal' --149
  AND O.ixOrder NOT LIKE '%-%' --149  
  AND mMerchandise < 125 --4/149   = 2.68%   
   
--$150 Threshold Haggle Codes for 2013    

SELECT COUNT(DISTINCT SP.ixOrder) AS OrdCnt 
FROM tblShippingPromo SP   
LEFT JOIN tblOrder O ON O.ixOrder = SP.ixOrder 
WHERE ixPromoId IN ('296') 
  AND sOrderStatus = 'Shipped' 
  AND dtShippedDate BETWEEN '01/01/13' AND '12/31/13'  --7
  AND sOrderChannel <> 'INTERNAL' --7
  AND sOrderType <> 'Internal' --7
  AND O.ixOrder NOT LIKE '%-%' --7  
  AND mMerchandise < 125 --0/7   = 0%      


  /**************************
        Part Two - AOV 
    for Orders Containing
      Free Freight SKUs 
  ***************************/ 

-- 7/11/09 thru 01/10/10 = $166,583.58 total sales  and 332 Distinct Orders 
SELECT DISTINCT O.ixOrder 
     , O.mMerchandise
FROM tblOrder O
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
WHERE ixSKU IN (SELECT ixSKU FROM tblPromotionalInventory) 
  AND O.dtOrderDate BETWEEN DATEADD(MONTH, -6, '1/11/10') AND '01/10/10'
  AND sOrderStatus = 'Shipped' --402
  AND sOrderChannel <> 'INTERNAL' --402
  AND sOrderType = 'Retail' --332
ORDER BY ixOrder  

-- 01/11/10 thru 07/11/10 = $803,626.03 total sales  and 1,479 Distinct Orders 

SELECT DISTINCT O.ixOrder 
     , O.mMerchandise
FROM tblOrder O
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
WHERE ixSKU IN (SELECT ixSKU FROM tblPromotionalInventory) 
  AND O.dtOrderDate BETWEEN '01/11/10' AND DATEADD(MONTH, 6, '1/11/10') 
  AND sOrderStatus = 'Shipped' --1699
  AND sOrderChannel <> 'INTERNAL' --1694
  AND sOrderType = 'Retail' --?? 1479
ORDER BY ixOrder  

-- 01/11/09 thru 07/11/09 = $382,783.60 total sales  and 730 Distinct Orders 

SELECT DISTINCT O.ixOrder 
     , O.mMerchandise
FROM tblOrder O
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
WHERE ixSKU IN (SELECT ixSKU FROM tblPromotionalInventory) 
  AND O.dtOrderDate BETWEEN DATEADD(MONTH, -12, '01/11/10') AND DATEADD(MONTH, -12, '7/11/10') 
  AND sOrderStatus = 'Shipped' --897
  AND sOrderChannel <> 'INTERNAL' --896
  AND sOrderType = 'Retail' --730
ORDER BY ixOrder 

/****************
 7/11/09 thru 1/10/10 
 332 Distinct Retail Orders
 272 Distinct Orders with Add-Ons 
 $56,945.53 in Add-On Sales 
*******************/
 
SELECT Orders.ixOrder 
     , OL.ixSKU 
     , OL.mExtendedPrice
     , (CASE WHEN ixSKU IN (SELECT ixSKU FROM tblPromotionalInventory) THEN 'Y' 
             ELSE 'N'
         END) AS PromoSku
FROM (SELECT DISTINCT O.ixOrder 
      FROM tblOrder O
      LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
      WHERE ixSKU IN (SELECT ixSKU FROM tblPromotionalInventory) 
		AND O.dtOrderDate BETWEEN DATEADD(MONTH, -6, '1/11/10') AND '01/10/10'
		AND sOrderStatus = 'Shipped' --402
		AND sOrderChannel <> 'INTERNAL' --402
		AND sOrderType = 'Retail' --332 
      ) Orders 
LEFT JOIN tblOrderLine OL ON OL.ixOrder = Orders.ixOrder
ORDER BY Orders.ixOrder 

/****************
 1/11/10 thru 7/11/10 
 1,479 Distinct Retail Orders
 1,169 Distinct Orders with Add-Ons 
 $289,423.62 in Add-On Sales 
*******************/

SELECT Orders.ixOrder 
     , OL.ixSKU 
     , OL.mExtendedPrice
     , (CASE WHEN ixSKU IN (SELECT ixSKU FROM tblPromotionalInventory) THEN 'Y' 
             ELSE 'N'
         END) AS PromoSku
FROM (SELECT DISTINCT O.ixOrder 
      FROM tblOrder O
      LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
      WHERE ixSKU IN (SELECT ixSKU FROM tblPromotionalInventory) 
		AND O.dtOrderDate BETWEEN '01/11/10' AND DATEADD(MONTH, 6, '1/11/10') 
		AND sOrderStatus = 'Shipped' --1699
		AND sOrderChannel <> 'INTERNAL' --1694
		AND sOrderType = 'Retail' --1479
      ) Orders 
LEFT JOIN tblOrderLine OL ON OL.ixOrder = Orders.ixOrder
ORDER BY Orders.ixOrder 


/****************
 1/11/09 thru 7/11/09  
 730 Distinct Retail Orders
 606 Distinct Orders with Add-Ons 
 $138,699.61 in Add-On Sales 
*******************/

SELECT Orders.ixOrder 
     , OL.ixSKU 
     , OL.mExtendedPrice
     , (CASE WHEN ixSKU IN (SELECT ixSKU FROM tblPromotionalInventory) THEN 'Y' 
             ELSE 'N'
         END) AS PromoSku
FROM (SELECT DISTINCT O.ixOrder 
      FROM tblOrder O
      LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
      WHERE ixSKU IN (SELECT ixSKU FROM tblPromotionalInventory) 
		AND O.dtOrderDate BETWEEN DATEADD(MONTH, -12, '01/11/10') AND DATEADD(MONTH, -12, '7/11/10') 
		AND sOrderStatus = 'Shipped' --897
		AND sOrderChannel <> 'INTERNAL' --896
		AND sOrderType = 'Retail' --730 
      ) Orders 
LEFT JOIN tblOrderLine OL ON OL.ixOrder = Orders.ixOrder
ORDER BY Orders.ixOrder 