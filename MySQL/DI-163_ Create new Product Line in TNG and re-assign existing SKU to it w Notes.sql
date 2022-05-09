SELECT * 
FROM tblskuvariant
WHERE ixSOPSKU = '55512003';

SELECT * 
FROM tblproductline
WHERE UPPER(sTitle) LIKE 'TAYLOR%';

SELECT * 
FROM tblskubase
WHERE ixSKUBase = 27501;



-- Taylor's TOP Glass (sTitle) 3154 (ixSOPProductLine) 10151 (ixSOPBrand) 

SELECT * 
FROM tblbrand 
WHERE ixSOPBrand = '10151'; -- ixBrand = 578 


INSERT INTO tblproductline (ixBrand, sTitle, ixSOPProductLine) 
VALUES (578, 'Taylors TOP Glass', '3154'); -- ixProductLine = 3055 

UPDATE tblskubase
SET ixProductLine = 3055 
WHERE ixSKUBase = 27501; 