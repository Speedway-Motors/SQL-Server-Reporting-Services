-- The task is re-assigning SKUs from the currently specified brand/product line categorization to the correct combination 

/******************************************* 
Since the data is very limited in size (8 records) this can be done by hand without importing an Excel file
*********************************************/     

-- First begin by determining all needed information such as the tng tied ixBrand to the ixSOPBrand given 

SELECT *
FROM tblbrand
WHERE ixSOPBrand = ('10085')
LIMIT 10; -- tng ixBrand = 529

-- Look at the product line information such as the tng tied ixProductLine to the ixSOPProductLine given 
SELECT *
FROM tblproductline
WHERE ixSOPProductLine IN ('1420', '2582'); -- tng ixProductLine for '1420' = 81 AND for '2582' = 1620  

/*******************************
A record for the new product line needs to be created. 
To determine how the record should be added (i.e. does ixProductLine auto increment on insert or not) right click the
table for the addition and select 'View Details'. In this case ixProductLine does auto increment therefore only the other fields 
need to be added/filled in
**********************************/

INSERT INTO tblproductline (ixBrand, sTitle, ixSOPProductLine) 
VALUES (529, 'HANS Device Sport II Series', '2582'); -- the NEW tng ixProductLine = 1620

-- Re-assign the SKUs given to the new product line created 
UPDATE tblskubase 
SET ixProductLine = 1620
WHERE ixSOPSKUBase IN ('451112321', '451112421', '451112351', '451112451', '451112311', '451112411', '451112341', '451112441');

-- Check that the values updated correctly

SELECT *
FROM tblskubase 
WHERE ixSOPSKUBase IN ('451112321', '451112421', '451112351', '451112451', '451112311', '451112411', '451112341', '451112441');




