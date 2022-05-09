

SELECT ixOrder as 'Order Number', 
       sShipToState as 'Ship To State',
       sShipToZip as 'Ship To Zip Code',
       mMerchandise as 'Merchandise',
       mMerchandiseCost as 'Merchandise Cost',
       mShipping as 'Shipping Billed',
       mPublishedShipping as 'Published Shipping', 
       mPromoDiscount as 'Shipping Discount',
       flgIsResidentialAddress 'Residential Flag',
       sOrderChannel as 'Order Channel'
     --  sShipToCountry
       
FROM tblOrder

WHERE sOrderType = 'Retail'
  and dtOrderDate BETWEEN '11/27/10' and '11/28/11'
  and iShipMethod in ('2', '9', '13', '14') 
  -- and sShipToCountry in ('US', 'NULL', 'USA') 
  and sShipToState not in ('AK', 'HI') 
  and sOrderStatus = 'Shipped'
  -- and mMerchandise > 0 
 
ORDER BY sShipToState