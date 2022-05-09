-- SMIHD-14951 - Cubic Volume of SKUs for Tolleson
SELECT AZD.*, 
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    S.dWeight,
    S.iLength, S.iWidth, S.iHeight,
    (S.iLength * S.iWidth * S.iHeight) 'UnitVol',
    ((S.iLength * S.iWidth * S.iHeight)*AZD.Qty) 'ExtVol'
FROM [SMITemp].dbo.PJC_AZD_SKUVolume AZD
    left join tblSKU S on AZD.ixSKU = S.ixSKU
-- WHERE (S.iLength * S.iWidth * S.iHeight) > 10000 -- 'UnitVol'
ORDER BY  ((S.iLength * S.iWidth * S.iHeight)*AZD.Qty)


