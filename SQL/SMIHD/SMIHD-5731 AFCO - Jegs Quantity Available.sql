-- SMIHD-5731 AFCO - Jegs Quantity Available
/*
SELECT S.ixSKU
,S.sDescription
,S.ixPGC
,SL.ixLocation
,SL.iQOS --AS 'QOStblSKULoc.'
,SL.iQAV --AS 'QAVtblSKULoc.'
FROM tblSKU S
JOIN tblSKULocation SL ON SL.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS= S.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
WHERE SL.ixLocation = '99' --ixLocation '68' not needed (SMI inventory counts) 
ORDER BY S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS


Similar to the Atech report, I run the SQL report and put the data into columns A-D of the attached spreadsheet "Jegs Sales 090111-083112 v2.xlsx". The formulas in E-G take care of the rest. Column G's formula is written so that no more than 100 items show as available, even if there are more on hand. if there is a negative, the quantity shows as 0.
The next steps will be slightly different from the Atech report, because Jegs asks that we submit a file for AFCO, Dynatech, and Suspension. 
They also do not require the Description to be in the files that are sent.

For the "AFCOJEGS.csv" file, I filter out any PGCs in column C that end in V or X, as well as any that start with P or Z.

For the "Dynatech.csv" file, I filter to keep only PGC Z, with the exception of ZP.

For the "Inventory.cvs" file, I keep all PGCs A, B, C, with the exception of any that end in P or V.

Let me know if you have any questions, or need anything explained in more detail.
*/


SELECT S.ixSKU 'SKU'
    ,(CASE WHEN SL.iQAV < 0 then 0
          WHEN SL.iQAV >100 then 100
          ELSE SL.iQAV
          END
    ) as 'QtyAvailable' -- Adjusted QAV
    , S.ixPGC
--INTO [SMITemp].dbo.PJC_SMIHD5731_SKUsForJegs -- Drop table [SMITemp].dbo.PJC_SMIHD5731_SKUsForJegs 
FROM tblSKU S
    JOIN tblSKULocation SL ON SL.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS= S.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
WHERE SL.ixLocation = '99' --ixLocation '68' not needed (SMI inventory counts) 
    -- these next  lines exclude PGCs that end in V or X and that start with P or Z
    AND S.flgDeletedFromSOP = 0 -- SKU has NOT been deleted from SOP
    AND S.ixPGC NOT LIKE '%V' -- end
    AND S.ixPGC NOT LIKE '%X' -- end
    AND S.ixPGC NOT LIKE 'Z%' -- start
    AND S.ixPGC NOT LIKE '%P%' -- start or end
    AND S.ixPGC <> 'Yk'
   -- AND S.ixSKU = '02-01-5600'
ORDER BY S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
/*
I run the SQL report and put the data into columns A-D of the attached spreadsheet "Atech Sales 010111-063012 v2.xlsx. 
The formulas in E-G take care of the rest. Column G's formula is written so that no more than 100 items show as available, 
even if there are more on hand. if there is a negative, the quantity shows as 0.

Once the data is put into the file, I filter out any PGCs in column C that end in V or X, as well as any that start with P.

Data is then put into a .csv file and sent to the customer. See attached file Atech QTY Available FIle.csv.

Let me know if you have any questions, or need anything explained in more detail.
If you think you can do this as an automated report. I have another 2 customers I do something similar for, with a few minor changes.
Anything that can help get me 45 minutes - 1 hour back a day would be EXTREMELY beneficial. Thanks again for all of your help!
*/



SELECT * FROM  [SMITemp].dbo.PJC_SMIHD5731_SKUsForJegs -- 33,536

SELECT * FROM [SMITemp].dbo.PJC_SMIHD5731_SKUsForJegs_Amandas -- 34,044
where ixSKU = 

SELECT * FROM  [SMITemp].dbo.PJC_SMIHD5731_SKUsForJegs 
    WHERE SKU COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS from [SMITemp].dbo.PJC_SMIHD5731_SKUsForJegs_Amandas )
/*
28500-1HTXB	IC
UP5682	MS
UP5683	MS
UP5684	MH
UP5685	MH
UP5686	MH
UP5687	IC
*/
SELECT * from tblSKU where ixSKU IN ('28500-1HTXB','UP5682','UP5683','UP5684','UP5685','UP5686','UP5687')

SELECT A.ixSKU, S.ixPGC, S.flgDeletedFromSOP, S.dtCreateDate
FROM  [SMITemp].dbo.PJC_SMIHD5731_SKUsForJegs_Amandas A  
    JOIN tblSKU S on S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS  = A.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS 
WHERE A.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT SKU COLLATE SQL_Latin1_General_CP1_CI_AS from  [SMITemp].dbo.PJC_SMIHD5731_SKUsForJegs  )
and flgDeletedFromSOP = 0
  