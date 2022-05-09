
SELECT SB.*
FROM tblskuvariant SV
LEFT JOIN tblskubase SB ON SB.ixSKUBase = SV.ixSKUBase
WHERE SV.ixSOPSKU IN ('1750315', '1750311', '1750310', '1750317', '1750313', '1750312', '1750316', '1750314', '1750115', 
                  '1750111', '1750110', '1750117', '1750113', '1750112', '1750116', '1750114');
                  -- currently all SKUs are assigned to a different product line 
                  
SELECT *
FROM tblproductline
WHERE ixSOPProductLine = '3152'; -- the product line did not yet exist and had to be created 

INSERT INTO tblproductline (ixBrand, sTitle, ixSOPProductLine) 
VALUES (599, 'Speedway Precision Carbon Steel Male Heim Joint Rod Ends', '3152');
-- ixProductLine = 2799 

SELECT * 
FROM tblbrand
WHERE ixSOPBrand = '10191'; -- ixBrand = 599 ; Speedway

UPDATE tblskubase 
SET ixProductLine = 2799 
WHERE ixSKUBase IN (SELECT ixSKUBase 
                    FROM tblskuvariant SV
                    WHERE SV.ixSOPSKU IN ('1750315', '1750311', '1750310', '1750317', '1750313', '1750312', '1750316', '1750314', '1750115', 
                                          '1750111', '1750110', '1750117', '1750113', '1750112', '1750116', '1750114')
                   )