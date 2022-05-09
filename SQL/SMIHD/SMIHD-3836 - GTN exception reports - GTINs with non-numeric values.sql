-- SMIHD-3836 - GTN exception reports - GTINs with Non-numeric Values

Select * from 
openquery([TNGREADREPLICA], '
        SELECT 
            sv.ixSOPSKU as SOPSKU,
            -- sa.sTitle as Title,
            sav.sAttributeValue as GTINCode,
            sav.sUpdateUser as UpdateUser
        FROM tblskuattribute_value sav
            INNER JOIN tblskuattribute sa ON sa.ixSkuAttribute = sav.ixSkuAttribute
            INNER JOIN tblskuvariant_skuattribute_value svsav ON svsav.ixSkuAttributeValue = sav.ixSkuAttributeValue
            INNER JOIN tblskuvariant sv ON sv.ixSKUVariant = svsav.ixSkuVariant
        WHERE sav.ixSkuAttribute = 1437 && 
              sav.sAttributeValue REGEXP ''[^0-9]+''
')
