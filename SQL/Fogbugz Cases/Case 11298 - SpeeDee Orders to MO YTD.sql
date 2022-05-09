


SELECT ixOrder as 'Order #',
       ixCustomer as'Customer #',
       sShipToZip as 'Zip Code',
       mMerchandise as 'Merchandise Total'
      -- sShipToState as 'State'
      -- dtShippedDate as 'Date Shipped'
   
FROM tblOrder

WHERE sShipToState = 'MO'
  and dtShippedDate between '01/01/2011' and '12/31/2011'					
  and sOrderStatus = 'Shipped'					
  and sOrderType <> 'Internal'	
  
  /*The two orders with the 'internal' order channel
    were actually still relevent customer orders
    and most likely should be contained in the data shown. */	
    				
 -- and sOrderChannel <> 'INTERNAL'				

  /*There were two orders with a merchandise total of $0.00 in which parts 
    on backorder were already paid for within a kit, etc. from the previous order. 
    These results are currently not being included */ 
      
  and mMerchandise > 0					
  and iShipMethod = '9'

ORDER BY sShipToZip, mMerchandise