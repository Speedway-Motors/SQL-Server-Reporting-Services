-- PGC Updates for AFCO

/* table backed up

select * from [SMIArchive].dbo.BU_AFCO_tblPGC_20220615


SELECT * INTO [SMIArchive].dbo.BU_AFCO_tblPGC_20220620
FROM tblPGC
*/

SELECT count(*) from tblPGC -- 516		613

SELECT dtDateLastSOPUpdate, count(*) 'RecCnt'
FROM tblPGC
GROUP BY dtDateLastSOPUpdate
ORDER BY dtDateLastSOPUpdate
/*			BEFORE

	dtDateLast
	SOPUpdate	RecCnt
	==========	======
	2022-06-17	382
	2022-06-20	231


			AFTER

	dtDateLast
	SOPUpdate	RecCnt
	=========	======
	2022-06-20	231

SELECT *
-- DELETE
FROM tblPGC
where dtDateLastSOPUpdate < '06/20/2022'


*/

-- Most (all?) AFCO SKUs will be refed because they're being reassigned PGCs

SELECT FORMAT(count(*),'###,###') 'RecCnt'
from tblSKU
where flgDeletedFromSOP = 0 -- 80,096 -- EVERY SKU has been updated 6/11/2022 or later
	and dtDateLastSOPUpdate < '06/18/2022' -- 4,522 @10:26


select ixSKU, ixPGC
from tblSKU
where flgDeletedFromSOP = 0
 AND ixPGC IN (select ixPGC from tblPGC)
order by dtDateLastSOPUpdate




select S.ixPGC, 
	PGC.sDescription,
	FORMAT(count(S.ixSKU),'###,###') SKUCnt
from tblPGC PGC 
	left join tblSKU S on S.ixPGC = PGC.ixPGC
where S.flgDeletedFromSOP = 0
	or S.ixSKU is NULL
group by S.ixPGC, PGC.sDescription
order by count(S.ixSKU), PGC.sDescription


