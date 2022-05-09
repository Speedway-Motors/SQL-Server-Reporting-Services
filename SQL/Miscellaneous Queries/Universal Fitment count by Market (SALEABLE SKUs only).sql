-- Universal Fitment count by Market (SALEABLE SKUs only)

select m.sMarketName, FORMAT(count(*),'###,###') as 'SkuCountUniversalFit'
from tng.tblskuvariant_vehicle_base svb
    inner join tng.tblskuvariant s on svb.ixSkuVariant = s.ixSKUVariant
    inner join tng.tblskubase_universal_market bum on bum.ixSkuBase = s.ixSkuBase
    inner join (-- SALEABLE SKUs
                SELECT DISTINCT t.ixSOPSKU AS 'ixSOPSKU', t1.ixSOPSKUBase 'SOPSKUBase', t.ixSKUBase 'SKUBase'  -- 168,191 SKUs
                FROM tng.tblskuvariant t
                    INNER JOIN tng.tblskubase t1 ON t.ixSKUBase = t1.ixSKUBase
                    INNER JOIN tng.tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
                    INNER JOIN tng.tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
                WHERE t.ixSOPSKU is NOT NULL
                    AND t.flgPublish = 1
                    AND t1.flgWebPublish = 1
                    AND t3.flgActive = 1
                    AND(t.iTotalQAV > 0 
                        OR t.flgBackorderable = 1)
                ) ss ON ss.ixSOPSKU = s.ixSOPSKU
    inner join tng.tblmarket m on m.ixMarket = bum.ixMarket 
group by  m.sMarketName







