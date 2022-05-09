-- SMIHD-5960 - AFCO SALES by Acct Mgr sales

-- LOGIC FROM THE MAIN SALES QUERY
SELECT --O.ixCustomer                               -- $15,561,910.49
       --, COUNT(DISTINCT O.ixOrder) AS OrdCount
        SUM(OL.mExtendedPrice) SalesOL,
        SUM(O.mMerchandise) AS Sales
       --, SUM(O.mMerchandiseCost) AS Cost
    --, SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GP
  FROM tblOrder O 
 left join tblOrderLine OL on OL.ixOrder = O.ixOrder 
  LEFT JOIN tblCustomer C on C.ixCustomer = O.ixCustomer
  WHERE --ISNULL(C.ixAccountManager,'UNASSIGNED')  IN (@AccountManager)
     O.sOrderStatus = 'Shipped'
    AND O.dtShippedDate BETWEEN '01/02/16' AND '11/17/16' --@StartDate AND @EndDate
--   GROUP BY O.ixCustomer



-- SALES by Acct Mgr
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
        AND O.dtShippedDate BETWEEN '01/02/16' AND '11/17/16' -- BETWEEN DATEADD(mm, -12,@StartDate) AND @EndDate
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
                      (SELECT --CMM.ixCustomer              $1,421,874.83
                             SUM(CMM.mMerchandise) AS ReturnsRev
                         --   , SUM(CMM.mMerchandiseCost) AS ReturnsCost
                         --   , SUM(CMM.mMerchandise) - SUM(CMM.mMerchandiseCost) AS GP
                       FROM tblCreditMemoMaster CMM 
                       LEFT JOIN tblCustomer C ON C.ixCustomer = CMM.ixCustomer
                       WHERE --ISNULL(C.ixAccountManager,'UNASSIGNED') IN (@AccountManager)
                          CMM.dtCreateDate BETWEEN '01/02/16' AND '11/17/16' --BETWEEN @StartDate AND @EndDate
                         AND CMM.flgCanceled = 0 -- NOT Canceled
                       GROUP BY CMM.ixCustomer
                      ) CustReturns 
                      
                    /****** RETURNS LOGIC FROM PGC SALES REPORT *********/  
                  (select --CMD.ixSKU,                                                                                    --  $1,421,874.83 RETURNS FROM SALES BY ACCT MGRS
                       --   SUM(CMD.iQuantityCredited) QTYCredited,                                                       --   1,352,660.627
                          SUM(CMD.iQuantityCredited*CMD.mUnitPrice) Sales
                          --SUM(CMD.iQuantityCredited*CMD.mUnitCost) Cost,
                          --SUM((CMD.mUnitPrice-CMD.mUnitCost)*CMD.iQuantityCredited) GP
                    from tblCreditMemoDetail CMD
                        join tblCreditMemoMaster CMM on CMM.ixCreditMemo = CMD.ixCreditMemo 
                       -- left join tblDate D on D.dtDate = CMM.dtCreateDate
                        left join tblSKU S on S.ixSKU = CMD.ixSKU 
                    where     CMM.dtCreateDate >=  '01/02/16'
                            and CMM.dtCreateDate < '11/18/16'
                            and CMM.flgCanceled = 0
                    group by CMD.ixSKU
                    ) SKUReturns 
                    

SELECT SUM(CMM.mMerchandise),
SUM(CMD.iQuantityCredited*CMD.mUnitPrice) Sales
FROM tblCreditMemoMaster CMM 
left join tblCreditMemoDetail CMD on CMM.ixCreditMemo = CMD.ixCreditMemo 
 where     CMM.dtCreateDate >=  '01/02/16'
                            and CMM.dtCreateDate < '11/18/16'
                            and CMM.flgCanceled = 0                   
                                          
 6,946,112
-1,352,660
==========
 5,593,452   
 
 select * from tblCreditMemoMaster CMM
 where flgCanceled = 0
 and CMM.dtCreateDate >=  '01/02/16'
 and CMM.dtCreateDate < '11/18/16'
 --  and CMM.ixCreditMemo not in (Select ixCreditMemo from tblCreditMemoDetail)
 order by mMerchandise
 
  select CMD.ixCreditMemo, iQuantityCredited, CMD.mExtendedPrice
   from tblCreditMemoMaster CMM
  join tblCreditMemoDetail CMD on CMM.ixCreditMemo = CMD.ixCreditMemo 
 where flgCanceled = 0
 and CMM.dtCreateDate >=  '01/02/16'
 and CMM.dtCreateDate < '11/18/16'
  and CMM.ixCreditMemo not in (Select ixCreditMemo from tblCreditMemoDetail)
 order by CMD.iQuantityCredited
 
 select * from tblCreditMemoDetail
 where ixCreditMemo in('F-15591','F-15871')

 select * from tblCreditMemoMaster
 where ixCreditMemo in('F-15591','F-15871')

  select CMD.ixCreditMemo, iQuantityCredited, CMD.mExtendedPrice
   from tblCreditMemoMaster CMM
  join tblCreditMemoDetail CMD on CMM.ixCreditMemo = CMD.ixCreditMemo 
 where flgCanceled = 0
 and CMM.dtCreateDate >=  '01/02/16'
 and CMM.dtCreateDate < '11/18/16'
  and CMM.ixCreditMemo not in (Select ixCreditMemo from tblCreditMemoDetail)
  
select CMM.ixCreditMemo, CMM.mMerchandise 'CMReturns', SUM(CMD.mExtendedPrice) 'SKUReturns'
   from tblCreditMemoMaster CMM
  left join tblCreditMemoDetail CMD on CMM.ixCreditMemo = CMD.ixCreditMemo 
   where flgCanceled = 0
 and CMM.dtCreateDate >=  '01/02/16'
 and CMM.dtCreateDate < '11/18/16'
 
group by  CMM.ixCreditMemo, CMM.mMerchandise
having  CMM.mMerchandise > SUM(isnull(CMD.mExtendedPrice,0))  
 
SELECT  FROM tblSKU 
 
order by CMM.mMerchandise desc     
                                       
                 FULL OUTER JOIN /****** SALES *********/   
                                 (SELECT O.ixCustomer
                                       , COUNT(DISTINCT O.ixOrder) AS OrdCount
                                       , SUM(O.mMerchandise) AS Sales
                                       , SUM(O.mMerchandiseCost) AS Cost
                                       , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS GP
                                  FROM tblOrder O 
                                  LEFT JOIN tblCustomer C on C.ixCustomer = O.ixCustomer
								  WHERE --ISNULL(C.ixAccountManager,'UNASSIGNED')  IN (@AccountManager)
                                    O.sOrderStatus = 'Shipped'
                                    AND O.dtShippedDate BETWEEN '01/02/16' AND '11/17/16' -- BETWEEN @StartDate AND @EndDate
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
                                  WHERE-- ISNULL(C.ixAccountManager,'UNASSIGNED') IN (@AccountManager)
                                     CMM.dtCreateDate BETWEEN '01/02/15' AND '11/17/15' -- BETWEEN DATEADD(mm, -12,@StartDate) AND DATEADD(mm, -12,@EndDate) 
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
											 WHERE O.dtShippedDate BETWEEN '01/02/15' AND '11/17/15' -- BETWEEN DATEADD(mm, -12,@StartDate) AND DATEADD(mm, -12,@EndDate)
                                               AND O.sOrderStatus = 'Shipped'
                                              -- AND ISNULL(C.ixAccountManager,'UNASSIGNED') IN (@AccountManager)
                                             GROUP BY O.ixCustomer
                                            ) SKUSales ON SKUSales.ixCustomer = CustReturns.ixCustomer
                          ) YR2 on YR2.ixCustomer = YTD.ixCustomer
         ) Performance ON Performance.ixCustomer = CUST.ixCustomer
WHERE --CUST.ixAccountManager IN (@AccountManager)
  (Performance.YTDSales IS NOT NULL OR  Performance.YR2Sales IS NOT NULL)
ORDER BY ((Performance.YTDSales-Performance.YTDReturnsRev) - (Performance.YTDCost-Performance.YTDReturnsCost)) DESC





SELECT OL.ixSKU
from tblOrderLine










SELECT -- SUM(OL.mExtendedCost) Sales,  -- $15,561,910.49
        SUM(O.mMerchandise) AS Sales
  FROM tblOrder O 
 -- join tblOrderLine OL on OL.ixOrder = O.ixOrder 
  LEFT JOIN tblCustomer C on C.ixCustomer = O.ixCustomer
  WHERE --ISNULL(C.ixAccountManager,'UNASSIGNED')  IN (@AccountManager)
     O.sOrderStatus = 'Shipped'
    AND O.dtShippedDate BETWEEN '01/02/16' AND '11/17/16' --@StartDate AND @EndDate
and O.ixOrder NOT IN (select DISTINCT O.ixOrder
/* -- 101,901,800
--OL.ixSKU,
--                            SUM(OL.iQuantity) QTYSold,
                            SUM(OL.iQuantity*CAST(OL.mUnitPrice as Money)) Sales,
                            SUM(CAST(OL.mExtendedPrice as Money)) Sales2
--                            SUM(OL.mExtendedCost) Cost,
                            --SUM((OL.mUnitPrice-OL.mCost)* CAST(OL.iQuantity as Money)) GP
*/                            
                     from tblOrder O 
                        join tblOrderLine OL on OL.ixOrder = O.ixOrder 
                        left join tblDate D on D.dtDate = OL.dtShippedDate
                        left join tblSKU S on S.ixSKU = OL.ixSKU 
                     where OL.flgLineStatus = 'Shipped' 
                                and OL.dtShippedDate >= '01/02/16' --@StartDate
                                and OL.dtShippedDate < '11/18/16' --(@EndDate+1)
                                and flgKitComponent = 0
                      )





-- PGC SALES sales query
select -- 15,561,910.476
       -- $14,209,249.85
--OL.ixSKU,
--                            SUM(OL.iQuantity) QTYSold,
                            SUM(OL.iQuantity*CAST(OL.mUnitPrice as Money)) Sales,
                            SUM(CAST(OL.mExtendedPrice as Money)) Sales2
--                            SUM(OL.mExtendedCost) Cost,
                            --SUM((OL.mUnitPrice-OL.mCost)* CAST(OL.iQuantity as Money)) GP
                     from tblOrder O 
                        join tblOrderLine OL on OL.ixOrder = O.ixOrder 
                        left join tblDate D on D.dtDate = OL.dtShippedDate
                        left join tblSKU S on S.ixSKU = OL.ixSKU 
                     where OL.flgLineStatus = 'Shipped' 
                                and OL.dtShippedDate >= '01/02/16' --@StartDate
                                and OL.dtShippedDate < '11/18/16' --(@EndDate+1)
                                and flgKitComponent = 0