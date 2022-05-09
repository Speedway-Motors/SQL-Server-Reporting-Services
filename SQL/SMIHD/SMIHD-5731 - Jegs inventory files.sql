-- SMIHD-5731 - Jegs inventory files
/*
next steps differ from Atech report
    Jegs asks that we submit a file for AFCO, Dynatech, and Suspension
    
AFCOJEGS.csv - filter out any PGCs end in V or X, as well as any that start with P or Z.
Dynatech.csv - keep only PGC Z, with the exception of ZP.
Inventory.cvs - keep all PGCs A, B, C, with the exception of any that end in P or V. 
*/


SELECT S.ixSKU 'SKU' --,S.sDescription 'Description' ,S.ixPGC as 'PGC'
    ,(CASE WHEN SL.iQAV < 0 then 0
          WHEN SL.iQAV >100 then 100
          ELSE SL.iQAV
          END
    ) as 'QuantityAvailable' -- Adjusted QAV
FROM tblSKU S
    JOIN tblSKULocation SL ON SL.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS= S.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
WHERE SL.ixLocation = '99' --ixLocation '68' not needed (SMI inventory counts) 
    AND S.flgDeletedFromSOP = 0
    -- these next lines exclude SKUs based on their PGCs 
    AND S.ixPGC NOT LIKE '%V' -- end
    AND S.ixPGC NOT LIKE '%P%' -- start or end
    AND S.ixPGC NOT LIKE 'Z%' -- start
    AND S.ixPGC <> 'Yk'
   -- AND S.ixPGC NOT LIKE '%X' -- end
--    AND isnumeric(S.ixSKU) = 1    AND LEN(S.ixSKU) > 10  -- checking for excel converting long numeric SKUs to scientific notation format
ORDER BY S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS

-- 33,567 Query Results
-- 33,598 Amanda's results from 10/31.. verifying if PCG '%X' should be excluded or not







/**********      Dynatech.csv   **********/
-- keep only PGC Z, with the exception of ZP.
SELECT S.ixSKU 'SKU' --,S.sDescription 'Description' ,S.ixPGC as 'PGC'
    ,(CASE WHEN SL.iQAV < 0 then 0
          WHEN SL.iQAV >100 then 100
          ELSE SL.iQAV
          END
    ) as 'QuantityAvailable' -- Adjusted QAV
FROM tblSKU S
    JOIN tblSKULocation SL ON SL.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS= S.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
WHERE SL.ixLocation = '99' --ixLocation '68' not needed (SMI inventory counts) 
    AND S.flgDeletedFromSOP = 0
    -- these next lines exclude SKUs based on their PGCs 
    AND S.ixPGC LIKE 'Z%' -- start
    AND S.ixPGC NOT LIKE '%P' -- end
--    AND isnumeric(S.ixSKU) = 1    AND LEN(S.ixSKU) > 10  -- checking for excel converting long numeric SKUs to scientific notation format
ORDER BY S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS

-- 2,423 Query Results
-- 2,430 Amanda's results from 10/31




/**********     Inventory.cvs   *************/
-- keep only PGC Z, with the exception of ZP.
SELECT S.ixSKU 'SKU' --,S.sDescription 'Description' ,S.ixPGC as 'PGC'
    ,(CASE WHEN SL.iQAV < 0 then 0
          WHEN SL.iQAV >100 then 100
          ELSE SL.iQAV
          END
    ) as 'QuantityAvailable' -- Adjusted QAV
FROM tblSKU S
    JOIN tblSKULocation SL ON SL.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS= S.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
WHERE SL.ixLocation = '99' --ixLocation '68' not needed (SMI inventory counts) 
    AND S.flgDeletedFromSOP = 0
    -- these next lines exclude SKUs based on their PGCs 
    AND (S.ixPGC LIKE 'A%' -- start
         OR S.ixPGC LIKE 'B%' -- start
         OR S.ixPGC LIKE 'C%' -- start
         )
    AND S.ixPGC NOT LIKE '%P' -- end
    AND S.ixPGC NOT LIKE '%V' -- end    
--    AND isnumeric(S.ixSKU) = 1    AND LEN(S.ixSKU) > 10  -- checking for excel converting long numeric SKUs to scientific notation format
ORDER BY S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
-- 1,345 Query Results
-- 1,345 Amanda's results from 10/31