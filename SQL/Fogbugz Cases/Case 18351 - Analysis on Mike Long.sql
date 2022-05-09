SELECT ixOrder --652 rows 
     , sShipToCity
     , sShipToState
     , sShipToZip
     , iShipMethod
     , dtShippedDate
     , sOrderChannel
     , mMerchandise AS Sales
     , mMerchandiseCost AS Cost
     , mShipping AS Shipping
     , (CASE WHEN ixOrder IN (SELECT DISTINCT O.ixOrder        
							  FROM tblOrder O 
							  LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder     
							  WHERE O.ixCustomer IN ('1073350', '1155856')
							    AND sOrderStatus = 'Shipped'
								AND OL.ixSKU = 'DROPSHIP') THEN 'Y' ELSE 'N'
        END) AS 'Dropship?'
     , D.iMonth
     , D.iQuarter
     , D.iPeriod
     , D.iYear        
  
FROM tblOrder O      
LEFT JOIN tblDate D ON D.ixDate = O.ixShippedDate
WHERE ixCustomer IN ('1073350', '1155856') -- Mike Long
  AND sOrderStatus = 'Shipped'
ORDER BY dtShippedDate     
       , ixOrder