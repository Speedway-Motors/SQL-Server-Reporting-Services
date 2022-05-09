SELECT 
    ixVendor,
    SUM(CASE WHEN AVGInvCost = 0 THEN 0 ELSE (ExCost/AVGInvCost)
        END) InvTurn,
    ExCost,
    AVGInvCost,
    YTDGP,
    YR2GP
FROM
        (SELECT 
            V.ixVendor,
        -- CASE WHEN [Denominator] = 0 THEN 0 ELSE [Numerator] / [Denominator]
            SUM(isnull(YTD.YTDQTYSold,0)*VSKU.mCost)   ExCost,
            SUM(isnull(YTD.AVGInvCost,0))              AVGInvCost,
            SUM(isnull(YTD.YTDGP,0))                   YTDGP,
            SUM(isnull(YR2.YR2GP,0))                   YR2GP
        FROM tblSKU SKU
                left join tblVendorSKU VSKU on VSKU.ixSKU = SKU.ixSKU and VSKU.iOrdinality = 1
                left join tblVendor V on V.ixVendor = VSKU.ixVendor
                left join (SELECT                               
                           AMS.ixSKU,
                             SUM(AMS.AdjustedQTYSold)   YTDQTYSold,
                             SUM(AMS.AdjustedGP)        YTDGP,
                             AVG(AMS.AVGInvCost)        AVGInvCost
                          FROM tblSnapAdjustedMonthlySKUSales AMS
                          WHERE AMS.iYearMonth >= '01/01/2010' and AMS.iYearMonth < '01/01/2011'
                          GROUP BY AMS.ixSKU
                          ) YTD on YTD.ixSKU = SKU.ixSKU

                left join (SELECT                               
                           AMS.ixSKU,
                             SUM(AMS.AdjustedGP)    YR2GP
                          FROM tblSnapAdjustedMonthlySKUSales AMS
                                      WHERE AMS.iYearMonth >= '01/01/2009' and AMS.iYearMonth < '01/01/2010' 
                          GROUP BY AMS.ixSKU
                          ) YR2 on YR2.ixSKU = SKU.ixSKU
       -- WHERE 
         -- V.ixVendor between '0' and  '9999'
         --(YTD.YTDQTYSold is not null OR YR2.YR2QTYSold is not null)
        GROUP BY V.ixVendor
        ) SUB1
GROUP BY 
    ixVendor,
    ExCost,
    AVGInvCost,
    YTDGP,
    YR2GP
order by YTDGP

