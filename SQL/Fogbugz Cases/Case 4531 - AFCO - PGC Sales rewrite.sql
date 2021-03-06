SELECT
    QualifyingSKUS.ixSKU    SKU,
    QualifyingSKUS.ixPGC,
    QualifyingSKUS.MajorSC,
    QualifyingSKUS.MinorSC,
    Performance.YTDQTYSold,
    Performance.YTDSales,
    Performance.YTDCost,
    Performance.YTDGP,
    Performance.YR2QTYSold,
    Performance.YR2Sales,
    Performance.YR2Cost, 
    Performance.YR2GP
FROM
    (SELECT
        distinct(OL.ixSKU),
        SKU.ixPGC,
        SUBSTRING(SKU.ixPGC,1,1) MajorSC,
        SUBSTRING(SKU.ixPGC,2,1) MinorSC
    FROM tblOrderLine OL 
        left join tblSKU SKU on SKU.ixSKU = OL.ixSKU
        left join tblPGC PGC on PGC.ixPGC = SKU.ixPGC
    WHERE 
            OL.flgLineStatus = 'Shipped'
        and OL.dtShippedDate >= DATEADD(yy, DATEDIFF(yy,0,'09/01/10')-1, 0)   -- first of the year for '09/01/10' -1 yr
        and OL.dtShippedDate < DATEADD(mm, DATEDIFF(mm,0,'09/01/10'), 0) -- first of the month for '09/01/10'
    ) QualifyingSKUS

left join (
    SELECT
        isnull(YTD.ixSKU,YR2.ixSKU) ixSKU,                -- Our Part Number
        /*********** section 2 TY_YTD & LY_YTD SUMMARY **********/
        isnull(YTD.QTYSold,0)   YTDQTYSold,
        isnull(YTD.Sales,0)     YTDSales,
        isnull(YTD.Cost,0)      YTDCost,
        isnull(YTD.GP,0)        YTDGP,
        isnull(YR2.QTYSold,0)   YR2QTYSold,
        isnull(YR2.Sales,0)     YR2Sales,
        isnull(YR2.Cost,0)      YR2Cost, 
        isnull(YR2.GP,0)        YR2GP
    FROM 
             /****** YTD SALES-RETURNS *********/ 
               (SELECT
                    isnull(SKUSales.ixSKU,SKUReturns.ixSKU)                     ixSKU,              
                    isnull(SKUSales.QTYSold,0)-isnull(SKUReturns.QTYCredited,0) QTYSold,
                    isnull(SKUSales.Sales,0)-isnull(SKUReturns.Sales,0)         Sales,
                    isnull(SKUSales.Cost,0) -isnull(SKUReturns.Cost,0)          Cost,
                    isnull(SKUSales.GP,0)-isnull(SKUReturns.GP,0)               GP
                FROM 
                    /****** RETURNS *********/  
                    (select CMD.ixSKU,
                          --D.iYearMonth,
                          SUM(CMD.iQuantityCredited) QTYCredited,
                          SUM(CMD.iQuantityCredited*CMD.mUnitPrice) Sales,
                          SUM(CMD.iQuantityCredited*CMD.mUnitCost) Cost,
                          SUM((CMD.mUnitPrice-CMD.mUnitCost)*CMD.iQuantityCredited) GP
                    from tblCreditMemoDetail CMD
                        join tblCreditMemoMaster CMM on CMM.ixCreditMemo = CMD.ixCreditMemo 
                            and CMM.dtCreateDate >= DATEADD(yy, DATEDIFF(yy,0,'09/01/10'), 0)   -- first of the year for '09/01/10'
                            and CMM.dtCreateDate < DATEADD(mm, DATEDIFF(mm,0,'09/01/10'), 0) -- first of the month for '09/01/10'
                        left join tblDate D on D.dtDate = CMM.dtCreateDate
                        left join tblSKU S on S.ixSKU = CMD.ixSKU 
                    group by CMD.ixSKU
                    ) SKUReturns 
                full outer join
                     /****** SALES *********/   
                    (select OL.ixSKU,
                            --D.iYearMonth,
                            SUM(OL.iQuantity) QTYSold,
                            SUM(OL.iQuantity*CAST(OL.mUnitPrice as Money)) Sales,
                            SUM(OL.mExtendedCost) Cost,
                            SUM((OL.mUnitPrice-OL.mCost)* CAST(OL.iQuantity as Money)) GP
                     from tblOrder O 
                        join tblOrderLine OL on OL.ixOrder = O.ixOrder 
                                and OL.flgLineStatus = 'Shipped' 
                                and OL.dtOrderDate >= DATEADD(yy, DATEDIFF(yy,0,'09/01/10'), 0)   -- first of the year for '09/01/10'
                                and OL.dtOrderDate < DATEADD(mm, DATEDIFF(mm,0,'09/01/10'), 0) -- first of the month for '09/01/10'
                                and flgKitComponent = 0
                        left join tblDate D on D.dtDate = OL.dtOrderDate 
                        left join tblSKU S on S.ixSKU = OL.ixSKU 
                     -- per Laurie, INCLUDE internal orders
                     group by OL.ixSKU
                    ) SKUSales on SKUSales.ixSKU = SKUReturns.ixSKU
                      ) YTD 
            /****** YR2 (last year YTD) SALES-RETURNS *********/ 
            left join (SELECT
                        isnull(SKUSales.ixSKU,SKUReturns.ixSKU)                     ixSKU,              
                        isnull(SKUSales.QTYSold,0)-isnull(SKUReturns.QTYCredited,0) QTYSold,
                        isnull(SKUSales.Sales,0)-isnull(SKUReturns.Sales,0)         Sales,
                        isnull(SKUSales.Cost,0) -isnull(SKUReturns.Cost,0)          Cost,
                        isnull(SKUSales.GP,0)-isnull(SKUReturns.GP,0)               GP
                        FROM 
                    /****** RETURNS *********/  
                        (select CMD.ixSKU,
                              --D.iYearMonth,
                              SUM(CMD.iQuantityCredited) QTYCredited,
                              SUM(CMD.iQuantityCredited*CMD.mUnitPrice) Sales,
                              SUM(CMD.iQuantityCredited*CMD.mUnitCost) Cost,
                              SUM((CMD.mUnitPrice-CMD.mUnitCost)*CMD.iQuantityCredited) GP
                        from tblCreditMemoDetail CMD
                            join tblCreditMemoMaster CMM on CMM.ixCreditMemo = CMD.ixCreditMemo 
                                and CMM.dtCreateDate >= DATEADD(yy, DATEDIFF(yy,0,'09/01/10')-1, 0)   -- first of the year for '09/01/10' -1 yr
                                and CMM.dtCreateDate < DATEADD(mm, DATEDIFF(mm,0,'09/01/10')-12, 0) -- first of the month for '09/01/10' -1 yr
                            left join tblDate D on D.dtDate = CMM.dtCreateDate
                            left join tblSKU S on S.ixSKU = CMD.ixSKU 
                        group by CMD.ixSKU
                        ) SKUReturns 
                     full join
                     /****** SALES *********/   
                        (select OL.ixSKU,
                                --D.iYearMonth,
                                SUM(OL.iQuantity) QTYSold,
                                SUM(OL.iQuantity*CAST(OL.mUnitPrice as Money)) Sales,
                                SUM(OL.mExtendedCost) Cost,
                                SUM((OL.mUnitPrice-OL.mCost)* CAST(OL.iQuantity as Money)) GP
                         from tblOrder O 
                            join tblOrderLine OL on OL.ixOrder = O.ixOrder 
                                    and OL.flgLineStatus = 'Shipped' 
                                    and OL.dtOrderDate >= DATEADD(yy, DATEDIFF(yy,0,'09/01/10')-1, 0)   -- first of the year for '09/01/10' -1 yr
                                    and OL.dtOrderDate < DATEADD(mm, DATEDIFF(mm,0,'09/01/10')-12, 0) -- first of the month for '09/01/10' -1 yr
                                    and flgKitComponent = 0
                            left join tblDate D on D.dtDate = OL.dtOrderDate 
                            left join tblSKU S on S.ixSKU = OL.ixSKU 
                         -- per Laurie, INCLUDE internal orders
                         group by OL.ixSKU
                        ) SKUSales on SKUSales.ixSKU = SKUReturns.ixSKU

                      ) YR2 on YR2.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = YTD.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS

    ) Performance on Performance.ixSKU = QualifyingSKUS.ixSKU


