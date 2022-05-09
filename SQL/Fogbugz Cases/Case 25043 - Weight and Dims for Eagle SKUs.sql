-- Case 25043 - Weight and Dims for Eagle SKUs


select * from PJC_25043_EagleCombinedSKULists
where SheetSource = 'Both'


set rowcount 0

-- forgot to remove dupes tagged with 'Both'
select ixSKU, COUNT(*) from PJC_25043_EagleCombinedSKULists
where SheetSource = 'Both'
group by ixSKU
order by COUNT(*) desc
/*
*/

set rowcount 1
-- DELETE
from PJC_25043_EagleCombinedSKULists
where ixSKU = '9708011'
set rowcount 0

select COUNT(E.ixSKU) 
from PJC_25043_EagleCombinedSKULists E                  -- 2,434
join [SMI Reporting].dbo.tblSKU S on S.ixSKU = E.ixSKU  -- 1,612


UPDATE E
set SKUMatchInDW = 'Y',
   dWeight = S.dWeight,
   iLength = S.iLength,
   iWidth = S.iWidth,
   iHeight = S.iHeight
from PJC_25043_EagleCombinedSKULists E
 join [SMI Reporting].dbo.tblSKU S on E.ixSKU = S.ixSKU

UPDATE PJC_25043_EagleCombinedSKULists
SET SKUMatchInDW = 'N'
where SKUMatchInDW is NULL


update A 
set COLUMN = B.COLUMN,
   NEXTCOLUMN = B.NEXTCOLUMN
from FIRSTTABLE A
 join SECONDTABLE B on A.XXX = B.XXX
 
 
SELECT * FROM PJC_25043_EagleCombinedSKULists
WHERE SKUMatchInDW = 'N'
and ixSKU like '%-%'
and SheetSource = 'JFPriced '
ORDER BY ixSKU




SELECT * FROM PJC_25043_EagleCombinedSKULists
WHERE SKUMatchInDW = 'N'
and ixSKU like '%-%'
and SheetSource = 'JFPriced'
ORDER BY ixSKU


UPDATE PJC_25043_EagleCombinedSKULists
SET ixCorrectedSKU = substring(ixSKU,1,3) + substring(ixSKU,5,99999) 
WHERE substring(ixSKU,4,1) = '-'
    and SKUMatchInDW = 'N'
    and SheetSource = 'JFPriced'


Select 
top 10 ixSKU, 
substring(ixSKU,1,3) + substring(ixSKU,5,99999) as NewString 
from PJC_25043_EagleCombinedSKULists
WHERE substring(ixSKU,4,1) = '-'
and SKUMatchInDW = 'N'
and SheetSource = 'JFPriced '
ORDER BY ixSKU


select ixSKU, ixCorrectedSKU
from PJC_25043_EagleCombinedSKULists
where ixCorrectedSKU is NOT NULL


UPDATE E
set SKUMatchInDW = 'Y',
   dWeight = S.dWeight,
   iLength = S.iLength,
   iWidth = S.iWidth,
   iHeight = S.iHeight
from PJC_25043_EagleCombinedSKULists E
 join [SMI Reporting].dbo.tblSKU S on E.ixCorrectedSKU = S.ixSKU
 
 
SELECT S.ixSKU
from PJC_25043_EagleCombinedSKULists E
 join [SMI Reporting].dbo.tblSKU S on E.ixCorrectedSKU = S.ixSKU 
 
 

 
select ixSKU           'SKUProvided', 
         ixCorrectedSKU 'SKUCorrectedTo',
         SKUMatchInDW,
         dWeight        'WeightSOPlbs',
         (dWeight*16)   'OZ',
         SheetSource,
         iLength        'Length',
         iWidth         'Width',
         iHeight        'Height'
from  PJC_25043_EagleCombinedSKULists
order by   SKUMatchInDW desc,
dWeight      
 
 
 
