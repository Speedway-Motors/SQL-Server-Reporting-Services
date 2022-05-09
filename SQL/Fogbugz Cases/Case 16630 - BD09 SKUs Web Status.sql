--Create temp table for all SKUs in BD09
SELECT CD.ixCatalog
     , CD.ixSKU
     , 'N' AS flgWebActive 
     , SL.iQAV
     , S.dtDiscontinuedDate 
     , S.flgActive 
     , S.flgDeletedFromSOP 
     , S.flgBackorderAccepted 
--INTO ASC_BD09_16630
--DROP TABLE ASC_BD09_16630
FROM tblCatalogDetail CD --1115 SKUs 
LEFT JOIN tblSKU S ON S.ixSKU = CD.ixSKU 
LEFT JOIN tblSKULocation SL ON SL.ixSKU = CD.ixSKU 
WHERE CD.ixCatalog = 'BD09'
  AND SL.ixLocation = '99'
--Check information in the table 
SELECT * FROM ASC_BD09_16630
--Update field flgWebActive to store true values 
UPDATE ASC_BD09_16630
SET flgWebActive = 'Y' 
WHERE ixSKU IN (SELECT ixSKU 
				FROM WebInfo.dbo.tblWebSKUInfo
				)
--Check information in the table 
SELECT * FROM ASC_BD09_16630
ORDER BY flgWebActive 				
					