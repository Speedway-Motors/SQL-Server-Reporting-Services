-- SMIHD-15497 - SKU QAV Over Time 
SELECT d.dtDate,
       sum(fd.iFIFOQuantity) 'FIFOQty'
FROM tblFIFODetail fd
    left join tblDate d on fd.ixDate=d.ixDate
WHERE fd.ixSKU='9158004' -- @SKU  '91035341'  '9158004' 17 days worth of inv      9180035
GROUP BY d.dtDate
ORDER BY d.dtDate

select S.ixSKU, S.dtCreateDate, SL.iQAV
from tblSKU S
    left join tblSKULocation SL on S.ixSKU = SL.ixSKU and SL.ixLocation = 99
where dtCreateDate > '01/01/2017'
and SL.iQAV > 0
and S.ixSKU NOT LIKE 'UP%'
and S.ixSKU NOT LIKE 'AUP%'
and S.flgIntangible = 0
and S.mPriceLevel1 > 0
and S.flgActive = 1
order by SL.iQAV desc --newid()

91035341, 9158004
select * from tblFIFODetail where ixSKU = '9158004' order by ixDate desc -- 17 days



select * from 