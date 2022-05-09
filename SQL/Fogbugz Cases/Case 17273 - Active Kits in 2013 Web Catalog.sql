
SELECT CD.ixSKU --12,814
     , S.sDescription
     , KIT.ixSKU 
     , KIT.sDescription
FROM (SELECT CD.ixSKU 
	  FROM tblCatalogDetail CD 
	  WHERE ixCatalog = 'WEB.13'
	  ) CD
LEFT JOIN tblSKU S ON S.ixSKU = CD.ixSKU 
LEFT JOIN (SELECT K.ixKitSKU AS ixKitSKU
                , K.ixSKU AS ixSKU
                , S.sDescription AS sDescription
           FROM tblKit K 
           LEFT JOIN tblSKU S ON S.ixSKU = K.ixSKU 
           ) KIT ON KIT.ixKitSKU = CD.ixSKU 	  
WHERE S.flgIsKit = '1'
  and S.flgActive = '1' --12,538
  and S.flgDeletedFromSOP = '0' --12,538
  and S.dtDiscontinuedDate > GETDATE() 
ORDER BY CD.ixSKU, KIT.ixSKU   

