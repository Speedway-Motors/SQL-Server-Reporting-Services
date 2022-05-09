-- tblSnapshotSKU DW1 checks
-- 16803	= 01/01/2014


select count(*) FROM [SMI Reporting].dbo.tblSnapshotSKU 
WHERE 
ixDate < 16803 -- 53.9 current              55.8M orig


select count(*) FROM [SMI Reporting].dbo.tblSnapshotSKU 
WHERE ixDate < 16453 -- 1.6M








select MIN(ixDate) from [SMI Reporting].dbo.tblSnapshotSKU 







select ixDate, count(*) FROM [SMI Reporting].dbo.tblSnapshotSKU 
WHERE 
ixDate < 16803 -- 8.9M  
group by ixDate
order by ixDate 

count(*) desc







select * from tblDate 
where ixDate = 16437 -- '12/31/2012'


select MIN(ixDate) from [SMI Reporting].dbo.tblSnapshotSKU -- 16308 01/01/2012      -- 16072 to TODAY

16308	2012-08-24







