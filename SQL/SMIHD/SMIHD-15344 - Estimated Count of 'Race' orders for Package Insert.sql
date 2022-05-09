-- SMIHD-15344 - Estimated Count of 'Race' orders for Package Insert

SELECT COUNT(distinct ixOrder)
from tblOrderLine OL
    left join tblSKU S on OL.ixSKU = S.ixSKU
    left join tblPGC PGC on PGC.ixPGC = S.ixPGC
where dtShippedDate between '11/01/2018' and '12/31/2018' -- 48,315   24
    and PGC.ixMarket = 'R'
    and ixOrder NOT LIKE '%-%' -- 47845
        and ixOrder NOT LIKE 'Q%' -- 46732
                and ixOrder NOT LIKE 'P%' -- 46,732




SELECT COUNT(distinct ixOrder)
from tblOrderLine OL
    left join tblSKU S on OL.ixSKU = S.ixSKU
    left join tblPGC PGC on PGC.ixPGC = S.ixPGC
where dtShippedDate between '01/01/2019' and '03/31/2019' -- 69,743 24
    and PGC.ixMarket = 'R'
        and ixOrder NOT LIKE '%-%' 
        and ixOrder NOT LIKE 'Q%' 
                and ixOrder NOT LIKE 'P%' -- 65,780




SELECT distinct ixMarket
from tblPGC
