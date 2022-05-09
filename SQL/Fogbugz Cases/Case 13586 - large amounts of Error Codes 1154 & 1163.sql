select '1154 - Failure to update tblBinSKU',
    dtDate 'Date', 
    count(*) 'QTY'
from tblErrorLogMaster
where ixErrorCode = '1154'
    and dtDate >= '02/01/2012'
group by dtDate
order by dtDate desc


select '1163 - Failure to update tblSKU', 
    dtDate 'Date', 
    count(*) 'QTY'
from tblErrorLogMaster
where ixErrorCode = '1163'
    and dtDate >= '02/01/2012'
group by dtDate
order by dtDate desc


