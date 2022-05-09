SELECT SKU.ixSKU, 
    TNG.ixSOPSKUBase,
    TNG.dtDateFirstMadeWebActiveUtc as 'dtSKUBaseFirstMadeWebActive',
    SKU.dtCreateDate
FROM tblSKU SKU        -- 336,890
    left join openquery([TNGREADREPLICA], '
                SELECT -- 326,574
                  SV.ixSOPSKU,
                  SB.ixSOPSKUBase,
                  SB.dtDateFirstMadeWebActiveUtc
                from tblskuvariant SV
                    left join tblskubase SB ON SV.ixSKUBase = SB.ixSKUBase
               ') TNG on TNG.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE SKU.flgDeletedFromSOP = 0 -- 326,557
    and SKU.flgActive = 1           -- 227,795
    and SKU.flgIntangible = 0       -- 222,730
ORDER BY  TNG.dtDateFirstMadeWebActiveUtc    


225,953 167