-- Case 25629 - create lists for Camaro's and Classics data to import into SOP
select * from tblSKU 
where ixSKU IN
--('92618398','92614361','92618537')

('9261002601','92614333','92610233')

-- DROP TABLE PJC_25629_CandC_MasterSKUList
SELECT TOP 10 * FROM PJC_25629_CandC_MasterSKUList

SELECT COUNT(*) from PJC_25629_CandC_MasterSKUList              -- 2275
SELECT COUNT(distinct ixSKU) from PJC_25629_CandC_MasterSKUList -- 2275

SELECT * FROM PJC_25629_CandC_MasterSKUList ML
JOIN [SMI Reporting].dbo.tblSKU SKU on ML.ixSKU = SKU.ixSKU

UPDATE PJC_25629_CandC_MasterSKUList
SET ixSKU = '9261002601'
where ixSKU = '92610026-01'

SELECT * FROM PJC_25629_CandC_MasterSKUList ML
WHERE ixSKU NOT IN (select ixSKU from [SMI Reporting].dbo.tblSKU)





-- DROP TABLE PJC_25629_FlaggedSKUs
SELECT TOP 10 * FROM PJC_25629_FlaggedSKUs

SELECT COUNT(*) from PJC_25629_FlaggedSKUs
SELECT COUNT(distinct ixSKU) from PJC_25629_FlaggedSKUs

SELECT * FROM PJC_25629_FlaggedSKUs FS
JOIN [SMI Reporting].dbo.tblSKU SKU on FS.ixSKU = SKU.ixSKU


SELECT * FROM PJC_25629_FlaggedSKUs FS
JOIN  PJC_25629_CandC_MasterSKUList ML on FS.ixSKU = ML.ixSKU


update A 
set COLUMN = B.COLUMN,
   NEXTCOLUMN = B.NEXTCOLUMN
from FIRSTTABLE A
 join SECONDTABLE B on A.XXX = B.XXX


-- create and populate flgLaser on Master List
UPDATE ML
set flgLaser = 1
from PJC_25629_CandC_MasterSKUList ML 
    JOIN PJC_25629_FlaggedSKUs FS on ML.ixSKU = FS.ixSKU
    

SELECT ixSKU+'²'+iQOH       -- 100
from  PJC_25629_CandC_MasterSKUList   
where flgLaser = 1

SELECT ixSKU+'²'+iQOH       -- 100
from  PJC_25629_CandC_MasterSKUList   
where flgLaser is NULL

select * from PJC_25629_CandC_MasterSKUList

select * from tblIPAddress
where sDescription like '%05%'