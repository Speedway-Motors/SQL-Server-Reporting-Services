-- SMIHD-3836 - GTN exception reports - GTINs assigned to multiple SKUs


Select * from -- 859 Active  about 26 of those are GS, 524 HAVE NO GTIN
openquery([TNGREADREPLICA], '
                SELECT 
                    svExt.ixSOPSKU as SOPSKU, 
                    dupv.sAttributeValue as GTIN,
                    dupv.iSkusSharingValue as SKUsWithSameGTIN,
                    (CASE when GS.ixSkuVariant is NULL then ''N'' 
                       else ''Y''
                     end) AS GarageSale,
                     br.ixBrand as Brand
                FROM tblskuvariant svExt
                    INNER JOIN tblskuvariant_skuattribute_value svsavExt ON svExt.ixSKUVariant = svsavExt.ixSkuVariant
                    INNER JOIN (SELECT 
                                    count(svsav.ixSkuAttributeValue) AS iSkusSharingValue,
                                    sav.ixSkuAttributeValue, 
                                    sav.sAttributeValue
                                FROM tblskuvariant_skuattribute_value svsav 
                                    INNER JOIN tblskuattribute_value sav ON svsav.ixSkuAttributeValue = sav.ixSkuAttributeValue
                                WHERE sav.ixSkuAttribute = 1437
                                GROUP BY svsav.ixSkuAttributeValue 
                                HAVING count(svsav.ixSkuAttributeValue) > 1
                                ) AS dupv ON svsavExt.ixSkuAttributeValue = dupv.ixSkuAttributeValue
                   LEFT JOIN vwSkuVariantGarageSale GS on GS.ixSkuVariant = svExt.ixSkuVariant
                   INNER JOIN (-- Active SKUs
                              SELECT ixSKUVariant -- approx 102k
                              FROM tblskuvariant sv
                                INNER JOIN tblskubase sb ON sv.ixSKUBase = sb.ixSKUBase
                                INNER JOIN tblproductpageskubase ppsb ON sb.ixSKUBase = ppsb.ixSKUBase
                                INNER JOIN tblproductpage pp ON ppsb.ixProductPage = pp.ixProductPage
                              WHERE sv.flgPublish = 1
                                  AND sb.flgWebActive = 1
                                  AND sb.flgWebPublish = 1
                                  AND pp.flgActive = 1
                                  AND (sv.iTotalQAV > 0 
                                      OR sv.flgBackorderable = 1)
                              ) as ACTV ON ACTV.ixSKUVariant = svExt.ixSKUVariant 
                    INNER JOIN tblskubase b on svExt.ixSKUBase = b.ixSKUBase   
                    LEFT JOIN tblbrand br on br.ixBrand = b.ixBrand                           
-- WHERE dupv.sAttributeValue = ''''                         
                ORDER BY dupv.sAttributeValue DESC, dupv.iSkusSharingValue;
                ')
                


  