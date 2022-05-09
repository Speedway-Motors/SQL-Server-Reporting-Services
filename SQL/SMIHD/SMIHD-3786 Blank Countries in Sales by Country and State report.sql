-- SMIHD-3786 Blank Countries in Sales by Country and State report
SELECT
CMM.ixOrder, O.ixOrder, O.sShipToCountry AS ShipTo 
/*(CASE WHEN O.ixCustomer = '16878' THEN 'NON-US'
                                    WHEN O.ixCustomer = '10533' THEN 'NON-US' 
                                    WHEN O.sShipToCountry IN ('US', 'USA') THEN 'US'
                                    ELSE 'NON-US'
                               END) AS Geo 
                             , (CASE WHEN O.ixCustomer = '16878' THEN 'BRAZIL'
									 WHEN O.ixCustomer = '10533' THEN 'GERMANY'
									 WHEN O.sShipToCountry IN ('US', 'USA') THEN O.sShipToState
									 ELSE O.sShipToCountry
								END) AS ShipTo
						     , ISNULL(SUM(CMM.mMerchandise),0) AS MerchRef
							 , ISNULL(SUM(CMM.mMerchandiseCost),0) AS CostRef
*/							 
					   FROM tblCreditMemoMaster CMM 
					   LEFT JOIN tblOrder O ON O.ixOrder = CMM.ixOrder 
					   WHERE flgCanceled = '0'
						 AND dtCreateDate >= '01/01/14' -- BETWEEN @PPRtnStart AND @PPRtnEnd -- '01/01/10' AND '12/31/10'
						-- AND CMM.ixOrder <> 'FSCR' -- PER TED H. THESE SHOULD NOT BE EXCLUDED
						 AND CMM.mMerchandise > 0 

AND O.sShipToCountry IS NULL						 

select SUM(mMerchandise)
from tblCreditMemoMaster 
where ixOrder = 'FSCR'
and dtCreateDate >= '01/01/15'
order by dtCreateDate desc

					   GROUP BY (CASE WHEN O.ixCustomer = '16878' THEN 'NON-US'
								      WHEN O.ixCustomer = '10533' THEN 'NON-US' 
									  WHEN O.sShipToCountry IN ('US', 'USA') THEN 'US'
									  ELSE 'NON-US'
								 END) 
							    , (CASE WHEN O.ixCustomer = '16878' THEN 'BRAZIL'
										WHEN O.ixCustomer = '10533' THEN 'GERMANY'
										WHEN O.sShipToCountry IN ('US', 'USA') THEN O.sShipToState
									    ELSE O.sShipToCountry
								   END) 
								   
								   
								   


SELECT * FROM tblOrder O
    WHERE O.dtShippedDate >= '01/04/10' --BETWEEN @PPSalesStart AND @PPSalesEnd -- '01/01/10' AND '12/31/10'
              AND O.sOrderStatus = 'Shipped'
              AND O.mMerchandise > 0 
              AND O.sShipToCountry IS NULL
                       