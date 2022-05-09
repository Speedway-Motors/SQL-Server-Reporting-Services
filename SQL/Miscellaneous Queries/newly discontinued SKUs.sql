-- newly discontinued SKUs
SELECT count(ixSKU) 
from tblSnapshotSKU SS
    left join tblSKU S on SS.ixSKU = S.ixSKU
where ixDate = 18984
and S.dtDiscontinuedDate 


select FORMAT(count(*),'###,###') 'SKUCnt', getdate()
from tblSKU where dtDiscontinuedDate <= '12/23/19' 
    and flgDeletedFromSOP = 0 -- 226,779
                              -- 230,380	2019-12-23 16:16:22.587

   
select  FORMAT(count(*),'###,###') 'SKUCnt'
from tblSKU 
where flgDeletedFromSOP = 0
and flgActive = 1 -- 233,004

select FORMAT(dtDiscontinuedDate,'yyyy.MM.dd') as 'Discontinued', FORMAT(count(*),'###,###') 'SKUCnt'
from tblSKU
 where flgDeletedFromSOP = 0
 and dtDiscontinuedDate between '12/01/19' and '12/31/19'
 and flgActive = 0
 group by  dtDiscontinuedDate
order by dtDiscontinuedDate desc
/*
Discontnd	SKUCnt
2019.12.22	62,720
2019.12.20	1
2019.12.19	82
2019.12.18	10
2019.12.17	3
2019.12.16	55
2019.12.15	3
2019.12.13	1
2019.12.12	6
2019.12.11	11
2019.12.10	1,571
2019.12.09	142
2019.12.08	9
2019.12.06	2
2019.12.05	5
2019.12.04	327
2019.12.03	11
2019.12.02	9
2019.12.01	4
*/
