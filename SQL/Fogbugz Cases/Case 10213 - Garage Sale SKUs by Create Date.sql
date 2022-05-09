select ixSKU SKU, iQAV QAV, ixPGC PGC, dtCreateDate Created, dtDiscontinuedDate DiscontinuedDate 
from tblSKU SKU
where substring(SKU.ixPGC,2,1) in ('a','c','d','q','r','s','z')
--and SKU.iQAV > 0
and ixSKU = 'UP13691'
order by dtCreateDate


