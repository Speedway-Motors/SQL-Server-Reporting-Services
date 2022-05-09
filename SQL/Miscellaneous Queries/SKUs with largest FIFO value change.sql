-- SKUs with largest FIFO value change
SELECT TOP 500 
    isNULL(PD.ixSKU,CD.ixSKU) 'SKU', -- 64,193 TOTAL SKUS
    isNULL(PD.FIFOValue,0) 'PD_FIFOValue',
    isNULL(CD.FIFOValue,0) 'CD_FIFOValue',
    ABS(isNULL(PD.FIFOValue,0) - isNULL(CD.FIFOValue,0)) 'Delta'
FROM
    (-- PRIMARY DATE
    select ixSKU, sum(iFIFOQuantity*mFIFOCost) 'FIFOValue' -- 
    from tblFIFODetail 
    where ixDate = 17624 --  4/1/16                       58,606 SKUs
    --and ixSKU ='1081X' -- $94.82
    GROUP BY ixSKU
    ) PD

FULL OUTER JOIN 

    (-- COMPARISON DATE
    select ixSKU, sum(iFIFOQuantity*mFIFOCost) 'FIFOValue'
    from tblFIFODetail 
    where ixDate = 17654 -- 05/01/16            -- 59,776 SKUs
    --and ixSKU ='1081X' -- $103.61
    GROUP BY ixSKU
    ) CD ON PD.ixSKU = CD.ixSKU
WHERE  isNULL(PD.FIFOValue,0) <> isNULL(CD.FIFOValue,0) -- excludes FIFO values that didn't change
ORDER BY Delta DESC  




select ixSKU, count(distinct mFIFOCost)
from tblFIFODetail 
where ixDate = 17624 -- 04/01/16            -- 233,000
GROUP BY ixSKU
ORDER BY count(distinct mFIFOCost) desc


SELECT *
from tblFIFODetail 
where ixDate = 17624 -- 04/01/16   
AND ixSKU = '1081X'