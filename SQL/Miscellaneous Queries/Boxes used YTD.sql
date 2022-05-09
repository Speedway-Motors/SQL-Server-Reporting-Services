-- Boxes used YTD

select ixBoxSKU, count(*)
from tblPackage
where ixShipDate >= 19360--	1/1/21                  07/01/2021 -- 
group by ixBoxSKU
ORDER BY ixBoxSKU


SELECT ixBoxSKU,  FORMAT(COUNT(*),'###,###') 'QtyUsedYTD'
INTO #UsedYTD -- DROP TABLE #UsedYTD
FROM tblPackage
WHERE ixShipDate >= 19360 --	1/1/21   
    and flgCanceled = 0
    and flgReplaced = 0
    and ( ixBoxSKU LIKE 'BOX-%' 
         OR ixBoxSKU LIKE 'PS%'
         OR ixBoxSKU LIKE 'FCM%'
        )
GROUP BY ixBoxSKU
ORDER BY ixBoxSKU


SELECT S.ixSKU, sDescription, flgActive,  S.iLength, S.iWidth, S.iHeight, SL.iQAV, SL.iQOS, YTD.QtyUsedYTD
FROM tblSKU S
    left join tblSKULocation SL on S.ixSKU = SL.ixSKU and SL.ixLocation = 99
    left join #UsedYTD YTD on YTD.ixBoxSKU = S.ixSKU
WHERE flgDeletedFromSOP = 0
    and ( S.flgActive = 1 OR SL.iQAV > 0) -- active or we still have some
    and (S.ixSKU LIKE 'BOX-%' 
        OR S.ixSKU LIKE 'PS%'
        OR S.ixSKU LIKE 'FCM%'
        )
   -- and S.ixSKU in ('BOX-156','BOX-198')
order by flgActive Desc, QtyUsedYTD desc
    
    

    
SELECT sPackageType, FORMAT(COUNT(*),'###,###') SKUCnt
from tblSKU
where flgDeletedFromSOP = 0
and flgActive = 1
group by sPackageType
/*
sPackage
Type	SKUCnt
NULL	1
BOX	    55
ENV	    3
NA	    183,839         -- How is this data useful at all!?!
NEW	    27,658
SLAPR	3,813
*/



