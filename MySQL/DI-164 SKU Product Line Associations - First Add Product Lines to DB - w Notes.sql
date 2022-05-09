SELECT * 
FROM tblproductline
WHERE sTitle LIKE 'G%' 
   OR sTitle LIKE 'H%'; 
   
-- The product lines do not yet exist. In order to insert them I need to be provided 
-- with the SOP Product Lines associated with each. 

SELECT * 
FROM tblbrand 
WHERE ixSOPBrand IN ('10467', '11105', '10274', '10971', '10126', '10270', '10972', '10320', '11110', '10499', '10213', '10127', '10378', '10502'
                      , '10060', '10572', '10466', '10525', '10019', '10606', '10128', '10500', '10974', '10054', '10129', '10339', '10631', '10995');
                      
-- All brands currently exist.                       

SELECT * 
FROM tmp.tmp_productlineadds;

ALTER TABLE tmp.tmp_productlineadds
ADD ixBrand INT AFTER ixSOPBrand; 

ALTER TABLE tmp.tmp_productlineadds CONVERT to character set latin1 collate latin1_general_cs;


UPDATE tmp.tmp_productlineadds, tblbrand
SET tmp.tmp_productlineadds.ixBrand = tblbrand.ixBrand
WHERE tmp.tmp_productlineadds.ixSOPBrand = tblbrand.ixSOPBrand; -- 927 rows affected 

SELECT *
FROM tmp.tmp_productlineadds
WHERE ixBrand IS NULL; 


INSERT IGNORE INTO tblproductline (ixBrand, sTitle, ixSOPProductLine) 
SELECT DISTINCT ixBrand
     , sTitle
     , ixSOPProductLine
FROM tmp.tmp_productlineadds; -- 214 rows affected


ALTER TABLE tmp.tmp_productlineadds
ADD ixProductLine INT AFTER ixSOPProductLine; 


UPDATE tmp.tmp_productlineadds, tblproductline
SET tmp.tmp_productlineadds.ixProductLine = tblproductline.ixProductLine
WHERE tmp.tmp_productlineadds.ixSOPProductLine = tblproductline.ixSOPProductLine; -- 927 rows affected 


-- Adding the SKU references 

SELECT * 
FROM tmp.tmp_skuproductlineadds;

ALTER TABLE tmp.tmp_skuproductlineadds
ADD ixBrand INT AFTER ixSOPBrand; 

ALTER TABLE tmp.tmp_skuproductlineadds CONVERT to character set latin1 collate latin1_general_cs;


UPDATE tmp.tmp_skuproductlineadds, tblbrand
SET tmp.tmp_skuproductlineadds.ixBrand = tblbrand.ixBrand
WHERE tmp.tmp_skuproductlineadds.ixSOPBrand = tblbrand.ixSOPBrand; -- 927 rows affected 

SELECT *
FROM tmp.tmp_skuproductlineadds
WHERE ixBrand IS NULL; 


ALTER TABLE tmp.tmp_skuproductlineadds
ADD ixProductLine INT AFTER ixSOPProductLine; 


UPDATE tmp.tmp_skuproductlineadds, tblproductline
SET tmp.tmp_skuproductlineadds.ixProductLine = tblproductline.ixProductLine
WHERE tmp.tmp_skuproductlineadds.ixSOPProductLine = tblproductline.ixSOPProductLine; -- 927 rows affected 


ALTER TABLE tmp.tmp_skuproductlineadds
ADD ixSKUBase INT AFTER ixSKU; 


UPDATE tmp.tmp_skuproductlineadds, tblskuvariant
SET tmp.tmp_skuproductlineadds.ixSKUBase = tblskuvariant.ixSKUBase
WHERE tmp.tmp_skuproductlineadds.ixSKU = tblskuvariant.ixSOPSKU; -- 927 rows affected 

SELECT * 
FROM tblskubase 
LIMIT 10;

SELECT SB.ixProductLine
FROM tblskubase SB
JOIN tmp.tmp_skuproductlineadds SPLA ON SPLA.ixSKUBase = SB.ixSKUBase 
WHERE SPLA.ixProductLine <> SB.ixProductLine
   OR SB.ixProductLine IS NULL; -- all values are currently null 
   
UPDATE tblskubase SB, tmp.tmp_skuproductlineadds
SET SB.ixProductLine = tmp.tmp_skuproductlineadds.ixProductLine
WHERE SB.ixSKUBase = tmp.tmp_skuproductlineadds.ixSKUBase;

SELECT SB.*
FROM tblskubase SB
JOIN tmp.tmp_skuproductlineadds SPLA ON SPLA.ixSKUBase = SB.ixSKUBase 
WHERE SPLA.ixProductLine <> SB.ixProductLine
   OR SB.ixProductLine IS NULL; 
   
SELECT * 
FROM tmp.tmp_skuproductlineadds 
WHERE ixSKU = '91637072';


SELECT SB.ixBrand, SPLA.ixBrand
FROM tblskubase SB
JOIN tmp.tmp_skuproductlineadds SPLA ON SPLA.ixSKUBase = SB.ixSKUBase 
WHERE SPLA.ixBrand <> SB.ixBrand
   OR SB.ixBrand IS NULL; 