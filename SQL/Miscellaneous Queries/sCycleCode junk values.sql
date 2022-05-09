-- sCycleCode junk values
select sProductContentQuality, FORMAT(count(*),'###,###') 'SKUcnt'
from tblSKU
where flgDeletedFromSOP = 0
group by sProductContentQuality

/*
sProduct
Content
Quality	SKUcnt
=======	=======
NULL	541,119
A		1,088
B		514
C		874
*/

select FORMAT(count(*),'###,###') 'SKUcnt' -- 2,486 @4/1/22	12:40
from tblSKU
where flgDeletedFromSOP = 0
and sProductContentQuality is NOT NULL

select ixSKU, dtCreateDate, sProductContentQuality, dtDateLastSOPUpdate
from tblSKU
where flgDeletedFromSOP = 0
	and sProductContentQuality in ('A','B') -- is NOT NULL
order by dtDateLastSOPUpdate

select len(sCycleCode) 'Chars', sCycleCode, count(*) 'SKUCnt'
from tblSKU
where flgDeletedFromSOP = 0
	and flgActive = 1
	and len(sCycleCode) <>  5
	and sCycleCode NOT like '%NA%'
group by sCycleCode
order by len(sCycleCode) --count(*) desc

