/*
orders shipping SmartPost to IA, NE, ND, SD, WI & IL 
and compare the cost of the packages shipping SmartPost vs. 
the cost to ship the same packages SpeeDee. 

– i.e. how much would it cost to take the packages we shipped
 for free via SmartPost to these states and instead ship the 
 packages SpeeDee?  Doesn’t need to be super accurate, just ballpark.
*/

select P.sTrackingNumber
     , P.ixOrder
     , P.dActualWeight
     , O.sShipToZip
from tblPackage P 
left join tblDate D ON D.ixDate = P.ixShipDate
left join tblOrder O ON O.ixOrder = P.ixOrder
where dtDate BETWEEN '1/1/16' AND '6/30/16'
  AND iShipMethod = '15'
  AND flgCanceled = 0 
  AND O.sOrderStatus = 'Shipped'
  AND O.sShipToCountry = 'US'
  AND O.sShipToState IN ('IA', 'NE', 'ND', 'SD', 'WI', 'IL')
  AND flgIsResidentialAddress = 0
  
  
select DISTINCT ixGeography, iZone
from tblGeography  
  
  
  

  
  
 