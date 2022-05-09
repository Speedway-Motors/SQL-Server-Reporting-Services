-- SMIHD-19407 - initial analysis for Promo Code 1808 

 -- 1st Time Buyers for Promo Offers under Promo ID 1808
SELECT PO.ixPromotionOffer 'ReportingPromoID',O.ixCustomer, O.ixOrderDate
INTO #FirstTimeBuyers -- drop table #FirstTimeBuyers
FROM tng.tblpromotion_offer PO
    LEFT JOIN tblOrderPromoCodeXref OPCXREF on OPCXREF.ixPromoID = PO.ixPromotionOffer
    LEFT JOIN tblOrder O on O.ixOrder = OPCXREF.ixOrder
    LEFT JOIN vwOrderCombinedPromoSummary CPS on O.ixOrder = CPS.ixOrder AND O.mMerchandise > 0 -- merch > 0 is needed to avoid pulling in zero-shipped CRAP
    LEFT JOIN  (-- First Order
                SELECT ixCustomer, MIN(ixOrderDate) ixFirstOrderDate, MIN(dtOrderDate) dtFirstOrderDate, COUNT(O.ixOrder) OrderCnt
                FROM tblOrder O
                WHERE O.sOrderStatus = 'Shipped'
                    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                    and O.sOrderType <> 'Internal'   -- USUALLY filtered
                GROUP BY ixCustomer) FO on FO.ixCustomer = O.ixCustomer AND O.ixOrderDate = FO.ixFirstOrderDate -- AND O.mMerchandise > 0-- merch > 0 is needed to avoid pulling in zero-shipped CRAP
                
WHERE  PO.ixPromotionOffer in (2011,2012,2013,2014)
                            and O.sOrderStatus = 'Shipped'
                            and O.sOrderType <> 'Internal'  
                            and O.mMerchandise > 0  
                            and O.ixOrder NOT LIKE '%-%'
                            AND FO.ixFirstOrderDate = O.ixOrderDate
--) O ON O.ixPromotionOffer = TP.ixPromotionOffer

 /*
Customer Detail:
    Customer number
    Customer name
    Column for date of first order.
    Column for elapsed days to second order
    Colum for total number of orders (which could be the reorder velocity field noted below)
    Average Order Value (AOV)
    Reorder velocity (2nd, 3rd, etc)
    Total Revenue
*/

SELECT FTB.ixCustomer, FTB.ReportingPromoID, C.sCustomerFirstName, C.sCustomerLastName, 
    --FTB.ixOrderDate, 
    D.dtDate 'FirstOrderDate',
    COM.OrderCount,
    COM.TotRev,
    0 as 'AOV', -- placeholder for Excel output
    0 as 'DaysTo2ndOrder'
FROM #FirstTimeBuyers FTB
    LEFT join tblCustomer C on FTB.ixCustomer = C.ixCustomer
    LEFT join tblDate D on FTB.ixOrderDate = D.ixDate
    LEFT JOIN (-- Customer Order Metrics
                SELECT ixCustomer, 
                    SUM(O.mMerchandise) 'TotRev',
                    SUM(CASE WHEN ixOrder LIKE '%-%' THEN 0
										                 ELSE 1 
									                END
									                ) 'OrderCount'
                FROM tblOrder O
                    where O.sOrderStatus = 'Shipped'
                        and O.sOrderType <> 'Internal'   -- normally filtered
                        and O.mMerchandise > 0 -- > 1 if looking at non-US orders  
                GROUP BY O.ixCustomer 
                ) COM on COM.ixCustomer = FTB.ixCustomer
ORDER BY FTB.ixCustomer --FTB.ixOrderDate

-- 2 CUSTOMERS USED 2 different promo offers that day
    SELECT * FROM tblOrder where ixCustomer = 3163553 and sOrderStatus = 'Shipped'
    order by ixOrderDate, ixOrderTime

    select * from tblOrderPromoCodeXref where ixOrder = '9931350'

    DELETE FROM #FirstTimeBuyers
        WHERE ixCustomer = 3075654 and ReportingPromoID = 2014

    DELETE FROM #FirstTimeBuyers
        WHERE ixCustomer = 3163553 and ReportingPromoID = 2014

        


/*


SELECT PO.ixPromotionOffer 'ReportingPromoID',O.ixCustomer, O.ixOrderDate
--INTO #FirstTimeBuyers -- drop table #FirstTimeBuyers
FROM tng.tblpromotion_offer PO
    LEFT JOIN tblOrderPromoCodeXref OPCXREF on OPCXREF.ixPromoID = PO.ixPromotionOffer
    LEFT JOIN tblOrder O on O.ixOrder = OPCXREF.ixOrder
    LEFT JOIN vwOrderCombinedPromoSummary CPS on O.ixOrder = CPS.ixOrder AND O.mMerchandise > 0 -- merch > 0 is needed to avoid pulling in zero-shipped CRAP
    LEFT JOIN  (-- First Order
                SELECT ixCustomer, MIN(ixOrderDate) ixFirstOrderDate, MIN(dtOrderDate) dtFirstOrderDate, COUNT(O.ixOrder) OrderCnt
                FROM tblOrder O
                WHERE O.sOrderStatus = 'Shipped'
                    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                    and O.sOrderType <> 'Internal'   -- USUALLY filtered
                GROUP BY ixCustomer) FO on FO.ixCustomer = O.ixCustomer AND O.ixOrderDate = FO.ixFirstOrderDate -- AND O.mMerchandise > 0-- merch > 0 is needed to avoid pulling in zero-shipped CRAP
                
WHERE  PO.ixPromotionOffer in (2011,2012,2013,2014)
                            and O.sOrderStatus = 'Shipped'
                            and O.sOrderType <> 'Internal'  
                            and O.mMerchandise > 0  
                            and O.ixOrder NOT LIKE '%-%'
                            AND FO.ixFirstOrderDate = O.ixOrderDate
and O.ixCustomer = '3075654'
*/