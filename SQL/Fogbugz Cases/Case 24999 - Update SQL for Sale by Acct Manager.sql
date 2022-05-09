SELECT CUST.*
     , Performance.YTDOrdCount AS YTDOrdCount
     , Performance.YTDSales AS YTDGrossRev
     , Performance.YTDCost AS YTDGrossCost
     , Performance.YTDReturnsRev AS YTDReturnsRev     
     , Performance.YTDReturnsCost AS YTDReturnsCost
     , Performance.YTDSales-Performance.YTDReturnsRev AS YTDNetRev
     , Performance.YTDCost-Performance.YTDReturnsCost AS YTDNetCost
     , ((Performance.YTDSales-Performance.YTDReturnsRev) - (Performance.YTDCost-Performance.YTDReturnsCost)) AS YTDGP
     , Performance.YR2OrdCount AS YR2OrdCount
     , Performance.YR2Sales AS YR2GrossRev
     , Performance.YR2Cost AS YR2GrossCost
     , Performance.YR2ReturnsRev AS YR2ReturnsRev
     , Performance.YR2ReturnsCost AS YR2ReturnsCost
     , Performance.YR2Sales-Performance.YR2ReturnsRev AS YR2NetRev
     , Performance.YR2Cost-Performance.YR2ReturnsCost AS YR2NetCost
     , ((Performance.YR2Sales-Performance.YR2ReturnsRev) - (Performance.YR2Cost-Performance.YR2ReturnsCost)) AS YR2GP
FROM
     (SELECT DISTINCT ISNULL(C.ixAccountManager,'UNASSIGNED') AS ixAccountManager
           , ISNULL(C.ixAccountManager2,'UNASSIGNED') AS ixAccountManager2
           , O.ixCustomer
           , C.sCustomerFirstName AS FirstName
           , C.sCustomerLastName AS LastName
           , C.iPriceLevel
           , C.ixCustomerType 
      FROM tblOrder O 
      LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
      WHERE O.sOrderStatus = 'Shipped'
        AND O.dtShippedDate BETWEEN DATEADD(mm, -12,@StartDate) AND @EndDate
    ) CUST
LEFT JOIN (SELECT ISNULL(YTD.ixCustomer,YR2.ixCustomer) AS ixCustomer              
           /*********** section 2 TY_YTD & LY_YTD SUMMARY **********/
                , YTD.OrdCount AS YTDOrdCount
                , ISNULL(YTD.Sales,0) AS YTDSales
                , ISNULL(YTD.Cost,0) AS YTDCost
                , ISNULL(YTD.ReturnsRev,0) AS YTDReturnsRev
                , ISNULL(YTD.ReturnsCost,0) AS YTDReturnsCost
                , YR2.OrdCount AS YR2OrdCount
                , ISNULL(YR2.Sales,0) AS YR2Sales
                , ISNULL(YR2.Cost,0) AS YR2Cost
                , ISNULL(YR2.ReturnsRev,0) AS YR2ReturnsRev
                , ISNULL(YR2.ReturnsCost,0) YR2ReturnsCost
           FROM /****** YTD SALES&RETURNS *********/ 
                (SELECT ISNULL(SKUSales.ixCustomer,CustReturns.ixCustomer) AS ixCustomer    
                      , OrdCount
                      , ISNULL(SKUSales.Sales,0) AS Sales
                      , ISNULL(SKUSales.Cost,0) AS Cost
                      , ISNULL(CustReturns.ReturnsRev,0) AS ReturnsRev
                      , ISNULL(CustReturns.ReturnsCost,0) AS ReturnsCost
                 FROM /****** RETURNS *********/  --includes freestanding credits
                      (SELECT CMM.ixCustomer
                            , SUM(CMM.mMerchandise) AS ReturnsRev
                            , SUM(CMM.mMerchandiseCost) AS ReturnsCost
                            , SUM(CMM.mMerchandise) - SUM(CMM.mMerchandiseCost) AS GP
                       FROM tblCreditMemoMaster CMM 
                       LEFT JOIN tblCustomer C ON C.ixCustomer = CMM.ixCustomer
                       WHERE ISNULL(C.ixAccountManager,'UNASSIGNED') IN (@AccountManager)
                         AND CMM.dtCreateDate BETWEEN @StartDate AND @EndDate
                         AND CMM.flgCanceled = 0 -- NOT Canceled
                       GROUP BY CMM.ixCustomer
                      ) CustReturns 
                 FULL OUTER JOIN /****** SALES *********/   
                                 (SELECT O.ixCustomer
                                       , COUNT(DISTINCT O.ixOrder) AS OrdCount
                                       , SUM(O.mMerchandise) AS Sales
                                       , SUM(O.mMerchandiseCost) AS Cost
                                       , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GP
                                  FROM tblOrder O 
                                  LEFT JOIN tblCustomer C on C.ixCustomer = O.ixCustomer
								  WHERE ISNULL(C.ixAccountManager,'UNASSIGNED')  IN (@AccountManager)
                                    AND O.sOrderStatus = 'Shipped'
                                    AND O.dtShippedDate BETWEEN @StartDate AND @EndDate
                                  GROUP BY O.ixCustomer
                                 ) SKUSales ON SKUSales.ixCustomer = CustReturns.ixCustomer
                ) YTD                      
           /****** YR2 (last year YTD) SALES&RETURNS *********/ 
           FULL OUTER JOIN (SELECT ISNULL(SKUSales.ixCustomer,CustReturns.ixCustomer) AS ixCustomer              
                                 , OrdCount
                                 , ISNULL(SKUSales.Sales,0) AS Sales
                                 , ISNULL(SKUSales.Cost,0) AS Cost
                                 , ISNULL(CustReturns.ReturnsRev,0) AS ReturnsRev
                                 , ISNULL(CustReturns.ReturnsCost,0) AS ReturnsCost                     
                            FROM /****** RETURNS *********/ --includes freestanding credits  
                                 (SELECT CMM.ixCustomer
									   , SUM(CMM.mMerchandise) AS ReturnsRev
                                       , SUM(CMM.mMerchandiseCost) AS ReturnsCost
                                       , SUM(CMM.mMerchandise) - SUM(CMM.mMerchandiseCost) AS GP
                                  FROM tblCreditMemoMaster CMM 
                                  LEFT JOIN tblCustomer C ON C.ixCustomer = CMM.ixCustomer
                                  WHERE ISNULL(C.ixAccountManager,'UNASSIGNED') IN (@AccountManager)
                                    AND CMM.dtCreateDate BETWEEN DATEADD(mm, -12,@StartDate) AND DATEADD(mm, -12,@EndDate) 
                                    AND CMM.flgCanceled = 0 -- NOT Canceled
                                  GROUP BY CMM.ixCustomer
                                 ) CustReturns 
                            FULL OUTER JOIN /******* SALES *********/   
										    (SELECT O.ixCustomer
                                                  , COUNT(DISTINCT O.ixOrder) AS OrdCount
                                                  , SUM(O.mMerchandise) AS Sales
                                                  , SUM(O.mMerchandiseCost) AS Cost
                                                  , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GP
											 FROM tblOrder O 
											 LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
											 WHERE O.dtShippedDate BETWEEN DATEADD(mm, -12,@StartDate) AND DATEADD(mm, -12,@EndDate)
                                               AND O.sOrderStatus = 'Shipped'
                                               AND ISNULL(C.ixAccountManager,'UNASSIGNED') IN (@AccountManager)
                                             GROUP BY O.ixCustomer
                                            ) SKUSales ON SKUSales.ixCustomer = CustReturns.ixCustomer
                          ) YR2 on YR2.ixCustomer = YTD.ixCustomer
         ) Performance ON Performance.ixCustomer = CUST.ixCustomer
WHERE CUST.ixAccountManager IN (@AccountManager)
 AND (Performance.YTDSales IS NOT NULL OR  Performance.YR2Sales IS NOT NULL)
ORDER BY ((Performance.YTDSales-Performance.YTDReturnsRev) - (Performance.YTDCost-Performance.YTDReturnsCost)) DESC