SELECT DISTINCT SP.ixVendor
     , SP.SKU
     , S.sDescription
     , SP.TransDate
FROM (SELECT ST.ixSKU AS SKU 
           , VS.ixVendor
           , D.dtDate AS TransDate
		   , ST.sTransactionType AS TransType 
	  FROM tblSKUTransaction ST 
	  JOIN tblDate D ON D.ixDate = ST.ixDate
	  LEFT JOIN tblVendorSKU VS ON VS.ixSKU = ST.ixSKU AND VS.iOrdinality = '1' 
	  WHERE sBin = '999'
	    AND sLocation = '99'
		AND ixVendor IN ('1106','1136','0210','0211','0491','0493','0630','0632')
	 )SP --Starting Pool of SKUs 
LEFT JOIN tblBinSku BS ON BS.ixSKU = SP.SKU AND BS.ixLocation = '99' 
LEFT JOIN tblSKU S ON S.ixSKU = SP.SKU 
WHERE BS.ixBin <> '999'
  AND SP.TransType = 'REMOVEPICKINGBIN'	 
ORDER BY SP.SKU
	  
