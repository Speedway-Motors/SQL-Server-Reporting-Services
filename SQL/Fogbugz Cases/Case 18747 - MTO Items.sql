
--return all kits with a sku in the kit that has a bin location = 'shop'
SELECT DISTINCT ixKitSKU 
FROM tblKit 
LEFT JOIN tblSKU S ON S.ixSKU = tblKit.ixKitSKU
WHERE tblKit.ixSKU IN (SELECT ixSKU 
			    FROM tblBinSku
			    WHERE ixBin = 'SHOP'
				  AND ixLocation = '99'
			    ) 
   AND flgActive = '1'		

SELECT DISTINCT BS.ixSKU 
FROM tblBinSku BS
LEFT JOIN tblSKU S ON S.ixSKU = BS.ixSKU 
WHERE BS.ixBin = 'SHOP'
  AND BS.ixLocation = '99'   	    
  AND flgActive = '1'
  AND BS.ixSKU NOT IN (SELECT ixSKU 
					   FROM tblKit 
					   )