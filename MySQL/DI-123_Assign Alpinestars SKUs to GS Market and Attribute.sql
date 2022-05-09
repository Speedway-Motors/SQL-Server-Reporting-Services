SELECT *
FROM tmp_alpinestars_gs_skus -- 826 records 

-- A new column will need to be added to the temp table to store the tng version ixSKUBase associated with the SOP ixSOPSKU 
ALTER TABLE tmp_alpinestars_gs_skus
ADD ixSKUBase int;

-- Verify the column was correctly added to the table 
SELECT *
FROM tmp_alpinestars_gs_skus
LIMIT 10;

-- Update the collation of the table if needed

ALTER TABLE tmp_alpinestars_gs_skus CONVERT to character set latin1 collate latin1_general_cs;

-- Update the new ixSKUBase column with the corresponding values 
UPDATE tmp_alpinestars_gs_skus AGS, tngLive.tblskuvariant SV 
SET AGS.ixSKUBase = SV.ixSKUBase
WHERE AGS.ixSOPSKU = SV.ixSOPSKU;

-- Look at records that did not update
SELECT *
FROM tmp_alpinestars_gs_skus
WHERE ixSKUBase IS NULL; -- 80 did not update [do not exist in tblskuvariant]  -- notified Wyatt, fixed, then re-ran 4/30 and all updated

-- A new column will need to be added to the temp table to store the tng version ixSKUVariant associated with the SOP ixSOPSKU 
ALTER TABLE tmp_alpinestars_gs_skus
ADD ixSKUVariant int;

-- Verify the column was correctly added to the table 
SELECT *
FROM tmp_alpinestars_gs_skus
LIMIT 10;

-- Update the new ixSKUVariant column with the corresponding values 
UPDATE tmp_alpinestars_gs_skus AGS, tngLive.tblskuvariant SV 
SET AGS.ixSKUVariant = SV.ixSKUVariant
WHERE AGS.ixSKUBase = SV.ixSKUBase
  AND AGS.ixSOPSKU = SV.ixSOPSKU; -- all rows updated 
  
-- Insert the values into the TNG market xref table 
INSERT IGNORE INTO tblskubasemarket (ixSKUBase, ixMarket)
SELECT DISTINCT AGS.ixSKUBase
     , 222
FROM tmp.tmp_alpinestars_gs_skus AGS; -- 69 values updated (there were 70 distinct sku bases, 1 already existed in the table) 

-- Insert the values into the TNG GS xref table 
INSERT IGNORE INTO tblskuvariant_garagesale_xref (ixSKUVariant, ixGarageSaleType)
SELECT DISTINCT AGS.ixSKUVariant
     , 3
FROM tmp.tmp_alpinestars_gs_skus AGS; -- 826 values updated 
