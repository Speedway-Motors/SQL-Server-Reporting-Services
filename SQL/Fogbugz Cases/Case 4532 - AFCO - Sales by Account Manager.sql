SELECT
    CUST.*,
    Performance.YTDOrdCount     YTDOrdCount,
    Performance.YTDSales        YTDGrossRev,
    Performance.YTDCost         YTDGrossCost,
    Performance.YTDReturnsRev   YTDReturnsRev,      
    Performance.YTDReturnsCost  YTDReturnsCost,
    Performance.YTDSales-Performance.YTDReturnsRev YTDNetRev,
    Performance.YTDCost-Performance.YTDReturnsCost YTDNetCost,
    ((Performance.YTDSales-Performance.YTDReturnsRev) - (Performance.YTDCost-Performance.YTDReturnsCost)) YTDGP,
    Performance.YR2OrdCount     YR2OrdCount,
    Performance.YR2Sales        YR2GrossRev,
    Performance.YR2Cost         YR2GrossCost,
    Performance.YR2ReturnsRev   YR2ReturnsRev,      
    Performance.YR2ReturnsCost  YR2ReturnsCost,
    Performance.YR2Sales-Performance.YR2ReturnsRev YR2NetRev,
    Performance.YR2Cost-Performance.YR2ReturnsCost YR2NetCost,
    ((Performance.YR2Sales-Performance.YR2ReturnsRev) - (Performance.YR2Cost-Performance.YR2ReturnsCost)) YR2GP
FROM
    (SELECT distinct
        C.ixAccountManager,
        OL.ixCustomer,
        C.sCustomerFirstName    FirstName,
        C.sCustomerLastName     LastName
       FROM tblOrderLine OL 
        left join tblSKU SKU on SKU.ixSKU = OL.ixSKU
        left join tblCustomer C on C.ixCustomer =OL.ixCustomer
       WHERE 
            OL.flgLineStatus = 'Shipped'
        and OL.dtShippedDate >= '01/01/2009'
        and OL.dtShippedDate < '08/01/2010'
     ) CUST

    left join (SELECT
                isnull(YTD.ixCustomer,'x') ixCustomer,              
                /*********** section 2 TY_YTD & LY_YTD SUMMARY **********/
                YTD.OrdCount          YTDOrdCount,
                isnull(YTD.Sales,0)     YTDSales,
                isnull(YTD.Cost,0)      YTDCost,
                isnull(YTD.ReturnsRev,0) YTDReturnsRev,
                isnull(YTD.ReturnsCost,0) YTDReturnsCost,
                YR2.OrdCount          YR2OrdCount,
                isnull(YR2.Sales,0)     YR2Sales,
                isnull(YR2.Cost,0)      YR2Cost, 
                isnull(YR2.ReturnsRev,0) YR2ReturnsRev,
                isnull(YR2.ReturnsCost,0) YR2ReturnsCost
              FROM 
             /****** YTD SALES-RETURNS *********/ 
               (SELECT
                    isnull(SKUSales.ixCustomer,CustReturns.ixCustomer) ixCustomer,              
                    OrdCount,
                    isnull(SKUSales.Sales,0)            Sales,
                    isnull(SKUSales.Cost,0)             Cost,
                    isnull(CustReturns.ReturnsRev,0)    ReturnsRev,
                    isnull(CustReturns.ReturnsCost,0)   ReturnsCost
                FROM 
                    /****** RETURNS *********/  
                    (select CMM.ixCustomer,
                          SUM(CMD.iQuantityCredited) QTYCredited,
                          SUM(CMD.iQuantityCredited*CMD.mUnitPrice) ReturnsRev,
                          SUM(CMD.iQuantityCredited*CMD.mUnitCost) ReturnsCost,
                          SUM((CMD.mUnitPrice-CMD.mUnitCost)*CMD.iQuantityCredited) GP
                    from tblCreditMemoDetail CMD
                        join tblCreditMemoMaster CMM on CMM.ixCreditMemo = CMD.ixCreditMemo 
                            and CMM.dtCreateDate >= '01/01/2010'
                            and CMM.dtCreateDate < '08/01/2010'
                        left join tblDate D on D.dtDate = CMM.dtCreateDate
                    group by CMM.ixCustomer
                    ) CustReturns 
                full outer join
                     /****** SALES *********/   
                    (select OL.ixCustomer,
                            count(distinct OL.ixOrder) OrdCount,
                            --SUM(OL.iQuantity) QTYSold,
                            SUM(OL.iQuantity*CAST(OL.mUnitPrice as Money)) Sales,
                            SUM(OL.mExtendedCost) Cost,
                            SUM((OL.mUnitPrice-OL.mCost)* CAST(OL.iQuantity as Money)) GP
                     from tblOrder O 
                        join tblOrderLine OL on OL.ixOrder = O.ixOrder 
                                and OL.flgLineStatus = 'Shipped' -- 'fail' 
                                and OL.dtOrderDate >= '01/01/2010'
                                and OL.dtOrderDate < '08/01/2010'
                                and flgKitComponent = 0
                        left join tblDate D on D.dtDate = OL.dtOrderDate 
                     group by OL.ixCustomer
                    ) SKUSales on SKUSales.ixCustomer = CustReturns.ixCustomer
                      ) YTD
            /****** YR2 (last year YTD) SALES-RETURNS *********/ 
                full outer join
               (SELECT
                    isnull(SKUSales.ixCustomer,CustReturns.ixCustomer)                     ixCustomer,              
                    OrdCount,
                    isnull(SKUSales.Sales,0)            Sales,
                    isnull(SKUSales.Cost,0)             Cost,
                    isnull(CustReturns.ReturnsRev,0)    ReturnsRev,
                    isnull(CustReturns.ReturnsCost,0)   ReturnsCost
                FROM 
                    /****** RETURNS *********/  
                    (select CMM.ixCustomer,
                          SUM(CMD.iQuantityCredited) QTYCredited,
                          SUM(CMD.iQuantityCredited*CMD.mUnitPrice) ReturnsRev,
                          SUM(CMD.iQuantityCredited*CMD.mUnitCost) ReturnsCost,
                          SUM((CMD.mUnitPrice-CMD.mUnitCost)*CMD.iQuantityCredited) GP
                    from tblCreditMemoDetail CMD
                        join tblCreditMemoMaster CMM on CMM.ixCreditMemo = CMD.ixCreditMemo 
                            and CMM.dtCreateDate >= '01/01/2009'
                            and CMM.dtCreateDate < '08/01/2009'
                        left join tblDate D on D.dtDate = CMM.dtCreateDate
                    group by CMM.ixCustomer
                    ) CustReturns 
                full outer join
                     /****** SALES *********/   
                    (select OL.ixCustomer,
                            count(distinct OL.ixOrder) OrdCount,
                            SUM(OL.iQuantity*CAST(OL.mUnitPrice as Money)) Sales,
                            SUM(OL.mExtendedCost) Cost,
                            SUM((OL.mUnitPrice-OL.mCost)* CAST(OL.iQuantity as Money)) GP
                     from tblOrder O 
                        join tblOrderLine OL on OL.ixOrder = O.ixOrder 
                                and OL.flgLineStatus = 'Shipped' -- 'fail' 
                                and OL.dtOrderDate >= '01/01/2009'
                                and OL.dtOrderDate < '08/01/2009'
                                and flgKitComponent = 0
                        left join tblDate D on D.dtDate = OL.dtOrderDate 
                     group by OL.ixCustomer
                    ) SKUSales on SKUSales.ixCustomer = CustReturns.ixCustomer
                      ) YR2 on YR2.ixCustomer = YTD.ixCustomer
    ) Performance on Performance.ixCustomer = CUST.ixCustomer

WHERE Performance.YTDSales is not null OR  Performance.YR2Sales is not null
order by ((Performance.YTDSales-Performance.YTDReturnsRev) - (Performance.YTDCost-Performance.YTDReturnsCost)) desc

