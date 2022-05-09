SELECT * 
FROM tblbrand 
WHERE ixSOPBrand IN ('10048', '10191'); -- ixBrand 520 'QA1' and ixBrand 599 'Speedway' 

SELECT *
FROM tblproductline
WHERE ixSOPProductLine IN ('2407' -- ixProductLine 1351 ixBrand 520
                         , '2923' -- ixProductLine 2566 ixBrand 520
                         , '2924' -- ixProductLine 2567 ixBrand 520
                         , '2925' -- ixProductLine 2568 ixBrand 520
                         , '2926' -- ixProductLine 2569 ixBrand 599
                         , '10' -- ixProductLine 2 ixBrand 599 (AND???) -- ixProductLine 2400 ixBrand 599 [[Use this one #2]]
                         , '9' -- ixProductLine 833 ixBrand 599 (AND???) -- ixProductLine 2784 ixBrand 599 [[Use this one #2]]
                         , '7' -- ixProductLine 831 ixBrand 599 (AND???) -- ixProductLine 2782 ixBrand 599 [[Use this one #2]]
                         , '8' -- ixProductLine 832 ixBrand 599 (AND???) -- ixProductLine 2783 ixBrand 599 [[Use this one #2]]
                         , '2927' -- ixProductLine 2570 ixBrand 599
                         , '2928' -- ixProductLine 2571 ixBrand 599
                         , '6' -- ixProductLine 830 ixBrand 599 (AND???) -- ixProductLine 2781 ixBrand 599 [[Use this one #2]]
                         , '2929' -- ixProductLine 2572 ixBrand 599
                         , '2930' -- ixProductLine 2573 ixBrand 599
                         , '2931' -- ixProductLine 2574 ixBrand 599
                         , '2932' -- ixProductLine 2575 ixBrand 599
                         , '2933' -- ixProductLine 2576 ixBrand 599
                         , '2934' -- ixProductLine 2577 ixBrand 599
                         ); 

-- Check that table uploaded properly 

SELECT * 
FROM tmp.tmp_productlineassign;

-- Insert additional columns for all 2/4 types to store the correct text value ID 

ALTER TABLE tmp.tmp_productlineassign
 ADD ixSKUVariant INT AFTER ixSOPSKU
,ADD ixSKUBase INT AFTER ixSKUVariant
,ADD ixProductLine INT AFTER ixSOPProductLine
,ADD ixBrand INT AFTER ixSOPBrand;

-- Update the collation so you can join against the current tables in TNG 
ALTER TABLE tmp.tmp_productlineassign CONVERT to character set latin1 collate latin1_general_cs;

-- Update the null values for the fields just added 
   
UPDATE tmp.tmp_productlineassign, tblskuvariant
SET tmp.tmp_productlineassign.ixSKUVariant = tblskuvariant.ixSKUVariant
WHERE tmp.tmp_productlineassign.ixSOPSKU = tblskuvariant.ixSOPSKU; 

-- Check that all fields updated 

SELECT * 
FROM tmp.tmp_productlineassign 
WHERE ixSKUVariant IS NULL; 


UPDATE tmp.tmp_productlineassign, tblskuvariant
SET tmp.tmp_productlineassign.ixSKUBase = tblskuvariant.ixSKUBase
WHERE tmp.tmp_productlineassign.ixSKUVariant = tblskuvariant.ixSKUVariant; 


UPDATE tmp.tmp_productlineassign, tblproductline
SET tmp.tmp_productlineassign.ixProductLine = tblproductline.ixProductLine
WHERE tmp.tmp_productlineassign.ixSOPProductLine = tblproductline.ixSOPProductLine
  AND tmp.tmp_productlineassign.ixSOPProductLine NOT IN (6, 7, 8, 9, 10); 
  
UPDATE tmp.tmp_productlineassign
SET ixProductLine = 2400 
WHERE ixSOPProductLine = 10; 

UPDATE tmp.tmp_productlineassign
SET ixProductLine = 2784 
WHERE ixSOPProductLine = 9; 

UPDATE tmp.tmp_productlineassign
SET ixProductLine = 2783 
WHERE ixSOPProductLine = 8; 

UPDATE tmp.tmp_productlineassign
SET ixProductLine = 2782 
WHERE ixSOPProductLine = 7; 

UPDATE tmp.tmp_productlineassign
SET ixProductLine = 2781 
WHERE ixSOPProductLine = 6; 

UPDATE tmp.tmp_productlineassign
SET ixProductLine = 2782 
WHERE ixSOPProductLine = 7; 

UPDATE tmp.tmp_productlineassign
SET ixBrand = 520 
WHERE ixSOPBrand = 10048; 

UPDATE tmp.tmp_productlineassign
SET ixBrand = 599
WHERE ixSOPBrand = 10191; 

SELECT PLA.ixSOPSKU
     , PLA.ixProductLine 
     , PLA.ixBrand
     , SB.ixProductLine
     , SB.ixBrand
FROM tmp.tmp_productlineassign PLA 
LEFT JOIN tblskubase SB ON SB.ixSKUBase = PLA.ixSKUBase
WHERE PLA.ixBrand <> SB.ixBrand; -- 9 values don't match ( 1170722, 1170807L, 1170807, 1750705GS, 1750707GS, 1750727GS, 1750507GS, 1750527GS, 1750526GS ) 

UPDATE tblskubase, tmp.tmp_productlineassign
SET tblskubase.ixBrand = tmp.tmp_productlineassign.ixBrand 
WHERE tblskubase.ixSKUBase = tmp.tmp_productlineassign.ixSKUBase; 

UPDATE tblskubase, tmp.tmp_productlineassign
SET tblskubase.ixProductLine = tmp.tmp_productlineassign.ixProductLine
WHERE tblskubase.ixSKUBase = tmp.tmp_productlineassign.ixSKUBase; 

