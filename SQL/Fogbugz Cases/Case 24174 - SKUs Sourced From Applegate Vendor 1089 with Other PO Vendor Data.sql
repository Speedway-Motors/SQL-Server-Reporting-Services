/*

715B200 -- Total Performance 0715
91054048 -- No Other Sources 
91077400 -- TIP-TOP MFG 1629 
9402073 -- RUMAR MFG CO 2744
94022004 -- VISION SPORTS 0758
9402252 -- MOOSE BLOCK INC 2252
94036004 -- No Other Sources 
94037012 -- No Other Sources
94037019 -- No Other Sources 
9404936 -- No Other Sources 
940848 -- No Other Sources 
95035027 -- No Other Sources
96012880-4 -- No Other Sources 
96012880-5 -- No Other Sources 
9602030 -- No Other Sources 
94054035-LR -- No Other Sources 
94054035-RR -- No Other Sources 
9609000 -- TEK HEADERS 2926
9609001 -- TEK HEADERS 2926
9609012 -- M&W ALUMINUM PRODUCTS INC 2200 

*/

SELECT V.sName, VS.*
FROM tblVendorSKU VS 
LEFT JOIN tblVendor V ON V.ixVendor = VS.ixVendor
WHERE ixSKU = '9609012'


SELECT DISTINCT ixSKU
FROM tblPODetail POD 
LEFT JOIN tblPOMaster POM ON POM.ixPO = POD.ixPO
LEFT JOIN tblVendor V ON V.ixVendor = POM.ixVendor AND iOrdinality = 1
WHERE POM.ixVendor = '1089' 
 
 
 
SELECT * 
FROM tblSKU
WHERE ixSKU IN ('91054048', '94036004', '94037012', '94037019', '9404936', '940848', '95035027', '96012880-4', '96012880-5', '9602030',
                  '94054035-LR', '94054035-RR')


SELECT DISTINCT POD.ixSKU 
     , S.sBaseIndex
     , S.sDescription
     , SL.iQOS
     , SL.iQAV
     , VWSKU.LYQuantity
     , V.ixVendor
     , V.sName
     , MAX(D.dtDate) AS MostRecentPO
FROM tblPODetail POD 
LEFT JOIN tblPOMaster POM ON POM.ixPO = POD.ixPO
LEFT JOIN tblVendor V ON V.ixVendor = POM.ixVendor -- AND iOrdinality = 1 
LEFT JOIN tblSKU S ON S.ixSKU = POD.ixSKU 
LEFT JOIN tblSKULocation SL ON SL.ixSKU = POD.ixSKU AND SL.ixLocation = 99 
LEFT JOIN vwSKUSalesPrev12Months VWSKU ON VWSKU.ixSKU = POD.ixSKU 
LEFT JOIN tblDate D ON D.ixDate = POM.ixPODate 
WHERE POD.ixSKU IN (SELECT DISTINCT ixSKU
				    FROM tblPODetail POD 
				    LEFT JOIN tblPOMaster POM ON POM.ixPO = POD.ixPO
				    LEFT JOIN tblVendor V ON V.ixVendor = POM.ixVendor AND iOrdinality = 1
				    WHERE POM.ixVendor = '1089' 
			       ) 
  AND S.flgActive = 1 
  AND S.flgDeletedFromSOP = 0 			       
  AND V.ixVendor <> '1089'			  
  AND dtDiscontinuedDate > GETDATE()
GROUP BY POD.ixSKU 
       , S.sBaseIndex
       , S.sDescription
       , SL.iQOS
       , SL.iQAV
       , VWSKU.LYQuantity
       , V.ixVendor
       , V.sName  
ORDER BY ixSKU  