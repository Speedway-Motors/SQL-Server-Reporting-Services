-- Testing new SKU Snapshot table
select * from ssSKU where ixSKU = '917346-31' -- verified through 17148. Should never change
order by ixDateStart desc

select * from tblSnapshotSKU where ixSKU = '917346-31' 
order by ixDate desc  -- same values 17137-17921 --





select * from ssSKU where ixSKU = '1011001110' 
and ixDateStart >= 17142 
order by ixDateStart desc-- verified through 17148, should change again on 17151

select * from tblSnapshotSKU where ixSKU = '1011001110' 
and ixDate >= 17142 
order by ixDate desc 





SELECT MAX(ixDateStart) from ssSKU -- 17149

select * from tblDate where ixDate in (17137,17148, 17921) 
17137	2014-12-01
17921	2017-01-23
