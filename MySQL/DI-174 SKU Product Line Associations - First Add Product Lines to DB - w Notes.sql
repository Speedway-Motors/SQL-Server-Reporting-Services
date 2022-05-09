SELECT *
FROM tmp.tmp_asc_productlineadds;


ALTER TABLE tmp.tmp_asc_productlineadds
ADD ixBrand INT AFTER ixSOPBrand; 

ALTER TABLE tmp.tmp_asc_productlineadds CONVERT to character set latin1 collate latin1_general_cs;

UPDATE tmp.tmp_asc_productlineadds, tblbrand
SET tmp.tmp_asc_productlineadds.ixBrand = tblbrand.ixBrand
WHERE tmp.tmp_asc_productlineadds.ixSOPBrand = tblbrand.ixSOPBrand; -- 48711 rows affected 

SELECT *
FROM tmp.tmp_asc_productlineadds
WHERE ixBrand IS NULL; -- all records updated 


INSERT IGNORE INTO tblproductline (ixBrand, sTitle, ixSOPProductLine) 
SELECT DISTINCT ixBrand
     , sTitle
     , ixSOPProductLine
FROM tmp.tmp_asc_productlineadds; -- 2807 distinct rows; 2377 rows affected/inserted


ALTER TABLE tmp.tmp_asc_productlineadds
ADD ixProductLine INT AFTER ixSOPProductLine; 


UPDATE tmp.tmp_asc_productlineadds, tblproductline
SET tmp.tmp_asc_productlineadds.ixProductLine = tblproductline.ixProductLine
WHERE tmp.tmp_asc_productlineadds.ixSOPProductLine = tblproductline.ixSOPProductLine; -- 48711 rows affected


SELECT *
FROM tmp.tmp_asc_productlineadds
WHERE ixProductLine IS NULL; -- all records updated 


ALTER TABLE tmp.tmp_asc_productlineadds
ADD ixSKUBase INT AFTER ixSOPSKU; 


UPDATE tmp.tmp_asc_productlineadds, tblskuvariant
SET tmp.tmp_asc_productlineadds.ixSKUBase = tblskuvariant.ixSKUBase
WHERE tmp.tmp_asc_productlineadds.ixSOPSKU = tblskuvariant.ixSOPSKU; -- 48706 rows affected 


SELECT * 
FROM tmp.tmp_asc_productlineadds 
WHERE ixSKUBase IS NULL; -- 5 records 

/*
4.91121E+11
54783931
5475568
91070047-RH
91070047-LH
*/


SELECT * 
FROM tblskubase 
LIMIT 10;

SELECT SB.ixProductLine
FROM tblskubase SB
JOIN tmp.tmp_asc_productlineadds PLA ON PLA.ixSKUBase = SB.ixSKUBase 
WHERE PLA.ixProductLine <> SB.ixProductLine
   OR SB.ixProductLine IS NULL; -- all values are currently null 
   
   
UPDATE tblskubase SB, tmp.tmp_asc_productlineadds
SET SB.ixProductLine = tmp.tmp_asc_productlineadds.ixProductLine
WHERE SB.ixSKUBase = tmp.tmp_asc_productlineadds.ixSKUBase
  AND tmp.tmp_asc_productlineadds.ixSKUBase IS NOT NULL; -- 16,983 records updated 


SELECT DISTINCT ixSKUBase 
FROM tmp.tmp_asc_productlineadds; -- 16984 distinct records existed 
   
   
SELECT DISTINCT SB.ixSOPSKUBase AS SKUBase
     , B.ixSOPBrand AS Stored
     , B.ixBrand AS StoredOURS
     , B.sBrandName AS StoredName
     , B2.ixSOPBrand AS ExcelValue
     , B2.ixBrand AS ExcelOURS
     , B2.sBrandName AS ExcelValueName
FROM tmp.tmp_asc_productlineadds SPLA 
LEFT JOIN tblskubase SB ON SPLA.ixSKUBase = SB.ixSKUBase 
LEFT JOIN tblbrand B ON B.ixBrand = SB.ixBrand
LEFT JOIN tblbrand B2 ON B2.ixBrand = SPLA.ixBrand
WHERE SPLA.ixBrand <> SB.ixBrand
   OR SB.ixBrand IS NULL
  AND SPLA.ixSKUBase IS NOT NULL;    -- 15 records where the brand associations do not match 

SELECT * FROM tblskubase WHERE ixSOPSKUBase = 5478110;

UPDATE tblskubase SB, tmp.tmp_asc_productlineadds PLA 
SET SB.ixBrand = PLA.ixBrand
WHERE SB.ixSKUBase IN (5423,41600,33269,669,16655,2194); -- these were marked as 'No brand assigned'
                                                      -- so i figured  they were safe to overwrite 

   
SELECT DISTINCT SPLA.ixSKUBase
     , SB.ixProductLine
     , SPLA.ixProductLine
FROM tmp.tmp_asc_productlineadds SPLA 
LEFT JOIN tblskubase SB ON SPLA.ixSKUBase = SB.ixSKUBase 
WHERE SPLA.ixProductLine <> SB.ixProductLine
   OR SB.ixProductLine IS NULL
  AND SPLA.ixSKUBase IS NOT NULL;    -- 6 records where the product line associations do not match  
  
UPDATE tblskubase SB, tmp.tmp_asc_productlineadds PLA 
SET SB.ixProductLine = PLA.ixProductLine
WHERE SB.ixSKUBase IN (26435,26119,56765,11992,5193,9390);  -- per JGO overwrite original values  
 


UPDATE tblskubase 
SET ixProductLine = 4535
WHERE ixSKUBase = 9390;

UPDATE tblskubase 
SET ixBrand = 699
WHERE ixSOPSKUBase = '91722399';



-- to help determine which active / non-garage sale skus still need product lines assigned
SELECT DISTINCT ixSOPSKU
     , SV.sSKUVariantName
     , B.sBrandName
     , B.ixSOPBrand  
FROM tblskubase SB
LEFT JOIN tblskuvariant SV ON SV.ixSKUBase = SB.ixSKUBase 
LEFT JOIN tblbrand B ON B.ixBrand = SB.ixBrand 
WHERE ixProductLine IS NULL
 -- AND UPPER(sName) NOT LIKE 'GARAGE SALE%'
  AND UPPER(sSKUVariantName) NOT LIKE 'GARAGE SALE%'
  AND sDescription NOT LIKE 'Clearance%'
  AND SV.flgPublish = 1
 -- AND SV.flgDiscontinued = 0 
  AND SB.flgWebActive = 1;
