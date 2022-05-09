-- SMIHD-5705 AFCO - Atech Quantity Available
SELECT S.ixSKU 'SKU'
    ,S.sDescription 'Description'
    -- ,S.ixPGC as 'PGC'
    --,SL.ixLocation
    -- ,SL.iQOS --AS 'QOStblSKULoc.'
    -- ,SL.iQAV as 'ActualQAV', --AS 'QAVtblSKULoc.',
    ,(CASE WHEN SL.iQAV < 0 then 0
          WHEN SL.iQAV >100 then 100
          ELSE SL.iQAV
          END
    ) as 'QuantityAvailable' -- Adjusted QAV
FROM tblSKU S
    JOIN tblSKULocation SL ON SL.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS= S.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
WHERE SL.ixLocation = '99' --ixLocation '68' not needed (SMI inventory counts) 
    -- these next 3 lines exclude PGCs that end in V or X and that start with P
    AND S.ixPGC NOT LIKE '%V' 
    AND S.ixPGC NOT LIKE '%X'
    AND S.ixPGC NOT LIKE 'P%'
    AND isnumeric(S.ixSKU) = 1    
    AND LEN(S.ixSKU) > 10
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
