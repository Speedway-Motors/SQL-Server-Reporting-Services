SELECT O.ixOrder 
     , O.iTotalOrderLines
     , AL.TotalLines 
     , O.iTotalTangibleLines
     , TL.TangibleLines 
     , O.iTotalShippedPackages 
     , P.Packages 
FROM tblOrder O 
LEFT JOIN (SELECT MAX(iOrdinality) AS TotalLines 
                , O.ixOrder
           FROM tblOrder O 
           LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
           WHERE O.dtShippedDate = '02/28/14' 
           GROUP BY O.ixOrder 
          ) AL ON AL.ixOrder = O.ixOrder -- AL = All Lines 
LEFT JOIN (SELECT COUNT(*) AS TangibleLines 
                , O.ixOrder
           FROM tblOrder O 
           LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
           LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
           WHERE O.dtShippedDate = '02/28/14' 
             AND S.flgIntangible = 0 
           GROUP BY O.ixOrder 
          ) TL ON TL.ixOrder = O.ixOrder -- TL = Tangible Lines 
LEFT JOIN (SELECT COUNT(DISTINCT sTrackingNumber) AS Packages  
				, O.ixOrder
		   FROM tblOrder O 
           LEFT JOIN tblPackage P ON P.ixOrder = O.ixOrder  
           WHERE O.dtShippedDate = '02/28/14' 
             AND ixShipDate IS NOT NULL
             AND ixShipTime IS NOT NULL
             AND ixShipper IS NOT NULL
             AND ixShippingIP IS NOT NULL
             AND sTrackingNumber NOT LIKE '%CP'
           GROUP BY O.ixOrder   
          ) P ON P.ixOrder = O.ixOrder         
WHERE dtShippedDate = '02/28/14'
  AND (O.iTotalShippedPackages <>  P.Packages  
    OR O.iTotalOrderLines <> AL.TotalLines 
    OR O.iTotalTangibleLines <> TL.TangibleLines 
      ) 
  


