-- next SKU FIFO Cost for Kayla

select * from tblFIFODetail
where ixSKU = '91018017'
--and sFIFOSourceType = 'R'
   -- and ixLocation = 99
    and ixDate = 19586 -- "yesterday" is always the latest date.  

-- IOridinality 1 should alwasy be the cost of the next unit we sell


select * from tblSKULocation 
where ixSKU = '91018017'


select ixSKU, count(distinct mFIFOCost)
from tblFIFODetail
group by ixSKU
having count(distinct mFIFOCost) > 3
order by count(distinct mFIFOCost) desc

