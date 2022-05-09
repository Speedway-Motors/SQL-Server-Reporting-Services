-- The first task is assigning SKUs to transmission families 

/******************************************* 
1) Import the data from the excel file (re-name the column headers to align with current table fields such as ixSOPSKU and sTransmissionFamilyName).
     (a) Select the wanted columns in the file and under the data tab choose MySQL for Excel. 
     (b) Enter the reporting password (Rep@rting123) and choose the correct schema (i.e. AWS Live _ tmp). 
     (c) Choose to "Export Excel Data to New Table". 
     (d) Name the table something like tmp.tmp_skutransfamilyassignment *NOTE -- all tables must use lowercase convention 
     (e) Generally you wil want to add a primary key column as a unique identifier (there is an option to have the system auto-generate this) 
     (f) Verify the column options are correct (i.e. datatype etc.) 
     (g) Click export
*********************************************/     

-- Verify that the temp table loaded correctly; You may have to refresh the table list 
SELECT *
FROM tmp.tmp_skutransfamilyassignment
LIMIT 10;

-- A new column will need to be added to the temp table to store the tng version ixTransmissionFamily associated with the sTransmissionFamilyName
ALTER TABLE tmp.tmp_skutransfamilyassignment 
-- ADD ixTransmissionFamily int;
-- ADD ixTransmissionFamily2 int;
-- ADD ixTransmissionFamily3 int;
-- ADD ixTransmissionFamily4 int;
-- ADD ixTransmissionFamily5 int;
ADD ixTransmissionFamily6 int;

-- Verify the column was correctly added to the table 
SELECT *
FROM tmp.tmp_skutransfamilyassignment
LIMIT 10;

-- Update the collation of the table if needed
ALTER TABLE tmp.tmp_skutransfamilyassignment CONVERT to character set latin1 collate latin1_general_cs;

-- Update the new ixTransmissionFamily column with the corresponding values 
UPDATE tmp.tmp_skutransfamilyassignment SFA, tbltransmission_family T  
SET SFA.ixTransmissionFamily = T.ixTransmissionFamily
WHERE SFA.sTransmissionFamilyName = T.sTransmissionFamilyName;

SELECT DISTINCT sTransmissionFamilyName
FROM tmp.tmp_skutransfamilyassignment
WHERE ixTransmissionFamily IS NULL; -- 3 values do not exist in tbltransmission_family ('45RFE', '4R70W', 'FMX') and will need to be added 

INSERT INTO tbltransmission_family (sTransmissionFamilyName, sTransmissionGroup) 
VALUES ('45RFE', 'Automatic Transmissions'), ('4R70W', 'Automatic Transmissions'), ('FMX', 'Automatic Transmissions'), ('T45', 'Manual Transmissions');

-- Re-run update queries above/below now that families are added 

-- Update the additional ixTransmissionFamily columns with the corresponding values 
UPDATE tmp.tmp_skutransfamilyassignment SFA, tbltransmission_family T  
SET SFA.ixTransmissionFamily2 = T.ixTransmissionFamily
WHERE SFA.sTransmissionFamilyName2 = T.sTransmissionFamilyName; 

UPDATE tmp.tmp_skutransfamilyassignment SFA, tbltransmission_family T  
SET SFA.ixTransmissionFamily3 = T.ixTransmissionFamily
WHERE SFA.sTransmissionFamilyName3 = T.sTransmissionFamilyName; 

UPDATE tmp.tmp_skutransfamilyassignment SFA, tbltransmission_family T  
SET SFA.ixTransmissionFamily4 = T.ixTransmissionFamily
WHERE SFA.sTransmissionFamilyName4 = T.sTransmissionFamilyName; 

UPDATE tmp.tmp_skutransfamilyassignment SFA, tbltransmission_family T  
SET SFA.ixTransmissionFamily5 = T.ixTransmissionFamily
WHERE SFA.sTransmissionFamilyName5 = T.sTransmissionFamilyName; 

UPDATE tmp.tmp_skutransfamilyassignment SFA, tbltransmission_family T  
SET SFA.ixTransmissionFamily6 = T.ixTransmissionFamily
WHERE SFA.sTransmissionFamilyName6 = T.sTransmissionFamilyName; 

SELECT *
FROM tblskuvariant_transmission_family_xref
LIMIT 10;

-- A new column will need to be added to the temp table to store the tng version ixSKUVariant associated with the SOP ixSOPSKU 
ALTER TABLE tmp.tmp_skutransfamilyassignment 
ADD ixSKUVariant int;

-- Verify the column was correctly added to the table 
SELECT *
FROM tmp.tmp_skutransfamilyassignment
LIMIT 10;

-- Update the new ixSKUVariant column with the corresponding values 
UPDATE tmp.tmp_skutransfamilyassignment SFA, tblskuvariant SV 
SET SFA.ixSKUVariant = SV.ixSKUVariant
WHERE SFA.ixSOPSKU = SV.ixSOPSKU;

-- Verify all data updated  
SELECT *
FROM tmp.tmp_skutransfamilyassignment
WHERE ixSKUVariant IS NULL;  -- There should be 0 records returned 

-- Last, insert the DISTINCT values into the permanent table 
INSERT IGNORE INTO tblskuvariant_transmission_family_xref (ixSKUVariant, ixTransmissionFamily, ixSOPSKU) -- all values updated  - 4 already existed 
SELECT DISTINCT ixSKUVariant, ixTransmissionFamily, ixSOPSKU -- 1648 distinct 
FROM tmp.tmp_skutransfamilyassignment
WHERE ixTransmissionFamily IS NOT NULL;

-- After all steps have been completed the temp table should be dropped 
DROP TABLE tmp.tmp_skutransfamilyassignment;


   