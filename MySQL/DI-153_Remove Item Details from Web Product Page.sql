SELECT * 
FROM tblproductpagetab
WHERE ixProductPage = 70078
  AND sTitle = 'Item Details';
  
SELECT * FROM tblproductpage WHERE tblproductpage.sUrlPart LIKE '%AFCO-1561%';  
  
-- www.speedwaymotors.com/Garage-Sale-AFCO-TrackPak-Shock-Package-23-Series-w-Schrader-Valve-Base-Set-up,53252.html 
-- the last part of the URL before .html is the piece that provides the product page info  
  
DELETE
FROM tblproductpagetab
WHERE ixProductPage = 70078
  AND sTitle = 'Item Details';  