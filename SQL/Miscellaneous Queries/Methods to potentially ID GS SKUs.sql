-- Methods to potentially ID GS SKUs
/*  
If the style is in the garage sale market (tblskubasemarket)
2. If the sku is marked as a garage sale (tblskuvariant_garagesale_xref)
*/
SELECT TNG.ixSOPSKU 'SKU',
       TNG.GSType 'TNG_GSType',
       TNG.GSMarket 'TNG_GSMarket',
        (CASE when SKU.ixSKU like 'UP%' then 'Y' 
              else 'N'
         end) as 'UP_SKU',
         (CASE when SUBSTRING(SKU.ixPGC,2,1) <> UPPER(SUBSTRING(SKU.ixPGC,2,1)) then 'Y'
               else 'N'
         end) as 'GS_PGC'
FROM openquery(TNGREADREPLICA, '
            SELECT sv.ixSOPSKU, 
            (CASE WHEN t.ixSKUVariant is NOT NULL then ''Y''
                  else ''N''   
             end) AS ''GSType'',
            (CASE WHEN bm.ixMarket = 222 then ''Y''
                  else ''N''
             end) as ''GSMarket''
FROM tblskuvariant sv
LEFT JOIN tblskubasemarket bm on sv.ixSKUBase = bm.ixSKUBase and bm.ixMarket = 222 -- Garage Sale
LEFT JOIN (SELECT distinct ixSKUVariant
           FROM tblskuvariant_garagesale_xref svgs 
           WHERE ixGarageSaleType is NOT NULL) t on sv.ixSKUVariant = t.ixSKUVariant
           ') TNG
JOIN tblSKU SKU on SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = TNG.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CS_AS

