/* CASE 7846 
"Wholesale Sales by Account Manager" 
report discrepancies
*/
/*
-- select top 10 * from tblCustomer

select distinct sCustomerType, count(ixCustomer) QTY
from tblCustomer
group by sCustomerType
/*
sCustomerType	QTY
MRR	         499
Other	         11861
PRS	         420
Retail	      1093784
*/

-- MRR & PRS Customers with incorrect/no account manager assigned
select *
from tblCustomer
where sCustomerType in ('MRR','PRS')
and (ixAccountManager NOT IN ('GGL','DMH')
      or ixAccountManager is NULL)
order by sCustomerType, ixAccountManager, dtAccountCreateDate

-- orders from MRR & PRS Customers with incorrect/no account manager assigned
select O.*
from tblOrder O
   join tblCustomer C on C.ixCustomer = O.ixCustomer
where C.sCustomerType in ('MRR','PRS')
and C.ixAccountManager NOT IN ('GGL','DMH')
and O.dtOrderDate > '01/01/2011'
*/
/***************************************/

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
        isnull(C.ixAccountManager,'UNASSIGNED') ixAccountManager,
        O.ixCustomer,
        C.sCustomerFirstName    FirstName,
        C.sCustomerLastName     LastName
       FROM tblOrder O 
        left join tblCustomer C on C.ixCustomer =O.ixCustomer
       WHERE 
            O.sOrderStatus = 'Shipped'
        and O.dtShippedDate >= DATEADD(yy, -1,'01/01/2011') 	--	1 year prior to Start Date
        and O.dtShippedDate < ('02/01/2011')
        and C.sCustomerType in ('MRR','PRS')
     ) CUST

    left join (SELECT
                isnull(YTD.ixCustomer,'') ixCustomer,              
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
                        SUM(CMM.mMerchandise)                           ReturnsRev, 
                        SUM(CMM.mMerchandiseCost)                       ReturnsCost,
                        SUM(CMM.mMerchandise)-SUM(CMM.mMerchandiseCost) GP
                    from tblCreditMemoMaster CMM 
                        left join tblDate D on D.dtDate = CMM.dtCreateDate
                        left join tblCustomer C on C.ixCustomer = CMM.ixCustomer
                    where --isnull(C.ixAccountManager,'UNASSIGNED') in (@AccountManager)
                            CMM.dtCreateDate >= '01/01/2010'
                        and CMM.dtCreateDate < ('02/01/2010')
                        and CMM.flgCanceled = 0 -- NOT Canceled
                    group by CMM.ixCustomer
                    ) CustReturns 
                full outer join
                     /****** SALES *********/   
                    (select O.ixCustomer,
                            count(distinct O.ixOrder) OrdCount,
                            SUM(O.mMerchandise) Sales,
                            SUM(O.mMerchandiseCost) Cost,
                            (SUM(O.mMerchandise) -  SUM(O.mMerchandiseCost)) GP
                     from tblOrder O 
                        left join tblCustomer C on C.ixCustomer = O.ixCustomer
                        where --isnull(C.ixAccountManager,'UNASSIGNED')  in (@AccountManager)
                                O.sOrderStatus = 'Shipped' 
                                and O.dtShippedDate >= '01/01/2010'
                                and O.dtShippedDate < ('02/01/2010')
                                and O.sOrderChannel <> 'INTERNAL'
                     group by O.ixCustomer
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
                        SUM(CMM.mMerchandise)                           ReturnsRev, 
                        SUM(CMM.mMerchandiseCost)                       ReturnsCost,
                        SUM(CMM.mMerchandise)-SUM(CMM.mMerchandiseCost) GP
                    from tblCreditMemoMaster CMM 
                        left join tblCustomer C on C.ixCustomer = CMM.ixCustomer
                    where 
--isnull(C.ixAccountManager,'UNASSIGNED') in (@AccountManager)
                      CMM.dtCreateDate >=  DATEADD(yy, -1,'01/01/2011') 	--	1 year prior to Start Date
                      and CMM.dtCreateDate < DATEADD(yy, -1,('02/01/2011')) 	--	1 year prior to End Date
                      and CMM.flgCanceled = 0
                    group by CMM.ixCustomer
                    ) CustReturns 
                full outer join
                     /******* SALES *********/   
                    (select O.ixCustomer,
                            count(distinct O.ixOrder) OrdCount,
                            SUM(O.mMerchandise) Sales,
                            SUM(O.mMerchandiseCost) Cost,
                            (SUM(O.mMerchandise) -  SUM(O.mMerchandiseCost)) GP
                     from tblOrder O 
                       left join tblCustomer C on C.ixCustomer = O.ixCustomer
                     where 
--isnull(C.ixAccountManager,'UNASSIGNED')  in (@AccountManager)
                                    O.sOrderStatus = 'Shipped' 
                                and O.dtShippedDate >= DATEADD(yy, -1,'01/01/2011') 	--	1 year prior to Start Date
                                and O.dtShippedDate < DATEADD(yy, -1,('02/01/2011')) 	--	1 year prior to End Date
                                and O.sOrderChannel <> 'INTERNAL'
                     group by O.ixCustomer
                     ) SKUSales on SKUSales.ixCustomer = CustReturns.ixCustomer

                ) YR2 on YR2.ixCustomer = YTD.ixCustomer
    ) Performance on Performance.ixCustomer = CUST.ixCustomer

WHERE 
--(CUST.ixAccountManager in (@AccountManager)
--              OR CUST.ixAccountManager = 'UNASSIGNED')
(Performance.YTDSales is not null OR Performance.YR2Sales is not null)
