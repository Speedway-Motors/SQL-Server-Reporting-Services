-- CREATE A VIEW WHEN DONE

-- latest timestamps from each table
select 'tblBin' as TableName, max(D.dtDate)
from tblDate D 
	join tblBin B on B.ixCreateDate = D.ixDate
where D.dtDate > DATEADD(day,-3,getdate())
UNION
select 'tblBinSku' as TableName,max(D.dtDate)
from tblDate D 
	join tblBinSku BS on BS.ixUpdateDate = D.ixDate
where D.dtDate > DATEADD(day,-3,getdate())
UNION
select 'tblBOMSequence' as TableName, max(D.dtDate)
from tblDate D 
	join tblBOMSequence BS on BS.ixCreateDate = D.ixDate
where D.dtDate > DATEADD(day,-10,getdate())
UNION
select 'tblBOMTemplateMaster' as TableName, max(D.dtDate)
from tblDate D 
	join tblBOMTemplateMaster X on X.ixCreateDate = D.ixDate
where D.dtDate > DATEADD(day,-10,getdate())
UNION
select 'tblBOMTransferMaster' as TableName, max(D.dtDate)
from tblDate D 
	join tblBOMTransferMaster X on X.ixCreateDate = D.ixDate
where D.dtDate > DATEADD(day,-10,getdate())
UNION
select 'tbl#####' as TableName, max(D.dtDate)
from tblDate D 
	join tbl#####  X on X.ixCreateDate = D.ixDate
where D.dtDate > DATEADD(day,-10,getdate())
UNION
select 'tbl#####' as TableName, max(D.dtDate)
from tblDate D 
	join tbl##### BS on BS.ixCreateDate = D.ixDate
where D.dtDate > DATEADD(day,-10,getdate())
UNION


select ixVendor
from tblVendorSKU
where len(ixVendor) > 4