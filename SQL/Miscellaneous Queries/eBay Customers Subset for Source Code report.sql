-- view [dbo].[vwSourceCodePerformance]
	
SELECT
    CM.ixCatalog        ixCatalog,
    --CM.iPages           'PageCount',
    CM.sDescription     CatalogTitle,
    CM.dtStartDate,
    CM.dtEndDate,
    (CM.mPrintingCost+CM.mPreparationCost+CM.mPostageCost) TotCatCost,
    (CASE WHEN CM.iPages = 0 THEN 0 
         ELSE (CM.mPrintingCost+CM.mPreparationCost+CM.mPostageCost) / CM.iPages 
         END
    ) CostPerPage,

    (CASE WHEN CM.iQuantityPrinted = 0 THEN 0 
     ELSE (CM.mPrintingCost+CM.mPreparationCost+CM.mPostageCost) / CM.iQuantityPrinted 
     END
    ) CostPerBook,
--    SC.ixMostSimilarSourceCode,
	SC.sSourceCodeType,
    SC.ixSourceCode                     ixSourceCode,
    SC.sDescription                     SourceDesc,
    SC.iQuantityPrinted                 ALLQtyPrinted,
    cast(CM.iPages as bigint) * cast(SC.iQuantityPrinted as bigint)   TotPagesPrinted,    
    count(distinct O.ixOrder)           ActOrdersToDate,    -- OrderCount,
    count(distinct O.ixCustomer)        ActBuyersToDate,    -- CustCount,
    sum(O.mMerchandise)                 SalesToDate,        -- Total Sales
   -- sum(O.mMerchandise)*.1              TotFulfilmentCost,  -- 10% of Total Sales             SalesToDate - COGSToDate / SalesToDate
    sum(O.mMerchandiseCost)             COGSToDate,
    (CASE WHEN sum(O.mMerchandise) = 0 THEN 0 
     ELSE (sum(O.mMerchandise) - sum(O.mMerchandiseCost)) / sum(O.mMerchandise) 
     END
    ) GMPercent,
    
(CASE WHEN C.ixSourceCode = 'EBAY' THEN 'eBay'
          else 'Other'
     END) CustSource
--    (CASE WHEN cast(SSC.iQuantityPrinted as dec(15,2)) = 0 THEN 0 
--     ELSE cast((cast(SC.iQuantityPrinted as dec(15,2)) / cast(SSC.iQuantityPrinted as dec(15,2)))as dec(15,3))
--     END 
--    ) SimSCRatio
FROM tblSourceCode SC
    left join tblOrder O on O.sMatchbackSourceCode = SC.ixSourceCode
    join tblCatalogMaster CM    on CM.ixCatalog = SC.ixCatalog
    left join tblSourceCode SSC on SSC.ixSourceCode = SC.ixMostSimilarSourceCode
    left join tblCustomer C on O.ixCustomer = C.ixCustomer

WHERE O.sOrderType <> 'Internal'
  and O.sOrderStatus = 'Shipped' 
 -- and O.dtShippedDate > '01/01/2008' -- to decrease runtime
  and O.dtShippedDate >= SC.dtStartDate
  and O.dtShippedDate < (SC.dtEndDate+1)
AND CM.ixCatalog = '335'  
-- and O.dtShippedDate < '11/22/2010' -- TEMP FOR VERIFICATION ONLY... REMOVE AFTER TESSTING COMPLETE!!!!!!!!!!!!!!!!!!!1
--AND  SC.ixSourceCode = '28710' -- and SC.ixSourceCode <> '2871'
GROUP BY CM.ixCatalog,CM.sDescription,CM.iPages,CM.dtStartDate,CM.dtEndDate,
    (CM.mPrintingCost+CM.mPreparationCost+CM.mPostageCost),
(CASE WHEN CM.iPages = 0 THEN 0 ELSE (CM.mPrintingCost+CM.mPreparationCost+CM.mPostageCost) / CM.iPages END),
(CASE WHEN CM.iQuantityPrinted = 0 THEN 0 ELSE (CM.mPrintingCost+CM.mPreparationCost+CM.mPostageCost) / CM.iQuantityPrinted END),
SC.ixMostSimilarSourceCode,SC.sSourceCodeType,SC.ixSourceCode,SC.sDescription,SC.iQuantityPrinted,
cast(CM.iPages as bigint) * cast(SC.iQuantityPrinted as bigint),
(CASE WHEN cast(SSC.iQuantityPrinted as dec(15,2)) = 0 THEN 0 ELSE cast((cast(SC.iQuantityPrinted as dec(15,2)) / cast(SSC.iQuantityPrinted as dec(15,2)))as dec(15,3)) END),
(CASE WHEN C.ixSourceCode = 'EBAY' THEN 'eBay'
          else 'Other'
     END)
order by ixSourceCode, CustSource      



select CO.ixSourceCode, COUNT(CO.ixCustomer) CustCount
from tblCustomerOffer CO
    left join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
    left join tblCustomer C on C.ixCustomer = CO.ixCustomer
where SC.ixCatalog = '335' 
    and C.ixSourceCode = 'EBAY'       
group by CO.ixSourceCode    
    
    
    
    