SELECT DISTINCT S.ixSKU AS SKU 
              , S.sDescription AS SKUDescrip
              , BS.sPickingBin AS PickLoc
              , SUM(ISNULL(BS.iSKUQuantity,0)) AS TotQty
FROM tblSKU S 
LEFT JOIN tblSKULocation SL ON SL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS 
                           AND SL.ixLocation = '99' --Afco only 
LEFT JOIN tblBinSku BS ON BS.ixSKU = S.ixSKU 
		              AND BS.ixLocation = '99' --Afco only
LEFT JOIN tblBin B ON B.ixBin = BS.ixBin    
		          AND B.ixLocation = '99' --Afco only
WHERE S.flgDeletedFromSOP = '0' 
  AND S.flgActive = '1'    
  AND B.sBinType = 'P' --PIC
  AND BS.sPickingBin IS NOT NULL 
  AND S.ixSKU IN (@ixSKU) 
GROUP BY S.ixSKU
	   , S.sDescription
	   , BS.sPickingBin
ORDER BY SKU	   