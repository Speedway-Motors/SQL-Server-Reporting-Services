-- view [dbo].[vwSourceCodePerformance]
	
SELECT
    --CM.ixCatalog ixCatalog, CM.sDescription CatalogTitle, CM.dtStartDate,CM.dtEndDate, SC.sSourceCodeType,
    SC.ixSourceCode                     ixSourceCode,
    SC.sDescription                     SourceDesc,
    SC.iQuantityPrinted                 ALLQtyPrinted,
    count(distinct O.ixOrder)           ActOrdersToDate,    -- OrderCount,
    count(distinct O.ixCustomer)        ActBuyersToDate,    -- CustCount,
    isNULL(sum(O.mMerchandise),0)                 SalesToDate,        -- Total Sales
    (CASE WHEN C.ixSourceCode = 'EBAY' THEN 'eBay'
          else 'Other'
     END) CustSource
FROM tblSourceCode SC
    left join tblOrder O on O.sMatchbackSourceCode = SC.ixSourceCode
    join tblCatalogMaster CM    on CM.ixCatalog = SC.ixCatalog
    left join tblSourceCode SSC on SSC.ixSourceCode = SC.ixMostSimilarSourceCode
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
WHERE O.sOrderType <> 'Internal'
  and O.sOrderStatus = 'Shipped' 
  and O.dtShippedDate >= SC.dtStartDate
  and O.dtShippedDate < (SC.dtEndDate+1)
AND CM.ixCatalog = '339'  
AND SC.sSourceCodeType = 'CAT-H'
AND SC.ixSourceCode in 
    -- Source Codes that had some ebay source customers
    (select distinct CO.ixSourceCode
    from tblCustomerOffer CO
        left join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
        left join tblCustomer C on C.ixCustomer = CO.ixCustomer
    where SC.ixCatalog = '339' 
        and C.ixSourceCode = 'EBAY'   
        and SC.sSourceCodeType = 'CAT-H' 
    --order by ixSourceCode       
     )
GROUP BY -- CM.ixCatalog,CM.sDescription,CM.iPages,CM.dtStartDate,CM.dtEndDate,SC.sSourceCodeType,
    SC.ixSourceCode,SC.sDescription,SC.iQuantityPrinted,
(CASE WHEN cast(SSC.iQuantityPrinted as dec(15,2)) = 0 THEN 0 ELSE cast((cast(SC.iQuantityPrinted as dec(15,2)) / cast(SSC.iQuantityPrinted as dec(15,2)))as dec(15,3)) END),
(CASE WHEN C.ixSourceCode = 'EBAY' THEN 'eBay'
          else 'Other'
     END)
order by ixSourceCode, CustSource      

/*
select * from tblSourceCodeType

SCType	sDescription
CAT-E	Catalog @ Event
CAT-H	Catalog House
CAT-P	Catalog Prospect
CAT-R	Catalog Request

*/

--ALL scourcodes that had 1+ customers with original source of EBAY
select CO.ixSourceCode, COUNT(CO.ixCustomer) CustCount
from tblCustomerOffer CO
    left join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
    left join tblCustomer C on C.ixCustomer = CO.ixCustomer
where SC.ixCatalog = '339' 
    and C.ixSourceCode = 'EBAY'   
AND SC.sSourceCodeType = 'CAT-H'        
group by CO.ixSourceCode    
order by CO.ixSourceCode 
*/    





select * from tblCatalogMaster where ixCatalog in ('338','339')




list of orders from ppl in the unique list 
with dtOrDate >= '41-19-2012'
and sCodeGive or Matchback '33898' or '33998'




