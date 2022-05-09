SELECT DISTINCT TOP 20 ISNULL(C.sCustomerLastName, C.sCustomerFirstName) AS CustomerName --11609 rows
       , C.ixCustomer AS CustomerNumber
     , ISNULL(Y1SALES.Merch,0) - ISNULL(Y1RTNS.MerchRef,0) AS Y1NetRev
     , ISNULL(Y1SALES.Cost,0) - ISNULL(Y1RTNS.CostRef,0) AS Y1NetCost
     , (ISNULL(Y1SALES.Merch,0) - ISNULL(Y1RTNS.MerchRef,0)) - (ISNULL(Y1SALES.Cost,0) - ISNULL(Y1RTNS.CostRef,0)) AS Y1GrossProfit
     --add in margin calculation in report for Y1 Margin %
     , ISNULL(Y2SALES.Merch,0) - ISNULL(Y2RTNS.MerchRef,0) AS Y2NetRev
     , ISNULL(Y2SALES.Cost,0) - ISNULL(Y2RTNS.CostRef,0) AS Y2NetCost
     , (ISNULL(Y2SALES.Merch,0) - ISNULL(Y2RTNS.MerchRef,0)) - (ISNULL(Y2SALES.Cost,0) - ISNULL(Y2RTNS.CostRef,0)) AS Y2GrossProfit
     --add in margin calculation in report for Y2 Margin %
     , (ISNULL(Y1SALES.Merch,0) - ISNULL(Y1RTNS.MerchRef,0)) - (ISNULL(Y2SALES.Merch,0) - ISNULL(Y2RTNS.MerchRef,0)) AS NetRevDifference  
     , ((ISNULL(Y1SALES.Merch,0) - ISNULL(Y1RTNS.MerchRef,0)) - (ISNULL(Y1SALES.Cost,0) - ISNULL(Y1RTNS.CostRef,0))) 
       - ((ISNULL(Y2SALES.Merch,0) - ISNULL(Y2RTNS.MerchRef,0)) - (ISNULL(Y2SALES.Cost,0) - ISNULL(Y2RTNS.CostRef,0))) AS GrossProfitDifference

FROM tblCustomer C 

LEFT JOIN (SELECT (CASE WHEN O.ixCustomer IN ('27511', '10511', '15242', '31173') THEN '10511'
                        WHEN O.ixCustomer IN ('10701', '10700') THEN '10701'
                        WHEN O.ixCustomer IN ('10164', '10704') THEN '10164'
                        WHEN O.ixCustomer IN ('10158', '10655') THEN '10158' 
                        ELSE O.ixCustomer  
                  END) AS CustomerNumber
                , ISNULL(SUM(O.mMerchandise),0) AS Merch
                , ISNULL(SUM(O.mMerchandiseCost),0) AS Cost
           FROM tblOrder O
           WHERE dtOrderDate BETWEEN @SalesStart1 AND @SalesEnd1 -- '01/01/2011' AND '12/31/2011'
             AND sOrderStatus = 'Shipped' 
           GROUP BY (CASE WHEN O.ixCustomer IN ('27511', '10511', '15242', '31173') THEN '10511'
                          WHEN O.ixCustomer IN ('10701', '10700') THEN '10701'
                          WHEN O.ixCustomer IN ('10164', '10704') THEN '10164'
                          WHEN O.ixCustomer IN ('10158', '10655') THEN '10158' 
                          ELSE O.ixCustomer  
                    END)
          ) AS Y1SALES ON Y1SALES.CustomerNumber = C.ixCustomer

LEFT JOIN (SELECT (CASE WHEN CMM.ixCustomer IN ('27511', '10511', '15242', '31173') THEN '10511'
                        WHEN CMM.ixCustomer IN ('10701', '10700') THEN '10701'
                        WHEN CMM.ixCustomer IN ('10164', '10704') THEN '10164'
                        WHEN CMM.ixCustomer IN ('10158', '10655') THEN '10158' 
                        ELSE CMM.ixCustomer  
                  END) AS CustomerNumber
                , ISNULL(SUM(CMM.mMerchandise),0) AS MerchRef
                , ISNULL(SUM(CMM.mMerchandiseCost),0) AS CostRef
           FROM tblCreditMemoMaster CMM 
           WHERE sMemoType = 'Refund'
             AND flgCanceled = '0'
             AND dtCreateDate BETWEEN @ReturnsStart1 AND @ReturnsEnd1 -- '01/01/2011' AND '12/31/2011'
           GROUP BY (CASE WHEN CMM.ixCustomer IN ('27511', '10511', '15242', '31173') THEN '10511'
                          WHEN CMM.ixCustomer IN ('10701', '10700') THEN '10701'
                          WHEN CMM.ixCustomer IN ('10164', '10704') THEN '10164'
                          WHEN CMM.ixCustomer IN ('10158', '10655') THEN '10158' 
                          ELSE CMM.ixCustomer  
                    END)
          ) AS Y1RTNS ON Y1RTNS.CustomerNumber = C.ixCustomer

LEFT JOIN (SELECT (CASE WHEN O.ixCustomer IN ('27511', '10511', '15242', '31173') THEN '10511'
                        WHEN O.ixCustomer IN ('10701', '10700') THEN '10701'
                        WHEN O.ixCustomer IN ('10164', '10704') THEN '10164'
                        WHEN O.ixCustomer IN ('10158', '10655') THEN '10158' 
                        ELSE O.ixCustomer  
                  END) AS CustomerNumber
                , ISNULL(SUM(O.mMerchandise),0) AS Merch
                , ISNULL(SUM(O.mMerchandiseCost),0) AS Cost
           FROM tblOrder O
           WHERE dtOrderDate BETWEEN @SalesStart2 AND @SalesEnd2 -- '01/01/2010' AND '12/31/2010'
             AND sOrderStatus = 'Shipped' 
           GROUP BY (CASE WHEN O.ixCustomer IN ('27511', '10511', '15242', '31173') THEN '10511'
                          WHEN O.ixCustomer IN ('10701', '10700') THEN '10701'
                          WHEN O.ixCustomer IN ('10164', '10704') THEN '10164'
                          WHEN O.ixCustomer IN ('10158', '10655') THEN '10158' 
                          ELSE O.ixCustomer  
                    END)
          ) AS Y2SALES ON Y2SALES.CustomerNumber = C.ixCustomer

LEFT JOIN (SELECT (CASE WHEN CMM.ixCustomer IN ('27511', '10511', '15242', '31173') THEN '10511'
                        WHEN CMM.ixCustomer IN ('10701', '10700') THEN '10701'
                        WHEN CMM.ixCustomer IN ('10164', '10704') THEN '10164'
                        WHEN CMM.ixCustomer IN ('10158', '10655') THEN '10158' 
                        ELSE CMM.ixCustomer  
                  END) AS CustomerNumber
                , ISNULL(SUM(CMM.mMerchandise),0) AS MerchRef
                , ISNULL(SUM(CMM.mMerchandiseCost),0) AS CostRef
           FROM tblCreditMemoMaster CMM 
           WHERE sMemoType = 'Refund'
             AND flgCanceled = '0'
             AND dtCreateDate BETWEEN @ReturnsStart2 AND @ReturnsEnd2 -- '01/01/2010' AND '12/31/2010'
           GROUP BY (CASE WHEN CMM.ixCustomer IN ('27511', '10511', '15242', '31173') THEN '10511'
                          WHEN CMM.ixCustomer IN ('10701', '10700') THEN '10701'
                          WHEN CMM.ixCustomer IN ('10164', '10704') THEN '10164'
                          WHEN CMM.ixCustomer IN ('10158', '10655') THEN '10158' 
                          ELSE CMM.ixCustomer  
                    END)
          ) AS Y2RTNS ON Y2RTNS.CustomerNumber = C.ixCustomer

ORDER BY Y1NetRev DESC